// Draw output of combine 2d contour
TGraph* get_contour(string poi, string filestring){

  TFile *f = new TFile(("higgsCombine"+filestring+".MultiDimFit.mH125.root").c_str());

  // Variables
  float x = 0;
  float y = 0;

  TTree* t = (TTree*)f->Get("limit");
  t->SetBranchAddress(poi.c_str(),&x);
  t->SetBranchAddress("deltaNLL",&y);
  int npoints = t->GetEntries();

  double r[npoints-1];
  double dnll[npoints-1];

  for(int i=0; i<npoints; i++){                                                                            

    t->GetEntry(i);

    if(i>0){
      r[i-1] = x;
      dnll[i-1] = 2*y;
    }
  }

  TGraph* g = new TGraph(npoints-1,r,dnll);

  g->SetLineWidth(3);
  g->SetLineColor(kBlack);

  return g;
}

void draw_likelihood(){

  // Get the year and prefit/postfit/obs from the running directory                                               
  string thisdir = gSystem->pwd();

  string year = "all";
  string year_string = "137/fb, Run 2";
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

  TCanvas* c0 = new TCanvas();

  double x[2] = {-10,10};
  double y1sigma[2] = {1,1};
  double y2sigma[2] = {4,4};
  double y3sigma[2] = {9,9};
  double y5sigma[2] = {25,25};

  TGraph* g1sigma = new TGraph(2,x,y1sigma);
  TGraph* g2sigma = new TGraph(2,x,y2sigma);
  TGraph* g3sigma = new TGraph(2,x,y3sigma);
  TGraph* g5sigma = new TGraph(2,x,y5sigma);

  g1sigma->SetLineColor(kGray);
  g2sigma->SetLineColor(kGray);
  g3sigma->SetLineColor(kGray);
  g5sigma->SetLineColor(kGray);

  g1sigma->SetLineWidth(3);
  g2sigma->SetLineWidth(3);
  g3sigma->SetLineWidth(3);
  g5sigma->SetLineWidth(3);

  g1sigma->SetLineStyle(3);
  g2sigma->SetLineStyle(3);
  g3sigma->SetLineStyle(3);
  g5sigma->SetLineStyle(3);

  TGraph* gvbf = get_contour("rVBF","rVBF");
  TGraph* gvbf_stat = get_contour("rVBF","rVBFStatOnly");

  gvbf->Draw("AC");
  gvbf->GetYaxis()->SetRangeUser(0,6);
  gvbf->GetXaxis()->SetRangeUser(-3,4);
  gvbf->GetXaxis()->SetTitle("#mu_{VBF}");
  gvbf->GetYaxis()->SetTitle("2#DeltaNLL");
  gvbf_stat->SetLineColor(kBlue);
  gvbf_stat->SetLineStyle(2);

  g1sigma->Draw("same");
  g2sigma->Draw("same");
  gvbf->Draw("Csame");
  gvbf_stat->Draw("Csame");

  TLegend* leg = new TLegend(.7,.8,0.9,0.9);
  leg->AddEntry(gvbf,"stat + syst","l");
  leg->AddEntry(gvbf_stat,"stat only","l");
  leg->Draw();

  c0->SaveAs("plots/likelihood_vbf.png");
  c0->SaveAs("plots/likelihood_vbf.pdf");

  TCanvas* c1 = new TCanvas();
  TGraph* gggf = get_contour("rggF","rggF");
  TGraph* gggf_stat = get_contour("rggF","rggFStatOnly");

  gggf->Draw("AC");
  gggf->GetYaxis()->SetRangeUser(0,6);
  gggf->GetXaxis()->SetRangeUser(-3,4);
  gggf->GetXaxis()->SetTitle("#mu_{ggF}");
  gggf->GetYaxis()->SetTitle("2#DeltaNLL");
  gggf_stat->SetLineColor(kBlue);
  gggf_stat->SetLineStyle(2);

  g1sigma->Draw("same");
  g2sigma->Draw("same");
  gggf->Draw("Csame");
  gggf_stat->Draw("Csame");

  leg->Draw();

  c1->SaveAs("plots/likelihood_ggf.png");
  c1->SaveAs("plots/likelihood_ggf.pdf");

  TCanvas* c2 = new TCanvas();
  TGraph* gzbb = get_contour("rZbb","rZbb");
  TGraph* gzbb_stat = get_contour("rZbb","rZbbStatOnly");

  gzbb->Draw("AC");
  gzbb->GetYaxis()->SetRangeUser(0,6);
  gzbb->GetXaxis()->SetRangeUser(.5,1.5);
  gzbb->GetXaxis()->SetTitle("#mu_{Zbb}");
  gzbb->GetYaxis()->SetTitle("2#DeltaNLL");
  gzbb_stat->SetLineColor(kBlue);
  gzbb_stat->SetLineStyle(2);

  g3sigma->Draw("same");
  g5sigma->Draw("same");
  gzbb->Draw("Csame");
  gzbb_stat->Draw("Csame");

  leg->Draw();

  c2->SaveAs("plots/likelihood_zbb.png");
  c2->SaveAs("plots/likelihood_zbb.pdf");

  return;

}
