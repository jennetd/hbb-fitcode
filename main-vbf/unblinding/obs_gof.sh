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

#combine -M MultiDimFit output/testModel${year}/model_combined.root -m 125 --saveWorkspace -n Snapshot --robustFit=1 --setParameters rggF=1,rVBF=1 --freezeParameters rggF,rVBF

combine -M GoodnessOfFit output/testModel${year}/model_combined.root -m 125 --algo=saturated --verbose=9 -t 10 --toysFrequentist


#--snapshotName=MultiDimFit --verbose=9 --bypassFrequentistFit --toysFrequentist
