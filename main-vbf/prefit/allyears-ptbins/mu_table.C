
string year_string = "138/fb (13 TeV)";

vector<double> read_from_file(string poi, string filestring){

  vector<double> vals; 

  string logfile = filestring;

  ifstream infile;
  string line;
  string theline;
  
  infile.open(logfile.c_str());
  while(getline(infile, line)) { 
    if (line.find(poi+" :", 0) != string::npos) {
      theline = line;
    }
  }

  vector<string> words;

  istringstream iss(theline);
  for (std::string s; iss >> s; )
    words.push_back(s);

  double center = stod(words.at(2));
  vals.push_back(center);
  
  int splitpoint = words.at(3).find('/');

  double down_unc = stod(words.at(3).substr(0,splitpoint));
  vals.push_back(-1*down_unc);

  double up_unc = stod(words.at(3).substr(splitpoint+1,string::npos));
  vals.push_back(up_unc);

  for(int i=0; i<vals.size(); i++){
    cout << vals.at(i) << endl;
  }

  vals.push_back(2);
  vals.push_back(3);
  vals.push_back(4);

  return vals;
}

TGraphAsymmErrors* get_total(string poi){

  vector<double> total = read_from_file(poi,"../allyears-prefit/logs/fit_batch.out");
  
  const int n = 2;
  double center[n] = {total.at(0),total.at(0)};
  double up_unc[n] = {total.at(2),total.at(2)};
  double do_unc[n] = {total.at(1),total.at(1)};
  double x[n] = {-100,100};

  TGraphAsymmErrors* g = new TGraphAsymmErrors(n,x,center,0,0,do_unc,up_unc);

  return g;
}

TGraphAsymmErrors* get_VBF_table(){

  vector<double> bin7 = read_from_file("rVBF7","logs/fit_batch.out");
  vector<double> bin8 = read_from_file("rVBF8","logs/fit_batch.out");
  vector<double> ggf  = read_from_file("rVBF1","logs/fit_batch.out");

  const int n = 3;
  double center[n] = {bin7.at(0),bin8.at(0),ggf.at(0)};
  double up_unc[n] = {bin7.at(2),bin8.at(2),ggf.at(2)};
  double do_unc[n] = {bin7.at(1),bin8.at(1),ggf.at(1)};
  double x[n] = {1,2,3};

  TGraphAsymmErrors* g = new TGraphAsymmErrors(n,x,center,0,0,do_unc,up_unc);

  return g;

}

TGraphAsymmErrors* get_ggF_table(){

  vector<double> bin1 = read_from_file("rggF1","logs/fit_batch.out");
  vector<double> bin2 = read_from_file("rggF2","logs/fit_batch.out");
  vector<double> bin3 = read_from_file("rggF3","logs/fit_batch.out");
  vector<double> bin4 = read_from_file("rggF4","logs/fit_batch.out");
  vector<double> bin5 = read_from_file("rggF5","logs/fit_batch.out");
  vector<double> bin6 = read_from_file("rggF6","logs/fit_batch.out");
  
  const int n = 6;
  double center[n] = {bin1.at(0),bin2.at(0),bin3.at(0),bin4.at(0),bin5.at(0),bin6.at(0)};
  double up_unc[n] = {bin1.at(2),bin2.at(2),bin3.at(2),bin4.at(2),bin5.at(2),bin6.at(2)};
  double do_unc[n] = {bin1.at(1),bin2.at(1),bin3.at(1),bin4.at(1),bin5.at(1),bin6.at(1)};
  double x[n] = {1,2,3,4,5,6};
  
  TGraphAsymmErrors* g = new TGraphAsymmErrors(n,x,center,0,0,do_unc,up_unc);
  
  return g;
  
}

