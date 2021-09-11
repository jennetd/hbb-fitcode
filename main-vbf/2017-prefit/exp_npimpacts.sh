modelfile=output/testModel/testModel_combined.root

# Do initial fit
#combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doInitialFit -t -1 --setParameters rggF=1,rVBF=1,rZbb=1

# Do more fits
#combineTool.py -M Impacts -d $modelfile -m 125 --robustFit 1 --doFits -t -1 --setParameters rggF=1,rVBF=1,rZbb=1 

# Collect results into json
#combineTool.py -M Impacts -d $modelfile -m 125 -o impacts.json

plotImpacts.py -i impacts.json -o impacts_VBF --POI 'rVBF'
plotImpacts.py -i impacts.json -o impacts_ggF --POI 'rggF'
plotImpacts.py -i impacts.json -o impacts_Zbb --POI 'rZbb'
