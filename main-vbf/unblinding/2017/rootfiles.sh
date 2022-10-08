rm signalregion.root muonCR.root

dir=/uscms/home/jennetd/nobackup/hbb-prod-modes/vbf-ul-feb-2022/2017

hadd signalregion.root $dir/2mjj* $dir/6pt*
hadd muonCR.root $dir/muonCR*
