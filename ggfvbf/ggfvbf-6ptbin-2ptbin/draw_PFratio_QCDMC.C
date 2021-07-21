/************************************************
 * Jennet Dickinson 
 * Nov 19, 2020
 * Draw Roofit plots
 ************************************************/
#include <iostream>

using namespace RooFit;
using namespace RooStats;

void draw_PFratio_QCDMC(){

  vector<string> procs = {"vbf","ggf"};
  vector<int> nbins = {1,6};

  for(int j=0; j<procs.size(); j++){
    for(int i=0; i<nbins.at(j); i++){

      TFile* f = new TFile(("output/testModel_qcdfit_"+procs.at(j)+".root").c_str());
      RooWorkspace* w = (RooWorkspace*)(f->Get("qcdfit_ws"));
      RooStats::ModelConfig* mc = (RooStats::ModelConfig*)(w->obj("ModelConfig"));

      RooDataSet* data_pass = (RooDataSet*)w->data(("ptbin"+to_string(i)+procs.at(j)+"pass_data_obs").c_str());
      RooDataSet* data_fail = (RooDataSet*)w->data(("ptbin"+to_string(i)+procs.at(j)+"fail_data_obs").c_str());
      
      TCanvas *c1 = new TCanvas(("c_"+procs.at(j)+"_"+to_string(i)).c_str(), ("c_"+procs.at(j)+"_"+to_string(i)).c_str(), 600, 600);
      RooPlot* frame1 = (*w->var("msd")).frame(23);
      (*w->pdf(("ptbin"+to_string(i)+procs.at(j)+"pass_qcd").c_str())).plotOn(frame1, LineColor(kRed));
      //    (*w->pdf(("ptbin"+to_string(i)+"pass").c_str())).plotOn(frame1, LineColor(kRed));
      data_pass->plotOn(frame1, Rescale(1.0/data_pass->sumEntries()), DataError(RooAbsData::SumW2), MarkerColor(kBlack));
      data_fail->plotOn(frame1, Rescale(1.0/data_fail->sumEntries()), LineColor(kBlue), MarkerColor(kBlue));
      /*
        TH1D* h_pass = (TH1D*)data_pass->createHistogram("data_pass",*w->var("msd"));
        TH1D* h_fail = (TH1D*)data_fail->createHistogram("data_fail",*w->var("msd"));
	
        TH1D* h_ratio = (TH1D*)h_pass->Clone("data_ratio");
        h_ratio->Divide(h_fail);
      */
      
      gPad->SetLeftMargin(0.15);
      
      frame1->SetMaximum(0.15);
      frame1->SetMinimum(0);
      frame1->SetTitle(("ptbin "+to_string(i)+" "+procs.at(j)).c_str());
      frame1->SetYTitle("Events / 7 GeV");
      frame1->SetXTitle("m_{sd} [GeV]");
      frame1->Draw();
      
      TH1D* h_dum1 = new TH1D("h1","h1",1,0,1);
      TH1D* h_dum2 = new TH1D("h2","h2",1,0,1);
      TH1D* h_dum3 = new TH1D("h3","h3",1,0,1);
      
      h_dum1->SetLineColor(kBlack);
      h_dum1->SetMarkerColor(kBlack);
      h_dum1->SetMarkerStyle(20);
      h_dum2->SetLineColor(kBlue);
      h_dum2->SetMarkerColor(kBlue);
      h_dum2->SetMarkerStyle(20);
      h_dum3->SetLineColor(kRed);
      h_dum3->SetMarkerColor(kRed);
      h_dum3->SetLineWidth(3);
      
      TLegend* leg = new TLegend(0.5,0.7,0.85,0.85);
      leg->SetBorderSize(0);
      leg->AddEntry(h_dum1,"QCD MC pass","p");
      leg->AddEntry(h_dum2,"QCD MC fail","p");
      leg->AddEntry(h_dum3,"Fit","l");
      leg->Draw();
      
      //h_ratio->Scale(1.0/h_ratio->Integral());
      //h_ratio->Draw("same");
      
      //    cout << (*w->pdf(("ptbin"+to_string(i)+"pass_qcd").c_str())).getNorm() << endl;
      c1->SaveAs(("ptbin"+to_string(i)+procs.at(j)+".png").c_str());
      c1->SaveAs(("ptbin"+to_string(i)+procs.at(j)+".pdf").c_str());

    }
  }
  
  return 0;

}
