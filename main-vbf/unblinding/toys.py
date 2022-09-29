import os
import numpy as np
import ROOT
import argparse

def gen_toys(ntoys, seed=123456):
    infile = "higgsCombineSnapshot.MultiDimFit.mH125.root"

    combine_cmd = "combineTool.py -M GenerateOnly -m 125 -d " + infile + " --snapshotName MultiDimFit --bypassFrequentistFit --setParameters rggF=1,rVBF=1 -n \"Toys\" -t "+str(ntoys)+" --saveToys --seed "+str(seed)

    os.system(combine_cmd)

def GoF(ntoys, seed=123456):
    infile = "higgsCombineSnapshot.MultiDimFit.mH125.root"

    combine_cmd = "combineTool.py -M GoodnessOfFit -m 125 -d " + infile + " --snapshotName MultiDimFit --bypassFrequentistFit \--setParameters rggF=1,rVBF=1 -n \"Toys" + "\" -t " + str(ntoys) + " --algo \"saturated\" --toysFile higgsCombineToys.GenerateOnly.mH125."+str(seed)+".root --seed "+str(seed)
    os.system(combine_cmd)

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='F-test')
    parser.add_argument('-n','--ntoys',nargs='+',help='number of toys')
    parser.add_argument('-i','--index',nargs='+',help='index for random seed')
    args = parser.parse_args()

    ntoys = int(args.ntoys[0])
    seed = 123456+int(args.index[0])*100+31
    
    # run toys and gof
    gen_toys(ntoys,seed=seed)
    GoF(ntoys,seed=seed)
    


