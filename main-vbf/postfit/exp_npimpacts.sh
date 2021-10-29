#!/bin/bash                                                                                                                                                                 
echo "Starting job on " `date` #Date/time of start of job                                                                                                                   
echo "Running on: `uname -a`" #Condor job is running on this node                                                                                                           
echo "System software: `cat /etc/redhat-release`" #Operating System on that node                                                                                            

# CMSSW                                                                                                                                                                     
source /cvmfs/cms.cern.ch/cmsset_default.sh
scramv1 project CMSSW CMSSW_10_2_13 # cmsrel is an alias not on the workers                                                                                                 
ls -alrth
cd CMSSW_10_2_13/src/
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers                                                                                                          
echo $CMSSW_BASE "is the CMSSW we created on the local worker node"
# Combine                                                                                                                                                                   
git clone https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit.git HiggsAnalysis/CombinedLimit
cd HiggsAnalysis/CombinedLimit
git fetch origin
git checkout v8.2.0
#scramv1 b clean; scramv1 b                                                                                                                                             
cd ../..

# IMPORTANT: Checkout the recommended tag on the link above                                                                                                             
git clone https://github.com/cms-analysis/CombineHarvester.git CombineHarvester
scramv1 b clean; scramv1 b
cd ../..

# Arguments
year=""

if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

modelfile=output/testModel${year}/model_combined.root

# Do initial fit
combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doInitialFit -t -1 --setParameters rggF=1,rVBF=1,rZbb=1 --freezeParameters rggF,rVBF,rZbb --toysFrequentist

# Do more fits
combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doFits -t -1 --setParameters rggF=1,rVBF=1,rZbb=1 --freezeParametersrggF,rVBF,rZbb --toysFrequentist --parallel 120

# Collect results into json
combineTool.py -M Impacts -d $modelfile -m 125 -o impacts.json

#plotImpacts.py -i impacts.json -o impacts_VBF --POI 'rVBF'
#plotImpacts.py -i impacts.json -o impacts_ggF --POI 'rggF'
#plotImpacts.py -i impacts.json -o impacts_Zbb --POI 'rZbb'

xrdcp -f impacts.json root://cmseos.fnal.gov/EOSDIR
