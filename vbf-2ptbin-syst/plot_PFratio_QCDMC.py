import numpy as np
import pandas as pd
import matplotlib.pyplot as plt  

def plot_rhopt():

    ptbins = np.linspace(450,1200,15)
    rhobins = np.linspace(-6,-2.1,23)
    
    df = pd.read_csv("rhopt.csv",names=["rho","pt","eQCDMC"])
    fig, ax = plt.subplots()
    h = ax.hist2d(x=df["rho"],y=df["pt"],weights=df["eQCDMC"], bins=(rhobins,ptbins))
    plt.xlabel("rho")
    plt.ylabel("$p_{T}$ [GeV]")

    cb = fig.colorbar(h[3],ax=ax)
    cb.set_label("Ratio")
    plt.show() 

    fig.savefig("rhopt.png",bbox="tight")

    return 0

def plot_msdpt():

    ptbins = np.linspace(450,1200,15)
    msdbins = np.linspace(47, 201, 23)

    df = pd.read_csv("msdpt.csv",names=["msd","pt","eQCDMC"])
    fig, ax = plt.subplots()
    h = ax.hist2d(x=df["msd"],y=df["pt"],weights=df["eQCDMC"],bins=(msdbins,ptbins))
    plt.xlabel("$m_{sd}$")
    plt.ylabel("$p_{T}$ [GeV]")

    cb = fig.colorbar(h[3],ax=ax)
    cb.set_label("Ratio")
    plt.show()

    fig.savefig("msdpt.png",bbox="tight")

    return 0

if __name__ == '__main__':
    plot_rhopt()
    plot_msdpt()
