class Emitter
{
  //emitter position
  PVector loc = new PVector(0,0);
  //rate particles are created
  float birthRate;
  //#d path particles are projects
  PVector birthPath;
  //keep trak of particle life span
  //float[] birthTime;
  //float[] lifeTime;
  // frame rate of sketch
  float sketchFrameRate;
  int maxParticles;
  //radius the particles spray from teh emittrer at birth
  float sprayWidth;
  //ammo
  //Particle[] p;
  //by defaul teh emitter runs infinitely
  boolean isInfinite = true;
  //environment reference w/ default instantiation
  Environment environment = new Environment();
  //used to control particle birth rate
  float particleCounter = 0.0;
  ArrayList p = new ArrayList();
  String type;
  int lifeSpan;
  
  boolean isOn = false;
  //boolean isOnPrev = false;
  //boolean stopIndexIsSet = false;
  //int stopIndex = 20;
  
  //default constructor
  Emitter()
  {
  }
  //constructor for infinite emission
  Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, String type, int maxParticles, int lifeSpan)
  {
    this.loc = loc;
    this.sketchFrameRate = sketchFrameRate;
    this.maxParticles = maxParticles;
    this.type = type;
    birthRate = maxParticles/((lifeSpan/1000.0) * (sketchFrameRate));
    this.birthPath = birthPath;
    this.sprayWidth = sprayWidth;
  }
  //constructor for single emission with birthRate param (explosions etc)
  Emitter(PVector loc, PVector birthPath, float birthRate, float sprayWidth, Particle p, int maxParticles)
  {
    this.loc = loc;
    this.maxParticles = maxParticles;
    this.type = type;
    //ensure birthRate max is particleCount-1
    this.birthRate = maxParticles - 1;
    this.birthPath = birthPath;
    this.sprayWidth = sprayWidth;
    isInfinite = false;
  }
  
  //called at beginning of each emission cycle (and initially by constructors)
  //void init(int i)
  //{
  //  float theta = random(TWO_PI);
  //  float r = random(sprayWidth);
  //  p[i].vel = new PVector(birthPath.x + cos(theta)*r, birthPath.y + sin(theta)*r);
  //  p[i].loc = new PVector(loc.x, loc.y);
  //}
  
  void setEnvironment(Environment environment)
  {
    this.environment = environment;
  }
  
  //general methods
  void emit()
  {
    if(p.size() < maxParticles)
    {
      for(int i = 0; i<min(birthRate,maxParticles-p.size()); i++)
      {
        if(type == "particle")
        {
          Particle temp = new Particle(random(1, 9), color(255, random(80, 150), 10, random(255)), 5000, 0.85);
          temp.loc.set(loc.x, loc.y, 0);
          temp.birthTime = millis();
          p.add(temp);
        }
      }
    }
    //for (int i=stopIndex; i<(particleCounter+stopIndex); i++)
    for (int i = p.size() - 1 ; i >= 0; i--)
    {
      Particle part = (Particle) p.get(i);
      //if(part.isDead == false)
      //{
      //println(p[i].isDead);
      pushMatrix();
      //move each particle to emitter location
      //translate(loc.x, loc.y);
      //draw/move particle
      part.move();
      part.create();
      popMatrix();
      //capture time at particle birth
      //if(birthTime[i] ==0.0)
      //{
      //  birthTime[i] = millis();
      //}
      if(part.lifeTime < part.lifeSpan)
      {
        //accelerate based on gravity
        part.vel.y += environment.gravity;
        part.vel.y += random(-environment.turbulence, environment.turbulence) + environment.wind.y;
        part.vel.x += random(-environment.turbulence, environment.turbulence) + environment.wind.x;
        part.vel.mult(environment.resistance);
        //fade particle
        part.createFade(part.initAlpha/(frameRate*(part.lifeSpan/1000)));
      }
      else
      {
        p.remove(i);
      }
      part.lifeTime = millis() - part.birthTime;
      //}
    }
    
    //controls rate of emission
    //if(particleCounter < p.length - birthRate && isOn)
    //{
      //particleCounter += birthRate;
      //for(int i = 0; i<particleCounter; i++)
      //{
      //  p[i].isDead = false;
      //}
    //}
    //if(!isOn)
    //{
    //  particleCounter -= birthRate;
    //  if(particleCounter<0)
    //   particleCounter=0;
    //}
    drawCursor();
  }
  void drawCursor()
  {
  }
  //set methods
  void setLoc(PVector loc)
  {
    this.loc = loc;
  }
  void setBirthRate(float birthRate)
  {
    this.birthRate = birthRate;
  }
}
