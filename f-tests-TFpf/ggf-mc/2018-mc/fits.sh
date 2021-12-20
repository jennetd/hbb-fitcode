year=""
if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
    year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

cd output/testModel${year}/
. build.sh
cd ../..

combineTool.py -M MultiDimFit -m 125 -d output/testModel${year}/testModel${year}_combined.root --saveWorkspace \
--setParameters r=0 --freezeParameters r -n "Snapshot" \
--robustFit=1 --cminDefaultMinimizerStrategy 0 #--verbose 9

combineTool.py -M GoodnessOfFit -m 125 -d higgsCombineSnapshot.MultiDimFit.mH125.root \
--snapshotName MultiDimFit --bypassFrequentistFit \
--setParameters r=0 --freezeParameters r \
-n "Baseline" --algo "saturated" \
--cminDefaultMinimizerStrategy 0 #--verbose 9

