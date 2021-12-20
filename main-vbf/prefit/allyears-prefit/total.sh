year=""
modelfile=output/testModel${year}/model_combined.root

combine -M MultiDimFit -m 125 output/testModel${year}/model_combined.root --setParameters rVBF=1,rggF=1,rZbb=1 -t -1 --cminDefaultMinimizerStrategy 0 --redefineSignalPOI rVBF,rggF,rZbb --saveWorkspace -n "_Total"
