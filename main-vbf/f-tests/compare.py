import os
import numpy as np
import ROOT
import matplotlib as plt

def gen_toys(infile, ntoys):
    combine_cmd = "combineTool.py -M GenerateOnly -m 125 -d " + infile + ".root \
    --snapshotName MultiDimFit --bypassFrequentistFit \
    --setParameters r=0 --freezeParameters r \
    -n \"Toys\" -t "+str(ntoys)+" --saveToys"
    os.system(combine_cmd)

def GoF(infile, ntoys):

    combine_cmd = "combineTool.py -M GoodnessOfFit -m 125 -d " + infile + ".root \
    --snapshotName MultiDimFit --bypassFrequentistFit \--setParameters r=0 --freezeParameters r \
    -n \"Toys." + infile + "\" -t " + str(ntoys) + " --algo \"saturated\" --toysFile higgsCombineToys.GenerateOnly.mH125.123456.root \
    --cminDefaultMinimizerStrategy 0"
    os.system(combine_cmd)

def Ftest(lambda1,lambda2,p1,p2,nbins=23*6):

    numerator = -2.0*np.log(1.0*lambda1/lambda2)/(p2-p1)
    denominator = -2.0*np.log(lambda2)/(nbins-p2)

    return numerator/denominator


if __name__ == '__main__':

    pt = 1
    rho = 1

    ntoys = 20
    
    while pt<2 and rho<2:

        p1 = pt+rho
        p2 = pt+rho+1

        baseline = "pt"+str(pt)+"rho"+str(rho)
        alternatives = []
        if pt == rho:
            alternatives += ["pt"+str(pt+1)+"rho"+str(rho)]
            alternatives += ["pt"+str(pt)+"rho"+str(rho+1)]
        else:
            alternatives += ["pt"+str(max(pt,rho))+"rho"+str(max(pt,rho))]


        for i,alt in enumerate(alternatives):

            print(alt)
            thedir = baseline+"_vs_"+alt

            os.mkdir(thedir)
            os.chdir(thedir)

            # Copy what we need
            os.system("cp ../"+baseline+"/higgsCombineSnapshot.MultiDimFit.mH125.root baseline.root")
            os.system("cp ../"+alt+"/higgsCombineSnapshot.MultiDimFit.mH125.root alt"+str(i)+".root")

            # Generate the toys
            gen_toys("baseline",ntoys)

            # run baseline gof
            GoF("baseline",ntoys)
            infile1 = ROOT.TFile.Open("higgsCombineToys.baseline.GoodnessOfFit.mH125.123456.root")
            tree1= infile1.Get("limit")
            lambda1_toys = []
            for j in range(tree1.GetEntries()):
                tree1.GetEntry(j)
                lambda1_toys += [getattr(tree1,"limit")]

            GoF("alt"+str(i),ntoys)    
            infile2 = ROOT.TFile.Open("higgsCombineToys.alt"+str(i)+".GoodnessOfFit.mH125.123456.root")
            tree2 = infile2.Get("limit")
            lambda2_toys = []
            for j in range(tree2.GetEntries()):
                tree2.GetEntry(j)
                lambda2_toys +=[getattr(tree2,"limit")]

            f_dist = [Ftest(lambda1_toys[j],lambda2_toys[j],p1,p2) for j in range(len(lambda1_toys))]
            print(f_dist)
            plt.hist(f_dist)
            plt.show()


                # F-test                                                                                                                                                       
            # Coming soon                                                                                                                                                  
            # def Ftest(lambda1,lambda2,p1,p2,nbins)                                                                                                                       
#            infile1 = ROOT.TFile.Open("")
#            tree1= infile1.Get("limit")
#            lambda1_toys = [getattr(tree1 ,"limit") for


            # run alternative gof
#            GoF("alt"+str(i),ntoys)
            
            # F-test
            # Coming soon
            # def Ftest(lambda1,lambda2,p1,p2,nbins)
#            infile1 = ROOT.TFile.Open("higgsCombineToys.baseline.GoodnessOfFit.mH125.123456.root")
#            tree1 = infile1.Get("limit")
                            
#            lambda1_toys = [getattr(tree1 ,"limit") for 
#            tree1.
            #lambda1_toys = tree1.Get()
            #lambda2_toys = tree2.Get()

            #f_dist = [F(lambda1_toys[i],lambda2_toys[i],p1,p2) for i in range(lambda1_toys)]

            # Observed
            #os.system("cp ../"+baseline+"/higgsCombineObserved.GoodnessOfFit.mH125.root baseline_obs.root")
            #os.system("cp ../"+alt+"/higgsCombineObserved.GoodnessOfFit.mH125.root alt"+str(i)+"_obs.root")

            #lambda1_obs = tree1.Get()
            #lambda2_obs = tree2.Get()
            #f_obs = F(lambda1_obs,lambda2_obs,p1,p2)

            os.chdir("../")

            #print(np.sum(f_dist[np.where(f_dist>f_obs)])/np.sum(f_dist))
            
            pt=2
            rho=2

