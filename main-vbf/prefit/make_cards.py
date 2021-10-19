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

eps=0.0000001

class AffineMorphTemplate(object):
    def __init__(self, hist):
        '''                                                   
        hist: a numpy-histogram-like tuple of (sumw, edges)    
        '''
        self.sumw = hist[0]
        self.edges = hist[1]
        self.varname = hist[2]
        self.centers = self.edges[:-1] + np.diff(self.edges)/2
        self.norm = self.sumw.sum()

        self.mean = (self.sumw*self.centers).sum() / self.norm
        self.cdf = interp1d(x=self.edges,
                            y=np.r_[0, np.cumsum(self.sumw / self.norm)],
                            kind='linear',
                            assume_sorted=True,
                            bounds_error=False,
                            fill_value=(0, 1),
        )

    def get(self, shift=0., smear=1.):
        '''                                                   
        Return a shifted and smeared histogram                
        i.e. new edges = edges * smear + shift                
        '''
        if not np.isclose(smear, 1.):
            shift += self.mean * (1 - smear)
        smeard_edges = (self.edges - shift) / smear
        return np.diff(self.cdf(smeard_edges)) * self.norm, self.edges, self.varname

def badtemp_ma(hvalues, mask=None):
    # Need minimum size & more than 1 non-zero bins           
    tot = np.sum(hvalues[mask])
    
    count_nonzeros = np.sum(hvalues[mask] > 0)
    if (tot < eps) or (count_nonzeros < 2):
        return True
    else:
        return False

def syst_variation(numerator,denominator):
    """
    Get systematic variation relative to nominal (denominator)
    """
    var = np.divide(numerator,denominator)
    var[np.where(numerator==0)] = 1
    var[np.where(denominator==0)] = 1

    return var

def smass(sName):
    if sName in ['ggF','VBF','WH','ZH','ggZH','ttH']:
        _mass = 125.
    elif sName in ['Wjets','ttbar','singlet','VV']:
        _mass = 80.379
    elif 'Zjets' in sName:
        _mass = 91.
    else:
        raise ValueError("What is {}".format(sName))
    return _mass

def get_template_year(y, sName, passed, ptbin, cat, obs, syst, muon=False):
    """                                                                                                                                   
    Read msd template from root file for year y                                                                    
    """

    f = ROOT.TFile.Open(y+'-signalregion.root')
    if muon:
        f = ROOT.TFile.Open(y+'-muonCR.root')

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

def shape_to_num(nom, up, down):
    nom_rate = np.sum(nom)
    if nom_rate < .1:
        return 1.0
    up_rate = np.sum(up)
    down_rate = np.sum(down)

    diff = np.abs(up_rate - nom_rate) + np.abs(down_rate - nom_rate)
    return 1.0 + diff / (2. * nom_rate)

def passfailSF(isPass, sName, ptbin, cat, obs, mask, SF=1, SF_unc=0.1, muon=False):
    """
    Return (SF, SF_unc) for a pass/fail scale factor.
    """
    if isPass:
        return SF, 1. + SF_unc / SF
    else:
        _pass = get_template(sName, 1, ptbin+1, cat, obs=obs, syst='nominal', muon=muon)
        _pass_rate = np.sum(_pass[0] * mask)

        _fail = get_template(sName, 0, ptbin+1, cat, obs=obs, syst='nominal', muon=muon)
        _fail_rate = np.sum(_fail[0] * mask)

        if _fail_rate > 0:
            _sf = 1 + (1 - SF) * _pass_rate / _fail_rate
            _sfunc = 1. - SF_unc * (_pass_rate / _fail_rate)

            eps=0.0000001
            if _sfunc < eps:
                return 0, 0
            return _sf, _sfunc
        else:
            return 1, 1

