import ROOT as rt
from array import array
from scipy.interpolate import Rbf
import numpy as np
import glob


def bestFit(t, x, y):
    nfind = t.Draw(y + ":" + x, "deltaNLL == 0")
    if nfind == 0:
        gr0 = rt.TGraph(1)
        gr0.SetPoint(0, -999, -999)
        gr0.SetMarkerStyle(34)
        gr0.SetMarkerSize(1.5)
        return gr0
    else:
        gr0 = rt.gROOT.FindObject("Graph").Clone()
        gr0.SetMarkerStyle(34)
        gr0.SetMarkerSize(1.5)
        if gr0.GetN() > 1:
            gr0.Set(1)
        return gr0


def frameTH2D(hin, threshold):
    frameValue = 1000
    xw = hin.GetXaxis().GetBinWidth(1)
    yw = hin.GetYaxis().GetBinWidth(1)
    nx = hin.GetNbinsX()
    ny = hin.GetNbinsY()
    x0 = hin.GetXaxis().GetXmin()
    x1 = hin.GetXaxis().GetXmax()
    y0 = hin.GetYaxis().GetXmin()
    y1 = hin.GetYaxis().GetXmax()
    xbins = array("d", [frameValue] * 999)
    ybins = array("d", [frameValue] * 999)
    eps = 0.001
    xbins[0] = x0 - eps * xw - xw
    xbins[1] = x0 + eps * xw - xw
    for ix in range(2, nx + 1):
        xbins[ix] = x0 + (ix - 1) * xw
    xbins[nx + 1] = x1 - eps * xw + 0.5 * xw
    xbins[nx + 2] = x1 + eps * xw + xw
    ybins[0] = y0 - eps * yw - yw
    ybins[1] = y0 + eps * yw - yw
    for iy in range(2, ny + 1):
        ybins[iy] = y0 + (iy - 1) * yw
    ybins[ny + 1] = y1 - eps * yw + yw
    ybins[ny + 2] = y1 + eps * yw + yw

    framed = rt.TH2D(
        "%s framed" % hin.GetName(),
        "%s framed" % hin.GetTitle(),
        nx + 2,
        xbins,
        ny + 2,
        ybins,
    )

    for ix in range(1, nx + 1):
        for iy in range(1, ny + 1):
            framed.SetBinContent(1 + ix, 1 + iy, hin.GetBinContent(ix, iy))

    nx = framed.GetNbinsX()
    ny = framed.GetNbinsY()
    for ix in range(1, nx + 1):
        framed.SetBinContent(ix, 1, frameValue)
        framed.SetBinContent(ix, ny, frameValue)
    for iy in range(2, ny):
        framed.SetBinContent(1, iy, frameValue)
        framed.SetBinContent(nx, iy, frameValue)

    return framed


def contourFromTH2(h2in, threshold, minPoints=20):

    contours = array("d", [threshold])
    hframed = frameTH2D(h2in, 2.3)
    hframed.SetContour(1, contours)
    hframed.Draw("CONT Z LIST")
    rt.gPad.Update()

    conts = rt.gROOT.GetListOfSpecials().FindObject("contours")
    contour0 = conts.At(0)
    curv = contour0.First()
    finalcurv = rt.TGraph(1)
    try:
        curv.SetLineWidth(3)
        curv.Draw("lsame")
        finalcurv = curv.Clone()
        maxN = curv.GetN()
    except AttributeError:
        print("ERROR: no curve drawn")

    for i in range(1, contour0.GetSize()):
        curv = contour0.After(curv)
        curv.SetLineWidth(3)
        curv.SetLineColor(rt.kWhite)
        curv.Draw("lsame")
        if curv.GetN() > maxN:
            maxN = curv.GetN()
            finalcurv = curv.Clone()

    return finalcurv


def interpolate2D(
    hist, function="multiquadric", metric="seuclidean", epsilon=0.2, smooth=0
):
    x = array("d", [])
    y = array("d", [])
    z = array("d", [])

    binWidthX = float(hist.GetXaxis().GetBinWidth(1))
    binWidthY = float(hist.GetYaxis().GetBinWidth(1))

    for i in range(1, hist.GetNbinsX() + 1):
        for j in range(1, hist.GetNbinsY() + 1):
            if hist.GetBinContent(i, j) > 0.0:
                x.append(hist.GetXaxis().GetBinCenter(i))
                y.append(hist.GetYaxis().GetBinCenter(j))
                z.append(hist.GetBinContent(i, j))

    xMin = hist.GetXaxis().GetBinCenter(1)
    xMax = hist.GetXaxis().GetBinCenter(hist.GetNbinsX())
    yMin = hist.GetYaxis().GetBinCenter(1)
    yMax = hist.GetYaxis().GetBinCenter(hist.GetNbinsY())

    myX = np.linspace(xMin, xMax, int((xMax - xMin) / binWidthX + 1))
    myY = np.linspace(yMin, yMax, int((yMax - yMin) / binWidthY + 1))
    myXI, myYI = np.meshgrid(myX, myY)

    rbf = Rbf(
        x,
        y,
        z,
        function=function,
        epsilon=epsilon,
        smooth=smooth,
        metric=metric,
    )
    myZI = rbf(myXI, myYI)

    for i in range(1, hist.GetNbinsX() + 1):
        for j in range(1, hist.GetNbinsY() + 1):
            hist.SetBinContent(i, j, myZI[j - 1][i - 1])

    return hist


