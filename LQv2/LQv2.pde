int[][] Color = {
  {230,171,235},
  {176,195,152},
  {221,238,146},
  {209,253,237},
  {180,199,200},
  {201,172,129},
  {248,226,164},
  {144,168,247},
  {176,196,186},
  {247,215,160},
  {246,147,208},
  {140,243,152},
  {137,202,187},
  {252,238,171},
  {170,182,231},
  {131,151,211},
  {162,218,183},
  {199,148,228},
  {189,129,186},
  {180,198,194},
  {165,172,245},
  {174,181,184},
  {218,164,165},
  {188,153,203},
  {199,202,200},
  {237,145,153},
  {152,137,217},
  {178,184,163},
  {221,237,246},
  {223,134,156},
  {168,206,238},
  {134,202,136},
  {159,151,232},
  {251,158,213},
  {191,130,168},
  {150,159,186},
  {187,240,147},
  {145,216,242},
  {196,159,136},
  {145,155,186},
  {157,229,166},
  {196,186,150},
  {189,200,149}
};

import android.app.Activity;
import android.content.Context;
import android.os.Vibrator;

Activity act;

int border[][] = new int[100][4];
int keydata[][] =
{
  {0,1},
  {2,3},
  {4,5},
  {6,7},
  {8,9},
  {10,11},
  {12,13},
  {14,15},
  {16,17},
  {18,19},
  {20,21},
  {22,23},
  {24,25},
  {26,27},
  {28,29},
  {30,31},
  {32,33},
  {34,35},
  {36,37},
  {38,39},
  {41,42},
  {43,44},
  {45,46},
  {47,48},
  {49,50},
  {51,52},
  {53,54},
  {55,56},
  {57,58},
  {60,62},
  {63,64},
  {65,66},
  {67,68},
  {69,70},
  {71,72},
  {73,74},
  {75,76},
  {77,79},
  {80,82},
  {83,84},
  {85,94},
  {95,96},
  {97,99}
};

int p=0;

int[][] M_log = new int[1000][3];
float [][] S_log = new float[1000][2];

float wanwin = 0;

String EN_keyname[] = 
{"1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","shift","z","x","c","v","b","n","m","<-","^-^","EN","space",".","OK"};
String EN_show[] = 
{"1","2","3","4","5","6","7","8","9","0","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","","z","x","c","v","b","n","m","<-","",""," ",".",""};

float num_key_ratio = 1.4;
float all_key_ratio = 0.4;

float[][][] c_log = new float[1000][10][2];

float[][][] c = new float[43][9][2];
int[] cnum = new int[43];

int[] kw = new int[43];
int[] kh = new int[43];
int[][] ctr = new int[43][2];

int[] effect = new int[43];

void setup(){
  act = this.getActivity();
  
  smooth();
  //size(450,800);
  textAlign(CENTER,CENTER);
  strokeWeight(1);
  
  for(int i=0;i<43;i++){
    c[i][0][0] = 1;
    c[i][2][0] = -4;
    c[i][4][0] = 6;
    c[i][6][0] = -4;
    c[i][8][0] = 1;
    c[i][0][1] = 1;
    c[i][2][1] = -4;
    c[i][4][1] = 6;
    c[i][6][1] = -4;
    c[i][8][1] = 1;
    cnum[i] = 25;
  }
  
  wanwin = width/450.0;

  float key_height = height * all_key_ratio * num_key_ratio / (1 + 4 * num_key_ratio);
  float num_height = height * all_key_ratio * 1 / (1 + 4 * num_key_ratio);
  
  for(int i=0;i<5;i++){
    for(int j=0;j<20;j++){
      border[20*i+j][0] = floor(j*width/20.0);
      if(i==0) border[20*i+j][1] = floor(height*(1-all_key_ratio));
      else border[20*i+j][1] = floor(height*(1-all_key_ratio) + num_height + (i-1)*key_height);
      border[20*i+j][2] = floor((j+1)*width/20.0);
      border[20*i+j][3] = floor(height*(1-all_key_ratio) + num_height + i*key_height);
    }
  }
  
  for(int i=0;i<43;i++){
    kw[i] = border[keydata[i][1]][2]-border[keydata[i][0]][0];
    kh[i] = border[keydata[i][1]][3]-border[keydata[i][0]][1];
    ctr[i][0] = (border[keydata[i][1]][2]+border[keydata[i][0]][0])/2;
    ctr[i][1] = (border[keydata[i][1]][3]+border[keydata[i][0]][1])/2;
  }
  
  for(int i=0; i<10; i++){
    pind[i]=100; 
    pmx[i]=pmy[i]=100;
  }
}

