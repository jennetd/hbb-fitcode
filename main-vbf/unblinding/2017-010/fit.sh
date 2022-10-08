year="_2017"
modelfile=output/testModel${year}/model_combined.root

# Do initial fit
combine -M MultiDimFit --algo singles -d $modelfile -m 125 --robustFit 1 --setParameters rggF=1,rVBF=1
