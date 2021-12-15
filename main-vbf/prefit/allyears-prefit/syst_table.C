vector<double> read_from_graph(string poi, string filestring){
  
  TFile *f = new TFile(("higgsCombine"+filestring+".MultiDimFit.mH125.root").c_str());  
  
  // Variables                                                                                                                                         
  float x = 0;
  float y = 0;
  
  TTree* t = (TTree*)f->Get("limit");
  t->SetBranchAddress(poi.c_str(),&x);
  t->SetBranchAddress("deltaNLL",&y);
  int npoints = t->GetEntries();
  
  double r_pos[npoints-1];
  double dnll_pos[npoints-1];

  double r_neg[npoints-1];
  double dnll_neg[npoints-1];

  t->GetEntry(0);
  double center = x;
  
  for(int i=0; i<npoints; i++){
    
    t->GetEntry(i);
    
    if( i>0 ){
      if( x > center ){
	r_pos[i-1] = x;
	dnll_pos[i-1] = 2*y;

	r_neg[i-1] = 0;
	dnll_neg[i-1] = 0;
      }
      else{
	r_pos[i-1] = 0;
	dnll_pos[i-1] = 0;

	r_neg[i-1] = x;
	dnll_neg[i-1] = 2*y;
      }
    }

  }
  
  TGraph* gpos = new TGraph(npoints-1,dnll_pos,r_pos);
  TGraph* gneg = new TGraph(npoints-1,dnll_neg,r_neg);
  
  vector<double> unc;
  unc.push_back(gpos->Eval(center) - center);
  unc.push_back(gneg->Eval(center) - center);
  
  return unc;
}

vector<double> read_from_tree(string poi, string filestring){

  TFile *f = new TFile(("higgsCombine"+filestring+".MultiDimFit.mH125.root").c_str());

  // Variables                                                                                                                                               
  float x = 0;
  float y = 0;

  TTree* t = (TTree*)f->Get("limit");
  t->SetBranchAddress(poi.c_str(),&x);
  int npoints = t->GetEntries();

  vector<double> uncs = {1,1};

  t->GetEntry(0);
  double center = x;
  for(int i=0; i<npoints; i++){

    t->GetEntry(i);

    if(x > center) uncs.at(1) = x - center;
    if(x < center) uncs.at(0) = x - center;

  }
  return uncs;

}

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

  //  double center = stod(words.at(2));                                                                                          
  //  vals.push_back(center);     
  
  int splitpoint = words.at(3).find('/');                                                                                  
  
  double down_unc = stod(words.at(3).substr(0,splitpoint));                                                                           
  vals.push_back(down_unc);                                                                                                           
                                                                                                                                      
  double up_unc = stod(words.at(3).substr(splitpoint+1,string::npos));                                                                
  vals.push_back(up_unc);                                                                                                             
                                                                                                                                      
  return vals;
}

void get_table(string poi){

  cout << "----------- " << poi << endl;

  vector<string> systnames = {"TFres","TTQ","AllExp","DDB","JESJER","JMSJMR","qcdparam","MCStat","Other","AllTh","ggFtheory","VBFtheory","VHttHtheory","Vtheory"}; 

  vector<double> unc_total = read_from_graph(poi,poi);
  cout << "Total & " << unc_total[1] << " & "<<  unc_total[0] << endl;

  vector<double> unc_allstat = read_from_graph(poi, poi+"StatOnly");
  cout << "AllStat & " << unc_allstat[1] <<" & " << unc_allstat[0] << endl;

  vector<double> unc_sigextr = read_from_graph(poi, "_"+poi+"SigExtr");
  cout << "SigExtr & " << unc_sigextr[1] <<" & " << unc_sigextr[0] << endl;

  for(int i=0; i<systnames.size(); i++){

    vector<double> unc = read_from_graph(poi, "_"+poi+systnames.at(i));

    //    cout << systnames.at(i) << ", " << unc[0] << ", " << unc[1] << endl;

    double delta_mu_m = sqrt(unc_total[0]*unc_total[0] - unc[0]*unc[0]);
    double delta_mu_p = sqrt(unc_total[1]*unc_total[1] - unc[1]*unc[1]);

    cout << systnames.at(i) << " & " << -1*delta_mu_m << " & " << delta_mu_p << endl;
  }

  return;

}
 
void syst_table(){

  get_table("rVBF");
  get_table("rggF");

  return;
}
