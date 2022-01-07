cl=$1

# Determine the year from the directory name                                                                                                                                                 
year=""

if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

# Increase this to get a smoother curve
npoints=100

combine -M MultiDimFit -m 125 output/testModel${year}/model_combined.root --algo contour2d --points=${npoints} --cl=${cl} --cminDefaultMinimizerStrategy 0 --robustFit=1 -t -1 --redefineSignalPOIs rVBF,rggF --setParameters rggF=1,rVBF=1
mv higgsCombineTest.MultiDimFit.mH125.root limit.2dcontour.${cl}.root
