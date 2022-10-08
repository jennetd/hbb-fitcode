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
cp /eos/uscms/store/user/jennetd/f-tests-unblinded/${year}_ggf*/${tag}*/*.root .

rm *total.root
hadd higgsCombineToys.GenerateOnly.mH125.total.root higgsCombineToys.GenerateOnly.mH125.*.root
hadd higgsCombineToys.baseline.GoodnessOfFit.mH125.total.root higgsCombineToys.baseline.GoodnessOfFit.mH125.*.root
hadd higgsCombineToys.alternative.GoodnessOfFit.mH125.total.root higgsCombineToys.alternative.GoodnessOfFit.mH125.*.root
