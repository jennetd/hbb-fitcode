year=""

if [[ "$PWD" == *"2016"* ]]; then
    year="_2016"
elif [[ "$PWD" == *"2017"* ]]; then
year="_2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="_2018"
fi

cd output/testModel${year}/

. build.sh

text2workspace.py model_combined.txt -P HiggsAnalysis.CombinedLimit.PhysicsModel:multiSignalModel \
--PO 'map=ptbin0mjjbin0vbf.*/VBF:rVBF7[1,-4,5]' --PO 'map=ptbin0mjjbin1vbf.*/VBF:rVBF8[1,-4,5]' \
--PO 'map=ptbin.*mjjbin0ggf.*/VBF:rVBF1[1,-9,10]' 



