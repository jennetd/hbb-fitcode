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
import json

class AffineMorphTemplate(object):
    def __init__(self, hist):
        '''                                                                                                   
        hist: a numpy-histogram-like tuple of (sumw, edges)                                                       
        '''
        from scipy.interpolate import interp1d

        self.sumw = hist[0]
        self.edges = hist[1]
        self.norm = self.sumw.sum()
        self.mean = (self.sumw*(self.edges[:-1] + self.edges[1:])/2).sum() / self.norm
        self.cdf = interp1d(x=self.edges,
                            y=np.r_[0, np.cumsum(self.sumw / self.norm)],
                            kind='linear',
                            assume_sorted=True,
                            bounds_error=False,
                            fill_value=(0, 1),
                           )

    def get(self, shift=0., scale=1.):
        '''                                                                                                             
        Return a shifted and scaled histogram                                                                                      
        i.e. new edges = edges * scale + shift                                                                                      
        '''
        scaled_edges = (self.edges - shift) / scale
        return np.diff(self.cdf(scaled_edges)) * self.norm, self.edges

def syst_variation(numerator,denominator):
    """
    Get systematic variation relative to nominal (denominator)
    """
    var = np.divide(numerator,denominator)
    var[np.where(numerator==0)] = 1
    var[np.where(denominator==0)] = 1
    return var

def get_template(sName, passed, ptbin, obs, syst, muon=False):
    """
    Read msd template from root file
    """
    f = ROOT.TFile.Open('signalregion.root')
    if muon:
        f = ROOT.TFile.Open('muonCR.root')

    name = 'fail_'
    if passed:
        name = 'pass_'
    if ptbin >=0:
        name += 'pt'+str(ptbin)+'_'+sName+'_'+syst
    else:
        name += sName+'_'+syst

    h = f.Get(name)
    sumw = []
    sumw2 = []
    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def passfailSF(isPass, sName, ptbin, obs, mask, SF=1, SF_unc=0.1, muon=False):
    """
    Return (SF, SF_unc) for a pass/fail scale factor.
    """
    if isPass:
        return SF, 1. + SF_unc / SF
    else:
        _pass = get_template(sName, 1, ptbin, obs=obs, syst='nominal', muon=muon)
        _pass_rate = np.sum(_pass[0] * mask)

        _fail = get_template(sName, 0, ptbin, obs=obs, syst='nominal', muon=muon)
        _fail_rate = np.sum(_fail[0] * mask)

        if _fail_rate > 0:
            _sf = 1 + (1 - SF) * _pass_rate / _fail_rate
            _sfunc = 1. - SF_unc * (_pass_rate / _fail_rate)
            return _sf, _sfunc
        else:
            return 1, 1

