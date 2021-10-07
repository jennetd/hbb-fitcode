#!/usr/bin/python
import os, sys
import subprocess
import argparse

# Main method                                                                          
def main():

    year = "2016"
    thisdir = os.getcwd()
    if "2017" in thisdir:
        year = "2017"
    elif "2018" in thisdir:
        year = "2018"

    cat = "vbf-mc"
    if "ggf" in thisdir:
        cat = "ggf-mc"

    parser = argparse.ArgumentParser(description='F-test batch submit')
    parser.add_argument('-p','--pt',nargs='+',help='pt of baseline')
    parser.add_argument('-r','--rho',nargs='+',help='rho of baseline')
    args = parser.parse_args()

    pt = int(args.pt[0])
    rho = int(args.rho[0])

    loc_base = os.environ['PWD']
    logdir = 'logs'

    tag = cat+'-'+year
    script = 'run-ftest.sh'

    homedir = '/store/user/jennetd/f-tests/'
    outdir = homedir + tag 

    # make local directory
    locdir = logdir
    os.system('mkdir -p  %s' %locdir)

    print('CONDOR work dir: ' + homedir)
    os.system('mkdir -p /eos/uscms'+outdir)

    prefix = tag
    print('Submitting '+prefix)

    condor_templ_file = open("submit.templ.condor")

    transferfiles = "compare.py,pt" + str(pt) + "rho" + str(rho) + ",pt" + str(pt+1) + "rho" + str(rho) + ",pt" + str(pt) + "rho" +  str(rho+1)
    print(transferfiles)
    submitargs = str(pt) + " " + str(rho) + " " + outdir
    print(submitargs)
    
    localcondor = locdir+'/'+prefix+".condor"
    condor_file = open(localcondor,"w")
    for line in condor_templ_file:
        line=line.replace('TRANSFERFILES',transferfiles)
        line=line.replace('PREFIX',prefix)
        line=line.replace('SUBMITARGS',submitargs)
        condor_file.write(line)
    condor_file.close()
    
    if (os.path.exists('%s.log'  % localcondor)):
        os.system('rm %s.log' % localcondor)
    os.system('condor_submit %s' % localcondor)

    condor_templ_file.close()
    
    return 

if __name__ == "__main__":
    main()
