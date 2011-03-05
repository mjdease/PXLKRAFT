import processing.opengl.*;

/**
  ------IMD2900 Interactive Video System------
  --------------------By:---------------------
  -Matt Dease--Kyle Thompson--Graeme Rombough-
  ---------Paul Young--Sunmock Yang-----------
*/

//create particle population
int particleCount = 2000;
//instantiate particle array
Particle[] particles = new Particle[particleCount];
//Arrow[] arrows = new Arrow[particleCount];

PVector mouse = new PVector(0,0);

//instantiate collider arrays
int colliderCount = 1;
Collider[] colliders = new Collider[colliderCount];
//instantiate emitter arrays
int emitterCount = 1;
Emitter[] emitters = new Emitter[emitterCount];
//declare rest of globals
Environment environment;
Engine engine;

//explicitly set framerate;
float myFrameRate = 60.0;

void setup()
{
  size(1024, 768, OPENGL);
  background(0);
  smooth();
  frameRate(myFrameRate);
  //instantiate base particles
  for(int i=0; i<particleCount; i++)
  {
    //Particle(float radius, color col, float lifeSpan, float damping)
    particles[i] = new Particle(random(1, 9), color(255, random(80, 150), 10, random(255)), 5000, 0.85);
  }
  //instantiate colliders
  for(int i=0; i<colliderCount; i++)
  {
    colliders[i] = new Collider(new PVector(width/2, height/1.1), 100, #323332, true);
  }
  //instantiate emitters
  //inf:Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //non:Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  emitters[0] = new Emitter(new PVector(mouseX, mouseY), myFrameRate, new PVector(0,0), 2, particles);
  
  //instantiate Environment
  //Environment(float gravity, float friction, PVector wind, float resistance, float turbulence)
  environment = new Environment(0.09, 0.785, new PVector(0,0), 0.995, 0.01);
  
  //instantiate engine
  engine = new Engine(emitters, colliders, environment);
  
  //set boundary collisions
  boolean[] bounds = {true, true, true, false};
  engine.setBoundaryCollision(true, bounds);
  
  //inf - Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //exp - Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  //emitter = new Emitter(new PVector(300, 200), new PVector(1, 0), 3, 10, arrows);
  //emitter = new Emitter(new PVector(width/2, 100), myFrameRate, new PVector(0, -1), 0.5, particle);
  //emitter = new Emitter(new PVector(width/2, height/6), myFrameRate, new PVector(0,0), 5, particles);
}
void draw()
{
  background(0, 255);
  mouse.x = mouseX;
  mouse.y = mouseY;
  emitters[0].setLoc(mouse);
  engine.run();
  //println(frameRate);
  //println(particles[0].loc);
  println(colliders[0].loc);
}
