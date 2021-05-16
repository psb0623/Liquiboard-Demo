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

int[][] M = new int[43][2];
float[] S = new float[43];
int [] msnum = new int[43];

int[] effect = new int[43];

void setup(){
  act = this.getActivity();
  
  smooth();
  //size(450,800);
  textAlign(CENTER,CENTER);
  strokeWeight(1);
  
  for(int i=0;i<43;i++) msnum[i] = 25;
  
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
    M[i][0] = (border[keydata[i][1]][2]+border[keydata[i][0]][0])/2;
    M[i][1] = (border[keydata[i][1]][3]+border[keydata[i][0]][1])/2;
    S[i] = width/20;
    if(i==40) S[i] = width/15;
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
    float r = dist(x,y,M[i][0],M[i][1]);  
    if(max < S[i]/r) {
      max = S[i]/r;
      ind = i;
    }
  }
    
  return ind;
}

int[] pind = new int[10];
float[] pmx = new float[10], pmy = new float[10];

void mousePressed(){
   int ind=-1;
   for(int i=0;i<43;i++) if(border[keydata[i][0]][0]<mouseX&&mouseX<border[keydata[i][1]][2]&&border[keydata[i][0]][1]<mouseY&&mouseY<border[keydata[i][1]][3]) ind = i;
    
    if(ind!=-1&&mouseY>height*(1-all_key_ratio)){
      Vibrator vibrer = (Vibrator)   act.getSystemService(Context.VIBRATOR_SERVICE);
            vibrer.vibrate(3);
      
      tchd++;
      effect[ind]=10;
      
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
    }
    
}

void ms_recover(){
  p--;
  
  int im = M_log[p][0];
  int is = (int)S_log[p][0];
  msnum[im]--;
  M[im][0] = M_log[p][1];
  M[im][1] = M_log[p][2];
  S[is] = S_log[p][1];
}

void E_update(){
 // error+=(tchd-1-targ.length())/2;
  
  cnt++;
  tchd=0;
}

void ms_update(int n, float x, float y){
  
  S[n] = S[n]*S[n];
  S[n] *= msnum[n];
  S[n] += (x-M[n][0])*(x-M[n][0]) + (y-M[n][1])*(y-M[n][1]);
  
  M[n][0] *= msnum[n];
  M[n][0] += x;
  M[n][1] *= msnum[n];
  M[n][1] += y;
      
  msnum[n]++;
  
  S[n] /= msnum[n];
  S[n] = sqrt(S[n]);
  
  M[n][0] /= msnum[n];
  M[n][1] /= msnum[n];
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
  text("\n [ Standard Keyboard ]\n\n"+"  "+targ+"\n  "+text,0,0,width,height*(1-all_key_ratio));
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
  
  stroke(0);
  
  RenderKey();
  RenderGraph();
  Text();
  for(int i=0;i<43;i++) if(effect[i]>0) effect[i]--;
  
  //if(cnt>0) println((float)error/(targ.length()*cnt));
  //println(error);
}
