/************************************************
 * Jennet Dickinson 
 * Nov 19, 2020
 * Draw Roofit plots
 ************************************************/
#include <iostream>

using namespace RooFit;
using namespace RooStats;

string year = "41.5/fb, 2017";
bool blind = true;

void draw(bool pass, bool log=true){

  vector<string> procs = {"ggf","vbf"};

  for(int j=0; j<procs.size(); j++){
    /* DATA */
    TH1D* data_obs;
    TFile* dataf = new TFile("signalregion.root");
    data_obs = (TH1D*)dataf->Get((procs.at(j)+"_fail_data_nominal").c_str());
    if( pass )
      data_obs = (TH1D*)dataf->Get((procs.at(j)+"_pass_data_nominal").c_str());

    // blind data!
    if( blind && pass ){                                                                                                   
      for(int i=10; i<14; i++){
	data_obs->SetBinContent(i,0);
	data_obs->SetBinError(i,0);
      }                            
    }                                                                                               
                                                                                                                 
    data_obs->SetLineColor(kBlack);
    data_obs->SetMarkerColor(kBlack);
    data_obs->SetMarkerStyle(20);
    
    string filename = "fitDiagnostics.root";
    string name = "ptbin0"+procs.at(j)+"fail";
    if( pass )
      name = "ptbin0"+procs.at(j)+"pass";
    
    string histdirname = "shapes_fit_s/" + name;
    
    TFile *f = new TFile(filename.c_str());
    
    //  RooArgSet* args = (RooArgSet*)f->Get("norm_fit_s");
    
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
    
    /* VBF */
    TH1D* VBF = (TH1D*)f->Get((histdirname+"/VBF").c_str());
    VBF->Scale(7.0);
    VBF->SetLineColor(kGreen+1);
    VBF->SetMarkerColor(kGreen+1);
    VBF->SetLineWidth(3);
    
    THStack *bkg = new THStack("bkg","");

    /* ggF */
    TH1D* ggF = (TH1D*)f->Get((histdirname+"/ggF").c_str());
    ggF->Scale(7.0);
    ggF->SetLineColor(kRed+1);
    ggF->SetMarkerColor(kRed+1);
    ggF->SetLineStyle(2);
    ggF->SetLineWidth(3);

    /* non-VBF Higgs */
    TH1D* bkgHiggs = (TH1D*)f->Get((histdirname+"/WH").c_str());
    bkgHiggs->Add((TH1D*)f->Get((histdirname+"/ZH").c_str()));
    bkgHiggs->Add((TH1D*)f->Get((histdirname+"/ttH").c_str()));
    bkgHiggs->Scale(7.0); 
    bkgHiggs->SetLineColor(kBlack);
    bkgHiggs->SetFillColor(kOrange);
    
    /* VV */
    TH1D* VV = (TH1D*)f->Get((histdirname+"/VV").c_str());
    VV->Scale(7.0);
    VV->SetLineColor(kBlack);
    VV->SetFillColor(kOrange-3);
    
    /* single t */
    TH1D* singlet = (TH1D*)f->Get((histdirname+"/singlet").c_str());
    singlet->Scale(7.0);
    singlet->SetLineColor(kBlack);
    singlet->SetFillColor(kPink+6);
    
    /* ttbar */
    TH1D* ttbar = (TH1D*)f->Get((histdirname+"/ttbar").c_str());
    ttbar->Scale(7.0);
    ttbar->SetLineColor(kBlack);
    ttbar->SetFillColor(kViolet-5);
    
    /* Z + jets */
    TH1D* Zjets = (TH1D*)f->Get((histdirname+"/Zjets").c_str());
    Zjets->Scale(7.0);
    Zjets->SetLineColor(kBlack);
    Zjets->SetFillColor(kAzure-1);
    
    /* W + jets */
    TH1D* Wjets = (TH1D*)f->Get((histdirname+"/Wjets").c_str());
    Wjets->Scale(7.0);
    Wjets->SetLineColor(kBlack);
    Wjets->SetFillColor(kAzure+8);
    
    /* QCD */
    TH1D* qcd = (TH1D*)f->Get((histdirname+"/qcd").c_str());
    qcd->Scale(7.0);
    qcd->SetLineColor(kBlack);
    qcd->SetFillColor(kGray);
    
    if( log ){
      bkg->Add(bkgHiggs);
      bkg->Add(VV);
      bkg->Add(singlet);
      bkg->Add(ttbar);
      bkg->Add(Zjets);
      bkg->Add(Wjets);
      bkg->Add(qcd);
    }
    else{
      bkg->Add(qcd);
      bkg->Add(Wjets);
      bkg->Add(Zjets);
      bkg->Add(ttbar);
      bkg->Add(singlet);
      bkg->Add(VV);
      bkg->Add(bkgHiggs);
    }
    
    cout << "QCD: "     << qcd->Integral()     << endl;
    cout << "Wjets: "   << Wjets->Integral()   << endl;
    cout << "Zjets: "   << Zjets->Integral()   << endl;
    cout << "ttbar: "   << ttbar->Integral()   << endl;
    cout << "singlet: " << singlet->Integral() << endl;
    cout << "VV: "      << VV->Integral()      << endl;
    cout << "bkgHiggs: " << bkgHiggs->Integral() << endl;
    
    /* total background */
    TH1D* TotalBkg = (TH1D*)f->Get((histdirname+"/total_background").c_str());
    TotalBkg->Scale(7.0);
    TotalBkg->SetMarkerColor(kRed);
    TotalBkg->SetLineColor(kRed);
    TotalBkg->SetFillColor(kRed);
    TotalBkg->SetFillStyle(3001);
    double max = TotalBkg->GetMaximum();
    TotalBkg->GetYaxis()->SetRangeUser(0.1,2000*max);
    if( !log ) TotalBkg->GetYaxis()->SetRangeUser(0,1.3*max);
    TotalBkg->GetYaxis()->SetTitleSize(textsize1);
    TotalBkg->GetYaxis()->SetLabelSize(textsize1);
    TotalBkg->GetYaxis()->SetTitle("Events / 7 GeV");
    TotalBkg->GetXaxis()->SetTitle("m_{sd} [GeV]");
    
    TotalBkg->Draw("e2");
    bkg->Draw("histsame");
    TotalBkg->Draw("e2same");
    ggF->Draw("histsame");
    VBF->Draw("histsame");
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
    leg->AddEntry(bkgHiggs,"VH+ttH","f");
    leg->AddEntry(ggF,"ggF","l");
    leg->AddEntry(VBF,"VBF","l");

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
    string text ="DDB failing "+procs.at(j)+" cat";
    if( pass )
      text = "DDB passing "+procs.at(j)+ "cat";
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
    
    double max2 = data_obs_ratio->GetMaximum();
    TotalBkg_ratio->GetYaxis()->SetRangeUser(0.6,1.3*max2);
    
    TotalBkg_ratio->Draw("e2");
    data_obs_ratio->Draw("pesame");
    
    if( !log ) name += "_lin";
    
    c->SaveAs((name+".png").c_str());
    c->SaveAs((name+".pdf").c_str());

  }
  return;
  
}

void draw_datafit(){

  draw(0);
  draw(1);

  draw(0,0);
  draw(1,0);

  return 0;

}
