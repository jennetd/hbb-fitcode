import os
import numpy as np
import ROOT
import argparse

def GoF(infile, ntoys, seed=123456):

    combine_cmd = "combine -M GoodnessOfFit -m 125 -d "+infile+" -n Toys -t " + str(ntoys) + " --algo saturated --seed " + str(seed)
    os.system(combine_cmd)

def Ftest(lambda1,lambda2,p1,p2,nbins=23*8-9):

    numerator = -2.0*np.log(1.0*lambda1/lambda2)/(p2-p1)
    denominator = -2.0*np.log(lambda2)/(nbins-p2)

    return numerator/denominator


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='F-test')
    parser.add_argument('-p','--pt',nargs='+',help='pt of ggf baseline')
    parser.add_argument('-r','--rho',nargs='+',help='rho of ggf baseline')
    parser.add_argument('-n','--ntoys',nargs='+',help='number of toys')
    parser.add_argument('-i','--index',nargs='+',help='index for random seed')
    args = parser.parse_args()

    pt = int(args.pt[0])
    rho = int(args.rho[0])
    ntoys = int(args.ntoys[0])
    seed = 123456+int(args.index[0])*100+31
    
    p1 = (pt+1)*(rho+1)

    baseline = "pt"+str(pt)+"rho"+str(rho)
    alternatives = []
    pvalues = []

#    alternatives += ["pt"+str(pt+1)+"rho"+str(rho)]
    alternatives += ["pt"+str(pt)+"rho"+str(rho+1)]
    
    alternatives = list(set(alternatives))

    for i,alt in enumerate(alternatives):

        pt_alt = int(alt.split("rho")[0].split("pt")[1])
        rho_alt = int(alt.split("rho")[1])
        print(pt_alt, rho_alt)
        
        p2 = (pt_alt+1)*(rho_alt+1)

        print(alt)
        thedir = baseline+"_vs_"+alt

        os.mkdir(thedir)
        os.chdir(thedir)

        # Copy what we need
        os.system("cp ../"+baseline+"/higgsCombineSnapshot.MultiDimFit.mH125.root baseline.root")
        os.system("cp ../"+alt+"/higgsCombineSnapshot.MultiDimFit.mH125.root alternative.root")

        # run baseline gof
        GoF("baseline.root",ntoys,seed=seed)
        os.system('mv higgsCombineToys.GoodnessOfFit.mH125.'+str(seed)+'.root higgsCombineToys.baseline.GoodnessOfFit.mH125.'+str(seed)+'.root')

        # run alternative gof
        GoF("alternative.root",ntoys,seed=seed)    
        os.system('mv higgsCombineToys.GoodnessOfFit.mH125.'+str(seed)+'.root higgsCombineToys.alternative.GoodnessOfFit.mH125.'+str(seed)+'.root')

        os.chdir('../')

