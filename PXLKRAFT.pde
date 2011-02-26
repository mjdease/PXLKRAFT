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
    particles[i] = new Particle(random(1, 3), color(255, random(90, 128), 10), 2000, 0.85);
  }
  //instantiate emitter
  //emitter = new Emitter(new PVector(300, 100), new PVector(0, 0), 20, 10, arrows);
  emitter = new Emitter(new PVector(width/2, 100), myFrameRate, new PVector(0, -1), 0.5, particles);
}
void draw()
{
  background(0);
  emitter.emit();
  println(frameRate);
}
