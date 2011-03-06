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
int colliderCount = 20;
Collider[] colliders = new Collider[colliderCount];
//instantiate emitter arrays
int emitterCount = 2;
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
  //for(int i=0; i<particleCount; i++)
  //{
    //Particle(float radius, color col, float lifeSpan, float damping)
    //particles[i] = new Particle(random(1, 9), color(255, random(80, 150), 10, random(255)), 5000, 0.85);
    //Arrow(float w, color col, float lifeSpan, float damping, int tailFinCount)
    //arrows[i] = new Arrow(random(5, 40), color(255, random(80, 150), 10, random(255)), 5000, 0.85, 6);
  //}
  //instantiate colliders
  for(int i=0; i<colliderCount; i++)
  {
    colliders[i] = new Collider(new PVector(random(1024), random(468)+300), 40, #666666, true);
  }
  //instantiate emitters
  //inf:Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //non:Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  emitters[0] = new Emitter(new PVector(mouseX, mouseY), myFrameRate, new PVector(0,0), 2, "particle", 1000, 5000);
  emitters[1] = new Emitter(new PVector(0, 0), myFrameRate, new PVector(0,0), 2, "arrow", 600, 7000);

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

  //inf - Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //exp - Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  //emitter = new Emitter(new PVector(300, 200), new PVector(1, 0), 3, 10, arrows);
  //emitter = new Emitter(new PVector(width/2, 100), myFrameRate, new PVector(0, -1), 0.5, particle);
  //emitter = new Emitter(new PVector(width/2, height/6), myFrameRate, new PVector(0,0), 5, particles);
}
void draw()
{
  background(0, 255);
  trail.set(pmouseX-mouseX, pmouseY-mouseY, 0);
  trail.normalize();
  trail.mult(6);
  emitters[0].setBirthPath(trail);
  wand1.set(mouseX, mouseY, 0);
  emitters[0].setLoc(wand1);
  //wand2.set(mouseX + 100, mouseY, 0);
  //emitters[1].setLoc(wand2);
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
  }
}