void draw_VBF(){
  
  TCanvas* cvbf = new TCanvas("vbf","vbf");
  //  gPad->SetLeftMargin(0.15);
  gPad->SetBottomMargin(0.15);
  
  gStyle->SetOptStat(0);
  gStyle->SetOptTitle(0);
  
  float textsize1 = 18/(gPad->GetWh()*gPad->GetAbsHNDC());
  
  TH1D* h = new TH1D("dummy1","dummy1",3,0.5,3.5);
  h->Fill("1-2 TeV",0);
  h->Fill("> 2 TeV",0);
  h->Fill("ggF cat.",0);

  h->GetXaxis()->SetTitle("m_{jj} bin in VBF category");
  h->GetXaxis()->SetTitleSize(textsize1);
  h->GetXaxis()->SetLabelSize(textsize1);
  h->GetXaxis()->SetTitleOffset(1.5);
  h->GetYaxis()->SetRangeUser(-10,10);
  h->GetYaxis()->SetTitle("#mu_{VBF}");
  h->GetYaxis()->SetTitleSize(textsize1);
  h->GetYaxis()->SetLabelSize(textsize1);
  h->GetYaxis()->SetTitleOffset(0.9);
  h->Draw("axis");

  TGraph* total = get_total("rVBF");
  total->SetLineColor(kBlue);
  total->SetFillColor(kBlue-10);
  total->SetLineWidth(3);
  total->Draw("3same");
  total->Draw("lsame");

  const int n = 2;
  double smx[n] = {-100,100};
  double smy[n] = {1,1};
  
  TGraph* sm = new TGraph(n,smx,smy);
  sm->SetLineColor(kBlack);
  sm->SetLineStyle(3);
  sm->SetLineWidth(3);
  sm->Draw("lsame");

  TGraphAsymmErrors* g = get_VBF_table();
  g->SetMarkerColor(kBlack);
  g->SetMarkerStyle(20);
  g->SetLineColor(kBlack);
  g->SetLineWidth(3);
  g->Draw("pzsame");
  
  h->Draw("axissame");

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

  cvbf->SaveAs("muVBF_perMjjBin.pdf");
  cvbf->SaveAs("muVBF_perMjjBin.png");

  return;
}

void draw_ggF(){

  TCanvas* cggf = new TCanvas("ggf","ggf");
  //  gPad->SetLeftMargin(0.15);
  gPad->SetBottomMargin(0.15);

  gStyle->SetOptStat(0);
  gStyle->SetOptTitle(0);

  float textsize1 = 19/(gPad->GetWh()*gPad->GetAbsHNDC());

  TH1D* h = new TH1D("dummy2","dummy2",7,0.5,7.5);
  h->Fill("[450, 500] GeV",0);
  h->Fill("[500, 550] GeV",0);
  h->Fill("[550, 600] GeV",0);
  h->Fill("[600, 675] GeV",0);
  h->Fill("[675, 800] GeV",0);
  h->Fill("[800, 1200] GeV",0);
  h->Fill("VBF category",0);

  h->GetXaxis()->SetTitle("p_{T} bin in ggF category");
  h->GetXaxis()->SetRangeUser(0.5,6.5);
  h->GetXaxis()->SetTitleSize(textsize1);
  h->GetXaxis()->SetLabelSize(textsize1);
  h->GetXaxis()->SetTitleOffset(1.5);
  h->GetYaxis()->SetRangeUser(-10,10);
  h->GetYaxis()->SetTitle("#mu_{ggF}");
  h->GetYaxis()->SetTitleSize(textsize1);
  h->GetYaxis()->SetLabelSize(textsize1);
  h->GetYaxis()->SetTitleOffset(0.9);
  h->Draw("axis");

  TGraph* total = get_total("rggF");
  total->SetLineColor(kBlue);
  total->SetFillColor(kBlue-10);
  total->SetLineWidth(3);
  total->Draw("3same");
  total->Draw("lsame");

  const int n = 2;
  double smx[n] = {-100,100};
  double smy[n] = {1,1};

  TGraph* sm = new TGraph(n,smx,smy);
  sm->SetLineColor(kBlack);
  sm->SetLineStyle(3);
  sm->SetLineWidth(3);
  sm->Draw("lsame");

  TGraphAsymmErrors* g = get_ggF_table();
  g->SetMarkerColor(kBlack);
  g->SetMarkerStyle(20);
  g->SetLineColor(kBlack);
  g->SetLineWidth(3);
  g->Draw("pzsame");

  h->Draw("axissame");

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

  cggf->SaveAs("muggF_perPtBin.pdf");
  cggf->SaveAs("muggF_perPtBin.png");

  return;
}

void mu_table(){

  //draw_VBF();

  draw_ggF();

  return;
}
