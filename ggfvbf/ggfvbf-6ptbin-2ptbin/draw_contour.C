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

  gStyle->SetOptTitle(0);

  TCanvas* c1 = new TCanvas();

  double x[1], y[1];
  x[0] = 1; y[0] = 1;
  TGraph* best = new TGraph(1,x,y);

  TGraph* g68 = get_contour("2017-ddb1","068");
  TGraph* g95 = get_contour("2017-ddb1","095");

  TGraph* f68 = get_contour("2017-best","068");
  TGraph* f95 = get_contour("2017-best","095");

  g95->SetLineWidth(3);
  g95->SetLineStyle(2);
  g95->Draw("AC");

  g95->GetXaxis()->SetTitle("#mu_{ggF}");
  g95->GetYaxis()->SetTitle("#mu_{VBF}");

  g68->SetLineWidth(3);
  g68->Draw("same");

  f95->SetLineColor(kBlue);
  f95->SetLineWidth(3);
  f95->SetLineStyle(2);
  f95->Draw("same");

  f68->SetLineColor(kBlue);
  f68->SetLineWidth(3);
  f68->Draw("same");

  best->SetMarkerStyle(29);
  best->SetMarkerSize(2);
  best->SetMarkerColor(kRed);
  best->Draw("p");

  TLegend* leg = new TLegend(.65,.75,.89,.89);
  leg->SetBorderSize(0);
  leg->AddEntry(best,"SM","p");
  leg->AddEntry(g68,"Exp. 68% CL, DDB v1","l");
  leg->AddEntry(g95,"Exp. 95% CL, DDB v1","l");
  leg->AddEntry(f68,"Exp. 68% CL, DDB v2","l");
  leg->AddEntry(f95,"Exp. 95% CL, DDB v2","l");
  leg->Draw();

  c1->SaveAs("contour2d.png");
  c1->SaveAs("contour2d.pdf");
  
  return;

}