int[] E_log = new int[100];
void RenderGraph(){
  for(int i=0;i<50;i++){
    int l = E_log[i]*width/50;
    int h = 2*height/5;
    fill(0,255,0);
    rect(width*i/50,h-l,width/50,l);
  }
}


int check(int x,int y){
  float max=0;
  int ind=-1;
  
    for(int i=0;i<43;i++){
      int tx,ty;
      tx = x-ctr[i][0];
      ty = y-ctr[i][1];
      
      if(abs(tx)>=kw[i] || abs(ty) >= kh[i]) continue;
      
      float X,Y;
      X = map(tx,-kw[i],kw[i],-0.5,0.5);
      Y = map(ty,-kh[i],kh[i],-0.5,0.5);
      
      if(max < fx(i,X)+fy(i,Y)){
        max = fx(i,X) + fy(i,Y);
        ind = i;
      }
    }
    
  return ind;
}

int[] pind = new int[10];
float[] pmx = new float[10], pmy = new float[10];

void mousePressed(){
  
    float max=0;
  int ind=-1;
  float nowx=0, nowy=0;
  
  for(int i=0;i<43;i++){
    int tx,ty;
    tx = mouseX-ctr[i][0];
    ty = mouseY-ctr[i][1];
    
    if(abs(tx)>=kw[i] || abs(ty) >= kh[i]) continue;
      
    float X,Y;
    X = map(tx,-kw[i],kw[i],-1,1);
    Y = map(ty,-kh[i],kh[i],-1,1);
      
    if(max < fx(i,X)+fy(i,Y)){
      max = fx(i,X) + fy(i,Y);
      ind = i;
      nowx = X;
      nowy = Y;
    }
  }
    
    if(ind!=-1&&mouseY>height*(1-all_key_ratio)){
      Vibrator vibrer = (Vibrator)   act.getSystemService(Context.VIBRATOR_SERVICE);
            vibrer.vibrate(3);
      
      tchd++;
      if(ind!=39) effect[ind]=10;
      else effect[39] = 2;
      
      if(ind==37 && text.length()>0){  //backspace
        if(text.length()>targ.length() || text.charAt(text.length()-1)!=targ.charAt(text.length()-1)) {
          error++;
          E_log[cnt]++;
        }
        text = text.substring(0,text.length()-1);
      }
      else if(ind==42 && text.equals(targ)) {  //ok
        text = "";
        E_update();
      }
      else if(ind==38) {  //pass
        tchd = 0;
        error -= E_log[cnt];
        E_log[cnt]=0;
        text = "";
      }
      else if(ind!=37){
        text = text + EN_show[ind];
      }
      
      if(ind == 40) p=0;
      
      if(ind != 37 && ind != 42 && ind != 38 && ind != 40){
        c_log[p][9][0] = c_log[p][9][1] = ind;
        for(int i=0;i<=8;i++){
          c_log[p][i][0] = c[ind][i][0];
          c_log[p][i][1] = c[ind][i][1];
        }
        p++;
      }
      
      if(ind == 37 && p>0) co_recover();
      else co_update(ind, nowx,nowy);
    }
    
}

void co_recover(){
  p--;
  
  int ic = (int)c_log[p][9][0];
  
  cnum[ic]--;
  
  for(int i=0;i<=8;i++){
    c[ic][i][0] = c_log[p][i][0];
    c[ic][i][1] = c_log[p][i][1];
  }
  
}

void E_update(){
 // error+=(tchd-1-targ.length())/2;
  
  cnt++;
  tchd=0;
}

float fx(int n,float x){
  return c[n][0][0] + c[n][1][0]*x + c[n][2][0]*x*x + c[n][3][0]*x*x*x + c[n][4][0]*x*x*x*x + c[n][5][0]*x*x*x*x*x + c[n][6][0]*x*x*x*x*x*x + c[n][7][0]*x*x*x*x*x*x*x + c[n][8][0]*x*x*x*x*x*x*x*x;
}
float fy(int n,float x){
  return c[n][0][1] + c[n][1][1]*x + c[n][2][1]*x*x + c[n][3][1]*x*x*x + c[n][4][1]*x*x*x*x + c[n][5][1]*x*x*x*x*x + c[n][6][1]*x*x*x*x*x*x + c[n][7][1]*x*x*x*x*x*x*x + c[n][8][1]*x*x*x*x*x*x*x*x;
}

