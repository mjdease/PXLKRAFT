class Engine
{
  //properties
  Emitter emitter;
  Emitter[] emitters;
  Collider[] colliders;

  //ArrayList<Particle> allObjs = new ArrayList<Particle>();

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
  boolean[] boundsSet = {
    false, false, false, false
  };

  //default constructor
  Engine()
  {
  }
  //constructor
  Engine(Emitter emitter, Environment[] environment)
  {
    this.emitter = emitter;
    this.environment = environment;
    init();
    pushEnvironment();
  }
  //constructor
  Engine(Emitter[] emitters, Environment[] environment)
  {
    this.emitters = emitters;
    this.environment = environment;
    pushEnvironment();
  }
  Engine(Emitter emitter, Collider[] colliders, Environment[] environment)
  {
    this.emitter = emitter;
    this.colliders = colliders;
    this.environment = environment;
    init();
    pushEnvironment();
  }
  //constructor
  Engine(Emitter[] emitters, Collider[] colliders, Environment[] environment)
  {
    this.emitters = emitters;
    this.colliders = colliders;
    this.environment = environment;

    fluidSolver = new MSAFluidSolver2D(128, 96);
    fluidSolver.enableRGB(true).setFadeSpeed(0.006).setDeltaT(0.8).setVisc(0.00005).setSolverIterations(8);

    // create image to hold fluid picture
    imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), ARGB);

    //hash grid
    allObjs = new HashGrid(1024, 768, RADIUS+1);

    pushEnvironment();
  }

  // if only one emitter added to engin, add to emitters array
  void init()
  {
    emitters = new Emitter[1];
    emitters[0] = emitter;
  }

  //pass through environment object to emitter objects (emitters handle controlling particles, not engine)
  void pushEnvironment()
  {
    for(int i=0; i<emitters.length; i++)
    {
      emitters[i].setEnvironment(environment[emitters[i].envIndex]);
    }
  }

  //called in draw function to run engine
  void run()
  {
    //colorMode(HSB, 360, 1, 1);
    //pushMatrix();
    colorMode(RGB, 1);
    if(drawFluid) {
      for(int i=0; i<fluidSolver.getNumCells(); i++) {
        int d = 3;
        imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d, .4);
      }  
      imgFluid.updatePixels();//  fastblur(imgFluid, 2);
      image(imgFluid, 0, 0, width, height);
    }
    fluidSolver.update();
    //popMatrix();
    if(emitters != null && emitters.length >0)
    {
      checkCollisions();
      for(int i=0; i<emitters.length; i++)
      {
        emitters[i].create();
        emitters[i].emit();
      }
    }
    if(colliders != null && colliders.length>0)
    {
      for(int i=0; i<colliders.length; i++)
      {
        colliders[i].create();
      }
    }
    if(frameCount%30 == 0)
    {
      //updateAllObjs();
    }
    //println(allObjs.size());
    allObjs.updateAll();
  }
  
  void updateAllObjs()
  {
    for (Iterator i=allObjs.iterator(); i.hasNext();)
    {
      Particle part = (Particle) i.next();
      if(part.isDead)
      {
        allObjs.remove(part);
      }
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
            part.loc.y = height - part.radius;
            part.vel.y *= -1;
            part.vel.y *= part.damping;
            part.vel.x *= environment[emitters[i].envIndex].friction;
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
    //collider collision
    if(colliders != null && colliders.length>0)
    {
      for(int i=0; i<emitters.length; i++)
      {
        for(int j=0; j<emitters[i].p.size(); j++)
        {
          //get shallow clone of current particle
          //Particle part = (Particle) emitters[i].p.get(j).clone();
          //emitters[i].p.get(j).hiTest();
          Particle part = (Particle) emitters[i].p.get(j);
          part = part.getClone();
          //add emitter offset
          //part.loc.add(emitters[i].loc);

          //check each particle against colliders
          for(int k=0; k<colliders.length; k++)
          {
            Collider cldr = colliders[k];
            if(dist(part.loc.x, part.loc.y, cldr.loc.x, cldr.loc.y) < part.radius + cldr.radius)
            {
              Particle realPart = (Particle) emitters[i].p.get(j);
              //set particle to collider bounds to avoid overlap
              correctEdgeOverlap((Particle) emitters[i].p.get(j), cldr, emitters[i].loc);
              //get reflection vector
              PVector rv = getReflection(part, cldr);
              realPart.setVel(rv);
              //damping slows particles on collisions
              realPart.vel.y *= realPart.damping;
            }
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
          part.checkBounce(otherParticle);
        }
      }
    }
  }

  //reset to boundary edges
  void correctEdgeOverlap(Particle part, Collider collider, PVector emitterOffset)
  {
    //get vector between object centers
    PVector collisionNormal = PVector.sub(part.loc, collider.loc);
    //convert vecotr to unit length (0-1)
    collisionNormal.normalize();
    //set to perfect distance (sum of the radii)
    collisionNormal.mult(collider.radius + part.radius);
    //put particle precisely on collider edge
    part.loc.set(PVector.add(collider.loc, collisionNormal));
  }

  //non-orthogonal reflection, using rotation of coordinate system
  PVector getReflection(Particle particle, Collider collider)
  {
    //get vector between object centers
    PVector collisionNormal = PVector.sub(particle.loc, collider.loc);
    //calculate reflection of angle by rotating vectors to 0 on unic circle
    //initial theta of collisionNormal
    float theta = atan2(collisionNormal.y, collisionNormal.x);

    //rotate particle velocity vector by -theta ( to bring 0 on unit circle)
    float vx = cos(-theta)*particle.vel.x - sin(-theta)*particle.vel.y;
    float vy = sin(-theta)*particle.vel.x + cos(-theta)*particle.vel.y;

    //reverse x component and rotate velocity vector back to original position
    PVector temp = new PVector(vx, vy);
    vx = cos(theta) * -temp.x - sin(theta)*temp.y;
    vy = sin(theta) * -temp.x + cos(theta)*temp.y;
    return new PVector(vx, vy);
  }
  void addForce(float x, float y, float dx, float dy) 
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
      float hue = ((x + y) * 180 + frameCount) % 360;
      drawColor = color(hue, 1, 1);
      //println( fluidSolver.rOld[index] +" : "+fluidSolver.gOld[index]+" : "+fluidSolver.bOld[index]);

      fluidSolver.rOld[index]  += red(drawColor) * colorMult;
      fluidSolver.gOld[index]  += green(drawColor) * colorMult;
      fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

      fluidSolver.uOld[index] += dx * velocityMult;
      fluidSolver.vOld[index] += dy * velocityMult;
    }
  }


  //setters
  void setEmitter(Emitter emitter)
  {
    this.emitter = emitter;
    //create emitters array and adds emitter at [0]
    init();
    //pass envirnoment to emitters
    pushEnvironment();
  }

  void setEmitter(Emitter[] emitters)
  {
    this.emitters = emitters;
    //pass environment to emitters
    pushEnvironment();
  }

  void setColliders(Collider[] colliders)
  {
    this.colliders = colliders;
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

