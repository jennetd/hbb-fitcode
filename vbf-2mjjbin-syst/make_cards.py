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

def syst_variation(numerator,denominator):
    var = np.divide(numerator,denominator)
    var[np.where(numerator==0)] = 1
    var[np.where(denominator==0)] = 1
    return var

def get_template(samp, passed, mjjbin, obs, syst):
    # open root file of histograms                                                                                            
    f = ROOT.TFile.Open("signalregion.root")

    name = "fail_"
    if passed:
        name = "pass_"
    name += "mjj"+str(mjjbin)+"_"+samp+"_"+syst

    h = f.Get(name)
    sumw = []
    sumw2 = []
    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def get_template_muonCR(samp, passed, obs):
    f = ROOT.TFile.Open("muonCR.root")

    name = "fail_"
    if passed:
        name = "pass_"
    name += samp+"_nominal"

    h = f.Get(name)

    sumw = []
    sumw2 = []
    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def test_rhalphabet(tmpdir):
    throwPoisson = True #False

    # experimental systematics
    lumi = rl.NuisanceParameter('CMS_lumi', 'lnN')
    jet_trigger = rl.NuisanceParameter('CMS_jet_trigger', 'lnN')
    jes = rl.NuisanceParameter('CMS_jes', 'lnN')
    jer = rl.NuisanceParameter('CMS_jer', 'lnN')
    ues = rl.NuisanceParameter('CMS_ues', 'lnN')
    btagWeight = rl.NuisanceParameter('CMS_btagWeight', 'lnN')
    btagEffStat = rl.NuisanceParameter('CMS_btagEffStat', 'lnN')

    # theory systematics
    pdf_weight = rl.NuisanceParameter('PDF_weight', 'shape')
    scale_ggF = rl.NuisanceParameter('scale_ggF', 'lnN')
    scale_VBF = rl.NuisanceParameter('scale_VBF', 'lnN')
    scale_VH = rl.NuisanceParameter('scale_VH', 'lnN')
    scale_ttH = rl.NuisanceParameter('scale_ttH', 'lnN')
    ps_weight = rl.NuisanceParameter('PS_weight', 'shape')

    tqqeffSF = rl.IndependentParameter('tqqeffSF', 1., 0, 20)
    tqqnormSF = rl.IndependentParameter('tqqnormSF', 1., 0, 20)

    ptbins = np.array([450, 1200])
    npt = len(ptbins) - 1
    msdbins = np.linspace(47, 201, 23)
    msd = rl.Observable('msd', msdbins)
    mjjbins = np.array([350,1000,4000])
    nmjj = len(mjjbins) - 1

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
    for mjjbin in range(nmjj):
        failCh = rl.Channel("mjjbin%d%s" % (mjjbin, 'fail'))
        passCh = rl.Channel("mjjbin%d%s" % (mjjbin, 'pass'))
        qcdmodel.addChannel(failCh)
        qcdmodel.addChannel(passCh)

        # QCD templates from file
        failTempl = get_template("QCD", 0, mjjbin+1, obs=msd, syst="nominal") #
        passTempl = get_template("QCD", 1, mjjbin+1, obs=msd, syst="nominal") #

        failCh.setObservation(failTempl, read_sumw2=True)
        passCh.setObservation(passTempl, read_sumw2=True)

        qcdfail += sum([val[0] for val in failCh.getObservation()])
        qcdpass += sum([val[0] for val in passCh.getObservation()])

    qcdeff = qcdpass / qcdfail
    print("Inclusive P/F from Monte Carlo = " + str(qcdeff))

    # initial values
    print("Initial fit values read from file initial_vals.csv")
    initial_vals = np.genfromtxt('initial_vals.csv')
    initial_vals = initial_vals.reshape(1, 3)
    print(initial_vals)

    tf_MCtempl = rl.BernsteinPoly("tf_MCtempl", (0, 2), ['pt', 'rho'], init_params=initial_vals, limits=(-20, 20))
    tf_MCtempl_params = qcdeff * tf_MCtempl(ptscaled, rhoscaled)
    for mjjbin in range(nmjj):
        failCh = qcdmodel['mjjbin%dfail' % mjjbin]
        passCh = qcdmodel['mjjbin%dpass' % mjjbin]
        failObs = failCh.getObservation()
        passObs = passCh.getObservation()

        qcdparams = np.array([rl.IndependentParameter('qcdparam_mjjbin%d_msdbin%d' % (mjjbin, i), 0) for i in range(msd.nbins)])
        sigmascale = 10.
        scaledparams = failObs * (1 + sigmascale/np.maximum(1., np.sqrt(failObs)))**qcdparams

        fail_qcd = rl.ParametericSample('mjjbin%dfail_qcd' % mjjbin, rl.Sample.BACKGROUND, msd, scaledparams[0])
        failCh.addSample(fail_qcd)
        pass_qcd = rl.TransferFactorSample('mjjbin%dpass_qcd' % mjjbin, rl.Sample.BACKGROUND, tf_MCtempl_params[0, :], fail_qcd)
        passCh.addSample(pass_qcd)

        failCh.mask = validbins[0]
        passCh.mask = validbins[0]

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

    param_names = [p.name for p in tf_MCtempl.parameters.reshape(-1)]
    decoVector = rl.DecorrelatedNuisanceVector.fromRooFitResult(tf_MCtempl.name + '_deco', qcdfit, param_names)
    tf_MCtempl.parameters = decoVector.correlated_params.reshape(tf_MCtempl.parameters.shape)
    tf_MCtempl_params_final = tf_MCtempl(ptscaled, rhoscaled)
    tf_dataResidual = rl.BernsteinPoly("tf_dataResidual", (0, 2), ['pt', 'rho'], limits=(-20, 20))
    tf_dataResidual_params = tf_dataResidual(ptscaled, rhoscaled)
    tf_params = qcdeff * tf_MCtempl_params_final * tf_dataResidual_params

    # build actual fit model now
    model = rl.Model("testModel")

    # exclud QCD from MC samps
    samps = ['ggF','VBF','WH','ZH','ttH','ttbar','singlet','Zjets','Wjets','VV']
    sigs = ['VBF']

    for mjjbin in range(nmjj):
        for region in ['pass', 'fail']:
            ch = rl.Channel("mjjbin%d%s" % (mjjbin, region))
            model.addChannel(ch)

            isPass = region == 'pass'
            mjjnorm = 1.

            templates = {}
            
            for sName in samps:

                templates[sName] = get_template(sName, isPass, mjjbin+1, obs=msd, syst="nominal") 
                nominal = templates[sName][0]

                # expectations
                templ = templates[sName]
                stype = rl.Sample.SIGNAL if sName in sigs else rl.Sample.BACKGROUND
                sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)

                if sName != "QCD":
                    sample.setParamEffect(lumi, 1.027)
                    
                    jet_trigger_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="jet_triggerUp")[0], nominal)
                    jet_trigger_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="jet_triggerDown")[0], nominal)
                    sample.setParamEffect(jet_trigger, jet_trigger_up, jet_trigger_down)

                    jes_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="JESUp")[0], nominal)
                    jes_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="JESDown")[0], nominal)
                    sample.setParamEffect(jes, jes_up, jes_down)

                    jer_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="JERUp")[0], nominal)
                    jer_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="JERDown")[0], nominal)
                    sample.setParamEffect(jer, jer_up, jer_down)

                    ues_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="UESUp")[0], nominal)
                    ues_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="UESDown")[0], nominal)
                    sample.setParamEffect(ues, ues_up, ues_down) 

                    btagWeight_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="btagWeightUp")[0], nominal)
                    btagWeight_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="btagWeightDown")[0], nominal)
                    sample.setParamEffect(btagWeight, btagWeight_up, btagWeight_down)

                    btagEffStat_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="btagEffStatUp")[0], nominal)
                    btagEffStat_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="btagEffStatDown")[0], nominal)
                    sample.setParamEffect(btagEffStat, btagEffStat_up, btagEffStat_down)

                if sName != "QCD":
                    pdf_weight_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="PDF_weightUp")[0], nominal)
                    pdf_weight_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="PDF_weightDown")[0], nominal)
                    sample.setParamEffect(pdf_weight, pdf_weight_up, pdf_weight_down)

                if sName == "ggF":
                    scale_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_7ptUp")[0], nominal)
                    scale_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_7ptDown")[0], nominal)
                    sample.setParamEffect(scale_ggF, scale_up, scale_down)
                if sName == "VBF":
                    scale_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_3ptUp")[0], nominal)
                    scale_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_3ptDown")[0], nominal)
                    sample.setParamEffect(scale_VBF, scale_up, scale_down)
                if sName == "VH":
                    scale_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_3ptUp")[0], nominal)
                    scale_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_3ptDown")[0], nominal)
                    sample.setParamEffect(scale_VH, scale_up, scale_down)
                if sName == "ttH":
                    scale_up = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_7ptUp")[0], nominal)
                    scale_down = syst_variation(get_template(sName, isPass, mjjbin+1, obs=msd, syst="scalevar_7ptDown")[0], nominal)
                    sample.setParamEffect(scale_ttH, scale_up, scale_down)

                ch.addSample(sample)

            data_obs = get_template("data", isPass, mjjbin+1, obs=msd, syst="nominal")
            ch.setObservation(data_obs, read_sumw2=True)

            # drop bins outside rho validity
            mask = validbins[0]

            # blind bins 11, 12, 13
