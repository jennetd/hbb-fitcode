from __future__ import print_function, division
import sys, os
import csv, json
import numpy as np
from scipy.interpolate import interp1d
import scipy.stats
import pickle
import ROOT
import pandas as pd

import rhalphalib as rl
rl.util.install_roofit_helpers()
rl.ParametericSample.PreferRooParametricHist = False

def get_template(sName, passed, ptbin, cat, obs, syst, muon=False):
    """
    Read msd template from root file
    """

    f = ROOT.TFile.Open('signalregion.root')
    if muon:
        f = ROOT.TFile.Open('muonCR.root')

    name = cat+'fail_'
    if passed:
        name = cat+'pass_'
    if cat == 'ggf_':
        name += 'pt'+str(ptbin)+'_'
    if cat == 'vbf_':
        name += 'mjj'+str(ptbin)+'_'

    name += sName+'_'+syst

    h = f.Get(name)
    sumw = []
    sumw2 = []

    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def ggfvbf_rhalphabet(tmpdir,
                    throwPoisson = True,
                    fast=0):
    """ 
    Create the data cards!
    """

    # define bins    
    ptbins = {}
    ptbins['ggf'] = np.array([450, 500, 550, 600, 675, 800, 1200])
    ptbins['vbf'] = np.array([450,1200])

    mjjbins = {}
    mjjbins['ggf'] = np.array([0,4000])
    mjjbins['vbf'] = np.array([1000,2000,4000])

    npt = {}
    npt['ggf'] = len(ptbins['ggf']) - 1
    npt['vbf'] = len(ptbins['vbf']) - 1

    nmjj = {}
    nmjj['ggf'] = len(mjjbins['ggf']) - 1
    nmjj['vbf'] = len(mjjbins['vbf']) - 1

    msdbins = np.linspace(40, 201, 24)
    msd = rl.Observable('msd', msdbins)

    validbins = {}

    thecat = 'ggf'
    thisdir = os.getcwd()
    if 'vbf-mc' in thisdir:
        thecat = 'vbf'

    # Build model
    tf_params = {}
    for cat in [thecat]:

        qcdeff = 0.001

        # here we derive these all at once with 2D array                            
        ptpts, msdpts = np.meshgrid(ptbins[cat][:-1] + 0.3 * np.diff(ptbins[cat]), msdbins[:-1] + 0.5 * np.diff(msdbins), indexing='ij')
        rhopts = 2*np.log(msdpts/ptpts)
        ptscaled = (ptpts - 450.) / (1200. - 450.)
        rhoscaled = (rhopts - (-6)) / ((-2.1) - (-6))
        validbins[cat] = (rhoscaled >= 0) & (rhoscaled <= 1)
        rhoscaled[~validbins[cat]] = 1  # we will mask these out later   

        # build actual fit model 
        model = rl.Model('testModel_'+year)

        # Initial TF coeffient values
        print('Initial fit values read from file initial_vals*')
        with open('initial_vals_'+cat+'.json') as f:
            initial_vals = np.array(json.load(f)['initial_vals'])
        print(initial_vals)

        tf_MCtempl = rl.BernsteinPoly('tf_MCtempl_'+cat, (initial_vals.shape[0]-1,initial_vals.shape[1]-1), ['pt', 'rho'], limits=(-10, 10))
        tf_MCtempl_params = qcdeff * tf_MCtempl(ptscaled, rhoscaled)
        tf_params[cat] = qcdeff * tf_MCtempl_params

        for ptbin in range(npt[cat]):
            for mjjbin in range(nmjj[cat]):
                
                binindex = ptbin
                if cat == 'vbf':
                    binindex = mjjbin
                print("Bin: " + cat + " bin " + str(binindex))

                passCh = rl.Channel('ptbin%dmjjbin%d%spass%s' % (ptbin, mjjbin, cat, year))  


                # QCD templates from file                                                                                                                         
                failTempl = get_template('QCD', 0, binindex+1, cat+'_', obs=msd, syst='nominal')
                initial_qcd = failTempl[0]

                qcdparams = np.array([rl.IndependentParameter('qcdparam_'+cat+'_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])

                sigmascale = 10  # to scale the deviation from initial                                                      
                scaledparams = initial_qcd * (1 + sigmascale/np.maximum(1., np.sqrt(initial_qcd)))**qcdparams
                fail_qcd = rl.ParametericSample('ptbin%dmjjbin%d%sfail%s_qcd' % (ptbin, mjjbin, cat, year), rl.Sample.BACKGROUND, msd, scaledparams)

                pass_qcd = rl.TransferFactorSample('ptbin%dmjjbin%d%spass%s_qcd' % (ptbin, mjjbin, cat, year), rl.Sample.BACKGROUND, tf_params[cat][ptbin, :], fail_qcd)
                passCh.addSample(pass_qcd)

                # Take random Higgs sample as signal. To be fixed to 0 in GoodnessOfFit
                fake_signal = rl.TemplateSample(passCh.name+'_ggF', rl.Sample.SIGNAL, get_template('ggF', 1, binindex+1, cat+'_', obs=msd, syst='nominal'))
                passCh.addSample(fake_signal)

                # passing QCD MC = fake data
                passCh.setObservation(get_template('QCD', 1, binindex+1, cat+'_', obs=msd, syst='nominal'), read_sumw2=True)

                model.addChannel(passCh)

    with open(os.path.join(str(tmpdir), 'testModel_'+year+'.pkl'), 'wb') as fout:
        pickle.dump(model, fout)

    model.renderCombine(os.path.join(str(tmpdir), 'testModel_'+year))

if __name__ == '__main__':

    year = "2016"
    thisdir = os.getcwd()
    if "2017" in thisdir: 
        year = "2017"
    elif "2018" in thisdir:
        year = "2018"

    print("Running for "+year)

    if not os.path.exists('output'):
        os.mkdir('output')

    ggfvbf_rhalphabet('output',year)

