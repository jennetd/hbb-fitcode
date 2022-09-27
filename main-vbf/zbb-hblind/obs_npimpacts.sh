#!/bin/bash                                                                                                                                   

# Arguments
year=""
if [[ "$PWD" == *"2016APV"* ]]; then
    year="_2016APV"
elif [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
    year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

modelfile=output/testModel${year}/model_combined.root

# Do initial fit
combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doInitialFit --setParameters rZbb=1 --cminDefaultMinimizerStrat\
egy 0

combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doFits --setParameters rZbb=1 --job-mode condor --sub-opts='+JobFlavour="nextweek"' --exclude 'rgx{qcdparams*}' --cminDefaultMinimizerStrat\
egy 0
