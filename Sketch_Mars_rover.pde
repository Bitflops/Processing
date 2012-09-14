import processing.opengl.*;

// Sphere Variables
float R = 250;
int xDetail = 40;
int yDetail = 30;
float[] xGrid = new float[xDetail+1];
float[] yGrid = new float[yDetail+1];
float[][][] allPoints = new float[xDetail+1][yDetail+1][3];

// Rotation Variables
float camDistance = -50;
float rotationX = 100;
float rotationY = 170;
float velocityX = 0;
float velocityY = 0;

// Object Varialbles
//Curiosity
float degLat = -5.4;  // in degrees -5.4
float degLong = 137.8; // in degrees 137.8

float xObj = R*cos(radians(degLat))*cos(radians(degLong));
float yObj = R*cos(radians(degLat))*sin(radians(degLong));
float zObj = R*sin(radians(-degLat));

//Opportunity
float degLatB = -2.172;  // in degrees 1.95 South
float degLongB = 54.445; // in degrees 354.47 East

float xObjB = R*cos(radians(degLatB))*cos(radians(degLongB));
float yObjB = R*cos(radians(degLatB))*sin(radians(degLongB));
float zObjB = R*sin(radians(-degLatB));

//Spirit
float degLatC = -14.6;  // in degrees 14.6 South
float degLongC = 175.4; // in degrees 175.4 East

float xObjC = R*cos(radians(degLatC))*cos(radians(degLongC));
float yObjC = R*cos(radians(degLatC))*sin(radians(degLongC));
float zObjC = R*sin(radians(-degLatC));

//Sojourner
float degLatD = 19.13;  // in degrees 19.30 North
float degLongD = -33.22; // in degrees 33.52 West

float xObjD = R*cos(radians(degLatD))*cos(radians(degLongD));
float yObjD = R*cos(radians(degLatD))*sin(radians(degLongD));
float zObjD = R*sin(radians(-degLatD));

String filename = "texture1.jpg";
int i = 0;


// Texture
PImage texmap;

////////////////////////////////////////////////////////////////////////
void setup(){

  size(700, 700, OPENGL);
  noStroke();
  smooth();
  
  PFont font;
  font = loadFont("CordiaNew-24.vlw");
  textFont(font);
  textMode(SCREEN);
  
  texmap = loadImage(filename);
 
  setupSphere(R, xDetail, yDetail);

}
////////////////////////////////////////////////////////////////////////

void draw(){
  
  background(0);
  lights();
  translate(width/2.0, height/2.0, camDistance);
  rotateX( radians(-rotationX) );  
  rotateZ( radians(270 - rotationY) );

  drawSphere(texmap);

  // Implements mouse control (interaction will be inverse when sphere is  upside down)
  rotationX += velocityX;
  rotationY += velocityY;
  velocityX *= 0.95;
  velocityY *= 0.95;
  if(mousePressed){
    velocityX += (mouseY-pmouseY) * 0.01;
    velocityY -= (mouseX-pmouseX) * 0.01;
  }
fill(255,255,255);
text("Curiosity",10,700-70);
text("Lat:"+degLat+char(176)+" Long:"+degLong+char(176),100,700-70);
fill(238,44,44);
text("Opportunity",10,700-50);
text("Lat:"+degLatB+char(176)+" Long:"+degLongB+char(176),100,700-50);
fill(0,178,238);
text("Spirit",10,700-30);
text("Lat:"+degLatC+char(176)+" Long:"+degLongC+char(176),100,700-30);
fill(60,179,113);
text("Sojourner",10,700-10);
text("Lat:"+degLatD+char(176)+" Long:"+degLongD+char(176),100,700-10);
fill(255,255,255);

//Texture choice
text("Change texture with keys 1 to 4",10,20);



//text("xCoord: "+xObj,10,700-50);
//text("yCoord: "+yObj,10,700-30);
//text("zCoord: "+zObj,10,700-10);


}

////////////////////////////////////////////////////////////////////////
void setupSphere(float R, int xDetail, int yDetail){

  // Create a 2D grid of standardized mercator coordinates
  for(int i = 0; i <= xDetail; i++){
    xGrid[i]= i / (float) xDetail;
  } 
  for(int i = 0; i <= yDetail; i++){
    yGrid[i]= i / (float) yDetail;
  }

  textureMode(NORMALIZED);

  // Transform the 2D grid into a grid of points on the sphere, using the inverse mercator projection
  for(int i = 0; i <= xDetail; i++){
    for(int j = 0; j <= yDetail; j++){
      allPoints[i][j] = mercatorPoint(R, xGrid[i], yGrid[j]);
    }
  }
}

////////////////////////////////////////////////////////////////////////
float[] mercatorPoint(float R, float x, float y){

  float[] thisPoint = new float[3];
  float phi = x*2*PI;
  float theta = PI - y*PI;

  thisPoint[0] = R*sin(theta)*cos(phi);
  thisPoint[1] = R*sin(theta)*sin(phi);
  thisPoint[2] = R*cos(theta);

  return thisPoint;
}

////////////////////////////////////////////////////////////////////////
void drawSphere(PImage Map){

  for(int j = 0; j < yDetail; j++){
    beginShape(TRIANGLE_STRIP);
    texture(Map);
    for(int i = 0; i <= xDetail; i++){
      vertex(allPoints[i][j+1][0],   allPoints[i][j+1][1],   allPoints[i][j+1][2],   xGrid[i],   yGrid[j+1]);
      vertex(allPoints[i][j][0],     allPoints[i][j][1],     allPoints[i][j][2],     xGrid[i],   yGrid[j]);
    }
    endShape(CLOSE);
  }
 
  stroke(0,0,0);        // Reference Equator Ellipse
  noFill();
  rectMode(CENTER);
  ellipse(0,0,500,500);
  noStroke();
  
  fill(250,250,250);    // Position of object on surface
  translate(-xObj,-yObj,zObj);
  sphere(2); 
  translate(xObj,yObj,-zObj);
  fill(238,44,44);    // Position of object on surface
  translate(-xObjB,-yObjB,zObjB);
  sphere(2); 
  translate(xObjB,yObjB,-zObjB);
  fill(0,178,238);    // Position of object on surface
  translate(-xObjC,-yObjC,zObjC);
  sphere(2); 
  translate(xObjC,yObjC,-zObjC);
  fill(60,179,113);    // Position of object on surface
  translate(-xObjD,-yObjD,zObjD);
  sphere(2);
}
  
void keyPressed(){
  if (keyCode >= 53){ 
  return;
  }
  StringBuilder keyNbr = new StringBuilder();
  keyNbr.append("texture");
  keyNbr.append(char(keyCode));   
  keyNbr.append(".jpg");
  filename = keyNbr.toString();
  texmap = loadImage(filename);  
}
 
