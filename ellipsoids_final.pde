Ellipsoid ellA0, ellAx, ellAy, ellAmx, ellAmy, ellAxy, ellAxmy, ellAmxy, ellAmxmy;
Ellipsoid ellB0, ellBx, ellBy, ellBmx, ellBmy, ellBxy, ellBxmy, ellBmxy, ellBmxmy;
float redFactor=0.05;
float errinho=0.05;

float angleXnorm2PI, angleXnorm2theta, angleX;
int Nx2PI, Nx2theta;

float angleYnorm2PI, angleYnorm2theta, angleY;
int Ny2PI, Ny2theta;

float S=1.0, C=1.0, n=0.0;
float Srelax=1.0;

float theta=0.05;
int P=95, AB=0;

boolean AA=true;

String phase="Crystal AA";

import controlP5.*;
ControlP5 cp5;


void setup()
{
  size(800, 600, P3D);
  noStroke();
  fill(150, 195, 125);
 
  ellA0 = new Ellipsoid(0, 0, 0);
  ellAx = new Ellipsoid(P*2*cos(PI/3), 0, 0);
  ellAy = new Ellipsoid(-P*3*cos(PI/3), P*sin(PI/3), 0);
  ellAmx = new Ellipsoid(-P*2*cos(PI/3), 0, 0);
  ellAmy = new Ellipsoid(P*3*cos(PI/3), -P*sin(PI/3), 0);
  ellAxy = new Ellipsoid(P*cos(PI/3), P*sin(PI/3), 0);
  ellAxmy = new Ellipsoid(P*cos(PI/3), -P*sin(PI/3), 0);
  ellAmxy = new Ellipsoid(-P*cos(PI/3), P*sin(PI/3), 0);
  ellAmxmy = new Ellipsoid(-P*cos(PI/3), -P*sin(PI/3), 0);
  
  ellB0 = new Ellipsoid(0, 0, 1);
  ellBx = new Ellipsoid(P*2*cos(PI/3), 0, 1);
  ellBy = new Ellipsoid(-P*3*cos(PI/3), P*sin(PI/3), 1);
  ellBmx = new Ellipsoid(-P*2*cos(PI/3), 0, 1);
  ellBmy = new Ellipsoid(P*3*cos(PI/3), -P*sin(PI/3), 1);
  ellBxy = new Ellipsoid(P*cos(PI/3), P*sin(PI/3), 1);
  ellBxmy = new Ellipsoid(P*cos(PI/3), -P*sin(PI/3), 1);
  ellBmxy = new Ellipsoid(-P*cos(PI/3), P*sin(PI/3), 1);
  ellBmxmy = new Ellipsoid(-P*cos(PI/3), -P*sin(PI/3), 1);
  
  cp5 = new ControlP5(this);
    
  cp5.addSlider("S")
     .setPosition(50,65)
     .setRange(0,1)
     ;
  
  cp5.addSlider("C")
     .setPosition(50,50)
     .setRange(0,1)
     ;
     
  cp5.addSlider("n")
     .setPosition(50,79)
     .setRange(0,30)
     ;   
   
  cp5.addToggle("AA")   
     .setPosition(180,50)
     .setSize(50,25)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
}

