year=""
if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
    year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

combine -M FitDiagnostics -m 125 output/testModel${year}/testModel${year}_combined.root --setParameters rVBF=1,rggF=1,rZbb=1 -t -1 --cminDefaultMinimizerStrategy 0 --robustFit=1 --robustHesse=1 #--verbose 9
