#combine -M HybridNew output/testModel/testModel_combined.root --LHCmode LHC-significance  --saveToys --fullBToys --saveHybridResult --expectSignal 1 #--verbose 9

combine -M Significance --signif output/testModel/testModel_combined.root --redefineSignalPOIs r --setParameters r=1 -t -1 --verbose 9
