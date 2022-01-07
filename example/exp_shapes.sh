# Determine the year from the directory name                                                                                                                                                
year=""

if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

combine -M FitDiagnostics -m 125 output/testModel${year}/model_combined.root --setParameters rVBF=1,rggF=1 -t -1 --saveShapes --saveWithUncertainties --cminDefaultMinimizerStrategy 0 --robustFit=1
