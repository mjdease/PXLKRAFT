import msafluid.*;

import processing.opengl.*;

/**
 ------IMD2900 Interactive Video System------
 --------------------By:---------------------
 -Matt Dease--Kyle Thompson--Graeme Rombough-
 ---------Paul Young--Sunmock Yang-----------
 */

PVector wand1 = new PVector(0,0);
PVector trail = new PVector(0,0);
PVector wand2 = new PVector(0,0);

//instantiate collider arrays
int colliderCount = 3;
Collider[] colliders = new Collider[colliderCount];
//instantiate emitter arrays
int emitterCount = 2;
Emitter[] emitters = new Emitter[emitterCount];
//declare rest of globals
Environment environment;
Engine engine;

//explicitly set framerate;
float myFrameRate = 60.0;
MSAFluidSolver2D fluidSolver;
final float FLUID_WIDTH = 120;
PImage imgFluid;
float invWidth, invHeight;    // inverse of screen dimensions
float aspectRatio, aspectRatio2;
boolean drawFluid = true;

void setup()
{
  size(1024, 768, OPENGL);
  background(0);
  //smooth();
  frameRate(myFrameRate);

  fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
  fluidSolver.enableRGB(true).setFadeSpeed(0.006).setDeltaT(0.9).setVisc(0.00005).setSolverIterations(5);

  // create image to hold fluid picture
  imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
    
  //instantiate colliders
  for(int i=0; i<colliderCount; i++)
  {
    colliders[i] = new Collider(new PVector(random(1024), random(468)+300), 70, #666666, true);
  }
  //instantiate emitters
  //inf:Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //non:Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  emitters[0] = new Emitter(new PVector(mouseX, mouseY), myFrameRate, new PVector(0,0), 2, 'p', 1000, 5000);
  emitters[1] = new Emitter(new PVector(0, 0), myFrameRate, new PVector(0,0), 2, 'a', 600, 7000);

  //instantiate Environment
  //Environment(float gravity, float friction, PVector wind, float resistance, float turbulence)
  environment = new Environment(0.09, 0.785, new PVector(0,0), 0.995, 0.01);

  //instantiate engine
  engine = new Engine(emitters, colliders, environment);

  //set boundary collisions
  boolean[] bounds = {
    true, true, true, false
  };
  engine.setBoundaryCollision(true, bounds);

  invWidth = 1.0f/width;
  invHeight = 1.0f/height;
  aspectRatio = width * invHeight;
  aspectRatio2 = aspectRatio * aspectRatio;

}
void draw()
{
  //background(0, 255);
  fluidSolver.update();
  if(drawFluid) {
    for(int i=0; i<fluidSolver.getNumCells(); i++) {
        int d = 2;
        imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
    }  
    imgFluid.updatePixels();//  fastblur(imgFluid, 2);
    image(imgFluid, 0, 0, width, height);
  } 
  trail.set(pmouseX-mouseX, pmouseY-mouseY, 0);
  trail.normalize();
  trail.mult(6);
  emitters[0].setBirthPath(trail);
  wand1.set(mouseX, mouseY, 0);
  emitters[0].setLoc(wand1);
  //wand2.set(mouseX + 100, mouseY, 0);
  emitters[1].setLoc(wand2);
  engine.run();
  //println(frameRate);
}
void mousePressed() {
    drawFluid ^= true;
}

void mouseMoved() {
    float mouseNormX = mouseX * invWidth;
    float mouseNormY = mouseY * invHeight;
    float mouseVelX = (mouseX - pmouseX) * invWidth;
    float mouseVelY = (mouseY - pmouseY) * invHeight;

    addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY);
}
void keyPressed() 
{
  if (key == CODED) {
    if (keyCode == UP) {
      wand2.y-=10;
    } 
    if (keyCode == DOWN) {
      wand2.y+=10;
    }
    if (keyCode == LEFT) {
      wand2.x-=10;
    }
    if (keyCode == RIGHT) {
      wand2.x+=10;
    }
  }
  else
  {
    if(key == 'o')
    {
      if(emitters[0].isOn)
        emitters[0].isOn = false;
      else
        emitters[0].isOn = true;
    }
    if(key == 'p')
    {
      if(emitters[1].isOn)
        emitters[1].isOn = false;
      else
        emitters[1].isOn = true;
    }
  }
}
void addForce(float x, float y, float dx, float dy) {
    float speed = dx * dx  + dy * dy * aspectRatio2;    // balance the x and y components of speed with the screen aspect ratio

    if(speed > 0) {
        if(x<0) x = 0; 
        else if(x>1) x = 1;
        if(y<0) y = 0; 
        else if(y>1) y = 1;

        float colorMult = 5;
        float velocityMult = 30.0f;

        int index = fluidSolver.getIndexForNormalizedPosition(x, y);

        color drawColor;

        colorMode(HSB, 360, 1, 1);
        float hue = ((x + y) * 180 + frameCount) % 360;
        drawColor = color(hue, 1, 1);
        colorMode(RGB, 1);  

        fluidSolver.rOld[index]  += red(drawColor) * colorMult;
        fluidSolver.gOld[index]  += green(drawColor) * colorMult;
        fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

        fluidSolver.uOld[index] += dx * velocityMult;
        fluidSolver.vOld[index] += dy * velocityMult;
    }
}
