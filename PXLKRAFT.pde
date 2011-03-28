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
PVector wandP1 = new PVector(0,0);
PVector force1 = new PVector(0,0);
PVector wand2 = new PVector(0,0);
PVector wandP2 = new PVector(0,0);
PVector force2 = new PVector(0,0);

PVector offScreen = new PVector(-100, -100, 0);

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

final static int particle_max = 200;
final static int arrow_max = 200;

final static int water_max = 800;
final static int oil_max = 400;
final static int seed_max = 100;
final static int fire_max = 1000;
final static int concrete_max = 600;
final static int ice_max = 100;
final static int firework_max = 100;
int particleCount = 0;
int arrowCount = 0;
int waterCount = 0;
int oilCount = 0;
int seedCount = 0;
int fireCount = 0;
int concreteCount = 0;
int iceCount = 0;
int fireworkCount = 0;

int particleOpacity = 200;

boolean wandIsInput = false;
char page = 'v'; //v=visualization, c=calibration, m=music, u=mainmenu

int emitterCount = 2;
Emitter[] emitters = new Emitter[emitterCount];
int environmentCount = 1;
Environment[] environments = new Environment[environmentCount];
Engine engine;

//fluids
float invWidth, invHeight;
float cursorNormX, cursorNormY, cursorVelX, cursorVelY;
color dye1, dye2, dye3;

//tracking
Glob glob;
Thread wrapper;

float constantFPS = 30.0;

void setup()
{
  size(1024, 768, OPENGL);
  colorMode(RGB);
  background(0);
  frameRate(constantFPS);
  rectMode(CENTER);


  //box2d = new PBox2D(this);
  //box2d.createWorld();

  //tracking thread
  //glob = new Glob(width, height);
  //wrapper = new Thread(glob);
  //wrapper.start();

  //instantiate emitters
  //Emitter(PVector loc, float sketchFrameRate, PVector birthForce, float sprayWidth, char type, float birthRate, int envIndex)
  //Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, char type, int maxParticles, float birthRate, int envIndex) 
  emitters[0] = new Emitter(new PVector(0,5), constantFPS, new PVector(0,0), 3, 'w', 0.2);
  emitters[1] = new Emitter(new PVector(0,5), constantFPS, new PVector(0,0), 3, 'f', 0.2);
  setHSB(233, 1,1,1);
  setHSB(0, 1,1,2);
  setHSB(58, 1,1,3);
  changeParticle('w', 0);
  changeParticle('f', 1);

  //instantiate Environments
  //Environment(float gravity, float friction, PVector wind, float resistance, float turbulence)
  //standard
  environments[0] = new Environment(0.2, 0.785, new PVector(0,0), 0.995, 0.01);
  //upside down
  //environments[1] = new Environment(-0.15, 0.5, new PVector(0,0), 0.995, 0.05);
  //no gravity
  //environments[2] = new Environment(0, 0, new PVector(0,0), 0.999, 0.09);

  //instantiate engine
  engine = new Engine(emitters, environments);

  //for fluids
  invWidth = 1.0f/width;
  invHeight = 1.0f/height;

  //set boundary collisions
  boolean[] bounds = {
    true, true, true, true
  };
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
  force1.add(emitters[0].birthForce);
  emitters[0].setBirthPath(force1);
  emitters[0].setLoc(wand1);

  force2.normalize();
  force2.mult(3);
  force2.add(emitters[1].birthForce);
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
      engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY, 1);
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
    glob.track();
    wandP1.set(wand1);
    wand1.set(glob.getPos1());
    if(wand1.x == -100)
    {
      println("wand1");
      emitters[0].turnOff();
      break;
    }
    wandP2.set(wand2);
    wand2.set(glob.getPos2());
    if(wand2.x == -100)
    {
      println("wand2");
      emitters[1].turnOff();
      break;
    }
    if(wand1.x != wandP1.x || wand1.y != wandP1.y)
    {
      cursorNormX = wand1.x * invWidth;
      cursorNormY = wand1.y * invHeight;
      cursorVelX = (wand1.x - wandP1.x) * invWidth;
      cursorVelY = (wand1.y - wandP1.y) * invHeight;
      engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY, 1);
      //println(glob.isDown1());
    }
    if(glob.isDown1() && !emitters[0].isOn)
    {
      emitters[0].turnOn();
    }
    if(!glob.isDown1() && emitters[0].isOn)
    {
      emitters[0].turnOff();
    }
    if(wand2.x != wandP2.x || wand2.y != wandP2.y)
    {
      cursorNormX = wand2.x * invWidth;
      cursorNormY = wand2.y * invHeight;
      cursorVelX = (wand2.x - wandP2.x) * invWidth;
      cursorVelY = (wand2.y - wandP2.y) * invHeight;
      engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY, 2);
    }
    if(glob.isDown2() && !emitters[1].isOn)
    {
      emitters[1].turnOn();
    }
    if(!glob.isDown2() && emitters[1].isOn)
    {
      emitters[1].turnOff();
    }

    force1.set(wandP1.x - wand1.x, wandP1.y - wand1.y, 0);

    force2.set(wandP2.x - wand2.x, wandP2.y - wand2.y, 0);
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
    if(true)
    {
      switch(key)
      {
      case '1':
        if(!emitters[0].isOn)
        {
          emitters[0].turnOn();
        }
        else
        {
          emitters[0].turnOff();
        }
        break;
      case '2':
        if(!emitters[1].isOn)
        {
          emitters[1].turnOn();
        }
        else
        {
          emitters[1].turnOff();
        }
        break;
      default:
        break;
      }
      changeParticle(key, 0);
    }
  }
}

void changeParticle(char type, int wand)
{
  
  switch(type)
  {
    //things you can set for particles:
    //PVector birthPath, float sprayWidth, char type, int maxParticles, int lifeSpan (-1 = infinite), int envIndex, float birthRate
  case 'w':
    emitters[wand].setType('w');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0.8);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(233,1,1,wand+1);
    break;
  case 'o':
    emitters[wand].setType('o');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(2);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(37,1,.58,wand+1);
    break;
  case 's':
    emitters[wand].setType('s');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0.2);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(50,1,1,wand+1);
    break;
  case 'f':
    emitters[wand].setType('f');
    emitters[wand].setLifeSpan(600);
    emitters[wand].calcAndSetRate(100);
    emitters[wand].setBirthForce(new PVector(0,-7));
    emitters[wand].setSprayWidth(5);
    setHSB(0,1,1,wand+1);
    break;
  case 'c':
    emitters[wand].setType('c');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(1);
    emitters[wand].setBirthForce(new PVector(0,0));
    setHSB(233,0,0.68,wand+1);
    break;
  case 'i':
    emitters[wand].setType('i');
    emitters[wand].setLifeSpan(1200);
    emitters[wand].calcAndSetRate(ice_max);
    emitters[wand].setBirthForce(new PVector(0,0));
    setHSB(178,1,1,wand+1);
    break;
  case 'k':
    emitters[wand].setType('k');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0.3);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(290,1,1,wand+1);
    break;
  default:
    break;
  }
}
void setHSB(int h, float s, float b, int wand)
{
  colorMode(HSB, 360, 1, 1);
  if(wand==1)
  {
    dye1 = color(h,s,b);
  }
  if(wand==2)
  {
    dye2 = color(h,s,b);
  }
  if(wand ==3)
  {
    dye3 = color(h,s,b);
  }
  colorMode(RGB, 255);
}