def plot_mctf(tf_MCtempl, msdbins):
    """
    Plot the MC pass / fail TF as function of (pt,rho) and (pt,msd)
    """
    import matplotlib.pyplot as plt

    # arrays for plotting pt vs msd                    
    pts = np.linspace(450,1200,15)
    ptpts, msdpts = np.meshgrid(pts[:-1] + 0.5 * np.diff(pts), msdbins[:-1] + 0.5 * np.diff(msdbins), indexing='ij')
    ptpts_scaled = (ptpts - 450.) / (1200. - 450.)
    rhopts = 2*np.log(msdpts/ptpts)

    rhopts_scaled = (rhopts - (-6)) / ((-2.1) - (-6))
    validbins = (rhopts_scaled >= 0) & (rhopts_scaled <= 1)

    ptpts = ptpts[validbins]
    msdpts = msdpts[validbins]
    ptpts_scaled = ptpts_scaled[validbins]
    rhopts_scaled = rhopts_scaled[validbins]

    tf_MCtempl_vals = tf_MCtempl(ptpts_scaled, rhopts_scaled, nominal=True)
    df = pd.DataFrame([])
    df['msd'] = msdpts.reshape(-1)
    df['pt'] = ptpts.reshape(-1)
    df['MCTF'] = tf_MCtempl_vals.reshape(-1)

    fig, ax = plt.subplots()
    h = ax.hist2d(x=df["msd"],y=df["pt"],weights=df["MCTF"], bins=(msdbins,pts))
    plt.xlabel("$m_{sd}$ [GeV]")
    plt.ylabel("$p_{T}$ [GeV]")
    cb = fig.colorbar(h[3],ax=ax)
    cb.set_label("Ratio")
    fig.savefig("MCTF_msdpt.png",bbox="tight")
    plt.clf()

    # arrays for plotting pt vs rho                                          
    rhos = np.linspace(-6,-2.1,23)
    ptpts, rhopts = np.meshgrid(pts[:-1] + 0.5*np.diff(pts), rhos[:-1] + 0.5 * np.diff(rhos), indexing='ij')
    ptpts_scaled = (ptpts - 450.) / (1200. - 450.)
    rhopts_scaled = (rhopts - (-6)) / ((-2.1) - (-6))
    validbins = (rhopts_scaled >= 0) & (rhopts_scaled <= 1)

    ptpts = ptpts[validbins]
    rhopts = rhopts[validbins]
    ptpts_scaled = ptpts_scaled[validbins]
    rhopts_scaled = rhopts_scaled[validbins]

    tf_MCtempl_vals = tf_MCtempl(ptpts_scaled, rhopts_scaled, nominal=True)

    df = pd.DataFrame([])
    df['rho'] = rhopts.reshape(-1)
    df['pt'] = ptpts.reshape(-1)
    df['MCTF'] = tf_MCtempl_vals.reshape(-1)

    fig, ax = plt.subplots()
    h = ax.hist2d(x=df["rho"],y=df["pt"],weights=df["MCTF"],bins=(rhos,pts))
    plt.xlabel("rho")
    plt.ylabel("$p_{T}$ [GeV]")
    cb = fig.colorbar(h[3],ax=ax)
    cb.set_label("Ratio")
    fig.savefig("MCTF_rhopt.png",bbox="tight")

    return

def test_rhalphabet(tmpdir,
                    throwPoisson = True,
                    fast=0):
    """ 
    Create the data cards!
    """
    with open('sf.json') as f:
        SF = json.load(f)

    # TT params
    tqqeffSF = rl.IndependentParameter('tqqeffSF_{}'.format(year), 1., 0, 10)
    tqqnormSF = rl.IndependentParameter('tqqnormSF_{}'.format(year), 1., 0, 10)

    # define bins    
    ptbins = np.array([450, 500, 550, 600, 675, 800, 1200])
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
    qcdmodel = rl.Model('qcdmodel')
    qcdpass, qcdfail = 0., 0.
    for ptbin in range(npt):
        failCh = rl.Channel('ptbin%d%s' % (ptbin, 'fail'))
        passCh = rl.Channel('ptbin%d%s' % (ptbin, 'pass'))
        qcdmodel.addChannel(failCh)
        qcdmodel.addChannel(passCh)

        # QCD templates from file
        failTempl = get_template('QCD', 0, ptbin+1, obs=msd, syst='nominal') 
        passTempl = get_template('QCD', 1, ptbin+1, obs=msd, syst='nominal') 

        failCh.setObservation(failTempl, read_sumw2=True)
        passCh.setObservation(passTempl, read_sumw2=True)

        qcdfail += sum([val[0] for val in failCh.getObservation()])
        qcdpass += sum([val[0] for val in passCh.getObservation()])

    qcdeff = qcdpass / qcdfail
    print('Inclusive P/F from Monte Carlo = ' + str(qcdeff))

    # initial values
    print('Initial fit values read from file initial_vals.csv')
    initial_vals = np.genfromtxt('initial_vals.csv')
    initial_vals = initial_vals.reshape(3,3)
    print(initial_vals)

    tf_MCtempl = rl.BernsteinPoly('tf_MCtempl', (2, 2), ['pt', 'rho'], init_params=initial_vals, limits=(-10, 10))
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
        print(p.name,p.value)

    if qcdfit.status() != 0:
        raise RuntimeError('Could not fit qcd')

    # Plot the MC P/F transfer factor
