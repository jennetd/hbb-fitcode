/************************************************
 * Jennet Dickinson 
 * Nov 19, 2020
 * Draw Roofit plots
 ************************************************/
#include <iostream>

using namespace RooFit;
using namespace RooStats;

string year = "59.9/fb, 2018";
bool blind = true;

void draw(bool pass, string var, bool log=true){

  string name = "muoncr_"+var+"fail";
  if( pass )
    name = "muoncr_"+var+"pass";

  int rebin = 1;
  //  if( var =a= "pt_" ) rebin = 10;

  /* DATA */
  TH1D* data_obs;
  TFile* f = new TFile("muonCR.root");
  data_obs = (TH1D*)f->Get(("muondata_"+var+"fail").c_str());
  if( pass )
    data_obs = (TH1D*)f->Get(("muondata_"+var+"pass").c_str());

  data_obs->SetLineColor(kBlack);
  data_obs->SetMarkerColor(kBlack);
  data_obs->SetMarkerStyle(20);
  data_obs->Rebin(rebin);

  gStyle->SetOptTitle(0);
  gStyle->SetOptStat(0);

  TCanvas* c = new TCanvas(name.c_str(),name.c_str(),600,600);
  TPad *pad1 = new TPad("pad1","pad1",0,.33,1,1);
  TPad *pad2 = new TPad("pad2","pad2",0,0,1,.33);

  pad1->SetBottomMargin(0.00001);
  pad1->SetTopMargin(0.1);
  pad1->SetBorderMode(0);
  pad2->SetTopMargin(0.00001);
  pad2->SetBottomMargin(0.3);
  pad2->SetBorderMode(0);
  pad1->Draw();
  pad2->Draw();

  float textsize1 = 16/(pad1->GetWh()*pad1->GetAbsHNDC());
  float textsize2 = 16/(pad2->GetWh()*pad2->GetAbsHNDC());

  pad1->cd();
  if( log ) pad1->SetLogy();

  THStack *bkg = new THStack("bkg","");

  /* VV */
  TH1D* VV;
  VV = (TH1D*)f->Get(("VV_"+var+"fail").c_str());
  if( pass )
    VV = (TH1D*)f->Get(("VV_"+var+"pass").c_str());
  VV->SetLineColor(kBlack);
  VV->SetFillColor(kOrange-3);
  VV->Rebin(rebin);

  /* single t */
  TH1D* singlet;
  singlet = (TH1D*)f->Get(("singlet_"+var+"fail").c_str());
  if( pass )
    singlet = (TH1D*)f->Get(("singlet_"+var+"pass").c_str());
  singlet->SetLineColor(kBlack);
  singlet->SetFillColor(kPink+6);
  singlet->Rebin(rebin);

  /* ttbar */
  TH1D* ttbar;
  ttbar = (TH1D*)f->Get(("ttbar_"+var+"fail").c_str());
  if( pass )
    ttbar = (TH1D*)f->Get(("ttbar_"+var+"pass").c_str());
  ttbar->SetLineColor(kBlack);
  ttbar->SetFillColor(kViolet-5);
  ttbar->Rebin(rebin);

  /* Z + jets */
  TH1D* Zjets;
  Zjets = (TH1D*)f->Get(("Zjets_"+var+"fail").c_str());
  if( pass )
    Zjets = (TH1D*)f->Get(("Zjets_"+var+"pass").c_str());
  Zjets->SetLineColor(kBlack);
  Zjets->SetFillColor(kAzure-1);
  Zjets->Rebin(rebin);

  /* W + jets */
  TH1D* Wjets;
  Wjets = (TH1D*)f->Get(("Wjets_"+var+"fail").c_str());
  if( pass )
    Wjets = (TH1D*)f->Get(("Wjets_"+var+"pass").c_str());
  Wjets->SetLineColor(kBlack);
  Wjets->SetFillColor(kAzure+8);
  Wjets->Rebin(rebin);

  /* QCD */
  TH1D* qcd;
  qcd = (TH1D*)f->Get(("QCD_"+var+"fail").c_str());
  if( pass )
    qcd = (TH1D*)f->Get(("QCD_"+var+"pass").c_str());
  qcd->SetLineColor(kBlack);
  qcd->SetFillColor(kGray);
  qcd->Rebin(rebin);

  if( log ){
    bkg->Add(VV);
    bkg->Add(Zjets);
    bkg->Add(Wjets);
    bkg->Add(singlet);
    bkg->Add(qcd);
    bkg->Add(ttbar);
  }
  else{
    bkg->Add(ttbar);
    bkg->Add(qcd);
    bkg->Add(singlet);
    bkg->Add(Wjets);
    bkg->Add(Zjets);
    bkg->Add(VV);
  }

  cout << "QCD: "     << qcd->Integral()     << endl;
  cout << "Wjets: "   << Wjets->Integral()   << endl;
  cout << "Zjets: "   << Zjets->Integral()   << endl;
  cout << "ttbar: "   << ttbar->Integral()   << endl;
  cout << "singlet: " << singlet->Integral() << endl;
  cout << "VV: "      << VV->Integral()      << endl;
  
  /* total background */
  TH1D* TotalBkg = (TH1D*)qcd->Clone("TotalBkg");
  TotalBkg->Add(Wjets);
  TotalBkg->Add(Zjets);
  TotalBkg->Add(ttbar);
  TotalBkg->Add(singlet);
  TotalBkg->Add(VV);
  TotalBkg->SetMarkerColor(kRed);
  TotalBkg->SetLineColor(kRed);
  TotalBkg->SetFillColor(kRed);
  TotalBkg->SetFillStyle(3001);
  double max = TotalBkg->GetMaximum();
  TotalBkg->GetYaxis()->SetRangeUser(0.1,1000*max);
  if( !log ) TotalBkg->GetYaxis()->SetRangeUser(0,1.3*max);
  TotalBkg->GetYaxis()->SetTitleSize(textsize1);
  TotalBkg->GetYaxis()->SetLabelSize(textsize1);
  TotalBkg->GetYaxis()->SetTitle("Events / 7 GeV");
  TotalBkg->GetXaxis()->SetTitle("m_{sd} [GeV]");
  if( var == "pt_" ){
    TotalBkg->GetXaxis()->SetTitle("Muon p_T [GeV]");
    TotalBkg->GetXaxis()->SetRangeUser(0,500);
  }
  if( var == "eta_" ) TotalBkg->GetXaxis()->SetTitle("Muon |#eta| [GeV]");

  TotalBkg->Draw("e2");
  bkg->Draw("histsame");
  TotalBkg->Draw("e2same");
  data_obs->Draw("pesame");
  data_obs->Draw("axissame");
  
  double x1=.6, y1=.88;
  TLegend* leg = new TLegend(x1,y1,x1+.3,y1-.3);
  leg->SetBorderSize(0);
  leg->SetNColumns(2);
  leg->SetTextSize(textsize1);

  leg->AddEntry(data_obs,"Data","p");
  leg->AddEntry(TotalBkg,"Bkg. Unc.","f");
  leg->AddEntry(qcd,"QCD","f");
  leg->AddEntry(Wjets,"W+jets","f");
  leg->AddEntry(Zjets,"Z+jets","f");
  leg->AddEntry(ttbar,"t#bar{t}","f");
  leg->AddEntry(singlet,"Single t","f");
  leg->AddEntry(VV,"VV","f");

  leg->Draw();

  TLatex l1;
  l1.SetNDC();
  l1.SetTextFont(42);
  l1.SetTextSize(textsize1);
  l1.DrawLatex(0.12,.92,"CMS Preliminary");

  TLatex l2;
  l2.SetNDC();
  l2.SetTextFont(42);
  l2.SetTextSize(textsize1);
  l2.DrawLatex(0.7,.92,year.c_str());

  TLatex l3;
  l3.SetNDC();
  l3.SetTextFont(42);
  l3.SetTextSize(textsize1);
  string text ="DDB failing";
  if( pass )
    text = "DDB passing";
  l3.DrawLatex(0.15,.82,text.c_str());

  pad2->cd();
  TH1D* TotalBkg_ratio = (TH1D*)TotalBkg->Clone("TotalBkg_ratio");
  TotalBkg_ratio->Divide(TotalBkg_ratio);
  TotalBkg_ratio->GetYaxis()->SetTitleSize(textsize2);
  TotalBkg_ratio->GetYaxis()->SetLabelSize(textsize2);
  TotalBkg_ratio->GetXaxis()->SetTitleSize(textsize2);
  TotalBkg_ratio->GetXaxis()->SetLabelSize(textsize2);
  TotalBkg_ratio->SetMarkerSize(0);
  TotalBkg_ratio->Draw("e2");

  TH1D* data_obs_ratio = (TH1D*)data_obs->Clone("data_obs_ratio");
  data_obs_ratio->Divide(TotalBkg);

  TotalBkg_ratio->GetYaxis()->SetRangeUser(0,2);
  
  TotalBkg_ratio->Draw("e2");
  data_obs_ratio->Draw("pesame");

  if( !log ) name += "_lin";

  c->SaveAs((name+".png").c_str());
  c->SaveAs((name+".pdf").c_str());

  return;

}

void draw_muonCR(){

  draw(0,"");
  draw(1,"");

  draw(0,"",0);
  draw(1,"",0);

  draw(0,"pt_");
  draw(1,"pt_");

  draw(0,"pt_",0);
  draw(1,"pt_",0);

  draw(0,"eta_");
  draw(1,"eta_");

  draw(0,"eta_",0);
  draw(1,"eta_",0);

  return 0;

}
