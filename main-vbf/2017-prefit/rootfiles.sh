rm signalregion.root
rm muonCR.root

dir=/uscms/home/jennetd/nobackup/hbb-prod-modes/july-2021/vbf-category/ggf-vbf-ddb2/2017

hadd signalregion.root $dir/2mjj* $dir/6pt*
hadd muonCR.root $dir/muonCR*
