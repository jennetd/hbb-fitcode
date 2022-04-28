year="_2016"
modelfile=output/testModel${year}/model_combined.root

# Do fit
combine -M MultiDimFit --algo singles -P rZbb --floatOtherPOIs=0 --robustFit=1 --cminDefaultMinimizerStrategy=0 -m 125 -d $modelfile --setParameters rZbb=1,rVBF=1,rggF=1 --verbose 9

