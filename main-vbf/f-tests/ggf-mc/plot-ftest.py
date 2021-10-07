import os
import numpy as np
import ROOT
import matplotlib.pyplot as plt
from scipy.stats import f
import matplotlib.pyplot as plt
fig, ax = plt.subplots(1, 1)

ntoys = 500
nbins = 23*6

def Ftest(lambda1,lambda2,p1,p2,nbins=23*6):

    numerator = -2.0*np.log(1.0*lambda1/lambda2)/(p2-p1)
    denominator = -2.0*np.log(lambda2)/(nbins-p2)

    return numerator/denominator

if __name__ == '__main__':

    year = "2016"
    thisdir = os.getcwd()
    if "2017" in thisdir:
        year = "2017"
    elif "2018" in thisdir:
        year = "2018"

    cat = 'vbf'
    if 'ggf' in thisdir:
        cat = 'ggf'

    thisdir = os.getcwd().split("/")[-1]
    baseline = thisdir.split("_vs_")[0]
    alt = thisdir.split("_vs_")[1]

    p1 = int(baseline.split("rho")[1]) + int(baseline.split("rho")[0].split("pt")[1])
    p2 = int(alt.split("rho")[1]) + int(alt.split("rho")[0].split("pt")[1])
    print(p1,p2)

    # run baseline gof                                                                                                                                   
    infile1 = ROOT.TFile.Open("higgsCombineToys.baseline.GoodnessOfFit.mH125.123456.root")
    tree1= infile1.Get("limit")
    lambda1_toys = []
    for j in range(tree1.GetEntries()):
        tree1.GetEntry(j)
        lambda1_toys += [getattr(tree1,"limit")]

    infile2 = ROOT.TFile.Open("higgsCombineToys.alternative.GoodnessOfFit.mH125.123456.root")
    tree2 = infile2.Get("limit")
    lambda2_toys = []
    for j in range(tree2.GetEntries()):
        tree2.GetEntry(j)
        lambda2_toys +=[getattr(tree2,"limit")]

    # Caculate the F-test for toys
    f_dist = [Ftest(lambda1_toys[j],lambda2_toys[j],p1,p2) for j in range(len(lambda1_toys))]

    # Observed
    infile1 = ROOT.TFile.Open("baseline_obs.root")
    tree1= infile1.Get("limit")
    tree1.GetEntry(0)
    lambda1_obs = getattr(tree1,"limit")

    infile2 = ROOT.TFile.Open("alternative_obs.root")
    tree2 = infile2.Get("limit")
    tree2.GetEntry(0)
    lambda2_obs = getattr(tree2,"limit")

    f_obs = Ftest(lambda1_obs,lambda2_obs,p1,p2)

    above = np.sum([x for x in f_dist if x>f_obs])
    pvalue = 1.0*above/np.sum(f_dist)
    print(pvalue)
    
    ashist = plt.hist(f_dist,bins=np.linspace(0,5,25),histtype='step',color='black')
    ymax = 1.2*max(ashist[0])

    plt.errorbar((ashist[1][:-1]+ashist[1][1:])/2., ashist[0], yerr=np.sqrt(ashist[0]),linestyle='',color='black',marker='o',label=str(ntoys) +" toys")
    plt.plot([f_obs,f_obs],[0,ymax],color='red',label="observed = {:.2f}".format(f_obs))
    plt.ylim(0,ymax)

    x = np.linspace(0,5,250)
    plt.plot(x, ntoys*0.2*f.pdf(x, p2-p1, nbins-p2),color='blue', label='F pdf')

    plt.text(3,ymax*0.9,year + " " + cat,fontsize='large')
    plt.text(3,ymax*0.8,baseline + " vs. " + alt,fontsize='large')

    plt.legend(loc='center right',frameon=False)
    plt.xlabel("F-statistic")

    plt.savefig(thisdir+".png",bbox_inches='tight')
    plt.show()