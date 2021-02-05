/************************************************
 * Jennet Dickinson 
 * Nov 19, 2020
 * Draw Roofit plots
 ************************************************/
#include <iostream>

void draw_muonCR(){

  gStyle->SetOptStat(0);
  gStyle->SetOptTitle(0);

  TFile* f = new TFile("muonCR.root");

  TH1D* muondata = (TH1D*)f->Get("muondata_pass");

  muondata->SetMarkerStyle(20);
  muondata->SetMarkerColor(kBlack);
  muondata->SetLineColor(kBlack);
  muondata->Draw("pe");

  return 0;

}
