from __future__ import print_function, division
import sys
import os
import csv
import rhalphalib as rl
import numpy as np
import scipy.stats
import pickle
import ROOT
rl.util.install_roofit_helpers()
rl.ParametericSample.PreferRooParametricHist = False
import pandas as pd

def expo_sample(norm, scale, obs):
    cdf = scipy.stats.expon.cdf(scale=scale, x=obs.binning) * norm
    return (np.diff(cdf), obs.binning, obs.name)

def gaus_sample(norm, loc, scale, obs):
    cdf = scipy.stats.norm.cdf(loc=loc, scale=scale, x=obs.binning) * norm
    return (np.diff(cdf), obs.binning, obs.name)

def get_template(samp, passed, ptbin, obs):
    # open root file of histograms
    f = ROOT.TFile.Open("signalregion.root")

    name = samp
    if passed:
        name += "_pass"
    else:
        name += "_fail"

    h = f.Get(name)
    hist = []
    for i in range(2,h.GetNbinsX()+1):
        hist += [h.GetBinContent(i)]

    return (np.array(hist), obs.binning, obs.name)

def get_template_muonCR(samp, passed, obs):
    # open root file of histograms                                                                                                      
    f = ROOT.TFile.Open("muonCR.root")

    name = samp
    if passed:
        name += "_pass"
    else:
        name += "_fail"

    h = f.Get(name)
    hist = []
    for i in range(2,h.GetNbinsX()+1):
        hist += [h.GetBinContent(i)]

    return (np.array(hist), obs.binning, obs.name)

def test_rhalphabet(tmpdir):
    throwPoisson = True #False

    jec = rl.NuisanceParameter('CMS_jec', 'lnN')
    massScale = rl.NuisanceParameter('CMS_msdScale', 'shape')
    lumi = rl.NuisanceParameter('CMS_lumi', 'lnN')
    tqqeffSF = rl.IndependentParameter('tqqeffSF', 1., 0, 10)
    tqqnormSF = rl.IndependentParameter('tqqnormSF', 1., 0, 10)

