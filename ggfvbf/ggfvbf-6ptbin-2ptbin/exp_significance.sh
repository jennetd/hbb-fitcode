cd output/testModel/
. build.sh
text2workspace.py testModel_combined.txt -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel  --PO verbose --PO 'map=.*/ggF:rggF[1,-100,100]' --PO 'map=.*/VBF:rVBF[1,-100,100]' --PO 'map=.*/Zjetsbb:rZbb[1,-100,100]'
cd ../..

echo "VBF SIGNIFICANCE"
combine -M Significance -m 125 --signif output/testModel/testModel_combined.root --cminDefaultMinimizerStrategy 0 -t -1 --redefineSignalPOI rVBF --setParameters rggF=1,rZbb=1 --freezeParameters rggF,rZbb --verbose 9 >> VBFsig.txt

echo "GGF SIGNIFICANCE"
combine -M Significance -m 125 --signif output/testModel/testModel_combined.root --cminDefaultMinimizerStrategy 0 -t -1 --redefineSignalPOI rggF --setParameters rVBF=1,rZbb=1 --freezeParameters rVBF,rZbb --verbose 9 >> ggFsig.txt

echo "Zbb SIGNIFICANCE"
combine -M Significance -m 125 --signif output/testModel/testModel_combined.root --cminDefaultMinimizerStrategy 0 -t -1 --redefineSignalPOI rZbb --setParameters rggF=1,rVBF=1 --freezeParameters rggF,rggF --verbose 9 >> Zbbsig.txt
