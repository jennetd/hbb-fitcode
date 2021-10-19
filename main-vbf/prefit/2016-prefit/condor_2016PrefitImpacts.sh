#!/bin/sh
ulimit -s unlimited
set -e
cd /uscms_data/d3/jennetd/hbb-prod-modes/CMSSW_10_2_13/src
export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
eval `scramv1 runtime -sh`
cd /uscms/home/jennetd/nobackup/hbb-prod-modes/CMSSW_10_2_13/src/hbb-fitcode/main-vbf/prefit/2016-prefit

if [ $1 -eq 0 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_L1Prefiring_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_L1Prefiring_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 1 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_eff_bb_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_eff_bb_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 2 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_PU_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_PU_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 3 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_W_d2kappa_EW --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_W_d2kappa_EW --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 4 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_W_d3kappa_EW --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_W_d3kappa_EW --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 5 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_Z_d2kappa_EW --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_Z_d2kappa_EW --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 6 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_Z_d3kappa_EW --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_Z_d3kappa_EW --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 7 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_btagWeight_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_btagWeight_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 8 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_d1K_NLO --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_d1K_NLO --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 9 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_d1kappa_EW --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_d1kappa_EW --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 10 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_d2K_NLO --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_d2K_NLO --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 11 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_d3K_NLO --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_d3K_NLO --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 12 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_e_veto_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_e_veto_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 13 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_jet_trigger_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_jet_trigger_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 14 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_mu_trigger_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_mu_trigger_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 15 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_mu_veto_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_mu_veto_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 16 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_scale_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_scale_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 17 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_smear_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_smear_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 18 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_tau_veto_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_tau_veto_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 19 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_vbfmucr_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_vbfmucr_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 20 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_hbb_veff_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_hbb_veff_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 21 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_lumi_13TeV_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_lumi_13TeV_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 22 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_lumi_13TeV_correlated_ --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_lumi_13TeV_correlated_ --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 23 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_mu_id_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_mu_id_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 24 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_res_j_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_res_j_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 25 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_scale_j_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_scale_j_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 26 ]; then
  combine -M MultiDimFit -n _paramFit_Test_CMS_ues_j_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P CMS_ues_j_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 27 ]; then
  combine -M MultiDimFit -n _paramFit_Test_QCDscale_VBF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P QCDscale_VBF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 28 ]; then
  combine -M MultiDimFit -n _paramFit_Test_QCDscale_VH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P QCDscale_VH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 29 ]; then
  combine -M MultiDimFit -n _paramFit_Test_QCDscale_ggF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P QCDscale_ggF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 30 ]; then
  combine -M MultiDimFit -n _paramFit_Test_QCDscale_ttH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P QCDscale_ttH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 31 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_FSR_VBF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_FSR_VBF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 32 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_FSR_VH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_FSR_VH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 33 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_FSR_ggF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_FSR_ggF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 34 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_FSR_ttH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_FSR_ttH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 35 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_ISR_VBF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_ISR_VBF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 36 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_ISR_VH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_ISR_VH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 37 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_ISR_ggF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_ISR_ggF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 38 ]; then
  combine -M MultiDimFit -n _paramFit_Test_UEPS_ISR_ttH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P UEPS_ISR_ttH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 39 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRfail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRfail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 40 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRfail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRfail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 41 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRfail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRfail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 42 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRfail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRfail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 43 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRfail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRfail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 44 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 45 ]; then
  combine -M MultiDimFit -n _paramFit_Test_muonCRpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P muonCRpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 46 ]; then
  combine -M MultiDimFit -n _paramFit_Test_pdf_Higgs_VBF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P pdf_Higgs_VBF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 47 ]; then
  combine -M MultiDimFit -n _paramFit_Test_pdf_Higgs_VH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P pdf_Higgs_VH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 48 ]; then
  combine -M MultiDimFit -n _paramFit_Test_pdf_Higgs_ggF --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P pdf_Higgs_ggF --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 49 ]; then
  combine -M MultiDimFit -n _paramFit_Test_pdf_Higgs_ttH --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P pdf_Higgs_ttH --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 50 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 51 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 52 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 53 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 54 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 55 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 56 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 57 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 58 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 59 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 60 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 61 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 62 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 63 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 64 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 65 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 66 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 67 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 68 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 69 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 70 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 71 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0ggfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0ggfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 72 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 73 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 74 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 75 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 76 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 77 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 78 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 79 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 80 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 81 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 82 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 83 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 84 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 85 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 86 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 87 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 88 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 89 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 90 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 91 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 92 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 93 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin0vbfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin0vbfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 94 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 95 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 96 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 97 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 98 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 99 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 100 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 101 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 102 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 103 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 104 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 105 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 106 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 107 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 108 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 109 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 110 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 111 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 112 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin0mjjbin1vbfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin0mjjbin1vbfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 113 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 114 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 115 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 116 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 117 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 118 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 119 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 120 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 121 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 122 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 123 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 124 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 125 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 126 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 127 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 128 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 129 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 130 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 131 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 132 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 133 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 134 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin1mjjbin0ggfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin1mjjbin0ggfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 135 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 136 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 137 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 138 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 139 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 140 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 141 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 142 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 143 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 144 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 145 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 146 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 147 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 148 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 149 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 150 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 151 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 152 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 153 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 154 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 155 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 156 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin2mjjbin0ggfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin2mjjbin0ggfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 157 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 158 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 159 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 160 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 161 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 162 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 163 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 164 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 165 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 166 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 167 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 168 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 169 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 170 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 171 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 172 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 173 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 174 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 175 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 176 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 177 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 178 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin3mjjbin0ggfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin3mjjbin0ggfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 179 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 180 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 181 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 182 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 183 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 184 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 185 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 186 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 187 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 188 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 189 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 190 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 191 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 192 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 193 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 194 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 195 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 196 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 197 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 198 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 199 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin4mjjbin0ggfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin4mjjbin0ggfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 200 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 201 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 202 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 203 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 204 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 205 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 206 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 207 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 208 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 209 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 210 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggffail2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggffail2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 211 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_VBF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_VBF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 212 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_VV_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_VV_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 213 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_WH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_WH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 214 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_Wjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_Wjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 215 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_ZH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_ZH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 216 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_Zjets_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_Zjets_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 217 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_Zjetsbb_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_Zjetsbb_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 218 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_ggF_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_ggF_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 219 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_singlet_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_singlet_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 220 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_ttH_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_ttH_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 221 ]; then
  combine -M MultiDimFit -n _paramFit_Test_ptbin5mjjbin0ggfpass2016_ttbar_mcstat --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P ptbin5mjjbin0ggfpass2016_ttbar_mcstat --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 222 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 223 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 224 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 225 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 226 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 227 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 228 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 229 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 230 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 231 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 232 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 233 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 234 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 235 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 236 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 237 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 238 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 239 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 240 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 241 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 242 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 243 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 244 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin0_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin0_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 245 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 246 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 247 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 248 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 249 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 250 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 251 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 252 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 253 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 254 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 255 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 256 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 257 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 258 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 259 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 260 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 261 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 262 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 263 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 264 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 265 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 266 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 267 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin1_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin1_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 268 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 269 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 270 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 271 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 272 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 273 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 274 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 275 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 276 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 277 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 278 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 279 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 280 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 281 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 282 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 283 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 284 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 285 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 286 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 287 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 288 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 289 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 290 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin2_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin2_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 291 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 292 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 293 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 294 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 295 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 296 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 297 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 298 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 299 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 300 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 301 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 302 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 303 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 304 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 305 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 306 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 307 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 308 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 309 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 310 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 311 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 312 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 313 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin3_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin3_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 314 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 315 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 316 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 317 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 318 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 319 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 320 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 321 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 322 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 323 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 324 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 325 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 326 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 327 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 328 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 329 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 330 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 331 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 332 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 333 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 334 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 335 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 336 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin4_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin4_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 337 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 338 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 339 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 340 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 341 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 342 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 343 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 344 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 345 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 346 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 347 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 348 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 349 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 350 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 351 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 352 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 353 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 354 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 355 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 356 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 357 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 358 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 359 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_ggf_ptbin5_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_ggf_ptbin5_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 360 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 361 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 362 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin10 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin10 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 363 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin11 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin11 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 364 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin12 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin12 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 365 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin13 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin13 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 366 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin14 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin14 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 367 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin15 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin15 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 368 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin16 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin16 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 369 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin17 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin17 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 370 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin18 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin18 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 371 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin19 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin19 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 372 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 373 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin20 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin20 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 374 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin21 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin21 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 375 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin22 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin22 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 376 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 377 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 378 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 379 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin6 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin6 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 380 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin7 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin7 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 381 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin8 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin8 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 382 ]; then
  combine -M MultiDimFit -n _paramFit_Test_qcdparam_vbf_ptbin0_msdbin9 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P qcdparam_vbf_ptbin0_msdbin9 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 383 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_ggf_deco0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_ggf_deco0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 384 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_ggf_deco1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_ggf_deco1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 385 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_ggf_deco2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_ggf_deco2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 386 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_ggf_deco3 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_ggf_deco3 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 387 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_ggf_deco4 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_ggf_deco4 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 388 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_ggf_deco5 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_ggf_deco5 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 389 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_vbf_deco0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_vbf_deco0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 390 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_MCtempl_vbf_deco1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_MCtempl_vbf_deco1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 391 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_ggf_pt_par0_rho_par0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_ggf_pt_par0_rho_par0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 392 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_ggf_pt_par0_rho_par1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_ggf_pt_par0_rho_par1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 393 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_ggf_pt_par0_rho_par2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_ggf_pt_par0_rho_par2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 394 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_ggf_pt_par1_rho_par0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_ggf_pt_par1_rho_par0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 395 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_ggf_pt_par1_rho_par1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_ggf_pt_par1_rho_par1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 396 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_ggf_pt_par1_rho_par2 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_ggf_pt_par1_rho_par2 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 397 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_vbf_pt_par0_rho_par0 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_vbf_pt_par0_rho_par0 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 398 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tf_dataResidual_vbf_pt_par0_rho_par1 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tf_dataResidual_vbf_pt_par0_rho_par1 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 399 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tqqeffSF_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tqqeffSF_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi
if [ $1 -eq 400 ]; then
  combine -M MultiDimFit -n _paramFit_Test_tqqnormSF_2016 --algo impact --redefineSignalPOIs rZbb,rVBF,rggF -P tqqnormSF_2016 --floatOtherPOIs 1 --saveInactivePOI 1 --robustFit 1 -t -1 -m 125 -d output/testModel_2016/model_combined.root --setParameters rggF=1,rVBF=1,rZbb=1
fi