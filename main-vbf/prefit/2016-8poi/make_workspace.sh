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
--PO 'map=.*/Zjetsbb:rZbb[1,-5,6]' \
--PO 'map=ptbin0mjjbin0vbf.*/ggF:rggF1[1,-9,10]' --PO 'map=ptbin1mjjbin0ggf.*/ggF:rggF2[1,-9,10]' \
--PO 'map=ptbin2mjjbin0ggf.*/ggF:rggF3[1,-9,10]' --PO 'map=ptbin3mjjbin0ggf.*/ggF:rggF4[1,-9,10]' \
--PO 'map=ptbin4mjjbin0ggf.*/ggF:rggF5[1,-9,10]' --PO 'map=ptbin5mjjbin0ggf.*/ggF:rggF6[1,-9,10]' \
--PO 'map=ptbin0mjjbin0vbf.*/ggF:rggF7[1,-9,10]' --PO 'map=ptbin0mjjbin1vbf.*/ggF:rggF8[1,-9,10]' \
--PO 'map=ptbin0mjjbin0ggf.*/VBF:rVBF1[1,-9,10]' --PO 'map=ptbin1mjjbin0ggf.*/VBF:rVBF2[1,-9,10]' \
--PO 'map=ptbin2mjjbin0ggf.*/VBF:rVBF3[1,-9,10]' --PO 'map=ptbin3mjjbin0ggf.*/VBF:rVBF4[1,-9,10]' \
--PO 'map=ptbin4mjjbin0ggf.*/VBF:rVBF5[1,-9,10]' --PO 'map=ptbin5mjjbin0ggf.*/VBF:rVBF6[1,-9,10]' \
--PO 'map=ptbin0mjjbin0vbf.*/VBF:rVBF7[1,-9,10]' --PO 'map=ptbin0mjjbin1vbf.*/VBF:rVBF8[1,-9,10]' \


