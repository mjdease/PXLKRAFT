import org.gicentre.utils.geom.*;
import msafluid.*;
import processing.opengl.*;

/**
 -----------------PXLKRAFT-------------------
 ------IMD2900 Interactive Video System------
 --------------------By:---------------------
 -Matt Dease--Kyle Thompson--Graeme Rombough-
 ---------Paul Young--Sunmock Yang-----------
 */

PVector wand1 = new PVector(0,0);
PVector force1 = new PVector(0,0);
PVector wand2 = new PVector(0,0);
PVector force2 = new PVector(0,0);

/*particle Types:
  p - base particle
  a - arrow (don't use)
  
  w - water
  o - oil
  s - seeds
  f - fire
  c - concrete
  i - ice
  k - fireworks
  l - plants
*/
char w1Type = 'w';
char w2Type = 'p';

boolean wandIsInput = false;
char page = 'v'; //v=visualization, c=calibration, m=music, u=mainmenu

int emitterCount = 2;
Emitter[] emitters = new Emitter[emitterCount];
int environmentCount = 2;
Environment[] environments = new Environment[environmentCount];
Engine engine;

//fluids
float invWidth, invHeight;
float cursorNormX, cursorNormY, cursorVelX, cursorVelY;

//tracking
Glob glob;
Thread wrapper;

float myFrameRate = 60.0;

PVector tempVector;

void setup()
{
  size(1024, 768, OPENGL);
  colorMode(RGB);
  background(0);
  frameRate(myFrameRate);
  rectMode(CENTER);
  
  
  //box2d = new PBox2D(this);
  //box2d.createWorld();
    
  //tracking thread
 // glob = new Glob(width, height, this);
  //glob.start();
  //glob.start();
  //wrapper = new Thread(glob);
  //wrapper.start();

  //instantiate emitters
  //Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, char type, int maxParticles, int lifeSpan, int envIndex)
  emitters[0] = new Emitter(new PVector(mouseX, mouseY), myFrameRate, new PVector(0,20), 1, w1Type, 100, 10000, 0);
  emitters[1] = new Emitter(new PVector(0, 0), myFrameRate, new PVector(0,0), 2, w2Type, 600, 7000, 1);

  //instantiate Environments
  //Environment(float gravity, float friction, PVector wind, float resistance, float turbulence)
  environments[0] = new Environment(0.09, 0.785, new PVector(0,0), 0.995, 0);
  environments[1] = new Environment(-0.09, 0.5, new PVector(0.05,0), 0.995, 0.04);

  //instantiate engine
  engine = new Engine(emitters, environments);

  //for fluids
  invWidth = 1.0f/width;
  invHeight = 1.0f/height;
  
  //set boundary collisions
  boolean[] bounds = {true, true, true, true};
  engine.setBoundaryCollision(true, bounds);
  

}
void draw()
{
  if(!wandIsInput)
    readMouse();
  else
    readWands();
  
  force1.normalize();
  force1.mult(-3);
  emitters[0].setBirthPath(force1);
  emitters[0].setLoc(wand1);
  
  force2.normalize();
  force2.mult(3);
  emitters[1].setBirthPath(force2);
  emitters[1].setLoc(wand2);
  engine.run();
  //println(frameRate);
}

void readMouse()
{
  switch(page)
  {
    case 'v':
      if(mouseX != pmouseX || mouseY != pmouseY);
      {
        cursorNormX = mouseX * invWidth;
        cursorNormY = mouseY * invHeight;
        cursorVelX = (mouseX - pmouseX) * invWidth;
        cursorVelY = (mouseY - pmouseY) * invHeight;
        engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY);
      }
      force1.set(pmouseX-mouseX, pmouseY-mouseY, 0);
      wand1.set(mouseX, mouseY, 0);
      break; 
    case 'c':
      glob.calibrate();
      break;
    case 'm':
      break;
    case 'u':
      break;
    default:
      break;
  }
}

void readWands()
{
  switch(page)
  {
    case 'v':
      //glob.run();
      if(glob.getPos1().x != glob.getPPos1().x || glob.getPos1().y != glob.getPPos1().y)
      {
        tempVector = glob.getPos1();
        cursorNormX = tempVector.x * invWidth;
        cursorNormY = tempVector.y * invHeight;
        cursorVelX = (tempVector.x - tempVector.x) * invWidth;
        cursorVelY = (tempVector.y - tempVector.y) * invHeight;
        engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY);
        //println(glob.isDown1());
      }
      if(glob.isDown1() && !emitters[0].isOn)
      {
        emitters[0].isOn = true;
      }
      if(!glob.isDown1() && emitters[0].isOn)
      {
        emitters[0].isOn = false;
      }
      
      if(glob.getPos2().x != glob.getPPos2().x || glob.getPos2().y != glob.getPPos2().y)
      {
        tempVector = glob.getPos2();
        cursorNormX = tempVector.x * invWidth;
        cursorNormY = tempVector.y * invHeight;
        cursorVelX = (tempVector.x - tempVector.x) * invWidth;
        cursorVelY = (tempVector.y - tempVector.y) * invHeight;
        engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY);
      }
      if(glob.isDown2() && !emitters[1].isOn)
      {
        emitters[1].isOn = true;
      }
      if(!glob.isDown2() && emitters[1].isOn)
      {
        emitters[1].isOn = false;
      }
      
      force1.set(glob.getPPos1().x - glob.getPos1().x, glob.getPPos1().y - glob.getPos1().y, 0);
      wand1.set(glob.getPos1().x, glob.getPos1().y, 0);
      
      force2.set(glob.getPPos2().x - glob.getPos2().x, glob.getPPos2().y - glob.getPos2().y, 0);
      wand2.set(glob.getPos2().x, glob.getPos2().y, 0);
      break;
    case 'c':
      break;
    case 'm':
      break;
    case 'u':
      break;
    default:
      break;
  }
}

void keyPressed() 
{
  if (key == CODED) {
    if(!wandIsInput)
    {
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
  }
  else
  {
    if(!wandIsInput)
    {
      if(key == 'o')
      {
        emitters[0].isOn = !emitters[0].isOn;
      }
      if(key == 'p')
      {
        emitters[1].isOn = !emitters[1].isOn;
      }
      if(key == 'a')
      {
        emitters[0].setType('a');
      }
    }
  }
}