#    plot_mctf(tf_MCtempl,msdbins)

    param_names = [p.name for p in tf_MCtempl.parameters.reshape(-1)]
    decoVector = rl.DecorrelatedNuisanceVector.fromRooFitResult(tf_MCtempl.name + '_deco', qcdfit, param_names)
    tf_MCtempl.parameters = decoVector.correlated_params.reshape(tf_MCtempl.parameters.shape)
    tf_MCtempl_params_final = tf_MCtempl(ptscaled, rhoscaled)
    tf_dataResidual = rl.BernsteinPoly('tf_dataResidual', (2, 2), ['pt', 'rho'], limits=(-10, 10))
    tf_dataResidual_params = tf_dataResidual(ptscaled, rhoscaled)
    tf_params = qcdeff * tf_MCtempl_params_final * tf_dataResidual_params

    # build actual fit model now
    model = rl.Model('testModel')

    # exclude QCD from MC samps
    samps = ['ggF','VBF','WH','ZH','ttH','ttbar','singlet','Zjets','Wjets','VV']
    sigs = ['ggF','VBF','WH','ZH','ttH']

    for ptbin in range(npt):
        for region in ['pass', 'fail']:

            # drop bins outside rho validity                                                                                         
            mask = validbins[ptbin]

            ch = rl.Channel('ptbin%d%s' % (ptbin, region))
            model.addChannel(ch)

            isPass = region == 'pass'
            templates = {}
            
            for sName in samps:

                templates[sName] = get_template(sName, isPass, ptbin+1, obs=msd, syst='nominal') 
                nominal = templates[sName][0]

                # expectations
                templ = templates[sName]
                stype = rl.Sample.SIGNAL if sName in sigs else rl.Sample.BACKGROUND
                sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)
                
                ch.addSample(sample)

            data_obs = get_template('data', isPass, ptbin+1, obs=msd, syst='nominal')
            ch.setObservation(data_obs, read_sumw2=True)

            # drop bins outside rho validity
            mask = validbins[ptbin]

            # blind bins 11, 12, 13
#            mask[11:14] = False
#            ch.mask = mask

    for ptbin in range(npt):
        failCh = model['ptbin%dfail' % ptbin]
        passCh = model['ptbin%dpass' % ptbin]

        qcdparams = np.array([rl.IndependentParameter('qcdparam_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
        initial_qcd = failCh.getObservation()[0].astype(float)  # was integer, and numpy complained about subtracting float from it

        for sample in failCh:
            initial_qcd -= sample.getExpectation(nominal=True)

        if np.any(initial_qcd < 0.):
            raise ValueError('initial_qcd negative for some bins..', initial_qcd)

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

#    # Fill in muon CR
    templates = {}
    samps = ['ttbar','QCD','singlet','Zjets','Wjets','VV']
    for region in ['pass', 'fail']:
        ch = rl.Channel('muonCR%s' % (region, ))
        model.addChannel(ch)

        isPass = region == 'pass'

        for sName in samps:
            templates[sName] = get_template(sName, isPass, -1, obs=msd, syst='nominal', muon=True)

            stype = rl.Sample.BACKGROUND
            sample = rl.TemplateSample(ch.name + '_' + sName, stype, templates[sName])

            ch.addSample(sample)

        data_obs = get_template('muondata', isPass, -1, obs=msd, syst='nominal', muon=True)
        ch.setObservation(data_obs, read_sumw2=True)

    tqqpass = model['muonCRpass_ttbar']
    tqqfail = model['muonCRfail_ttbar']
    tqqPF = tqqpass.getExpectation(nominal=True).sum() / tqqfail.getExpectation(nominal=True).sum()
    tqqpass.setParamEffect(tqqeffSF, 1*tqqeffSF)
    tqqfail.setParamEffect(tqqeffSF, (1 - tqqeffSF) * tqqPF + 1)
    tqqpass.setParamEffect(tqqnormSF, 1*tqqnormSF)
    tqqfail.setParamEffect(tqqnormSF, 1*tqqnormSF)

    with open(os.path.join(str(tmpdir), 'testModel.pkl'), 'wb') as fout:
        pickle.dump(model, fout)

    model.renderCombine(os.path.join(str(tmpdir), 'testModel'))

if __name__ == '__main__':

    year = sys.argv[1]
    if not os.path.exists('output'):
        os.mkdir('output')

    test_rhalphabet('output',year)