#            mask[11:14] = False
#            ch.mask = mask

    for mjjbin in range(nmjj):
        failCh = model['mjjbin%dfail' % mjjbin]
        passCh = model['mjjbin%dpass' % mjjbin]

        qcdparams = np.array([rl.IndependentParameter('qcdparam_mjjbin%d_msdbin%d' % (mjjbin, i), 0) for i in range(msd.nbins)])
        initial_qcd = failCh.getObservation()[0].astype(float)  # was integer, and numpy complained about subtracting float from it

        for sample in failCh:
            initial_qcd -= sample.getExpectation(nominal=True)

        if np.any(initial_qcd < 0.):
            raise ValueError("initial_qcd negative for some bins..", initial_qcd)

        sigmascale = 10  # to scale the deviation from initial
        scaledparams = initial_qcd * (1 + sigmascale/np.maximum(1., np.sqrt(initial_qcd)))**qcdparams
        fail_qcd = rl.ParametericSample('mjjbin%dfail_qcd' % mjjbin, rl.Sample.BACKGROUND, msd, scaledparams)
        failCh.addSample(fail_qcd)
        pass_qcd = rl.TransferFactorSample('mjjbin%dpass_qcd' % mjjbin, rl.Sample.BACKGROUND, tf_params[0, :], fail_qcd)
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

