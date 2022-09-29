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

combineTool.py -M MultiDimFit -m 125 -d output/testModel${year}/model_combined.root --saveWorkspace -P rggF -P rVBF --floatOtherPOIs=0 -n Snapshot --robustFit=1 --setParameters rVBF=1,rggF=1 --verbose 9

# Run the goodness of fit                                                                     
combineTool.py -M GoodnessOfFit -m 125 -d higgsCombineSnapshot.MultiDimFit.mH125.root -n Observed --snapshotName MultiDimFit --bypassFrequentistFit --algo "saturated" --setParameters rVBF=1,rggF=1 --verbose 9

