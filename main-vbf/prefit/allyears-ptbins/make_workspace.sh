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
--PO 'map=ptbin0mjjbin0vbf.*/ggF:rggF1[1,-4,5]' --PO 'map=ptbin1mjjbin0ggf.*/ggF:rggF2[1,-4,5]' \
--PO 'map=ptbin2mjjbin0ggf.*/ggF:rggF3[1,-4,5]' --PO 'map=ptbin3mjjbin0ggf.*/ggF:rggF4[1,-4,5]' \
--PO 'map=ptbin4mjjbin0ggf.*/ggF:rggF4[1,-4,5]' --PO 'map=ptbin5mjjbin0ggf.*/ggF:rggF4[1,-4,5]' \
--PO 'map=ptbin0mjjbin.*vbf.*/ggF:rggF7[1,-4,6]'




