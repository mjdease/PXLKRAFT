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
  float theta, r;
  char type;
  int lifeSpan;
  int birthNum = 0;
  float birthRemainder = 0.0;
  Particle temp;
  final static float MOMENTUM = 0.1;
  final static float FLUID_FORCE = 0.4;
  int envIndex = 0;
  
  boolean isOn = false;
  //boolean isOnPrev = false;
  //boolean stopIndexIsSet = false;
  //int stopIndex = 20;
  
  //default constructor
  Emitter()
  {
  }
  //constructor for infinite emission
  Emitter(PVector loc, float sketchFrameRate, PVector birthPath, float sprayWidth, char type, int maxParticles, int lifeSpan, int envIndex)
  {
    this.loc = loc;
    this.sketchFrameRate = sketchFrameRate;
    this.maxParticles = maxParticles;
    this.type = type;
    birthRate = maxParticles/((lifeSpan/1000.0) * (sketchFrameRate));
    this.lifeSpan = lifeSpan;
    //birthRate = 0.5;
    this.birthPath = birthPath;
    this.sprayWidth = sprayWidth;
    this.envIndex = envIndex;
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
  
  void setEnvironment(Environment environment)
  {
    this.environment = environment;
  }
  
  //general methods
  void create()
  {
    //println(frameRate + " - " + birthRate + " - " + birthNum + " - " + birthRemainder + " - " + p.size());
    if(p.size() < maxParticles && isOn)
    {
      birthRemainder = birthRate + birthRemainder;
      birthNum = floor(birthRemainder);
      birthRemainder %= 1;

      colorMode(RGB,255);
      for(int i = 0; i < min(birthNum,maxParticles-p.size()); i++)
      {
        switch(type)
        {
          case 'p':
            temp = new Particle(random(18, 20), color(random(255,180), random(120,160), random(0, 30), 255), 30000, 0.95);
            initParticle(temp);
            break;
          case 'a':
            temp = new Arrow(random(5, 40), color(255, random(80, 150), 10, 255), 5000, 0.85, 6);
            initParticle(temp);
            break;
          default:
            println("unknown particle type...");
            break;
        }
      }
    }
  }
  
  void initParticle(Particle particle)
  {
    theta = random(TWO_PI);
    r = random(sprayWidth);
    
    temp.loc.set(loc.x, loc.y, 0);
    temp.birthTime = millis();
    temp.vel = new PVector(birthPath.x + cos(theta)*r, birthPath.y + sin(theta)*r);
    temp.loc = new PVector(loc.x, loc.y);
    p.add(temp);
    engine.allObjs.add(temp);
  }
  
  void emit()
  {
    colorMode(RGB,255);
    for (int i = p.size() - 1 ; i >= 0; i--)
    {
      Particle part = (Particle) p.get(i);
      pushMatrix();
      part.move();
      part.create();
      popMatrix();
      
      if(part.lifeTime < part.lifeSpan)
      {
        int fluidIndex = engine.fluidSolver.getIndexForNormalizedPosition(part.loc.x * invWidth, part.loc.y * invHeight);
        part.vel.x += engine.fluidSolver.u[fluidIndex] * (width/24);
        part.vel.y += engine.fluidSolver.v[fluidIndex] * (height/24);
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
        part.kill();
        p.remove(i);
        continue;
      }
      part.lifeTime = millis() - part.birthTime;
      //println(part.vel);
      //println(part.loc);
    }
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
  void setBirthPath(PVector birthPath)
  {
    this.birthPath = birthPath;
  }
  void setType(char type)
  {
    this.type = type;
  }
}