#    ptbins = np.array([450, 500, 550, 600, 675, 800, 1200])
    ptbins = np.array([450,1200])
    npt = len(ptbins) - 1
    msdbins = np.linspace(47, 201, 23)
    msd = rl.Observable('msd', msdbins)

    # here we derive these all at once with 2D array
    ptpts, msdpts = np.meshgrid(ptbins[:-1] + 0.3 * np.diff(ptbins), msdbins[:-1] + 0.5 * np.diff(msdbins), indexing='ij')
    rhopts = 2*np.log(msdpts/ptpts)
    ptscaled = (ptpts - 450.) / (1200. - 450.)
    rhoscaled = (rhopts - (-6)) / ((-2.1) - (-6))
    validbins = (rhoscaled >= 0) & (rhoscaled <= 1)
    rhoscaled[~validbins] = 1  # we will mask these out later

    # Build qcd MC pass+fail model and fit to polynomial
    qcdmodel = rl.Model("qcdmodel")
    qcdpass, qcdfail = 0., 0.
    for ptbin in range(npt):
        failCh = rl.Channel("ptbin%d%s" % (ptbin, 'fail'))
        passCh = rl.Channel("ptbin%d%s" % (ptbin, 'pass'))
        qcdmodel.addChannel(failCh)
        qcdmodel.addChannel(passCh)

        # QCD templates from file
        failTempl = get_template("QCD", 0, ptbin+1, obs=msd) #
        passTempl = get_template("QCD", 1, ptbin+1, obs=msd) #

        failCh.setObservation(failTempl)
        passCh.setObservation(passTempl)

        qcdfail += failCh.getObservation().sum()
        qcdpass += passCh.getObservation().sum()


    qcdeff = qcdpass / qcdfail

    # initial values
    initial_vals = np.array([[-0.724877067901, 2.08405991802, 0.7834449503],
                             [0.70392199007, 2.07323502814, 0.046337412277],
                             [0.768381509607, 0.457222806859, 0.662486260717]])

    tf_MCtempl = rl.BernsteinPoly("tf_MCtempl", (2, 2), ['pt', 'rho'], init_params=initial_vals, limits=(-10, 10))
    tf_MCtempl_params = qcdeff * tf_MCtempl(ptscaled, rhoscaled)
    for ptbin in range(npt):
        failCh = qcdmodel['ptbin%dfail' % ptbin]
        passCh = qcdmodel['ptbin%dpass' % ptbin]
        failObs = failCh.getObservation()
        passObs = passCh.getObservation()

        qcdparams = np.array([rl.IndependentParameter('qcdparam_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
        sigmascale = 10.
        scaledparams = failObs * (1 + sigmascale/np.maximum(1., np.sqrt(failObs)))**qcdparams
        fail_qcd = rl.ParametericSample('ptbin%dfail_qcd' % ptbin, rl.Sample.BACKGROUND, msd, scaledparams)
        failCh.addSample(fail_qcd)
        pass_qcd = rl.TransferFactorSample('ptbin%dpass_qcd' % ptbin, rl.Sample.BACKGROUND, tf_MCtempl_params[ptbin, :], fail_qcd)
        passCh.addSample(pass_qcd)

        failCh.mask = validbins[ptbin]
        passCh.mask = validbins[ptbin]

    qcdfit_ws = ROOT.RooWorkspace('qcdfit_ws')

    simpdf, obs = qcdmodel.renderRoofit(qcdfit_ws)
    qcdfit = simpdf.fitTo(obs,
                          ROOT.RooFit.Extended(True),
                          ROOT.RooFit.SumW2Error(True),
                          ROOT.RooFit.Strategy(2),
                          ROOT.RooFit.Save(),
                          ROOT.RooFit.Minimizer('Minuit2', 'migrad'),
                          ROOT.RooFit.PrintLevel(1),
                          )
    qcdfit_ws.add(qcdfit)
    qcdfit_ws.writeToFile(os.path.join(str(tmpdir), 'testModel_qcdfit.root'))

    if qcdfit.status() != 0:
        raise RuntimeError('Could not fit qcd')

    # Set parameters to fitted values
    allparams = dict(zip(qcdfit.nameArray(), qcdfit.valueArray()))
    for i, p in enumerate(tf_MCtempl.parameters.reshape(-1)):
        p.value = allparams[p.name]

    # plot pt vs msd
#    tf_MCtempl_vals = tf_MCtempl(ptscaled, rhoscaled, nominal=True)

    # arrays for plotting pt vs msd
    pts_plot = np.linspace(450,1200,15)
    ptpts_plot, msdpts_plot = np.meshgrid(pts_plot[:-1] + 0.5 * np.diff(pts_plot), msdbins[:-1] + 0.5 * np.diff(msdbins), indexing='ij')
    ptpts_plot_scaled = (ptpts_plot - 450.) / (1200. - 450.)
    rhopts_plot = 2*np.log(msdpts_plot/ptpts_plot)

    rhopts_plot_scaled = (rhopts_plot - (-6)) / ((-2.1) - (-6))
    validbins_plot = (rhopts_plot_scaled >= 0) & (rhopts_plot_scaled <= 1)

    ptpts_plot = ptpts_plot[validbins_plot]
    msdpts_plot = msdpts_plot[validbins_plot]
    ptpts_plot_scaled = ptpts_plot_scaled[validbins_plot]
    rhopts_plot_scaled = rhopts_plot_scaled[validbins_plot]

    tf_MCtempl_vals = tf_MCtempl(ptpts_plot_scaled, rhopts_plot_scaled, nominal=True)
    df_msdpt = pd.DataFrame([])
    df_msdpt["msd"] = msdpts_plot.reshape(-1)
    df_msdpt["pt"] = ptpts_plot.reshape(-1)
    df_msdpt["eQCDMC"] = tf_MCtempl_vals.reshape(-1)
    df_msdpt.to_csv("msdpt.csv", header=False)
    
    # arrays for plotting pt vs rho
    rhos_plot = np.linspace(-6,-2.1,23)
    ptpts_plot, rhopts_plot = np.meshgrid(pts_plot[:-1] + 0.5*np.diff(pts_plot), rhos_plot[:-1] + 0.5 * np.diff(rhos_plot), indexing='ij')
    ptpts_plot_scaled = (ptpts_plot - 450.) / (1200. - 450.)
    rhopts_plot_scaled = (rhopts_plot - (-6)) / ((-2.1) - (-6))
    validbins_plot = (rhopts_plot_scaled >= 0) & (rhopts_plot_scaled <= 1)

    ptpts_plot = ptpts_plot[validbins_plot]
    rhopts_plot = rhopts_plot[validbins_plot]
    ptpts_plot_scaled = ptpts_plot_scaled[validbins_plot]
    rhopts_plot_scaled = rhopts_plot_scaled[validbins_plot]

    tf_MCtempl_vals = tf_MCtempl(ptpts_plot_scaled, rhopts_plot_scaled, nominal=True)
    
    df_rhopt = pd.DataFrame([])
    df_rhopt["rho"] = rhopts_plot.reshape(-1)
    df_rhopt["pt"] = ptpts_plot.reshape(-1)
    df_rhopt["eQCDMC"] = tf_MCtempl_vals.reshape(-1)
    df_rhopt.to_csv("rhopt.csv", header=False)

    

    param_names = [p.name for p in tf_MCtempl.parameters.reshape(-1)]
    decoVector = rl.DecorrelatedNuisanceVector.fromRooFitResult(tf_MCtempl.name + '_deco', qcdfit, param_names)
    tf_MCtempl.parameters = decoVector.correlated_params.reshape(tf_MCtempl.parameters.shape)
    tf_MCtempl_params_final = tf_MCtempl(ptscaled, rhoscaled)
    tf_dataResidual = rl.BernsteinPoly("tf_dataResidual", (2, 2), ['pt', 'rho'], limits=(0, 10))
    tf_dataResidual_params = tf_dataResidual(ptscaled, rhoscaled)
    tf_params = qcdeff * tf_MCtempl_params_final * tf_dataResidual_params

    # build actual fit model now
    model = rl.Model("testModel")

    samps = ['ggF','VBF','WH','ZH','ttH','ttbar','singlet','Zjets','Wjets','VV']
    sigs = ['VBF']

    for ptbin in range(npt):
        for region in ['pass', 'fail']:
            ch = rl.Channel("ptbin%d%s" % (ptbin, region))
            model.addChannel(ch)

            isPass = region == 'pass'
            ptnorm = 1.

            templates = {}
            
            for sName in samps:

                templates[sName] = get_template(sName, region=="pass", ptbin+1, obs=msd) 

                # some mock expectations
                templ = templates[sName]
                stype = rl.Sample.SIGNAL if sName in sigs else rl.Sample.BACKGROUND
                sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)

                # mock systematics
                jecup_ratio = np.random.normal(loc=1, scale=0.05, size=msd.nbins)
                msdUp = np.linspace(0.9, 1.1, msd.nbins)
                msdDn = np.linspace(1.2, 0.8, msd.nbins)

                # for jec we set lnN prior, shape will automatically be converted to norm systematic
                sample.setParamEffect(jec, jecup_ratio)
                sample.setParamEffect(massScale, msdUp, msdDn)
                sample.setParamEffect(lumi, 1.027)

                ch.addSample(sample)

            # make up a data_obs, with possibly different yield values
#            templates = {
#                'ttH': gaus_sample(norm=ptnorm*(100 if isPass else 300), loc=80, scale=8, obs=msd),
#                'WH': gaus_sample(norm=ptnorm*(100 if isPass else 300), loc=80, scale=8, obs=msd),
#                'ZH': gaus_sample(norm=ptnorm*(200 if isPass else 100), loc=91, scale=8, obs=msd),
#                'VBF': gaus_sample(norm=ptnorm*(40 if isPass else 80), loc=150, scale=20, obs=msd),
#                'ggF': gaus_sample(norm=ptnorm*(20 if isPass else 5), loc=125, scale=8, obs=msd),
#                'QCD': expo_sample(norm=ptnorm*(1e3 if isPass else 1e5), scale=40, obs=msd),
#                'ttbar': expo_sample(norm=ptnorm*(1e2 if isPass else 1e5), scale=40, obs=msd),
#                'singlet': expo_sample(norm=ptnorm*(1e2 if isPass else 1e3), scale=40, obs=msd),
#                'Zjets': expo_sample(norm=ptnorm*(1e2 if isPass else 1e3), scale=40, obs=msd),
#                'Wjets': expo_sample(norm=ptnorm*(1e2 if isPass else 1e3), scale=40, obs=msd),
#                'VV': expo_sample(norm=ptnorm*(1e1 if isPass else 1e2), scale=40, obs=msd),
#            }
            yields = sum(tpl[0] for tpl in templates.values())
            if throwPoisson:
                yields = np.random.poisson(yields)
            data_obs = (yields, msd.binning, msd.name)
            ch.setObservation(data_obs)

            # drop bins outside rho validity
            mask = validbins[ptbin]
            # blind bins 11, 12, 13
            mask[11:14] = False
            ch.mask = mask

    for ptbin in range(npt):
        failCh = model['ptbin%dfail' % ptbin]
        passCh = model['ptbin%dpass' % ptbin]

        qcdparams = np.array([rl.IndependentParameter('qcdparam_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
        initial_qcd = failCh.getObservation().astype(float)  # was integer, and numpy complained about subtracting float from it

#        for sample in failCh:
#            print(sample)
#            initial_qcd -= sample.getExpectation(nominal=True)
#            print(initial_qcd)
        if np.any(initial_qcd < 0.):
            raise ValueError("initial_qcd negative for some bins..", initial_qcd)
        sigmascale = 10  # to scale the deviation from initial
        scaledparams = initial_qcd * (1 + sigmascale/np.maximum(1., np.sqrt(initial_qcd)))**qcdparams
        fail_qcd = rl.ParametericSample('ptbin%dfail_qcd' % ptbin, rl.Sample.BACKGROUND, msd, scaledparams)
        failCh.addSample(fail_qcd)
        pass_qcd = rl.TransferFactorSample('ptbin%dpass_qcd' % ptbin, rl.Sample.BACKGROUND, tf_params[ptbin, :], fail_qcd)
        passCh.addSample(pass_qcd)

        tqqpass = passCh['ttbar']
        tqqfail = failCh['ttbar']
        tqqPF = tqqpass.getExpectation(nominal=True).sum() / tqqfail.getExpectation(nominal=True).sum()
        tqqpass.setParamEffect(tqqeffSF, 1*tqqeffSF)
        tqqfail.setParamEffect(tqqeffSF, (1 - tqqeffSF) * tqqPF + 1)
        tqqpass.setParamEffect(tqqnormSF, 1*tqqnormSF)
        tqqfail.setParamEffect(tqqnormSF, 1*tqqnormSF)

    # Fill in muon CR
    templates = {}

    for region in ['pass', 'fail']:
        ch = rl.Channel("muonCR%s" % (region, ))
        model.addChannel(ch)

        isPass = region == 'pass'
        templates['ttbar'] = get_template_muonCR('ttbar',isPass,obs=msd); 
        templates['QCD'] = get_template_muonCR('QCD',isPass,obs=msd);

        for sName, templ in templates.items():
            stype = rl.Sample.BACKGROUND
            sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)

            # mock systematics
            jecup_ratio = np.random.normal(loc=1, scale=0.05, size=msd.nbins)
            sample.setParamEffect(jec, jecup_ratio)

            ch.addSample(sample)

        # make up a data_obs
#        templates = {
#            'ttbar': gaus_sample(norm=10*(30 if isPass else 60), loc=150, scale=20, obs=msd),
#            'QCD': expo_sample(norm=10*(5e2 if isPass else 1e3), scale=40, obs=msd),
#        }
        yields = sum(tpl[0] for tpl in templates.values())
        if throwPoisson:
            yields = np.random.poisson(yields)
        data_obs = (yields, msd.binning, msd.name)
        ch.setObservation(data_obs)

    tqqpass = model['muonCRpass_ttbar']
    tqqfail = model['muonCRfail_ttbar']
    tqqPF = tqqpass.getExpectation(nominal=True).sum() / tqqfail.getExpectation(nominal=True).sum()
    tqqpass.setParamEffect(tqqeffSF, 1*tqqeffSF)
    tqqfail.setParamEffect(tqqeffSF, (1 - tqqeffSF) * tqqPF + 1)
    tqqpass.setParamEffect(tqqnormSF, 1*tqqnormSF)
    tqqfail.setParamEffect(tqqnormSF, 1*tqqnormSF)

    with open(os.path.join(str(tmpdir), 'testModel.pkl'), "wb") as fout:
        pickle.dump(model, fout)

    model.renderCombine(os.path.join(str(tmpdir), 'testModel'))

if __name__ == '__main__':
    if not os.path.exists('output'):
        os.mkdir('output')
    test_rhalphabet('output')

