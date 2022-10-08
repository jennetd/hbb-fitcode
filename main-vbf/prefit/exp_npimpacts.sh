#!/bin/bash                                        
echo "Starting job on " `date` #Date/time of start of job   
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node   
# bring in the tarball you created before with caches and large files excluded: 
xrdcp -s root://cmseos.fnal.gov//store/user/jennetd/CMSSW_10_2_13.tar.gz .
source /cvmfs/cms.cern.ch/cmsset_default.sh
tar -xf CMSSW_10_2_13.tar.gz
rm CMSSW_10_2_13.tar.gz
cd CMSSW_10_2_13/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile 
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers 
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ${_CONDOR_SCRATCH_DIR}
pwd

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
combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doInitialFit -t -1 --setParameters rggF=1,rVBF=1

# Do more fits
combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doFits -t -1 --setParameters rggF=1,rVBF=1 --parallel 64

# Collect results into json
combineTool.py -M Impacts -d $modelfile -m 125 -o impacts.json

#plotImpacts.py -i impacts.json -o impacts_VBF --POI 'rVBF'
#plotImpacts.py -i impacts.json -o impacts_ggF --POI 'rggF'
#plotImpacts.py -i impacts.json -o impacts_Zbb --POI 'rZbb'

xrdcp -f impacts.json root://cmseos.fnal.gov/EOSDIR
