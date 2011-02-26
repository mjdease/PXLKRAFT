import processing.opengl.*;

/**
  ------IMD2900 Interactive Video System------
  --------------------By:---------------------
  -Matt Dease--Kyle Thompson--Graeme Rombough-
  ---------Paul Young--Sunmock Yang-----------
*/

//create particle population
int particleCount = 5000;
//instantiate particle array
Particle[] particles = new Particle[particleCount];
//Arrow[] arrows = new Arrow[particleCount];

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
  size(800, 600, OPENGL);
  background(0);
  smooth();
  frameRate(myFrameRate);
  //instantiate base particles
  for(int i=0; i<particleCount; i++)
  {
    //Particle(float radius, color col, float lifeSpan, float damping)
    particles[i] = new Particle(random(1, 2), color(255, random(80, 150), 10, random(255)), 8000, 0.85);
  }
  //instantiate colliders
  for(int i=0; i<colliderCount; i++)
  {
    colliders[i] = new Collider(new PVector(width/2, height/2), 200, #323332, false);
  }
  //instantiate emitters
  emitters[0] = new Emitter(new PVector(width/2, height/2), new PVector(0,0), particles.length, 5, particles);
  
  //instantiate Environment
  environment = new Environment(0.01, 0.785, new PVector(0,0), 0.995, 0.01);
  
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
  engine.run();
  println(frameRate);
}