if __name__ == "__main__":

    rt.gStyle.SetOptTitle(0)
    rt.gStyle.SetOptStat(0)
    rt.gStyle.SetPadRightMargin(0.15)
    rt.gStyle.SetPalette(rt.kBird)
    rt.gStyle.SetNumberContours(999)

    c = rt.TCanvas("c", "c", 500, 400)

    limit = rt.TChain("limit")
    for ifile in glob.glob("limit.grid2d.root"):
        limit.Add(ifile)

    poi_x = "rggF"
    poi_y = "rVBF"
    labels = {}
    labels["rggF"] = "#mu_{ggF}"
    labels["rVBF"] = "#mu_{VBF}"
    munpoints = 50
    mumin = -8
    mumax = 9

    fit = bestFit(limit, poi_x, poi_y)
    limit.Draw(
        "{poi_y}:{poi_x}>>htemp({munpoints},{mumin},{mumax},{munpoints},{mumin},{mumax})".format(
            poi_y=poi_y, poi_x=poi_x, munpoints=munpoints, mumin=mumin, mumax=mumax
        ),
        "2*deltaNLL*(quantileExpected>-1)*(deltaNLL>0)*(deltaNLL<100)",
        "colz",
    )

    htemp = rt.gPad.GetPrimitive("htemp")

    htemp = interpolate2D(htemp)
    htemp.GetXaxis().SetTitle(labels[poi_x])
    htemp.GetYaxis().SetTitle(labels[poi_y])
    htemp.GetZaxis().SetTitle("-2 #Delta ln L")
    htemp.SetMinimum(0.0)
    htemp.SetMaximum(16.0)
    htemp.SetLineColor(rt.kRed)

    cl68 = contourFromTH2(htemp, 2.3)
    cl95 = contourFromTH2(htemp, 5.99)
    cl997 = contourFromTH2(htemp, 11.83)
    cl68.SetLineColor(rt.kWhite)
    cl68.SetLineWidth(2)
    cl68.SetLineStyle(1)
    cl95.SetLineColor(rt.kWhite)
    cl95.SetLineWidth(2)
    cl95.SetLineStyle(2)
    cl997.SetLineColor(rt.kWhite)
    cl997.SetLineWidth(2)
    cl997.SetLineStyle(3)

    htemp.DrawCopy("colz")
    cl68.Draw("L SAME")
    cl95.Draw("L SAME")
    # cl997.Draw("L SAME")
    fit.Draw("P SAME")

    smx = 1.0
    smy = 1.0
    m = rt.TMarker()
    m.SetMarkerSize(1.8)
    m.SetMarkerColor(rt.kRed)
    m.SetMarkerStyle(29)
    m.DrawMarker(smx, smy)

    lumi = 138
    tag1 = rt.TLatex(0.65, 0.92, "%.0f fb^{-1} (13 TeV)" % lumi)
    tag1.SetNDC()
    tag1.SetTextFont(42)
    tag1.SetTextSize(0.04)
    tag2 = rt.TLatex(0.13, 0.85, "CMS")
    tag2.SetNDC()
    tag2.SetTextFont(62)
    tag3 = rt.TLatex(0.22, 0.85, "Preliminary")
    tag3.SetNDC()
    tag3.SetTextFont(52)
    tag2.SetTextSize(0.05)
    tag3.SetTextSize(0.04)
    tag1.Draw()
    tag2.Draw()
    tag3.Draw()

    leg = rt.TLegend(0.65, 0.7, 0.85, 0.87)
    leg.SetBorderSize(0)
    leg.SetTextFont(42)
    leg.SetFillColor(rt.kWhite)
    leg.SetLineColor(rt.kWhite)
    leg.SetLineStyle(0)
    leg.SetFillStyle(0)
    leg.SetLineWidth(0)
    leg.AddEntry(fit, "Best fit", "p")
    leg.AddEntry(m, "SM expected", "p")
    leg.AddEntry(cl68, "68% CL", "l")
    leg.AddEntry(cl95, "95% CL", "l")
    leg.Draw("same")

    c.Print("deltaLL2D.pdf")
    c.Print("deltaLL2D.C")

    htemp.Draw("axis")
    cl68.Draw("L SAME")
    cl95.Draw("L SAME")
    fit.Draw("P SAME")
