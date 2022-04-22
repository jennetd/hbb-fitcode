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
scramv1 b clean; scramv1 b
cd ../..

git clone https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit.git HiggsAnalysis/CombinedLimit
# IMPORTANT: Checkout the recommended tag on the link above
git clone https://github.com/cms-analysis/CombineHarvester.git CombineHarvester
scramv1 b clean; scramv1 b
cd ../..

#cd ${_CONDOR_SCRATCH_DIR}
#pwd

# My job
echo "Arguments passed to the job, $1 and then $2: "
echo $1
echo $2
echo $3
echo $4

eosout=$3
index=$4

python compare.py --pt=$1 --rho=$2 --ntoys=50 --index=${index}

ls

dirs=`ls | grep pt$1rho$2_vs_`
for d in $dirs;
do
    #move output to eos
    xrdfs root://cmseos.fnal.gov/ mkdir $eosout/${d}_$index
    xrdcp -rf $d root://cmseos.fnal.gov/$eosout/${d}_$index
done
