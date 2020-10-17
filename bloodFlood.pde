PImage img;
PImage backImg;
int n = 50;
int N;
float damp = 0.1;
float g = 2000;
float dx = 400.0/n;
float dt = 0.0005;

float h[];
float hu[];

void setup()
{
  size(400,300,P3D);
  textureMode(NORMAL);
  img = loadImage("bloodTexture.png");
  backImg = loadImage("darkRedMoonTheme.jpg");
  n = 50;
  N = n+2;
  h = new float[N];
  hu = new float[N];
  float val = 10;
  for(int i=0;i<n;i++)
  {
    
    if(i < n/2){
      h[i+1] = val;
      hu[i+1] = val;
    }
    else{
      val += 0.5;
      h[i+1] = val;
      hu[i+1] = val;
    }
  }
}


void update(float dt)
{
  
  h[0] = h[1]; //free boundary
  h[N-1] = h[n];
  hu[0] = -hu[1];
  hu[N-1] = -hu[n];
  
  float[] h_mid = new float[N];
  float[] hu_mid = new float[N];
  
  for(int i=0;i<N-1;i++)
  {
    h_mid[i] = (h[i+1] + h[i])/2;
    hu_mid[i] = (hu[i+1] + hu[i])/2;
  }
  
  for(int i=0;i<N-1;i++)
  {
    float dhudx_mid = (hu[i+1] - hu[i])/dx;
    
    float dhu2dx_mid = (sq(hu[i+1])/h[i+1] - sq(hu[i])/h[i])/dx;
    
    float dgh2dx_mid = g*(sq(h[i+1]) - sq(h[i]))/dx;
    
    float dhdt_mid = -dhudx_mid;
    
    float dhudt_mid = -(dhu2dx_mid + 0.5*dgh2dx_mid);
    
    h_mid[i] += dhdt_mid*(dt/2);
    hu_mid[i] += dhudt_mid*(dt/2);
  }
  
  for(int i=0;i<N-2;i++)
  {
    float dhudx = (hu_mid[i+1] - hu_mid[i])/dx;
    
    float dhu2dx = (sq(hu_mid[i+1])/h_mid[i+1] - sq(hu_mid[i])/h_mid[i])/dx;
    
    float dgh2dx = g*(sq(h_mid[i+1]) - sq(h_mid[i]));
    
    float dhdt = -dhudx;
    
    float dhudt = -(dhu2dx + 0.5*dgh2dx);
    
    h[i+1] += damp*dhdt*dt;
    hu[i+1] += damp*dhudt*dt;
  }
}
void draw()
{
  
  background(backImg);
  for(int i=0;i<50;i++){
    update(dt);
  }
  translate(0, 300);
  //fill(0, 120, 200);
  noStroke();
  
  for(int i=0;i<n;i++)
  {
    int ht = int(h[i+1]*5);
    beginShape();
    texture(img);
    vertex(i*dx, 0, 0, 0, 1);
    vertex(i*dx + dx, 0, 0, 1, 1);
    vertex(i*dx + dx, -ht, 0, 0, 0);
    vertex(i*dx, -ht, 0, 1, 0);
    endShape();
    //rect(i*13, -ht, 12, ht, 4, 4, 0, 0);
  }
}
