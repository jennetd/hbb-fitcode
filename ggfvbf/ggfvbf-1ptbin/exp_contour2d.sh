cd output/testModel/
. build.sh
text2workspace.py testModel_combined.txt -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel  --PO verbose --PO 'map=.*/ggF:rggF[1,-100,100]' --PO 'map=.*/VBF:rVBF[1,-100,100]'
cd ../..

combine -M MultiDimFit -m 125 output/testModel/testModel_combined.root --algo contour2d --points=100 --cl=0.68 --cminDefaultMinimizerStrategy 0 --robustFit=1 -t -1 --redefineSignalPOIs rVBF,rggF --setParameters rggF=1,rVBF=1
mv higgsCombineTest.MultiDimFit.mH125.root limit.2dcontour.068.root  

combine -M MultiDimFit -m 125 output/testModel/testModel_combined.root --algo contour2d --points=100 --cl=0.95 --cminDefaultMinimizerStrategy 0 --robustFit=1 -t -1 --redefineSignalPOIs rVBF,rggF --setParameters rggF=1,rVBF=1
mv higgsCombineTest.MultiDimFit.mH125.root limit.2dcontour.095.root  
