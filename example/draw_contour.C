// Draw output of combine 2d contour
TGraph* get_contour(string dir, string cl){

  TFile *f = new TFile((dir+"/limit.2dcontour."+cl+".root").c_str());

  // Variables
  float rVBF = 0;
  float rggF = 0;
  float quantileExpected = 0;

  TTree* t = (TTree*)f->Get("limit");
  t->SetBranchAddress("rVBF",&rVBF);
  t->SetBranchAddress("rggF",&rggF);
  t->SetBranchAddress("quantileExpected",&quantileExpected);
  int npoints = t->GetEntries()-5;

  double rVBF_lim[npoints];
  double rggF_lim[npoints];

  int j = 0;
  int k = npoints-1;
  for(int i=4; i<t->GetEntries(); i++){                                                                            

    t->GetEntry(i);
    if( quantileExpected > 0 ){
      if( i%2 == 0 ){
	rVBF_lim[j] = rVBF;
	rggF_lim[j] = rggF;
	j++;
      }
      else{
	rVBF_lim[k] = rVBF;
        rggF_lim[k] = rggF;
        k--;
      }
    }
  }

  TGraph* g = new TGraph(npoints,rggF_lim,rVBF_lim);
  return g;
}

void draw_contour(){

  // Get the year and prefit/postfit/obs from the running directory                                               
  string thisdir = gSystem->pwd();

  string year = "all";
  string year_string = "137/fb (13 TeV)";
  double rZbb = 1;

  if(thisdir.find("2016") != std::string::npos){
    year = "2016";
    year_string = "35.9/fb, 2016";
  }
  if(thisdir.find("2017") != std::string::npos){
    year = "2017";
    year_string = "41.5/fb, 2017";
  }
  if(thisdir.find("2018") != std::string::npos){
    year = "2018";
    year_string = "59.9/fb, 2018";
  }

  string asimov = "Observed";
  if(thisdir.find("postfit") != std::string::npos)
    asimov = "Exp. postfit";
  if(thisdir.find("prefit") !=std::string::npos)
    asimov = "Exp. prefit";

  gStyle->SetOptTitle(0);

  TCanvas* c1 = new TCanvas();

  double x[1], y[1];
  x[0] = 1; y[0] = 1;
  TGraph* best = new TGraph(1,x,y);

  TGraph* g68 = get_contour(".","0.68");
  TGraph* g95 = get_contour(".","0.95");

  float textsize1 = 18/(gPad->GetWh()*gPad->GetAbsHNDC());

  g95->SetLineWidth(3);
  g95->SetLineStyle(2);
  g95->GetXaxis()->SetLabelSize(textsize1);
  g95->GetXaxis()->SetTitleSize(textsize1);
  g95->GetYaxis()->SetLabelSize(textsize1);
  g95->GetYaxis()->SetTitleSize(textsize1);
  g95->GetHistogram()->SetMaximum(6);
  //g95->GetYaxis()->SetLimits(-10,10);
  g95->Draw("AC");

  g95->GetXaxis()->SetTitle("#mu_{ggF}");
  g95->GetYaxis()->SetTitle("#mu_{VBF}");

  g68->SetLineWidth(3);
  g68->Draw("same");

  best->SetMarkerStyle(29);
  best->SetMarkerSize(2);
  best->SetMarkerColor(kRed);
  best->Draw("p");

  TLegend* leg = new TLegend(.6,.7,.89,.85);
  leg->SetBorderSize(0);
  leg->AddEntry(best,"SM","p");
  leg->AddEntry(g68,(asimov+" 68% CL").c_str(),"l");
  leg->AddEntry(g95,(asimov+" 95% CL").c_str(),"l");
  leg->SetTextSize(textsize1);
  leg->Draw();

  TLatex l1;
  l1.SetNDC();
  l1.SetTextFont(42);
  l1.SetTextSize(textsize1);
  l1.DrawLatex(0.15,.82,"#bf{CMS} Preliminary");

  TLatex l2;
  l2.SetNDC();
  l2.SetTextFont(42);
  l2.SetTextSize(textsize1);
  l2.DrawLatex(0.7,.92,year_string.c_str());

  c1->SaveAs("plots/contour2d.png");
  c1->SaveAs("plots/contour2d.pdf");
  
  return;

}
