import org.gicentre.utils.geom.*;
import msafluid.*;
import processing.opengl.*;
import ddf.minim.*;
import ddf.minim.effects.*;
import gifAnimation.*;

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

Minim minim;
Music music;

final static int particle_max = 200;
final static int arrow_max = 200;

final static int water_max = 800;
final static int oil_max = 400;
final static int seed_max = 30;
final static int fire_max = 1000;
final static int concrete_max = 600;
final static int ice_max = 100;
final static int firework_max = 200;
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
color[] firePalette;

boolean wandIsInput = false;
char page = 'u'; //v=visualization, c=calibration, m=music, u=mainmenu

int emitterCount = 2;
Emitter[] emitters = new Emitter[emitterCount];
int environmentCount = 1;
Environment[] environments = new Environment[environmentCount];
Engine engine;

//fluids
float invWidth, invHeight;
float cursorNormX, cursorNormY, cursorVelX, cursorVelY;
color dye1, dye2, dye3;
color cursor1Col, cursor2Col;

UI ui;
//Music button rollovers, they are in UI class because there is an error if they are put in the button class
Gif rhy1Over;
Gif rhy2Over;
Gif rhy3Over;
Gif rhy4Over;
Gif mel1Over;
Gif mel2Over;

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

  minim = new Minim(this);
  music = new Music();

  //tracking thread
  glob = new Glob(width, height);
  wrapper = new Thread(glob);
  wrapper.start();

  //Music button rollovers
  rhy1Over = new Gif(this, "rhy1Over.gif");
  rhy1Over.loop();

  rhy2Over = new Gif(this, "rhy2Over.gif");
  rhy2Over.loop();

  rhy3Over = new Gif(this, "rhy3Over.gif");
  rhy3Over.loop();

  rhy4Over = new Gif(this, "rhy4Over.gif");
  rhy4Over.loop();

  mel1Over = new Gif(this, "mel1Over.gif");
  mel1Over.loop();

  mel2Over = new Gif(this, "mel2Over.gif");
  mel2Over.loop();

  ui = new UI();

  //instantiate emitters
  emitters[0] = new Emitter(new PVector(0,5), constantFPS, new PVector(0,0), 3, 'w', 0.2);
  emitters[1] = new Emitter(new PVector(0,5), constantFPS, new PVector(0,0), 3, 'f', 0.2);
  setHSB(233, 1,1,1);
  setHSB(0, 1,1,2);
  setHSB(58, 1,1,3);
  changeParticle('w', 0);
  changeParticle('f', 1);

  //start code based on http://processing.org/learning/topics/firecube.html
  colorMode(HSB);
  firePalette = new color[255];
  for(int x = 0; x < firePalette.length; x++) {
    firePalette[x] = color(int(map(x, 0, 254, 0, 41)), 255, int(map(x, 0, 254, 128, 255)), x);
  }
  colorMode(RGB);
  //end code from http://processing.org/learning/topics/firecube.html

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
  
  emitters[0].createErasor(wand1);
  emitters[1].createErasor(wand2);

}
void reset()
{
  emitters[0] = new Emitter(new PVector(0,5), constantFPS, new PVector(0,0), 3, 'w', 0.2);
  emitters[1] = new Emitter(new PVector(0,5), constantFPS, new PVector(0,0), 3, 'f', 0.2);
  setHSB(233, 1,1,1);
  setHSB(0, 1,1,2);
  setHSB(58, 1,1,3);
  changeParticle('w', 0);
  changeParticle('f', 1);
  
  emitters[0].turnOff();
  emitters[1].turnOff();
  
  emitters[0].p = new ArrayList();
  emitters[1].p = new ArrayList();
  
  Iterator it = engine.allObjs.iterator();
  while(it.hasNext())
  {
    Particle item = (Particle) it.next();
    it.remove();
  }
  
  emitters[0].createErasor(wand1);
  emitters[1].createErasor(wand2);
}
void draw()
{
  rectMode(CENTER);
  if(!wandIsInput) //|| page != 'v'
  {
    readMouse();
  }
  else
  {
    readWands();
  }
  if(page == 'c')
    cursor();
  else
    noCursor();
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
  ui.run();
  //println(frameRate);
}

void readMouse()
{
  wandP1.set(wand1);
  wand1.set(mouseX, mouseY, 0);
  switch(page)
  {
  case 'v':
    force1.set(pmouseX-mouseX, pmouseY-mouseY, 0);
    wand1Fluids();
    if(mousePressed && !emitters[0].isOn)
    {
        emitters[0].turnOn();
    }
    if(!mousePressed && emitters[0].isOn)
    {
      emitters[0].turnOff();
    }
    music.movedMouse(wand1, wand2);
    music.run(wand1);
    break; 
  case 'c':
    background(200);
    glob.calibrate();
    break;
  case 'm':
    wand1Fluids();
    break;
  case 'u':
    wand1Fluids();
    break;
  default:
    break;
  }
}

