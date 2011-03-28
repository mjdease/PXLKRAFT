class Engine
{
  //properties
  Emitter emitter;
  Emitter[] emitters;

  ArrayList<Emitter> burstEmitters = new ArrayList<Emitter>();

  HashGrid allObjs;
  static final int RADIUS = 40;

  MSAFluidSolver2D fluidSolver;
  PImage imgFluid;
  boolean drawFluid = true;

  float aspectRatio = width * invHeight;
  float aspectRatio2 = aspectRatio * aspectRatio;

  //create default environment
  Environment[] environment;

  //engine states
  boolean isColliderCollision;
  boolean isBoundaryCollision;

  //for individual boundary collisions
  boolean[] boundsSet = {false, false, false, false};

  //default constructor
  Engine()
  {
  }
  Engine(Emitter[] emitters, Environment[] environment)
  {
    this.emitters = emitters;
    this.environment = environment;
    fluidSolver = new MSAFluidSolver2D(128, 96);
    fluidSolver.enableRGB(true).setFadeSpeed(0.002).setDeltaT(0.8).setVisc(0.00004).setSolverIterations(7);

    // create image to hold fluid picture
    imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), ARGB);

    //hash grid
    allObjs = new HashGrid(1024, 768, RADIUS+1);

    pushEnvironment();
  }
  //pass through environment object to emitter objects (emitters handle controlling particles, not engine)
  void pushEnvironment()
  {
    for(int i=0; i<emitters.length; i++)
    {
      emitters[i].setEnvironment(environment[0]);
    }
  }

  //called in draw function to run engine
  void run()
  {
    colorMode(RGB, 1);
    if(drawFluid) {
      for(int i=0; i<fluidSolver.getNumCells(); i++) {
        int d = 3;
        imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d, .3);
      }  
      imgFluid.updatePixels();//  fastblur(imgFluid, 2);
      image(imgFluid, 0, 0, width, height);
    }
    fluidSolver.update();

    if(emitters != null && emitters.length >0)
    {
      checkCollisions();
      for(int i=0; i<emitters.length; i++)
      {
        emitters[i].create();
        emitters[i].emit();
      }
      for (int i = burstEmitters.size() - 1 ; i >= 0; i--)
      {
        Emitter burst = (Emitter) burstEmitters.get(i);
        burst.create();
        if(burst.isOn)
          burst.isOn = false;
        burst.emit();
        if(burst.birthTime + burst.lifeSpan +500 < millis())
          burstEmitters.remove(i);
      }
    }
    if(frameCount%30 == 0)
    {
      println(frameRate);
      //updateAllObjs();
    }
    //println(allObjs.size());
    allObjs.updateAll();
  }

  //collision detection
  void checkCollisions()
  {
    //boundary collisions
    if(isBoundaryCollision)
    {
      for(int i = 0; i<emitters.length; i++)
      {
        for(int j=0; j<emitters[i].p.size(); j++)
        {
          Particle part = (Particle) emitters[i].p.get(j);
          // right bounds collision
          if(boundsSet[0] && part.loc.x > width - part.radius)
          {
            part.loc.x = width - part.radius;
            part.vel.x *= -1;
          }
          //left bounds collision
          else if(boundsSet[1] && part.loc.x < part.radius)
          {
            part.loc.x = part.radius;
            part.vel.x *= -1;
          }

          //bottom bounds collision
          if(boundsSet[2] && part.loc.y > height - part.radius)
          {
            //println(part.loc.y);
            part.loc.y = height - part.radius;
            part.vel.y *= -1;
            part.vel.y *= part.damping;
            part.vel.x *= environment[0].friction;
          }
          //top bounds collision
          else if(boundsSet[3] && part.loc.y < part.radius)
          {
            part.loc.y = part.radius;
            part.vel.y *= -1;
          }
        }
      }
    }
    for (Iterator i=allObjs.iterator(); i.hasNext();)
    {
      Particle part = (Particle) i.next();
      Collection neighbours = allObjs.get(part.getLocation());
      for(Iterator j=neighbours.iterator(); j.hasNext();)
      {
        Particle otherParticle = (Particle) j.next();
        if(!otherParticle.isDead)
        {
          part.checkHit(otherParticle);
        }
      }
    }
  }
  void addForce(float x, float y, float dx, float dy, int wand) 
  {
    float speed = dx * dx  + dy * dy;

    if(speed > 0) {
      if(x<0) x = 0; 
      else if(x>1) x = 1;
      if(y<0) y = 0; 
      else if(y>1) y = 1;

      float colorMult = 5;
      float velocityMult = 30.0f;

      int index = fluidSolver.getIndexForNormalizedPosition(x, y);
      color drawColor;
      colorMode(HSB, 360, 1, 1);
      //float hue = ((x + y) * 180 + frameCount) % 360;
      drawColor = dye3;
      if(wand == 1)
        drawColor = dye1;
      if(wand == 2)
        drawColor = dye2;
      //println( fluidSolver.rOld[index] +" : "+fluidSolver.gOld[index]+" : "+fluidSolver.bOld[index]);

      fluidSolver.rOld[index]  += red(drawColor) * colorMult;
      fluidSolver.gOld[index]  += green(drawColor) * colorMult;
      fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

      fluidSolver.uOld[index] += dx * velocityMult;
      fluidSolver.vOld[index] += dy * velocityMult;
    }
  }
  
  void setColliderCollision(boolean isColliderCollision)
  {
    this.isColliderCollision = isColliderCollision;
  }
  //overloaded setBoundaryCollision method - individual boundaries set
  void setBoundaryCollision(boolean isBoundaryCollision, boolean[] boundsSet)
  {
    this.isBoundaryCollision = isBoundaryCollision;
    this.boundsSet = boundsSet;
  }
  //overloaded setBoundaryCollision method - all boundaries set
  void setBoundaryCollision(boolean isBoundaryCollision)
  {
    this.isBoundaryCollision = isBoundaryCollision;
    for(int i=0; i<boundsSet.length; i++)
    {
      boundsSet[i] = true;
    }
  }
  //set individual boundary collisions to true
  void setBounds(boolean[] boundsSet)
  {
    this.boundsSet = boundsSet;
  }
  void setEmitter(Emitter[] emitters)
  {
    this.emitters = emitters;
    //pass environment to emitters
    pushEnvironment();
  }

  void setEnvironment(Environment[] environment)
  {
    this.environment = environment;
    //ensures particles have been added to teh engine before calling pushEnvironment()
    if(emitters != null)
    {
      pushEnvironment();
    }
  }
}

