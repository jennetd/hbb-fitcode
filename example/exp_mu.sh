poi=$1

# Determine the year from the directory name                                                                                                                                                  
year=""

if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

# You can increase this to get a smoother curve
npoints=100

combine -M MultiDimFit -m 125 output/testModel${year}/model_combined.root --setParameters rVBF=1,rggF=1 -t -1 --cminDefaultMinimizerStrategy 0 --algo grid --points ${npoints} --redefineSignalPOI ${poi} --saveWorkspace -n ${poi}
