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

def get_template(samp, passed, ptbin, obs):
    # open root file of histograms
    f = ROOT.TFile.Open("signalregion.root")

    name = samp
    if passed:
        name += "_pass"
    else:
        name += "_fail"
    name += "_pt"+str(ptbin)

    h = f.Get(name)
    sumw = []
    sumw2 = []
    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def get_template_muonCR(samp, passed, obs):
    # open root file of histograms                                                                                                      
    f = ROOT.TFile.Open("muonCR.root")

    name = samp
    if passed:
        name += "_pass"
    else:
        name += "_fail"

    h = f.Get(name)
#    h.Rebin(h.GetNbinsX())

    sumw = []
    sumw2 = []
    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def test_rhalphabet(tmpdir):
    throwPoisson = True #False

#    jec = rl.NuisanceParameter('CMS_jec', 'lnN')
#    massScale = rl.NuisanceParameter('CMS_msdScale', 'shape')
#    lumi = rl.NuisanceParameter('CMS_lumi', 'lnN')

    tqqeffSF = rl.IndependentParameter('tqqeffSF', 1., 0, 20)
    tqqnormSF = rl.IndependentParameter('tqqnormSF', 1., 0, 20)

    ptbins = np.array([450, 550, 675, 1200])
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

        failCh.setObservation(failTempl, read_sumw2=True)
        passCh.setObservation(passTempl, read_sumw2=True)

        qcdfail += sum([val[0] for val in failCh.getObservation()])
        qcdpass += sum([val[0] for val in passCh.getObservation()])

    qcdeff = qcdpass / qcdfail
    print("Inclusive P/F from Monte Carlo = " + str(qcdeff))

    # initial values
    print("Initial fit values read from file initial_vals.csv")
    initial_vals = np.genfromtxt('initial_vals.csv')
    initial_vals = initial_vals.reshape(2,3)
    print(initial_vals)

    tf_MCtempl = rl.BernsteinPoly("tf_MCtempl", (1, 2), ['pt', 'rho'], init_params=initial_vals, limits=(-20, 20))
    tf_MCtempl_params = qcdeff * tf_MCtempl(ptscaled, rhoscaled)
    for ptbin in range(npt):
        failCh = qcdmodel['ptbin%dfail' % ptbin]
        passCh = qcdmodel['ptbin%dpass' % ptbin]
        failObs = failCh.getObservation()
        passObs = passCh.getObservation()

        qcdparams = np.array([rl.IndependentParameter('qcdparam_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
        sigmascale = 10.
        scaledparams = failObs * (1 + sigmascale/np.maximum(1., np.sqrt(failObs)))**qcdparams

        fail_qcd = rl.ParametericSample('ptbin%dfail_qcd' % ptbin, rl.Sample.BACKGROUND, msd, scaledparams[0])
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

    # Set parameters to fitted values  
    allparams = dict(zip(qcdfit.nameArray(), qcdfit.valueArray()))
    for i, p in enumerate(tf_MCtempl.parameters.reshape(-1)):
        p.value = allparams[p.name]

    if qcdfit.status() != 0:
        raise RuntimeError('Could not fit qcd')

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
    tf_dataResidual = rl.BernsteinPoly("tf_dataResidual", (1, 2), ['pt', 'rho'], limits=(-20, 20))
    tf_dataResidual_params = tf_dataResidual(ptscaled, rhoscaled)
    tf_params = qcdeff * tf_MCtempl_params_final * tf_dataResidual_params

    # build actual fit model now
    model = rl.Model("testModel")

    # exclud QCD from MC samps
    samps = ['ggF','VBF','WH','ZH','ttH','ttbar','singlet','Zjets','Wjets','VV']
    sigs = ['ggF','VBF','WH','ZH','ttH']

    for ptbin in range(npt):
        for region in ['pass', 'fail']:
            ch = rl.Channel("ptbin%d%s" % (ptbin, region))
            model.addChannel(ch)

            isPass = region == 'pass'
            ptnorm = 1.

            templates = {}
            
            for sName in samps:

                templates[sName] = get_template(sName, isPass, ptbin+1, obs=msd) 

                # some mock expectations
                templ = templates[sName]
                stype = rl.Sample.SIGNAL if sName in sigs else rl.Sample.BACKGROUND
                sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)

                ch.addSample(sample)

            data_obs = get_template("data", isPass, ptbin+1, obs=msd)
            ch.setObservation(data_obs, read_sumw2=True)

            # drop bins outside rho validity
            mask = validbins[ptbin]

            # blind bins 11, 12, 13
            mask[11:14] = False
            ch.mask = mask

    for ptbin in range(npt):
        failCh = model['ptbin%dfail' % ptbin]
        passCh = model['ptbin%dpass' % ptbin]

        qcdparams = np.array([rl.IndependentParameter('qcdparam_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
        initial_qcd = failCh.getObservation()[0].astype(float)  # was integer, and numpy complained about subtracting float from it

        for sample in failCh:
            initial_qcd -= sample.getExpectation(nominal=True)

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
    samps = ['ttbar','QCD','singlet','Zjets','Wjets','VV']
    for region in ['pass', 'fail']:
        ch = rl.Channel("muonCR%s" % (region, ))
        model.addChannel(ch)

        isPass = region == 'pass'

        for sName in samps:
            templates[sName] = get_template_muonCR(sName, isPass, obs=msd)

            stype = rl.Sample.BACKGROUND
            sample = rl.TemplateSample(ch.name + '_' + sName, stype, templates[sName])

            ch.addSample(sample)

        data_obs = get_template_muonCR("muondata", isPass, obs=msd)
        ch.setObservation(data_obs, read_sumw2=True)

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

