cd output/testModel/
. build.sh
cd ../..

combine -M FitDiagnostics -m 125 --expectSignal 1 output/testModel/testModel_combined.root --rMin=-5 --rMax=10  --cminDefaultMinimizerStrategy 0 --robustFit=1 -t -1 --verbose 9 --saveShapes --saveWithUncertainties --toysFrequentist
