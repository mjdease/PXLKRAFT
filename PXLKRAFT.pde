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

float invWidth, invHeight;    // inverse of screen dimensions

//explicitly set framerate;
float myFrameRate = 60.0;

void setup()
{
  size(1024, 768, OPENGL);
  colorMode(RGB);
  background(0);
  //smooth();
  frameRate(myFrameRate);
    
  //instantiate colliders
  for(int i=0; i<colliderCount; i++)
  {
    colliders[i] = new Collider(new PVector(random(1024), random(468)+300), 70, #666666, true);
  }
  //instantiate emitters
  //inf:Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //non:Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  emitters[0] = new Emitter(new PVector(mouseX, mouseY), myFrameRate, new PVector(0,20), 1, 'p', 500, 10000);
  emitters[1] = new Emitter(new PVector(0, 0), myFrameRate, new PVector(0,0), 2, 'a', 600, 7000);

  //instantiate Environment
  //Environment(float gravity, float friction, PVector wind, float resistance, float turbulence)
  environment = new Environment(0.09, 0.785, new PVector(0,0), 0.995, 0.01);

  //instantiate engine
  engine = new Engine(emitters, colliders, environment);

  invWidth = 1.0f/width;
  invHeight = 1.0f/height;
  //set boundary collisions
  boolean[] bounds = {true, true, true, true};
  engine.setBoundaryCollision(true, bounds);

}
void draw()
{
  //background(0, 255);
  if(mouseX != pmouseX || mouseY != pmouseY);
  {
    float mouseNormX = mouseX * invWidth;
    float mouseNormY = mouseY * invHeight;
    float mouseVelX = (mouseX - pmouseX) * invWidth;
    float mouseVelY = (mouseY - pmouseY) * invHeight;

    engine.addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY);
  }
  trail.set(pmouseX-mouseX, pmouseY-mouseY, 0);
  trail.normalize();
  trail.mult(-2);
  emitters[0].setBirthPath(trail);
  wand1.set(mouseX, mouseY, 0);
  emitters[0].setLoc(wand1);
  //wand2.set(mouseX + 100, mouseY, 0);
  emitters[1].setLoc(wand2);
  engine.run();
  //println(frameRate);
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
