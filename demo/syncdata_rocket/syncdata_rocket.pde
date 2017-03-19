import moonlander.library.*;
import ddf.minim.*;
  

//rgb for 
Moonlander moonlander;
//PGraphics pg;
int ptsW, ptsH;



int numPointsW;
int numPointsH_2pi; 
int numPointsH;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;

PImage bg;
PImage[] textures = new PImage[8];
PShape planet;
PShape meteor;
PImage img2;
int num = 6;  
int r = 150;
int width = 1280;
int height = 720;
int parAmount = 10;
PShape rocket;
PShape sun_, earth_, mars_;
float ry;

void setup() {
  
  textures[0] =loadImage("earth.jpg");
  textures[1] =loadImage("mars.jpg");
  textures[2] =loadImage("jupiter.jpg");
  textures[3] =loadImage("saturn.jpg");
  textures[4] =loadImage("uranus.jpg");
  textures[5] =loadImage("neptune.jpg");
  textures[6] =loadImage("pluto.jpg");
  textures[7] = loadImage("moon.jpg");
  img2 = loadImage("image_2.jpg");
  moonlander = Moonlander.initWithSoundtrack(this, "random.mp3", 120, 4);
  size(1280, 720, P3D);
  rocket = loadShape("rocket.obj");
  moonlander.start();
  bg = loadImage("image.jpg");
  
  //frustum(-10, 0, 0, 10, 10, 200);
  
  // Automatically texturedsdas the shape with the image
}

void draw() {
  
  
  moonlander.update();
  double value = moonlander.getValue("my_track");
  if(value > 254.0) {
    background(img2);
    exit();
  } else if(value > 228) {
    background(img2);
  } else {
   background(bg);
  }
  noStroke();
  
  ptsW=60;
  ptsH=60;
  
camera(width/2, height/2 -300 , -400*(float)value + 200, width/2, height/2 -300, -401*(float)value + 200, 0, 1, 0);
perspective(PI/3.0,(float)width/height,1,15000);
  directionalLight(241, 250, 180, 1, 1, -1);
  
  pushMatrix();
  if(value < 230) {
  translate(width/2, height/2, -400*(float)value - 900);
  } else {
    perspective(PI/3.0,(float)width/height,1,100000);
  translate(width/2, height/2, -400*(float)value - 900*pow(2, (float)value - 230));
  }

  //rotateZ(PI);
  rotateZ((float)value);
  rotateX(-PI/2);
  shape(rocket);
  popMatrix();
  initializeSphere(ptsW, ptsH);
  
  ry += 0.02;
  
  translate(width/2 - 500, height/2+100, -5000*0 -5000);
  textureSphere(300, 300, 300, textures[0]);
  
  translate(-600, -1000, 10000);
  textureSphere(500, 500, 500, textures[1]);
  
  translate(-2000, -3000, -10000);
  textureSphere(4000, 4000, 4000, textures[2]);


  translate(2000, 2000, 20000);
  textureSphere(4000, 4000, 4000, textures[3]);
  
  
  translate(5000, 2000, -10000);
  textureSphere(500, 500, 500, textures[4]);
  
  translate(1000, 2000, 40000);
  textureSphere(500, 500, 500, textures[5]);
  
  translate(0, 2000, 40000);
  textureSphere(800, 800, 800, textures[5]);
  
  translate(1000, 0, 40000);
  textureSphere(500, 500, 500, textures[5]);
  
  translate(3000, -2000, 40000);
  textureSphere(400, 400, 400, textures[5]);
  
  translate(2000, 2000, -10000);
  textureSphere(200, 200, 200, textures[6]);
  


      
     
  
  
  //translate(width/1.5, height/1.5, -500);

  noStroke();
  

 // translate(width/4, height/4, 0);
  
}

void initializeSphere(int numPtsW, int numPtsH_2pi) {

  // The number of points around the width and height
  numPointsW=numPtsW+1;
  numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
  numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW ;i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }
  
  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=0;
    } 
    else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=sin(thetaH);
    }
  }
}

void textureSphere(float rx, float ry, float rz, PImage t) { 
  // These are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture

  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
      normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
      vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
      vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  this.rotateY(PI);
  endShape();
  
}