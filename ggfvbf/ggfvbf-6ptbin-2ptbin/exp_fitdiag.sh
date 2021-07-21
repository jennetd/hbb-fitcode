cd output/testModel/
. build.sh
text2workspace.py testModel_combined.txt -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel  --PO verbose --PO 'map=.*/ggF:rggF[1,-100,100]' --PO 'map=.*/VBF:rVBF[1,-100,100]'
cd ../..

combine -M FitDiagnostics -m 125 output/testModel/testModel_combined.root --cminDefaultMinimizerStrategy 0 --robustFit=1 -t -1 --saveShapes --saveWithUncertainties --redefineSignalPOIs rVBF,rggF --setParameters rggF=1,rVBF=1 --verbose 9
