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
text2workspace.py testModel${year}_combined.txt -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel --PO 'map=.*/ggF:rggF[1,-5,5]' --PO verbose --PO 'map=.*/VBF:rVBF[1,-5,5]' --PO 'map=.*/Zjetsbb:rZbb[1,-5,5]'
cd ../../

combine -M FitDiagnostics -m 125 output/testModel${year}/testModel${year}_combined.root --setParameters rVBF=1,rggF=1,rZbb=1 --freezeParameters rVBF,rggF,rZbb -t -1 --saveShapes --saveWithUncertainties --cminDefaultMinimizerStrategy 0 --robustFit=1 --robustHesse=1 --verbose 9
