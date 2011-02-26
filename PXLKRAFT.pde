import processing.opengl.*;

/**
  ------IMD2900 Interactive Video System------
  --------------------By:---------------------
  -Matt Dease--Kyle Thompson--Graeme Rombough-
  ---------Paul Young--Sunmock Yang-----------
*/

//create particle population
int particleCount = 300;
//instantiate particle array
Particle[] particles = new Particle[particleCount];
Arrow[] arrows = new Arrow[particleCount];
//declare emitter
Emitter emitter;
//explicitly set framerate;
float myFrameRate = 60.0;

void setup()
{
  size(1024, 768, OPENGL);
  background(0);
  smooth();
  frameRate(myFrameRate);
  //instantiate particles
  for(int i=0; i<particleCount; i++)
  {
    //Particle(float radius, color col, float lifeSpan, float damping)
    //particles[i] = new Particle(random(1, 3), color(255, random(90, 128), 10), 2000, 0.85);
    //Arrow(float w, color col, float lifeSpan, float damping, int tailFinCount)
    arrows[i] = new Arrow(20, color(200), 4000, 0.85, 8);
  }
  //instantiate emitter
  //inf - Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, Particle[] p)
  //exp - Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle[] p)
  //emitter = new Emitter(new PVector(300, 200), new PVector(1, 0), 3, 10, arrows);
  //emitter = new Emitter(new PVector(width/2, 100), myFrameRate, new PVector(0, -1), 0.5, particle);
  emitter = new Emitter(new PVector(width/2, height/2), myFrameRate, new PVector(0,0), 5, arrows)
}
void draw()
{
  background(0);
  emitter.emit();
  println(frameRate);
}
