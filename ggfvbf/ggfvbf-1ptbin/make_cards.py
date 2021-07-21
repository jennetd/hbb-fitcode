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
        Return a shifted and smeard histogram                                                                                      
        i.e. new edges = edges * smear + shift                                                                                     
        '''
        if not np.isclose(smear, 1.):
            shift += self.mean * (1 - smear)
        smeard_edges = (self.edges - shift) / smear
        return np.diff(self.cdf(smeard_edges)) * self.norm, self.edges, self.varname



def syst_variation(numerator,denominator):
    """
    Get systematic variation relative to nominal (denominator)
    """
    var = np.divide(numerator,denominator)
    var[np.where(numerator==0)] = 1
    var[np.where(denominator==0)] = 1
    return var

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
    if ptbin >=0:
        name += 'pt'+str(ptbin)+'_'

    name += sName+'_'+syst
    print(name)

    h = f.Get(name)
    sumw = []
    sumw2 = []
    for i in range(1,h.GetNbinsX()+1):
        sumw += [h.GetBinContent(i)]
        sumw2 += [h.GetBinError(i)*h.GetBinError(i)]

    return (np.array(sumw), obs.binning, obs.name, np.array(sumw2))

def passfailSF(isPass, sName, ptbin, cat, obs, mask, SF=1, SF_unc=0.1, muon=False):
    """
    Return (SF, SF_unc) for a pass/fail scale factor.
    """
    if isPass:
        return SF, 1. + SF_unc / SF
    else:
        _pass = get_template(sName, 1, ptbin, cat, obs=obs, syst='nominal', muon=muon)
        _pass_rate = np.sum(_pass[0] * mask)

        _fail = get_template(sName, 0, ptbin, cat, obs=obs, syst='nominal', muon=muon)
        _fail_rate = np.sum(_fail[0] * mask)

        if _fail_rate > 0:
            _sf = 1 + (1 - SF) * _pass_rate / _fail_rate
            _sfunc = 1. - SF_unc * (_pass_rate / _fail_rate)
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
    fig.savefig("MCTF_msdpt_"+name+".png",bbox="tight")
    fig.savefig("MCTF_msdpt_"+name+".pdf",bbox="tight")
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
    fig.savefig("MCTF_rhopt_"+name+".png",bbox="tight")
    fig.savefig("MCTF_rhopt_"+name+".pdf",bbox="tight")

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

    # Systematics
    sys_lumi = rl.NuisanceParameter('CMS_lumi', 'lnN')
    sys_eleveto = rl.NuisanceParameter('CMS_hbb_e_veto_{}'.format(year), 'lnN')                                    
    sys_muveto = rl.NuisanceParameter('CMS_hbb_m_veto_{}'.format(year), 'lnN')  

    sys_shape_dict = {}
    if fast == 0:
        sys_shape_dict['JES'] = rl.NuisanceParameter('CMS_scale_j_{}'.format(year), 'lnN')
        sys_shape_dict['JER'] = rl.NuisanceParameter('CMS_res_j_{}'.format(year), 'lnN')
        sys_shape_dict['UES'] = rl.NuisanceParameter('CMS_ues_j_{}'.format(year), 'lnN')
        sys_shape_dict['jet_trigger'] = rl.NuisanceParameter('CMS_hbb_trigger_{}'.format(year), 'lnN')
        sys_shape_dict['pileup_weight'] = rl.NuisanceParameter('CMS_hbb_PU_{}'.format(year), 'lnN')
        for sys in ['btagEffStat', 'btagWeight', 'd1kappa_EW', 'Z_d2kappa_EW', 'Z_d3kappa_EW', 'W_d2kappa_EW', 'W_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
            sys_shape_dict[sys] = rl.NuisanceParameter('CMS_hbb_{}_{}'.format(sys, year), 'lnN')
    else:
        sys_shape_dict['JES'] = rl.NuisanceParameter('CMS_scale_j_{}'.format(year), 'shape')
        sys_shape_dict['JER'] = rl.NuisanceParameter('CMS_res_j_{}'.format(year), 'shape')
        sys_shape_dict['UES'] = rl.NuisanceParameter('CMS_ues_j_{}'.format(year), 'shape')
        sys_shape_dict['jet_trigger'] = rl.NuisanceParameter('CMS_hbb_trigger_{}'.format(year), 'shape')
        sys_shape_dict['pileup_weight'] = rl.NuisanceParameter('CMS_hbb_PU_{}'.format(year), 'shape')
        for sys in ['btagEffStat', 'btagWeight', 'd1kappa_EW', 'Z_d2kappa_EW', 'Z_d3kappa_EW', 'W_d2kappa_EW', 'W_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
            sys_shape_dict[sys] = rl.NuisanceParameter('CMS_hbb_{}_{}'.format(sys, year), 'shape')

    sys_ddxeffbb = rl.NuisanceParameter('CMS_eff_bb_{}'.format(year), 'lnN')
    sys_veff = rl.NuisanceParameter('CMS_hbb_veff_{}'.format(year), 'lnN')
    sys_scale = rl.NuisanceParameter('CMS_hbb_scale_{}'.format(year), 'shape')
    sys_smear = rl.NuisanceParameter('CMS_hbb_smear_{}'.format(year), 'shape')

    # theory systematics                                                                           
    pdf_weight = rl.NuisanceParameter('PDF_weight', 'shape')
    scale_ggF = rl.NuisanceParameter('scale_ggF', 'lnN')
    scale_VBF = rl.NuisanceParameter('scale_VBF', 'lnN')
    scale_VH = rl.NuisanceParameter('scale_VH', 'lnN')
    scale_ttH = rl.NuisanceParameter('scale_ttH', 'lnN')
    ps_weight = rl.NuisanceParameter('PS_weight', 'shape')

    # define bins    
    ptbins = np.array([450, 1200])
    npt = len(ptbins) - 1
    msdbins = np.linspace(40, 201, 24)
    msd = rl.Observable('msd', msdbins)

    cats = ['ggf','vbf']
    ncat = len(cats)

    # here we derive these all at once with 2D array
    ptpts, msdpts = np.meshgrid(ptbins[:-1] + 0.3 * np.diff(ptbins), msdbins[:-1] + 0.5 * np.diff(msdbins), indexing='ij')
    rhopts = 2*np.log(msdpts/ptpts)
    ptscaled = (ptpts - 450.) / (1200. - 450.)
    rhoscaled = (rhopts - (-6)) / ((-2.1) - (-6))
    validbins = (rhoscaled >= 0) & (rhoscaled <= 1)
    rhoscaled[~validbins] = 1  # we will mask these out later

    # Build qcd MC pass+fail model and fit to polynomial
    tf_params = {}
    for cat in cats:

        qcdmodel = rl.Model('qcdmodel_'+cat)
        qcdpass, qcdfail = 0., 0.
        
        for ptbin in range(npt):
            failCh = rl.Channel('ptbin%d%s%s' % (ptbin, cat, 'fail'))
            passCh = rl.Channel('ptbin%d%s%s' % (ptbin, cat, 'pass'))
            qcdmodel.addChannel(failCh)
            qcdmodel.addChannel(passCh)
        
            # QCD templates from file                                                                                                        
            failTempl = get_template('QCD', 0, -1, cat+'_', obs=msd, syst='nominal')
            passTempl = get_template('QCD', 1, -1, cat+'_', obs=msd, syst='nominal')
        
            failCh.setObservation(failTempl, read_sumw2=True)
            passCh.setObservation(passTempl, read_sumw2=True)

            qcdfail += sum([val[0] for val in failCh.getObservation()])
            qcdpass += sum([val[0] for val in passCh.getObservation()])
        
        qcdeff = qcdpass / qcdfail
        print('Inclusive P/F from Monte Carlo = ' + str(qcdeff))

        # initial values                                                                                                          
        print('Initial fit values read from file initial_vals*.csv')
        initial_vals = np.genfromtxt('initial_vals_'+cat+'.csv')
        if cat == 'ggf':
            initial_vals = initial_vals.reshape(1, 3)
            print(initial_vals)
            tf_MCtempl = rl.BernsteinPoly('tf_MCtempl_'+cat, (0, 2), ['pt', 'rho'], init_params=initial_vals, limits=(-20, 20))
        else:
            initial_vals = initial_vals.reshape(1, 2)
            print(initial_vals)
            tf_MCtempl = rl.BernsteinPoly('tf_MCtempl_'+cat, (0, 1), ['pt', 'rho'], init_params=initial_vals, limits=(-20, 20))

        tf_MCtempl_params = qcdeff * tf_MCtempl(ptscaled, rhoscaled)

        for ptbin in range(npt):
            failCh = qcdmodel['ptbin%d%sfail' % (ptbin, cat)]
            passCh = qcdmodel['ptbin%d%spass' % (ptbin, cat)]
            failObs = failCh.getObservation()
            passObs = passCh.getObservation()
        
            qcdparams = np.array([rl.IndependentParameter('qcdparam_'+cat+'_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
            sigmascale = 10.
            scaledparams = failObs * (1 + sigmascale/np.maximum(1., np.sqrt(failObs)))**qcdparams
            
            fail_qcd = rl.ParametericSample('ptbin%d%sfail_qcd' % (ptbin, cat), rl.Sample.BACKGROUND, msd, scaledparams[0])
            failCh.addSample(fail_qcd)
            pass_qcd = rl.TransferFactorSample('ptbin%d%spass_qcd' % (ptbin, cat), rl.Sample.BACKGROUND, tf_MCtempl_params[ptbin, :], fail_qcd)
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
        qcdfit_ws.writeToFile(os.path.join(str(tmpdir), 'testModel_qcdfit_'+cat+'.root'))

        # Set parameters to fitted values  
        allparams = dict(zip(qcdfit.nameArray(), qcdfit.valueArray()))
        for i, p in enumerate(tf_MCtempl.parameters.reshape(-1)):
            p.value = allparams[p.name]
            print(cat,p.name,p.value)
            
        if qcdfit.status() != 0:
            raise RuntimeError('Could not fit qcd')

        # Plot the MC P/F transfer factor                                                                                    
        plot_mctf(tf_MCtempl,msdbins, cat)                                                                                            
    
        param_names = [p.name for p in tf_MCtempl.parameters.reshape(-1)]
        decoVector = rl.DecorrelatedNuisanceVector.fromRooFitResult(tf_MCtempl.name + '_deco', qcdfit, param_names)
        tf_MCtempl.parameters = decoVector.correlated_params.reshape(tf_MCtempl.parameters.shape)
        tf_MCtempl_params_final = tf_MCtempl(ptscaled, rhoscaled)

        if cat == 'ggf':
            tf_dataResidual = rl.BernsteinPoly('tf_dataResidual_'+cat, (0, 2), ['pt', 'rho'], limits=(-20, 20))
        else:
            tf_dataResidual = rl.BernsteinPoly('tf_dataResidual_'+cat, (0, 1), ['pt', 'rho'], limits=(-20, 20))

        tf_dataResidual_params = tf_dataResidual(ptscaled, rhoscaled)
        tf_params[cat] = qcdeff * tf_MCtempl_params_final * tf_dataResidual_params

    # build actual fit model now
    model = rl.Model('testModel')

    # exclude QCD from MC samps
    samps = ['ggF','VBF','WH','ZH','ttH','ttbar','singlet','Zjets','Zjetsbb','Wjets','VV']
    sigs = ['ggF','VBF']

    for cat in cats:
        for ptbin in range(npt):
            for region in ['pass', 'fail']:

                # drop bins outside rho validity                                                
                mask = validbins[ptbin]

                ch = rl.Channel('ptbin%d%s%s' % (ptbin, cat, region))
                model.addChannel(ch)

                isPass = region == 'pass'
                templates = {}
            
                for sName in samps:

                    templates[sName] = get_template(sName, isPass, -1, cat+'_', obs=msd, syst='nominal') 
                    nominal = templates[sName][0]

                    # expectations
                    templ = templates[sName]

                    if sName in sigs:
                        stype = rl.Sample.SIGNAL
                    else:
                        stype = rl.Sample.BACKGROUND
                    
                    sample = rl.TemplateSample(ch.name + '_' + sName, stype, templ)
                
                    # Experimental systematics #############################################################
                    sample.setParamEffect(sys_lumi, 1.027)
                    sample.setParamEffect(sys_eleveto, 1.005)
                    sample.setParamEffect(sys_muveto, 1.005)

                    for sys in ['jet_trigger','JES','JER','UES','pileup_weight','btagWeight','btagEffStat']:
                        sys_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst=sys+'Up')[0], nominal)
                        sys_do = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst=sys+'Down')[0], nominal)
                        sample.setParamEffect(sys_shape_dict[sys], sys_up, sys_do)

                    # DDB SF
                    if sName in ['ggF','VBF','WH','ZH','ttH','Zjetsbb']:
                        sf,sfunc = passfailSF(isPass, sName, -1, cat+'_', msd, mask, 1, 0.3)
                        sample.scale(sf)
                        sample.setParamEffect(sys_ddxeffbb, sfunc)                    

                    # N2DDT SF (V SF)
                    sample.scale(SF[year]['V_SF'])
                    sample.setParamEffect(sys_veff, 1.0 + SF[year]['V_SF_ERR'] / SF[year]['V_SF'])

                    # JMS and JMR                                                                                                 
                    mtempl = AffineMorphTemplate(templ)

                    def badtemp_ma(hvalues, eps=0.0000001, mask=None):
                        # Need minimum size & more than 1 non-zero bins                                                      
                        tot = np.sum(hvalues[mask])
                        count_nonzeros = np.sum(hvalues[mask] > 0)
                        if (tot < eps) or (count_nonzeros < 2):
                            return True
                        else:
                            return False

                    # shift                                                                                                      
                    realshift = SF[year]['shift_SF_ERR'] #/smass('wcq') * smass(sName)                                                  
                    _up = mtempl.get(shift=realshift)
                    _down = mtempl.get(shift=-realshift)
                    if badtemp_ma(_up[0]) or badtemp_ma(_down[0]):
                        print("Skipping sample {}, scale systematic would be empty".format(sName))
                        continue
                    sample.setParamEffect(sys_scale, _up, _down, scale=1)

                    # smear                                                                                                        
                    if sName not in ['VV']:
                        _up = mtempl.get(smear=1 + SF[year]['smear_SF_ERR'])
                        _down = mtempl.get(smear=1 - SF[year]['smear_SF_ERR'])
                        if badtemp_ma(_up[0]) or badtemp_ma(_down[0]):
                            print("Skipping sample {}, smear systematic would be empty".format(sName))
                            continue
                        sample.setParamEffect(sys_smear, _up, _down)

                    # Theory systematics #############################################################  
                    # uncertainties on Higgs signal                                                                                  
                    # PDF uncertainty                                                                                         
                    pdf_weight_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='PDF_weightUp')[0], nominal)
                    pdf_weight_down = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='PDF_weightDown')[0], nominal)
                    sample.setParamEffect(pdf_weight, pdf_weight_up, pdf_weight_down)                       

                    # uncertainties on V+jets                                                                                
                    if 'Zjets' in sName:
                        for sys in ['d1kappa_EW', 'Z_d2kappa_EW', 'Z_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
                            sys_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst=sys+'Up')[0], nominal)
                            sys_do = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst=sys+'Down')[0], nominal)
                            sample.setParamEffect(sys_shape_dict[sys], sys_up, sys_do)
                    if 'Wjets' in sName:
                        for sys in ['d1kappa_EW', 'W_d2kappa_EW', 'W_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
                            sys_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst=sys+'Up')[0], nominal)
                            sys_do = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst=sys+'Down')[0], nominal)
                            sample.setParamEffect(sys_shape_dict[sys], sys_up, sys_do)    

                    # uncertainties on Higgs signal 
                    if sName == 'ggF':
                        scale_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_7ptUp')[0], nominal)
                        scale_down = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_7ptDown')[0], nominal)
                        sample.setParamEffect(scale_ggF, scale_up, scale_down)                                                       
                    if sName == 'VBF':
                        scale_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_3ptUp')[0], nominal)
                        scale_down = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_3ptDown')[0], nominal)
                        sample.setParamEffect(scale_VBF, scale_up, scale_down)                                                        
                    if sName == 'VH':
                        scale_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_3ptUp')[0], nominal)
                        scale_down = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_3ptDown')[0], nominal)
                        sample.setParamEffect(scale_VH, scale_up, scale_down)                                                         
                    if sName == 'ttH':
                        scale_up = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_7ptUp')[0], nominal)
                        scale_down = syst_variation(get_template(sName, isPass, -1, cat+'_', obs=msd, syst='scalevar_7ptDown')[0], nominal)
                        sample.setParamEffect(scale_ttH, scale_up, scale_down)   

                    ch.addSample(sample)

                data_obs = get_template('data', isPass, -1, cat+'_', obs=msd, syst='nominal')
                ch.setObservation(data_obs, read_sumw2=True)

                # drop bins outside rho validity
                mask = validbins[ptbin]

    for cat in cats:
        for ptbin in range(npt):
            failCh = model['ptbin%d%sfail' % (ptbin, cat)]
            passCh = model['ptbin%d%spass' % (ptbin, cat)]

            qcdparams = np.array([rl.IndependentParameter('qcdparam_'+cat+'_ptbin%d_msdbin%d' % (ptbin, i), 0) for i in range(msd.nbins)])
            initial_qcd = failCh.getObservation()[0].astype(float)  # was integer, and numpy complained about subtracting float from it

            for sample in failCh:
                initial_qcd -= sample.getExpectation(nominal=True)

            if np.any(initial_qcd < 0.):
                raise ValueError('initial_qcd negative for some bins..', initial_qcd)

            sigmascale = 10  # to scale the deviation from initial
            scaledparams = initial_qcd * (1 + sigmascale/np.maximum(1., np.sqrt(initial_qcd)))**qcdparams
            fail_qcd = rl.ParametericSample('ptbin%d%sfail_qcd' % (ptbin, cat), rl.Sample.BACKGROUND, msd, scaledparams)
            failCh.addSample(fail_qcd)
            pass_qcd = rl.TransferFactorSample('ptbin%d%spass_qcd' % (ptbin, cat), rl.Sample.BACKGROUND, tf_params[cat][ptbin, :], fail_qcd)
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
    samps = ['ttbar','QCD','singlet','Zjets','Zjetsbb','Wjets'] #'VV']
    for region in ['pass', 'fail']:
        ch = rl.Channel('muonCR%s' % (region, ))
        model.addChannel(ch)

        isPass = region == 'pass'

        for sName in samps:
            templates[sName] = get_template(sName, isPass, -1, '', obs=msd, syst='nominal', muon=True)

            stype = rl.Sample.BACKGROUND
            sample = rl.TemplateSample(ch.name + '_' + sName, stype, templates[sName])

            sample.setParamEffect(sys_lumi, 1.027)
            sample.setParamEffect(sys_eleveto, 1.005)

            for sys in ['jet_trigger','JES','JER','UES','pileup_weight','btagWeight','btagEffStat']:
                sys_up = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Up',muon=True)[0], nominal)
                sys_do = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Down',muon=True)[0], nominal)
                sample.setParamEffect(sys_shape_dict[sys], sys_up, sys_do)

            # DDB SF
            if sName in ['ggF','VBF','WH','ZH','ttH','Zjetsbb']:
                sf,sfunc = passfailSF(isPass, sName, -1, '', msd, mask, 1, 0.3, muon=True)
                sample.scale(sf)
                sample.setParamEffect(sys_ddxeffbb, sfunc)

            # N2DDT SF (V SF)                                                                        
            sample.scale(SF[year]['V_SF'])
            sample.setParamEffect(sys_veff, 1.0 + SF[year]['V_SF_ERR'] / SF[year]['V_SF'])

            # JMS and JMR                                                                                                        
            mtempl = AffineMorphTemplate(templ)
            
            def badtemp_ma(hvalues, eps=0.0000001, mask=None):
                # Need minimum size & more than 1 non-zero bins                                                                  
                tot = np.sum(hvalues[mask])
                count_nonzeros = np.sum(hvalues[mask] > 0)
                if (tot < eps) or (count_nonzeros < 2):
                    return True
                else:
                    return False

            # shift                                                                                                              
            realshift = SF[year]['shift_SF_ERR'] #/smass('wcq') * smass(sName)                                                  
            _up = mtempl.get(shift=realshift)
            _down = mtempl.get(shift=-realshift)
            if badtemp_ma(_up[0]) or badtemp_ma(_down[0]):
                print("Skipping sample {}, scale systematic would be empty".format(sName))
                continue
            sample.setParamEffect(sys_scale, _up, _down, scale=1)

            # smear                                                                                                              
            if sName not in ['VV']:
                _up = mtempl.get(smear=1 + SF[year]['smear_SF_ERR'])
                _down = mtempl.get(smear=1 - SF[year]['smear_SF_ERR'])
                if badtemp_ma(_up[0]) or badtemp_ma(_down[0]):
                    print("Skipping sample {}, smear systematic would be empty".format(sName))
                    continue
                sample.setParamEffect(sys_smear, _up, _down)

            # PDF uncertainty                                                                                               
            pdf_weight_up = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst='PDF_weightUp', muon=True)[0], nominal)
            pdf_weight_down = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst='PDF_weightDown', muon=True)[0], nominal)
            sample.setParamEffect(pdf_weight, pdf_weight_up, pdf_weight_down)                              
            
            # uncertainties on V+jets                                                                                       
            if 'Zjets' in sName:
                for sys in ['d1kappa_EW', 'Z_d2kappa_EW', 'Z_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
                    sys_up = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Up', muon=True)[0], nominal)
                    sys_do = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Down', muon=True)[0], nominal)
                    sample.setParamEffect(sys_shape_dict[sys], sys_up, sys_do)
            if 'Wjets' in sName:
                for sys in ['d1kappa_EW', 'W_d2kappa_EW', 'W_d3kappa_EW', 'd1K_NLO', 'd2K_NLO', 'd3K_NLO']:
                    sys_up = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Up', muon=True)[0], nominal)
                    sys_do = syst_variation(get_template(sName, isPass, -1, '', obs=msd, syst=sys+'Down', muon=True)[0], nominal)
                    sample.setParamEffect(sys_shape_dict[sys], sys_up, sys_do)

            ch.addSample(sample)

        data_obs = get_template('muondata', isPass, -1, '', obs=msd, syst='nominal', muon=True)
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

