TH2D* get_th2(string dir){

  TFile *f = new TFile((dir+"/limit.grid2d.root").c_str());

  // Variables                                                                                                                          
  float rVBF = 0;
  float rggF = 0;
  float deltaNLL = 0;

  TTree* t = (TTree*)f->Get("limit");
  t->SetBranchAddress("rVBF",&rVBF);
  t->SetBranchAddress("rggF",&rggF);
  t->SetBranchAddress("deltaNLL",&deltaNLL);

  const int npoints = 32;

  double mumin = -6;
  double mumax = 7;

  TH2D* h = new TH2D("deltaNLL","deltaNLL",npoints,mumin,mumax,npoints,mumin,mumax);

  cout << t->GetEntries() << endl;

  for(int i=0; i<t->GetEntries(); i++){

    t->GetEntry(i);
    cout << rggF << ", " << rVBF << ", " << deltaNLL << endl;
    h->Fill(rggF,rVBF,deltaNLL);

  }

  return h;
}

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

  int npoints = t->GetEntries()-4;
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
  string year_string = "138/fb (13 TeV)";
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
    year_string = "59.2/fb, 2018";
  }

  string asimov = "Observed";
  if(thisdir.find("postfit") != std::string::npos)
    asimov = "Exp. postfit";
  if(thisdir.find("prefit") !=std::string::npos)
    asimov = "Exp. prefit";

  gStyle->SetOptTitle(0);

  TCanvas* c1 = new TCanvas();
  gStyle->SetOptStat(0);
  gStyle->SetOptTitle(0);
  gPad->SetRightMargin(0.15);

  double x[1], y[1];
  x[0] = 1; y[0] = 1;
  TGraph* best = new TGraph(1,x,y);

  TGraph* g68 = get_contour(".","068");
  TGraph* g95 = get_contour(".","095");

  TH2D* h = get_th2(".");

  float textsize1 = 18/(gPad->GetWh()*gPad->GetAbsHNDC());

  h->GetXaxis()->SetLabelSize(textsize1);                                                                                                                             
  h->GetXaxis()->SetTitleSize(textsize1);                                                                                                                             
  h->GetYaxis()->SetLabelSize(textsize1);                                                                                                                             
  h->GetYaxis()->SetTitleSize(textsize1);  
  h->GetXaxis()->SetTitle("#mu_{ggF}");                                                                                                                               
  h->GetYaxis()->SetTitle("#mu_{VBF}");  
  h->GetZaxis()->SetTitle("#Delta NLL");
  h->GetYaxis()->SetRangeUser(-6,7);
  h->GetXaxis()->SetRangeUser(-6,7);
  h->Draw("COLZ");

  g95->SetLineColor(kWhite);
  g95->SetLineWidth(3);
  g95->SetLineStyle(2);
  g95->Draw("same");

  g68->SetLineColor(kWhite);
  g68->SetLineWidth(3);
  g68->Draw("same");

  best->SetMarkerStyle(29);
  best->SetMarkerSize(2);
  best->SetMarkerColor(kRed);
  best->Draw("p");

  TLegend* leg = new TLegend(.15,.2,.44,.35);
  leg->SetFillStyle(0);
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