void draw()
{
  
  if(AA==true) AB=0;
  else AB=1;
  
  if(C<0.75)
  {
    if(S<0.75) phase="Isotropic"; 
    else phase="Nematic";
  }
  else if(C<0.85)
  {
    if(n<10) phase="Smectic A";  
    else phase="Smectic C";
    
    if(S<0.75) cp5.getController("S").setValue(C);
  }
  else if(C<0.95)
  {
    phase="Smectic B"; 
    
    if(S<0.85) cp5.getController("S").setValue(C);
  }
  else
  {
    if(AA==true) phase="Crystal AA";
    else phase="Crystal AB";
    
    if(S<0.95) cp5.getController("S").setValue(C);
  }
  
  
  hint(ENABLE_DEPTH_TEST);
  pushMatrix();
  
  background(50, 64, 42);
  lights();
  
  camera(width*cos(PI*mouseX/width), width*cos(PI*mouseY/height), width*sin(PI*mouseX/width)*sin(PI*mouseY/height), 0.0, 0.0, 0.0, 0, 1, 0);

  theta=acos(sqrt(0.666*S+0.333));

  ellA0.display();
  ellAx.display();
  ellAy.display();
  ellAmx.display();
  ellAmy.display();
  ellAxy.display();
  ellAxmy.display();
  ellAmxy.display();
  ellAmxmy.display();

  ellB0.display();
  ellBx.display();
  ellBy.display();
  ellBmx.display();
  ellBmy.display();
  ellBxy.display();
  ellBxmy.display();
  ellBmxy.display();
  ellBmxmy.display();
  
  popMatrix();
  hint(DISABLE_DEPTH_TEST);
  
  textSize(32);
  text(phase, 50, 550); 
  
}

class Ellipsoid
{
  float X;
  float Y;
  float Z;
  int B; 
  float Vx;
  float Vy;
  float Vz;
  float Xiso;
  float Yiso;
  float Ziso;
  int pts;
  PVector vertices[];
  PVector vertices2[];
  float angle;
  float radius;
  int segments;
  float latheAngle;
  float plusABx;
  float plusABy;
   
  Ellipsoid(float tempX, float tempY, int tempZ)
  {
    X = tempX;
    Y = tempY;
    Z = (1-2*(float)tempZ)*P;
    B = tempZ;
    Vx = random(0.1,1.0)*redFactor;
    Vy = random(0.1,1.0)*redFactor;
    Vz = random(0.1,0.5)*redFactor;
    Xiso = random(0.1,1.0)*tempX;
    Yiso = random(0.1,1.5)*tempY;
    Ziso = random(-0.25,1.0)*Z;
    pts = 300;
    vertices = new PVector[pts+1];
    vertices2 = new PVector[pts+1];
    angle = 0;
    radius = 30.0;   
    segments = 50;
    latheAngle = 0;
    plusABx = 0;
    plusABy = 0;
    
    for(int i=0; i<=pts; i++)
    {
      vertices[i] = new PVector();
      vertices2[i] = new PVector();
      vertices[i].x = sin(radians(angle))*radius;
      vertices[i].z = cos(radians(angle))*radius;
      angle+=360.0/pts;
    }
  }
  
  void display() 
  {
    plusABx = B*P*cos(PI/3)*AB;
    plusABy = B*P*sin(PI/3)*0.5*AB;
    
    translate(X+plusABx, Y+plusABy, Z);
    translate(Xiso*(1-C),Yiso*(1-C),Ziso*(1-C));

    angleX=theta*cos(frameCount*Vx);

    angleY=theta*cos(frameCount*Vy);
    
    //rotateX(-0.5*theta);
    //rotateY(-0.5*theta);

    rotateX(angleX);
    rotateY(angleY);
    rotateZ(frameCount*Vz*(1-C)*(1-S));
    
    rotateX(n*PI/180);
    
    for(int i=0; i<=segments; i++)
    {
      beginShape(QUAD_STRIP);
      for(int j=0; j<=pts; j++)
      {
        if (i>0) vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);

        vertices2[j].z = 3*cos(radians(latheAngle))*vertices[j].x;
        vertices2[j].y = sin(radians(latheAngle))*vertices[j].x;
        vertices2[j].x = vertices[j].z;
        vertex(vertices2[j].x, vertices2[j].y, vertices2[j].z);
      }
      latheAngle+=360.0/segments;
      endShape();
    }
    
    rotateX(-n*PI/180);
    
    rotateZ(-frameCount*Vz*(1-C)*(1-S));
    rotateY(-angleY);
    rotateX(-angleX);
    
    //rotateY(0.5*theta);
    //rotateX(0.5*theta);
    
    translate(-Xiso*(1-C),-Yiso*(1-C),-Ziso*(1-C));
    translate(-X-plusABx, -Y-plusABy, -Z);
    
    
  }
  
}