def plot_mctf(tf_MCtempl, msdbins, name):
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
    fig.savefig("plots/MCTF_msdpt_"+name+".png",bbox="tight")
    fig.savefig("plots/MCTF_msdpt_"+name+".pdf",bbox="tight")
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
    fig.savefig("plots/MCTF_rhopt_"+name+".png",bbox="tight")
    fig.savefig("plots/MCTF_rhopt_"+name+".pdf",bbox="tight")

    return

def ggfvbf_rhalphabet(tmpdir,
                    throwPoisson = True,
                    fast=0):
    """ 
    Create the data cards!
    """
    with open('sf.json') as f:
        SF = json.load(f)

    with open('lumi.json') as f:
        lumi = json.load(f)

    vbf_ttbar_unc = dict({"2016":1.29,"2017":1.34,"2018":1.52})

    # TT params
    tqqeffSF = rl.IndependentParameter('tqqeffSF_{}'.format(year), 1., 0, 10)
    tqqnormSF = rl.IndependentParameter('tqqnormSF_{}'.format(year), 1., 0, 10)

    # Systematics
    sys_lumi_uncor = rl.NuisanceParameter('CMS_lumi_13TeV_{}'.format(year), 'lnN')
    sys_lumi_cor_161718 = rl.NuisanceParameter('CMS_lumi_13TeV_correlated_', 'lnN')
    sys_lumi_cor_1718 = rl.NuisanceParameter('CMS_lumi_13TeV_correlated_20172018', 'lnN')

    sys_eleveto = rl.NuisanceParameter('CMS_hbb_e_veto_{}'.format(year), 'lnN')                                    
    sys_muveto = rl.NuisanceParameter('CMS_hbb_mu_veto_{}'.format(year), 'lnN')  
    sys_tauveto = rl.NuisanceParameter('CMS_hbb_tau_veto_{}'.format(year), 'lnN')

    sys_dict = {}

    # Systematics 

    # experimental systematics are uncorrelated across years
    sys_dict['mu_isoweight'] = rl.NuisanceParameter('CMS_mu_iso_{}'.format(year), 'lnN')
    sys_dict['mu_idweight'] = rl.NuisanceParameter('CMS_mu_id_{}'.format(year), 'lnN')
    sys_dict['mu_trigger'] = rl.NuisanceParameter('CMS_hbb_mu_trigger_{}'.format(year), 'lnN')
    sys_dict['JES'] = rl.NuisanceParameter('CMS_scale_j_{}'.format(year), 'lnN')
    sys_dict['JER'] = rl.NuisanceParameter('CMS_res_j_{}'.format(year), 'lnN')
    sys_dict['UES'] = rl.NuisanceParameter('CMS_ues_j_{}'.format(year), 'lnN')
    sys_dict['jet_trigger'] = rl.NuisanceParameter('CMS_hbb_jet_trigger_{}'.format(year), 'lnN')
    sys_dict['pileup_weight'] = rl.NuisanceParameter('CMS_hbb_PU_{}'.format(year), 'lnN')
    sys_dict['btagWeight'] = rl.NuisanceParameter('CMS_hbb_btagWeight_{}'.format(year), 'lnN')
    sys_dict['btagEffStat'] = rl.NuisanceParameter('CMS_hbb_btagEffStat_{}'.format(year),'lnN')

    sys_prefire = rl.NuisanceParameter('CMS_L1Prefiring_{}'.format(year),'lnN')

    sys_ddxeffbb = rl.NuisanceParameter('CMS_eff_bb_{}'.format(year), 'lnN')
    sys_veff = rl.NuisanceParameter('CMS_hbb_veff_{}'.format(year), 'lnN')

    sys_scale = rl.NuisanceParameter('CMS_hbb_scale_{}'.format(year), 'shape')
    sys_smear = rl.NuisanceParameter('CMS_hbb_smear_{}'.format(year), 'shape')

    sys_vbf_ttbar_unc = rl.NuisanceParameter('CMS_hbb_vbfmucr_{}'.format(year), 'lnN')

    # theory systematics are correlated across years
    for sys in ['d1kappa_EW', 'Z_d2kappa_EW', 'Z_d3kappa_EW', 'W_d2kappa_EW', 'W_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
        sys_dict[sys] = rl.NuisanceParameter('CMS_hbb_{}'.format(sys), 'lnN')
            
    Zjets_thsysts = ['d1kappa_EW', 'Z_d2kappa_EW', 'Z_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']
    Wjets_thsysts = ['d1kappa_EW', 'W_d2kappa_EW', 'W_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']         
                      
    pdf_Higgs_ggF = rl.NuisanceParameter('pdf_Higgs_ggF','lnN')
    pdf_Higgs_VBF = rl.NuisanceParameter('pdf_Higgs_VBF','lnN')
    pdf_Higgs_VH  = rl.NuisanceParameter('pdf_Higgs_VH','lnN')
    pdf_Higgs_ttH = rl.NuisanceParameter('pdf_Higgs_ttH','lnN')

    scale_ggF = rl.NuisanceParameter('QCDscale_ggF', 'lnN')
    scale_VBF = rl.NuisanceParameter('QCDscale_VBF', 'lnN')
    scale_VH = rl.NuisanceParameter('QCDscale_VH', 'lnN')
    scale_ttH = rl.NuisanceParameter('QCDscale_ttH', 'lnN')

    isr_ggF = rl.NuisanceParameter('UEPS_ISR_ggF', 'lnN')
    isr_VBF = rl.NuisanceParameter('UEPS_ISR_VBF', 'lnN')
    isr_VH = rl.NuisanceParameter('UEPS_ISR_VH', 'lnN')
    isr_ttH = rl.NuisanceParameter('UEPS_ISR_ttH', 'lnN')

    fsr_ggF = rl.NuisanceParameter('UEPS_FSR_ggF', 'lnN')
    fsr_VBF = rl.NuisanceParameter('UEPS_FSR_VBF', 'lnN')
    fsr_VH = rl.NuisanceParameter('UEPS_FSR_VH', 'lnN')
    fsr_ttH = rl.NuisanceParameter('UEPS_FSR_ttH', 'lnN')

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

    cats = ['ggf','vbf']
    ncat = len(cats)

    # Build qcd MC pass+fail model and fit to polynomial
    tf_params = {}
    for cat in cats:

        fitfailed_qcd = 0

        # here we derive these all at once with 2D array                            
        ptpts, msdpts = np.meshgrid(ptbins[cat][:-1] + 0.3 * np.diff(ptbins[cat]), msdbins[:-1] + 0.5 * np.diff(msdbins), indexing='ij')
        rhopts = 2*np.log(msdpts/ptpts)
        ptscaled = (ptpts - 450.) / (1200. - 450.)
        rhoscaled = (rhopts - (-6)) / ((-2.1) - (-6))
        validbins[cat] = (rhoscaled >= 0) & (rhoscaled <= 1)
        rhoscaled[~validbins[cat]] = 1  # we will mask these out later   

        while fitfailed_qcd < 5:
        
            qcdmodel = rl.Model('qcdmodel_'+cat)
            qcdpass, qcdfail = 0., 0.

            for ptbin in range(npt[cat]):
                for mjjbin in range(nmjj[cat]):

                    failCh = rl.Channel('ptbin%dmjjbin%d%s%s%s' % (ptbin, mjjbin, cat, 'fail',year))
                    passCh = rl.Channel('ptbin%dmjjbin%d%s%s%s' % (ptbin, mjjbin, cat, 'pass',year))
                    qcdmodel.addChannel(failCh)
                    qcdmodel.addChannel(passCh)

                    binindex = ptbin
                    if cat == 'vbf':
                        binindex = mjjbin

                    # QCD templates from file                           
                    failTempl = get_template('QCD', 0, binindex+1, cat+'_', obs=msd, syst='nominal')
                    passTempl = get_template('QCD', 1, binindex+1, cat+'_', obs=msd, syst='nominal')

                    failCh.setObservation(failTempl, read_sumw2=True)
                    passCh.setObservation(passTempl, read_sumw2=True)

                    qcdfail += sum([val for val in failCh.getObservation()[0]])
                    qcdpass += sum([val for val in passCh.getObservation()[0]])

            qcdeff = qcdpass / qcdfail
            print('Inclusive P/F from Monte Carlo = ' + str(qcdeff))

            # initial values                                                                 
            print('Initial fit values read from file initial_vals*')
            with open('initial_vals_'+cat+'.json') as f:
                initial_vals = np.array(json.load(f)['initial_vals'])
            print(initial_vals)

            tf_MCtempl = rl.BernsteinPoly('tf_MCtempl_'+cat, (initial_vals.shape[0]-1,initial_vals.shape[1]-1), ['pt', 'rho'], init_params=initial_vals, limits=(-5, 5))
            tf_MCtempl_params = qcdeff * tf_MCtempl(ptscaled, rhoscaled)

            for ptbin in range(npt[cat]):
                for mjjbin in range(nmjj[cat]):

                    failCh = qcdmodel['ptbin%dmjjbin%d%sfail%s' % (ptbin, mjjbin, cat, year)]
                    passCh = qcdmodel['ptbin%dmjjbin%d%spass%s' % (ptbin, mjjbin, cat, year)]
                    failObs = failCh.getObservation()
                    passObs = passCh.getObservation()
                
                    qcdparams = np.array([rl.IndependentParameter('qcdparam_'+cat+'_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
                    sigmascale = 10.
                    scaledparams = failObs * (1 + sigmascale/np.maximum(1., np.sqrt(failObs)))**qcdparams
                
                    fail_qcd = rl.ParametericSample('ptbin%dmjjbin%d%sfail%s_qcd' % (ptbin, mjjbin, cat, year), rl.Sample.BACKGROUND, msd, scaledparams[0])
                    failCh.addSample(fail_qcd)
                    pass_qcd = rl.TransferFactorSample('ptbin%dmjjbin%d%spass%s_qcd' % (ptbin, mjjbin, cat, year), rl.Sample.BACKGROUND, tf_MCtempl_params[ptbin, :], fail_qcd)
                    passCh.addSample(pass_qcd)
                
                    failCh.mask = validbins[cat][ptbin]
                    passCh.mask = validbins[cat][ptbin]

            qcdfit_ws = ROOT.RooWorkspace('w')

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
            qcdfit_ws.writeToFile(os.path.join(str(tmpdir), 'testModel_qcdfit_'+cat+'_'+year+'.root'))

            # Set parameters to fitted values  
            allparams = dict(zip(qcdfit.nameArray(), qcdfit.valueArray()))
            pvalues = []
            for i, p in enumerate(tf_MCtempl.parameters.reshape(-1)):
                p.value = allparams[p.name]
                pvalues += [p.value]
            
            if qcdfit.status() != 0:
                print('Could not fit qcd')
                fitfailed_qcd += 1

                new_values = np.array(pvalues).reshape(tf_MCtempl.parameters.shape)
                with open("initial_vals_"+cat+".json", "w") as outfile:
                    json.dump({"initial_vals":new_values.tolist()},outfile)

            else:
                break

        if fitfailed_qcd >=5:
            raise RuntimeError('Could not fit qcd after 5 tries')

        print("Fitted qcd for category " + cat)

        # Plot the MC P/F transfer factor                                                   
        plot_mctf(tf_MCtempl,msdbins, cat)                           

        param_names = [p.name for p in tf_MCtempl.parameters.reshape(-1)]
        decoVector = rl.DecorrelatedNuisanceVector.fromRooFitResult(tf_MCtempl.name + '_deco', qcdfit, param_names)
        tf_MCtempl.parameters = decoVector.correlated_params.reshape(tf_MCtempl.parameters.shape)
        tf_MCtempl_params_final = tf_MCtempl(ptscaled, rhoscaled)

        tf_dataResidual = rl.BernsteinPoly('tf_dataResidual_'+cat, (initial_vals.shape[0]-1,initial_vals.shape[1]-1), ['pt', 'rho'], limits=(-10, 10))
        tf_dataResidual_params = tf_dataResidual(ptscaled, rhoscaled)
        tf_params[cat] = qcdeff * tf_MCtempl_params_final * tf_dataResidual_params

    # build actual fit model now
    model = rl.Model('testModel_'+year)

    # exclude QCD from MC samps
    samps = ['ggF','VBF','WH','ZH','ttH','ttbar','singlet','Zjets','Zjetsbb','Wjets','VV']
    sigs = ['ggF','VBF']

    cols = ['bin','region','samp','syst','val']
    df = pd.DataFrame(columns=cols)

    for cat in cats:
        for ptbin in range(npt[cat]):
            for mjjbin in range(nmjj[cat]):
                for region in ['pass', 'fail']:

                    binindex = ptbin
                    if cat == 'vbf':
                        binindex = mjjbin

                    print("Bin: " + cat + " bin " + str(binindex) + " " + region)

                    # drop bins outside rho validity                                                
                    mask = validbins[cat][ptbin]

                    ch = rl.Channel('ptbin%dmjjbin%d%s%s%s' % (ptbin, mjjbin, cat, region, year))
                    model.addChannel(ch)

                    isPass = region == 'pass'
                    templates = {}
            
                    for sName in samps:

                        templates[sName] = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='nominal')
                        nominal = templates[sName][0]

                        if(badtemp_ma(nominal)):
                            print("Sample {} is too small, skipping".format(sName))
                            continue

                        # expectations
                        templ = templates[sName]
                        
                        if sName in sigs:
                            stype = rl.Sample.SIGNAL
                        else:
                            stype = rl.Sample.BACKGROUND
                    
                        sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)
                        sample.autoMCStats(lnN=True)

                        # Experimental systematics #######################################
                        
                        sample.setParamEffect(sys_lumi_uncor, lumi[year]['uncorrelated'])
                        sample.setParamEffect(sys_lumi_cor_161718, lumi[year]['correlated'])
                        sample.setParamEffect(sys_lumi_cor_1718, lumi[year]['correlated_20172018'])

                        sample.setParamEffect(sys_eleveto, 1.005)
                        sample.setParamEffect(sys_muveto, 1.005)
                        sample.setParamEffect(sys_tauveto, 1.005)

                        if year == "2016" or year == "2017":
                            syst_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='L1PrefiringUp')[0]
                            syst_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='L1PrefiringDown')[0]
                            effect = shape_to_num(nominal,syst_up,syst_do)
                            sample.setParamEffect(sys_prefire, effect)
                            df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'L1Prefiring',effect-1]],columns=cols))

                        for sys in ['JES','JER','UES','jet_trigger','pileup_weight','btagWeight']:
                            syst_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst=sys+'Up')[0]
                            syst_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst=sys+'Down')[0]
                            effect = shape_to_num(nominal,syst_up,syst_do)
                            if abs(effect-1) > 1:
                                effect = 2.

                            if abs(effect-1) > eps:
                                sample.setParamEffect(sys_dict[sys], effect)
                                df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,sys,effect-1]],columns=cols))

                        # DDB SF                                                                      
                        if sName in ['ggF','VBF','WH','ZH','ggZH','ttH','Zjetsbb']:
                            sf,sfunc = passfailSF(isPass, sName, binindex, cat+'_', msd, mask, 1, 0.3)
                            sample.scale(sf)
                            sample.setParamEffect(sys_ddxeffbb, sfunc)
                            df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'DDB',sfunc-1]],columns=cols))

                        # N2DDT SF (V SF)                          
                        sample.scale(SF[year]['V_SF'])
                        effect = 1.0 + SF[year]['V_SF_ERR'] / SF[year]['V_SF']
                        sample.setParamEffect(sys_veff, effect)
                        df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'N2DDT',effect-1]],columns=cols))

                        # Jet mass shift/smear                         
                        mtempl = AffineMorphTemplate(templ)

                        if sName not in ['QCD']:
                            # shift                                                          
                            realshift = SF[year]['shift_SF_ERR'] /smass('Wjets') * smass(sName)   
                            _up = mtempl.get(shift=realshift)
                            _down = mtempl.get(shift=-realshift)
                            if badtemp_ma(_up[0]) or badtemp_ma(_down[0]):
                                print("Skipping sample {}, scale systematic would be empty".format(sName))
                            else:
                                sample.setParamEffect(sys_scale, _up, _down, scale=1)
                            
                            # smear                                                     
                            _up = mtempl.get(smear=1 + SF[year]['smear_SF_ERR'])
                            _down = mtempl.get(smear=1 - SF[year]['smear_SF_ERR'])
                            if badtemp_ma(_up[0]) or badtemp_ma(_down[0]):
                                print("Skipping sample {}, smear systematic would be empty".format(sName))
                            else:
                                sample.setParamEffect(sys_smear, _up, _down)

                        # Theory systematics ############################################
                        # uncertainties on V+jets                 

                        if sName in ['Wjets']:
                            for sys in Wjets_thsysts:
                                syst_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst=sys+'Up')[0]
                                syst_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst=sys+'Down')[0]
                                effect = shape_to_num(nominal,syst_up,syst_do)
                                if abs(effect-1) > 1:
                                    effect = 2.

                                if abs(effect-1) > eps:
                                    sample.setParamEffect(sys_dict[sys], effect)
                                    df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,sys,effect-1]],columns=cols))
                               
                        if sName in ['Zjets','Zjetsbb']:
                            for sys in Zjets_thsysts:
                                syst_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst=sys+'Up')[0]
                                syst_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst=sys+'Down')[0]
                                effect = shape_to_num(nominal,syst_up,syst_do)
                                if abs(effect-1) > 1:
                                    effect = 2.

                                if abs(effect-1) > eps:
                                    sample.setParamEffect(sys_dict[sys], effect)
                                    df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,sys,effect-1]],columns=cols))

                        # Muon CR phase space unc on ttbar
                        if sName == "ttbar" and cat == "vbf":
                            sample.setParamEffect(sys_vbf_ttbar_unc,vbf_ttbar_unc[year])

                        # QCD scale and PDF uncertainties on Higgs signal    
                        if sName in ['ggF','VBF','WH','ZH','ggZH','ttH']:
                            
                            nominal18 = get_template_year('2018', sName, isPass, binindex+1, cat+'_', obs=msd, syst='nominal')[0]
  
                            fsr18_up = get_template_year('2018', sName, isPass, binindex+1, cat+'_', obs=msd, syst='UEPS_FSRUp')[0]
                            fsr18_do = get_template_year('2018', sName, isPass, binindex+1, cat+'_', obs=msd, syst='UEPS_FSRDown')[0]
                            effect_fsr = shape_to_num(nominal18,fsr18_up,fsr18_do)

                            isr18_up = get_template_year('2018', sName, isPass, binindex+1, cat+'_', obs=msd, syst='UEPS_ISRUp')[0]
                            isr18_do = get_template_year('2018', sName, isPass, binindex+1, cat+'_', obs=msd, syst='UEPS_ISRDown')[0]
                            effect_isr = shape_to_num(nominal18,isr18_up,isr18_do)

                            pdf_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='PDF_weightUp')[0]
                            pdf_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='PDF_weightDown')[0]
                            effect_pdf = shape_to_num(nominal,pdf_up,pdf_do)
                            
                            if sName == 'ggF':
                                scale_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_7ptUp')[0]
                                scale_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_7ptDown')[0]
                                effect_scale = shape_to_num(nominal,scale_up,scale_do)

                                sample.setParamEffect(scale_ggF,effect_scale)
                                sample.setParamEffect(pdf_Higgs_ggF,effect_pdf)
                                sample.setParamEffect(fsr_ggF,effect_fsr)
                                sample.setParamEffect(isr_ggF,effect_isr)

                            elif sName == 'VBF':
                                scale_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_3ptUp')[0]
                                scale_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_3ptDown')[0]
                                effect_scale = shape_to_num(nominal,scale_up,scale_do)

                                sample.setParamEffect(scale_VBF,effect_scale)
                                sample.setParamEffect(pdf_Higgs_VBF,effect_pdf)
                                sample.setParamEffect(fsr_VBF,effect_fsr)
                                sample.setParamEffect(isr_VBF,effect_isr)

                            elif sName in ['WH','ZH','ggZH']:
                                scale_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_3ptUp')[0]
                                scale_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_3ptDown')[0]
                                effect_scale = shape_to_num(nominal,scale_up,scale_do)

                                sample.setParamEffect(scale_VH,effect_scale)
                                sample.setParamEffect(pdf_Higgs_VH,effect_pdf)
                                sample.setParamEffect(fsr_VH,effect_fsr)
                                sample.setParamEffect(isr_VH,effect_isr)

                            elif sName == 'ttH':
                                scale_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_7ptUp')[0]
                                scale_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='scalevar_7ptDown')[0]
                                effect_scale = shape_to_num(nominal,scale_up,scale_do)

                                sample.setParamEffect(scale_ttH,effect_scale)
                                sample.setParamEffect(pdf_Higgs_ttH,effect_pdf)
                                sample.setParamEffect(fsr_ttH,effect_fsr)
                                sample.setParamEffect(isr_ttH,effect_isr)
 
                            df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'scale',effect_scale-1]],columns=cols))
                            df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'PDF',effect_pdf-1]],columns=cols))
                            df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'FSR',effect_fsr-1]],columns=cols))
                            df = df.append(pd.DataFrame([[cat+' '+str(binindex+1),region,sName,'ISR',effect_isr-1]],columns=cols))

                        ch.addSample(sample)

                    data_obs = get_template('data', isPass, binindex+1, cat+'_', obs=msd, syst='nominal')

                    ch.setObservation(data_obs, read_sumw2=True)

                    # drop bins outside rho validity
                    mask = validbins[cat][ptbin]

    for cat in cats:
        for ptbin in range(npt[cat]):
            for mjjbin in range(nmjj[cat]):

                failCh = model['ptbin%dmjjbin%d%sfail%s' % (ptbin, mjjbin, cat, year)]
                passCh = model['ptbin%dmjjbin%d%spass%s' % (ptbin, mjjbin, cat, year)]

                qcdparams = np.array([rl.IndependentParameter('qcdparam_'+cat+'_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
                initial_qcd = failCh.getObservation()[0].astype(float)  # was integer, and numpy complained about subtracting float from it

                for sample in failCh:
                    initial_qcd -= sample.getExpectation(nominal=True)

                if np.any(initial_qcd < 0.):
                    raise ValueError('initial_qcd negative for some bins..', initial_qcd)

                sigmascale = 10  # to scale the deviation from initial                      
                scaledparams = initial_qcd * (1 + sigmascale/np.maximum(1., np.sqrt(initial_qcd)))**qcdparams
                fail_qcd = rl.ParametericSample('ptbin%dmjjbin%d%sfail%s_qcd' % (ptbin, mjjbin, cat, year), rl.Sample.BACKGROUND, msd, scaledparams)
                failCh.addSample(fail_qcd)
                pass_qcd = rl.TransferFactorSample('ptbin%dmjjbin%d%spass%s_qcd' % (ptbin, mjjbin, cat, year), rl.Sample.BACKGROUND, tf_params[cat][ptbin, :], fail_qcd)
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
        ch = rl.Channel('muonCR%s%s' % (region, year))
        model.addChannel(ch)

        isPass = region == 'pass'
        print("Bin: muon cr " + region)

        for sName in samps:
            templates[sName] = get_template(sName, isPass, -1, '', obs=msd, syst='nominal', muon=True)
            nominal = templates[sName][0]

            if(badtemp_ma(nominal)):
                print("Sample {} is too small, skipping".format(sName))
                continue

            stype = rl.Sample.BACKGROUND
            sample = rl.TemplateSample(ch.name + '_' + sName, stype, templates[sName])
            sample.autoMCStats(lnN=True)

            sample.setParamEffect(sys_lumi_uncor, lumi[year]['uncorrelated'])
            sample.setParamEffect(sys_lumi_cor_161718, lumi[year]['correlated'])
            sample.setParamEffect(sys_lumi_cor_1718, lumi[year]['correlated_20172018'])

            sample.setParamEffect(sys_eleveto, 1.005)
            sample.setParamEffect(sys_tauveto, 1.005)

            # End of systematics applied to QCD
            if sName == 'QCD':
                continue

            for sys in ['mu_trigger','mu_isoweight','mu_idweight','JES','JER','UES','pileup_weight','btagWeight']:
                syst_up = get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Up', muon=True)[0]
                syst_do = get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Down', muon=True)[0]
                effect = shape_to_num(nominal,syst_up,syst_do)
                if abs(effect-1) > 1:
                    effect = 2.

                if abs(effect-1) > eps:
                    sample.setParamEffect(sys_dict[sys], effect)
                    df = df.append(pd.DataFrame([["mucr",region,sName,sys,effect-1]],columns=cols))
                    
            if year == "2016" or year == "2017":
                syst_up = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='L1PrefiringUp')[0]
                syst_do = get_template(sName, isPass, binindex+1, cat+'_', obs=msd, syst='L1PrefiringDown')[0]
                effect = shape_to_num(nominal,syst_up,syst_do)
                sample.setParamEffect(sys_prefire, effect)
                df = df.append(pd.DataFrame([["mucr",region,sName,'L1Prefiring',effect-1]],columns=cols))

            # DDB SF                                                                                  
            if sName in ['ggF','VBF','WH','ZH','ggZH','ttH','Zjetsbb']:
                sf,sfunc = passfailSF(isPass, sName, -1, '', msd, mask, 1, 0.3, muon=True)
                sample.scale(sf)
                sample.setParamEffect(sys_ddxeffbb, sfunc)
                df = df.append(pd.DataFrame([["mucr",region,sName,'DDB',sfunc-1]],columns=cols))

            # N2DDT SF (V SF)                                                            
            sample.scale(SF[year]['V_SF'])
            effect = 1.0 + SF[year]['V_SF_ERR'] / SF[year]['V_SF']
            sample.setParamEffect(sys_veff, effect)
            df = df.append(pd.DataFrame([["mucr",region,sName,'N2DDT',effect-1]],columns=cols))

            ch.addSample(sample)

        data_obs = get_template('muondata', isPass, -1, '', obs=msd, syst='nominal', muon=True)
        ch.setObservation(data_obs, read_sumw2=True)

    tqqpass = model['muonCRpass'+year+'_ttbar']
    tqqfail = model['muonCRfail'+year+'_ttbar']
    tqqPF = tqqpass.getExpectation(nominal=True).sum() / tqqfail.getExpectation(nominal=True).sum()
    tqqpass.setParamEffect(tqqeffSF, 1*tqqeffSF)
    tqqfail.setParamEffect(tqqeffSF, (1 - tqqeffSF) * tqqPF + 1)
    tqqpass.setParamEffect(tqqnormSF, 1*tqqnormSF)
    tqqfail.setParamEffect(tqqnormSF, 1*tqqnormSF)

    df.to_csv('systematics.csv')

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

