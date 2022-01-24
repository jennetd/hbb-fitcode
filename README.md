Fit code for boosted H(bb) production mode measurements

Set up CMSSW and combine:
```
export SCRAM_ARCH=slc7_amd64_gcc700
cmsrel CMSSW_10_2_13
cd CMSSW_10_2_13/src
cmsenv
git clone https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit.git HiggsAnalysis/CombinedLimit
cd HiggsAnalysis/CombinedLimit
cd $CMSSW_BASE/src/HiggsAnalysis/CombinedLimit
git fetch origin
git checkout v8.0.1
scramv1 b clean; scramv1 b

cd $CMSSW_BASE/src/
git clone https://github.com/cms-analysis/CombineHarvester.git CombineHarvester
scram b -j8
```

Set up rhalphalib
```
cd $CMSSW_BASE/src/
git clone git@github.com:andrzejnovak/rhalphalib.git
cd rhalphalib
git fetch
git checkout origin/newhcc
pip install --user .

# Need to update some packages against the ones in CMSSW (might need a few more)
pip install uproot --user --upgrade
pip install matplotlib --user --upgrade
pip install mplhep --user
pip install --user .
```

Install this code:
```
cd $CMSSW_BASE/src/
git clone https://github.com/jennetd/hbb-fitcode.git
```
