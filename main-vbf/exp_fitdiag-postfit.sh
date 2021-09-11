cd output/testModel/
. build.sh
text2workspace.py testModel_combined.txt -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel --PO 'map=.*/ggF:rggF[1,-5,5]' --PO verbose --PO 'map=.*/VBF:rVBF[1,-5,5]' --PO 'map=.*/Zjetsbb:rZbb[1,-5,5]'
cd ../..

combine -M FitDiagnostics -m 125 output/testModel/testModel_combined.root --setParameters rVBF=1,rggF=1,rZbb=1 --freezeParameters rVBF,rggF,rZbb -t -1 --saveShapes --saveWithUncertainties --cminDefaultMinimizerStrategy 0 --robustFit=1 --toysFrequentist