float p(float t,int n){
  float ans = 1;
  for(int i=0;i<n;i++) ans*=t;
  return ans;
}


void co_update(int n, float X, float Y){
  
  for(int j=0;j<=8;j++){
    c[n][j][0]*=cnum[n];
    c[n][j][1]*=cnum[n];
  }
  
  c[n][0][0] += p(X,8) - 4*p(X,6) + 6*p(X,4) - 4*p(X,2) + 1;
  c[n][1][0] += - 8*p(X,7) + 24*p(X,5) - 24*p(X,3) + 8*X;
  c[n][2][0] += 28*p(X,6) - 60*p(X,4) + 36*p(X,2) - 4;
  c[n][3][0] += -56*p(X,5) + 80*p(X,3) - 24*X;
  c[n][4][0] += 70*p(X,4) - 60*p(X,2) + 6;
  c[n][5][0] += -56*p(X,3) + 24*X;
  c[n][6][0] += 28*p(X,2) - 4;
  c[n][7][0] += -8*X;
  c[n][8][0] += 1;
    
  c[n][0][1] += p(Y,8) - 4*p(Y,6) + 6*p(Y,4) - 4*p(Y,2) + 1;
  c[n][1][1] += - 8*p(Y,7) + 24*p(Y,5) - 24*p(Y,3) + 8*Y;
  c[n][2][1] += 28*p(Y,6) - 60*p(Y,4) + 36*p(Y,2) - 4;
  c[n][3][1] += -56*p(Y,5) + 80*p(Y,3) - 24*Y;
  c[n][4][1] += 70*p(Y,4) - 60*p(Y,2) + 6;
  c[n][5][1] += -56*p(Y,3) + 24*Y;
  c[n][6][1] += 28*p(Y,2) - 4;
  c[n][7][1] += -8*Y;
  c[n][8][1] += 1;
  
  cnum[n]++;
  
  for(int j=0;j<=8;j++){
    c[n][j][0]/=(float)cnum[n];
    c[n][j][1]/=(float)cnum[n];
  }
}

int[][][] pM = new int[10][43][2];
int[][] pS = new int[10][43];

void RenderKey(){
  
  textSize(25*wanwin);
  
  for(int i=0;i<43;i++){
    if(effect[i]==0||i==39) noFill();
    else fill(204);
    
    rect(border[keydata[i][0]][0], border[keydata[i][0]][1], border[keydata[i][1]][2]-border[keydata[i][0]][0], border[keydata[i][1]][3]-border[keydata[i][0]][1]);
    fill(0);
    text(EN_keyname[i],(border[keydata[i][0]][0]+border[keydata[i][1]][2])/2, (border[keydata[i][0]][1]+border[keydata[i][1]][3])/2);
  }
}

void Text(){
  fill(0);
  textSize(18*wanwin);
  textAlign(LEFT,LEFT);
  text("\n [ Liquiboard preset 2 ]\n\n"+"  "+targ+"\n  "+text,0,0,width,height*(1-all_key_ratio));
  textAlign(CENTER,CENTER);
}

int cnt = 0;
int error = 0;
int tchd = 0;

String text = "";
String targ = "the quick brown fox jumps over the lazy dog.";

void draw(){
  background(255);
  
  text("Typo rate : " + str((float)error/(targ.length()*cnt)) + "\nTry : " + str(cnt) + "\n(" + str(error) +"/" + str(cnt*targ.length()) + ")", width/2, height/2);
  
  noStroke();
  
  if(effect[39]>0)
  for(int i=(int)(height*(1-all_key_ratio));i<height;i++){
    for(int j=0;j<width;j++){
      int k = check(j,i);
      if(k==-1) continue;
      fill(Color[k][0],Color[k][1],Color[k][2]);
      rect(j,i,1,1);
    }
  }

  stroke(0);
  
  RenderKey();
  RenderGraph();
  Text();
  for(int i=0;i<43;i++) if(effect[i]>0) effect[i]--;
  
  //if(cnt>0) println((float)error/(targ.length()*cnt));
  //println(error);
}
