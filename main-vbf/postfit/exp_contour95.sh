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
year=$1

combine -M MultiDimFit -m 125 output/testModel${year}/model_combined.root --algo contour2d --points=100 --cl=0.95 --cminDefaultMinimizerStrategy 0 --robustFit=1 -t -1 --redefineSignalPOIs rVBF,rggF --setParameters rggF=1,rVBF=1,rZbb=1 --freezeParameters rZbb --toysFrequentist

mv higgsCombineTest.MultiDimFit.mH125.root limit.2dcontour.095.root
xrdcp -f limit.2dcontour.095.root root://cmseos.fnal.gov/EOSDIR
