cd output/testModel/
. build.sh
cd ../..

combine -M Significance -m 125 --expectSignal 1 --signif output/testModel/testModel_combined.root --rMin=-5 --rMax=10  --cminDefaultMinimizerStrategy 0 -t -1 --verbose 9 --toysFrequentist