void readWands()
{
  glob.track();
  wandP1.set(wand1);
  wand1.set(glob.getPos1());
  wandP2.set(wand2);
  wand2.set(glob.getPos2());
  switch(page)
  {
  case 'v':
    if(wand1.x == -100)
    {
      emitters[0].turnOff();
    }
    if(wand2.x == -100)
    {
      emitters[1].turnOff();
    }
    wand1Fluids();
    wand2Fluids();
    if(glob.isDown1() && !emitters[0].isOn)
    {
      if(wand1.x != -100)
        emitters[0].turnOn();
    }
    if(!glob.isDown1() && emitters[0].isOn)
    {
      emitters[0].turnOff();
    }

    if(glob.isDown2() && !emitters[1].isOn)
    {
      if(wand2.x != -100)
        emitters[1].turnOn();
    }
    if(!glob.isDown2() && emitters[1].isOn)
    {
      emitters[1].turnOff();
    }

    force1.set(wandP1.x - wand1.x, wandP1.y - wand1.y, 0);

    force2.set(wandP2.x - wand2.x, wandP2.y - wand2.y, 0);
    
    music.movedMouse(wand1, wand2);
    music.run(wand1);
    
    break;
  case 'c':
    background(200);
    glob.calibrate();
    break;
  case 'm':
    wand1Fluids();
    break;
  case 'u':
    wand1Fluids();
    break;
  default:
    break;
  }
}
void wand1Fluids()
{
  if((wand1.x != wandP1.x || wand1.y != wandP1.y) && wand1.x != -100)
  {
    cursorNormX = wand1.x * invWidth;
    cursorNormY = wand1.y * invHeight;
    cursorVelX = (wand1.x - wandP1.x) * invWidth;
    cursorVelY = (wand1.y - wandP1.y) * invHeight;
    engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY, 1);
    //println(glob.isDown1());
  }
}
void wand2Fluids()
{
  if((wand2.x != wandP2.x || wand2.y != wandP2.y) && wand2.x != -100)
  {
    cursorNormX = wand2.x * invWidth;
    cursorNormY = wand2.y * invHeight;
    cursorVelX = (wand2.x - wandP2.x) * invWidth;
    cursorVelY = (wand2.y - wandP2.y) * invHeight;
    engine.addForce(cursorNormX, cursorNormY, cursorVelX, cursorVelY, 2);
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
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('w');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0.8);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(233,1,1,wand+1);
    break;
  case 'o':
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('o');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(.8);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(290,1,1,wand+1);
    break;
  case 's':
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('s');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0.15);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(50,1,1,wand+1);
    break;
  case 'f':
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('f');
    emitters[wand].setLifeSpan(600);
    emitters[wand].calcAndSetRate(75);
    emitters[wand].setBirthForce(new PVector(0,-7));
    emitters[wand].setSprayWidth(5);
    setHSB(20,1,1,wand+1);
    break;
  case 'c':
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('c');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(1);
    emitters[wand].setBirthForce(new PVector(0,0));
    setHSB(233,0,0.68,wand+1);
    break;
  case 'i':
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('i');
    emitters[wand].setLifeSpan(1200);
    emitters[wand].calcAndSetRate(ice_max);
    emitters[wand].setBirthForce(new PVector(0,0));
    setHSB(178,1,1,wand+1);
    break;
  case 'k':
    if(emitters[wand].type == 'e')
    {
      emitters[wand].killEraser();
    }
    emitters[wand].setType('k');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0.5);
    emitters[wand].setBirthForce(new PVector(0,5));
    setHSB(37,1,0.58,wand+1);
    break;
  case 'e':
    emitters[wand].setType('e');
    emitters[wand].setLifeSpan(-1);
    emitters[wand].setBirthRate(0);
    if(emitters[wand].isOn)
      emitters[wand].turnOn();
    setHSB(0,1,1, wand+1);
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
void stop()
{
  // always close Minim audio classes when you are done with them
  music.groove[music.rhythm].close();

  // always stop Minim before exiting.
  minim.stop();
  String OS = System.getProperty("os.name");
  super.stop();
  
  try {
    if (OS.startsWith("Windows")) {
      String pidstr = java.lang.management.ManagementFactory.getRuntimeMXBean().getName();
      String pid[] = pidstr.split("@");
      Runtime.getRuntime().exec("taskkill /F /PID " + pid[0]).waitFor();
    }
  } 
  catch (Exception e) {
  }
}

