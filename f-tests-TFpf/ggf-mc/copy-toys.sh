year=""
if [[ "$PWD" == *"2016APV"* ]]; then
    year="2016APV"
elif [[ "$PWD" == *"2016"* ]]; then
    year="2016"
elif [[ "$PWD" == *"2017"* ]]; then
    year="2017"
elif [[ "$PWD" == *"2018"* ]]; then
    year="2018"
fi

tag=`echo $PWD | sed 's:.*/::'`
echo $tag
tag2=`echo $tag | sed 's/.$//'`

rm higgsCombineToys.*GoodnessOfFit.mH125*.root
cp /eos/uscms/store/user/jennetd/f-tests-pf/ggf-mc/${year}/*/${tag}*${tag2}*/higgsCombineToys.baseline.GoodnessOfFit.mH125*.root .

hadd higgsCombineToys.GoodnessOfFit.mH125.root higgsCombineToys.baseline.GoodnessOfFit.mH125.*.root
