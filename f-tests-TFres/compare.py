import os
import numpy as np
import ROOT
import argparse

def gen_toys(infile, ntoys, seed=123456):
    combine_cmd = "combineTool.py -M GenerateOnly -m 125 -d " + infile + ".root \
    --snapshotName MultiDimFit --bypassFrequentistFit \
    --setParameters r=0 --freezeParameters r \
    -n \"Toys\" -t "+str(ntoys)+" --saveToys \
    --seed "+str(seed)
    os.system(combine_cmd)

def GoF(infile, ntoys, seed=123456):

    combine_cmd = "combineTool.py -M GoodnessOfFit -m 125 -d " + infile + ".root \
    --snapshotName MultiDimFit --bypassFrequentistFit \--setParameters r=0 --freezeParameters r \
    -n \"Toys." + infile + "\" -t " + str(ntoys) + " --algo \"saturated\" --toysFile higgsCombineToys.GenerateOnly.mH125."+str(seed)+".root \
    --cminDefaultMinimizerStrategy 0 \
    --seed "+str(seed)
    os.system(combine_cmd)

def Ftest(lambda1,lambda2,p1,p2,nbins=23*6):

    numerator = -2.0*np.log(1.0*lambda1/lambda2)/(p2-p1)
    denominator = -2.0*np.log(lambda2)/(nbins-p2)

    return numerator/denominator


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='F-test')
    parser.add_argument('-p','--pt',nargs='+',help='pt of ggf baseline')
    parser.add_argument('-r','--rho',nargs='+',help='rho of ggf baseline')
    parser.add_argument('-s','--rho2',nargs='+',help='rho of vbf baseline')
    parser.add_argument('-n','--ntoys',nargs='+',help='number of toys')
    parser.add_argument('-i','--index',nargs='+',help='index for random seed')
    args = parser.parse_args()

    pt = int(args.pt[0])
    rho = int(args.rho[0])
    rho2 = int(args.rho2[0])
    ntoys = int(args.ntoys[0])
    seed = 123456+int(args.index[0])*100+31
    
    p1 = pt+rho+rho2
    p2 = pt+rho+rho2+1

    baseline = "pt"+str(pt)+"rho"+str(rho) + "_rho"+str(rho2)
    alternatives = []
    pvalues = []

    if pt == rho:
        alternatives += ["pt"+str(pt+1)+"rho"+str(rho) + "_rho"+str(rho2)]
        alternatives += ["pt"+str(pt)+"rho"+str(rho+1) + "_rho"+str(rho2)]
    if pt == rho2:
        alternatives += ["pt"+str(pt+1)+"rho"+str(rho) + "_rho"+str(rho2)]
        alternatives += ["pt"+str(pt)+"rho"+str(rho) + "_rho"+str(rho2+1)]
    if rho == rho2:
        alternatives += ["pt"+str(pt)+"rho"+str(rho+1) + "_rho"+str(rho2)]
        alternatives += ["pt"+str(pt)+"rho"+str(rho) + "_rho"+str(rho2+1)]

    if pt > rho and pt > rho2:
        alternatives += ["pt"+str(pt)+"rho"+str(rho+1) + "_rho"+str(rho2)]
        alternatives += ["pt"+str(pt)+"rho"+str(rho) + "_rho"+str(rho2+1)]
    if rho > pt and rho > rho2:
        alternatives += ["pt"+str(pt+1)+"rho"+str(rho) + "_rho"+str(rho2)]
        alternatives += ["pt"+str(pt)+"rho"+str(rho) + "_rho"+str(rho2+1)]
    if rho2 > pt and rho2 > rho:
        alternatives += ["pt"+str(pt+1)+"rho"+str(rho) + "_rho"+str(rho2)]
        alternatives += ["pt"+str(pt)+"rho"+str(rho+1) + "_rho"+str(rho2)]
    
    alternatives = list(set(alternatives))

    for i,alt in enumerate(alternatives):

        pt_alt = int(alt.split("rho")[0].split("pt")[1])
        rho_alt = int(alt.split("rho")[1][:-1])
        print(pt_alt, rho_alt)
        
        print(alt)
        thedir = baseline+"_vs_"+alt

        os.mkdir(thedir)
        os.chdir(thedir)

        # Copy what we need
        os.system("cp ../"+baseline+"/higgsCombineSnapshot.MultiDimFit.mH125.root baseline.root")
        os.system("cp ../"+alt+"/higgsCombineSnapshot.MultiDimFit.mH125.root alternative.root")

        # Generate the toys
        gen_toys("baseline",ntoys,seed=seed)
        
        # run baseline gof
        GoF("baseline",ntoys,seed=seed)
        infile1 = ROOT.TFile.Open("higgsCombineToys.baseline.GoodnessOfFit.mH125."+str(seed)+".root")
        tree1= infile1.Get("limit")
        lambda1_toys = []
        for j in range(tree1.GetEntries()):
            tree1.GetEntry(j)
            lambda1_toys += [getattr(tree1,"limit")]

        GoF("alternative",ntoys,seed=seed)    
        infile2 = ROOT.TFile.Open("higgsCombineToys.alternative.GoodnessOfFit.mH125."+str(seed)+".root")
        tree2 = infile2.Get("limit")
        lambda2_toys = []
        for j in range(tree2.GetEntries()):
            tree2.GetEntry(j)
            lambda2_toys +=[getattr(tree2,"limit")]

        # Caculate the F-test for toys
        f_dist = [Ftest(lambda1_toys[j],lambda2_toys[j],p1,p2) for j in range(len(lambda1_toys))]
        print(f_dist)

        # Observed
        os.system("cp ../"+baseline+"/higgsCombineObserved.GoodnessOfFit.mH125.root baseline_obs.root")
        infile1 = ROOT.TFile.Open("baseline_obs.root")
        tree1= infile1.Get("limit")
        tree1.GetEntry(0)
        lambda1_obs = getattr(tree1,"limit")
        print(lambda1_obs)

        os.system("cp ../"+alt+"/higgsCombineObserved.GoodnessOfFit.mH125.root alternative_obs.root")
        infile2 = ROOT.TFile.Open("alternative_obs.root")
        tree2 = infile2.Get("limit")
        tree2.GetEntry(0)
        lambda2_obs = getattr(tree2,"limit")
        print(lambda2_obs)

        f_obs = Ftest(lambda1_obs,lambda2_obs,p1,p2)
                
        above = np.sum([x for x in f_dist if x>f_obs])
        pvalue = 1.0*above/np.sum(f_dist)

        pvalues += [pvalue]
        print(pvalue)

        os.chdir('../')

