import os
import numpy as np
import ROOT
import argparse

def gen_toys(ntoys, seed=123456):
    infile = "higgsCombineSnapshot.MultiDimFit.mH125.root"

    combine_cmd = "combineTool.py -M GenerateOnly -m 125 -d " + infile + " -n \"Toys\" -t " + str(ntoys) + " --saveToys --seed "+str(seed) + " --toysFrequentist --bypassFrequentistFit --snapshotName MultiDimFit"

    os.system(combine_cmd)

def GoF(ntoys, seed=123456):
    infile = "higgsCombineSnapshot.MultiDimFit.mH125.root"

#    combine_cmd = "combine -M GoodnessOfFit " + infile + " --algo=saturated -t " + str(ntoys) + " -s "+str(seed)+" --toysFrequentist"

    combine_cmd = "combineTool.py -M GoodnessOfFit -m 125 -d " + infile + " -n \"Toys" + "\" -t " + str(ntoys) + " --algo \"saturated\" --toysFile higgsCombineToys.GenerateOnly.mH125."+str(seed)+".root --seed "+str(seed)+" --snapshotName MultiDimFit"
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
    


