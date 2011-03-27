class Emitter
{
  //emitter position
  PVector loc = new PVector(0,0);
  //rate particles are created
  float birthRate;
  //#d path particles are projects
  PVector birthPath = new PVector(0,0);
  PVector birthForce;
  //keep trak of particle life span
  //float[] birthTime;
  //float[] lifeTime;
  // frame rate of sketch
  float sketchFrameRate;
  int maxParticles = 2000;
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
  int envIndex = 0;
  boolean isOn = false;
  PVector concretePos = new PVector(-10,-10);
  PVector concretePPos = new PVector(-100, -100);
  
  //default constructor
  Emitter()
  {
  }
  //constructor for infinite emission
  Emitter(PVector loc, float sketchFrameRate, PVector birthForce, float sprayWidth, char type, int lifeSpan, int envIndex)
  {
    this.loc = loc;
    this.sketchFrameRate = sketchFrameRate;
    this.type = type;
      this.birthRate = maxParticles/((lifeSpan/1000.0) * (sketchFrameRate));
    this.lifeSpan = lifeSpan;
    this.birthForce = birthForce;
    this.birthPath.add(birthForce);
    this.sprayWidth = sprayWidth;
    this.envIndex = envIndex;
  }
  //infinite life particles
  Emitter(PVector loc, float sketchFrameRate, PVector birthForce, float sprayWidth, char type, float birthRate, int envIndex)
  {
    this.loc = loc;
    this.sketchFrameRate = sketchFrameRate;
    this.type = type;
    this.birthRate = birthRate;
    this.lifeSpan = -1;
    this.birthForce = birthForce;
    this.birthPath.add(birthForce);
    this.sprayWidth = sprayWidth;
    this.envIndex = envIndex;
  }
  //constructor for single emission with birthRate param (explosions etc) !!!NOT USABLE ATM
  Emitter(PVector loc, PVector birthForce, float birthRate, float sprayWidth, Particle p)
  {
    this.loc = loc;
    this.type = type;
    //ensure birthRate max is particleCount-1
    this.birthRate = maxParticles - 1;
    this.birthForce = birthForce;
    this.birthPath.add(birthForce);
    this.sprayWidth = sprayWidth;
    isInfinite = false;
  }
  
  //general methods
  void create()
  {
    //println(frameRate + " - " + birthRate + " - " + birthNum + " - " + birthRemainder + " - " + p.size());
    if(isOn && !isMaxed())
    {
      birthRemainder = birthRate + birthRemainder;
      birthNum = floor(birthRemainder);
      birthRemainder %= 1;

      colorMode(RGB,255);
      for(int i = 0; i < min(birthNum,maxParticles-p.size()); i++)
      {
        switch(type)
        {
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
          case 'p':
            temp = new Particle(random(9, 12), color(random(255,180), random(120,160), random(0, 30), 255), lifeSpan, 0.98, type);
            initParticle(temp);
            particleCount++;
            break;
          case 'a':
            temp = new Arrow(random(5, 40), color(255, random(80, 150), 10, 255), lifeSpan, 0.85, 6, type);
            initParticle(temp);
            arrowCount++;
            break;
          case 'w':
            temp = new Water(random(7, 9), color(random(0,30), random(0,30), random(230, 255), 255), lifeSpan, 0.95, type);
            initParticle(temp);
            waterCount++;
            break;
          case 'o':
            temp = new Oil(random(7, 9), color(random(170, 190), random(110,125), random(20,40), 255), lifeSpan, 0.98, type);
            initParticle(temp);
            oilCount++;
            break;
          case 's':
            temp = new Seed(random(2, 4), color(random(220,240), random(160,180), random(55,75), 255), lifeSpan, 0.98, type);
            initParticle(temp);
            seedCount++;
            break;
          case 'f':
            temp = new Fire(random(3, 7), color(random(225,255), random(0,30), random(0,30), 255), lifeSpan, 0.98, type);
            initParticle(temp);
            fireCount++;
            break;
          case 'c':
            concretePos.set(loc.x, loc.y, 0);
            println(concretePPos);
            if(PVector.dist(concretePos, concretePPos) > 10)
            {
              temp = new Concrete(random(13, 16), color(175, 255), lifeSpan, 0.98, type);
              initParticle(temp);
              concreteCount++;
              concretePPos.set(concretePos);
            }
            break;
          case 'i':
            temp = new Ice(random(3, 7), color(random(120,130), random(225,235), random(230,240), 255), lifeSpan, 0.98, type);
            initParticle(temp);
            iceCount++;
            break;
          case 'k':
            temp = new Firework(random(3, 5), color(random(190,210), random(65,80), random(220,230), 255), lifeSpan, 0.98, type);
            initParticle(temp);
            fireworkCount++;
            break;
          case 'l':
            //plants dont get emitted ><
            //temp = new Plant(random(18, 20), color(random(255,180), random(120,160), random(0, 30), 255), lifeSpan, 0.98, type);
            //initParticle(temp);
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
      
      if((part.lifeTime >= part.lifeSpan && part.lifeSpan != -1) || part.toKill)
      {
        part.kill();
        p.remove(i);
        switch(part.type)
        {
          case 'p':
            particleCount--;
            break;
          case 'a':
            arrowCount--;
            break;
          case 'w':
            waterCount--;
            break;
          case 'o':
            oilCount--;
            break;
          case 's':
            seedCount--;
            break;
          case 'f':
            fireCount--;
            break;
          case 'c':
            concreteCount--;
            break;
          case 'i':
            iceCount--;
            break;
          case 'k':
            fireworkCount--;
            break;
          default:
            break;
        }
        continue;
      }
      else
      {
        int fluidIndex = engine.fluidSolver.getIndexForNormalizedPosition(part.loc.x * invWidth, part.loc.y * invHeight);
        part.vel.x += engine.fluidSolver.u[fluidIndex] * (width/20);
        part.vel.y += engine.fluidSolver.v[fluidIndex] * (height/20);
        //accelerate based on gravity
        part.vel.y += environment.gravity;
        part.vel.y += random(-environment.turbulence, environment.turbulence) + environment.wind.y;
        part.vel.x += random(-environment.turbulence, environment.turbulence) + environment.wind.x;
        part.vel.mult(environment.resistance);
        //fade particle
        if(part.lifeSpan > -1)
          part.createFade(part.initAlpha/(frameRate*(part.lifeSpan/1000)));
      }
      part.lifeTime = millis() - part.birthTime;
      //println(part.vel);
      //println(part.loc);
    }
  }
  boolean isMaxed()
  {
    boolean answer;
    switch(type)
    {
      case 'p':
        if(particleCount < particle_max)
          return false;
        else
          return true;
      case 'a':
        if(arrowCount < arrow_max)
          return false;
        else
          return true;
      case 'w':
        if(waterCount < water_max)
          return false;
        else
          return true;
      case 'o':
        if(oilCount < oil_max)
          return false;
        else
          return true;
      case 's':
        if(seedCount < seed_max)
          return false;
        else
          return true;
      case 'f':
        if(fireCount < fire_max)
          return false;
        else
          return true;
      case 'c':
        if(concreteCount < concrete_max)
          return false;
        else
          return true;
      case 'i':
        if(iceCount < ice_max)
          return false;
        else
          return true;
      case 'k':
        if(fireworkCount < firework_max)
          return false;
        else
          return true;
      default:
        return true;
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
  void setBirthForce(PVector birthForce)
  {
    this.birthForce = birthForce;
  }
  void setBirthPath(PVector birthPath)
  {
    this.birthPath = birthPath;
  }
  void setType(char type)
  {
    this.type = type;
  }
  void setSprayWidth(float sprayWidth)
  {
    this.sprayWidth = sprayWidth;
  }
  void calcAndSetRate(int maxNum)
  {
    birthRate = maxNum/((lifeSpan/1000.0) * (sketchFrameRate));
  }
  void setLifeSpan(int lifeSpan)
  {
    this.lifeSpan = lifeSpan;
  }
    void setEnvironment(Environment environment)
  {
    this.environment = environment;
  }
}
