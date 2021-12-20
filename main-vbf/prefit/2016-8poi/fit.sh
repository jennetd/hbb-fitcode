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
combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doInitialFit -t -1 --setParameters rggF1=1,rggF2=1,rggF3=1,rggF4=1,rggF5=1,rggF6=1,rggF7=1,rggF8=1,rVBF1=1,rVBF2=1,rVBF3=1,rVBF4=1,rVBF5=1,rVBF6=1,rVBF7=1,rVBF8=1,rZbb=1 --freezeParameters rZbb
