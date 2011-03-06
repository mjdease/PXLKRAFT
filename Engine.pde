class Engine
{
  //properties
  Emitter emitter;
  Emitter[] emitters;
  Collider[] colliders;
  
  MSAFluidSolver2D fluidSolver;
  final float FLUID_WIDTH = 120;
  PImage imgFluid;
  float aspectRatio, aspectRatio2;
  boolean drawFluid = true;
  
  //create default environment
  Environment environment = new Environment();
  
  //engine states
  boolean isColliderCollision;
  boolean isBoundaryCollision;
  
  //for individual boundary collisions
  boolean[] boundsSet = {false, false, false, false};
  
  //default constructor
  Engine()
  {
  }
  //constructor
  Engine(Emitter emitter, Environment environment)
  {
    this.emitter = emitter;
    this.environment = environment;
    init();
    pushEnvironment();
  }
  //constructor
  Engine(Emitter[] emitters, Environment environment)
  {
    this.emitters = emitters;
    this.environment = environment;
    pushEnvironment();
  }
  Engine(Emitter emitter, Collider[] colliders, Environment environment)
  {
    this.emitter = emitter;
    this.colliders = colliders;
    this.environment = environment;
    init();
    pushEnvironment();
  }
  //constructor
  Engine(Emitter[] emitters, Collider[] colliders, Environment environment)
  {
    this.emitters = emitters;
    this.colliders = colliders;
    this.environment = environment;
    
    aspectRatio = width * invHeight;
    aspectRatio2 = aspectRatio * aspectRatio;
    
    fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
    fluidSolver.enableRGB(true).setFadeSpeed(0.006).setDeltaT(0.9).setVisc(0.00005).setSolverIterations(5);
  
    // create image to hold fluid picture
    imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), RGB);
  
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
      emitters[i].setEnvironment(environment);
    }
  }
  
  //called in draw function to run engine
  void run()
  {
    fluidSolver.update();
    if(drawFluid) {
      for(int i=0; i<fluidSolver.getNumCells(); i++) {
          int d = 2;
          imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d);
      }  
      imgFluid.updatePixels();//  fastblur(imgFluid, 2);
      image(imgFluid, 0, 0, width, height);
    }
    if(emitters != null && emitters.length >0)
    {
      for(int i=0; i<emitters.length; i++)
      {
        emitters[i].emit();
      }
      checkCollisions();
    }
    
    if(colliders != null && colliders.length>0)
    {
      for(int i=0; i<colliders.length; i++)
      {
        colliders[i].create();
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
            part.vel.x *= environment.friction;
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
  }
  
  //reset to boundary edges
  void correctEdgeOverlap(Particle part, Collider collider, PVector emitterOffset)
  {
    //temporarily add emitter location to particle
    //part.loc.add(emitterOffset);
    //get vector between object centers
    PVector collisionNormal = PVector.sub(part.loc, collider.loc);
    //convert vecotr to unit length (0-1)
    collisionNormal.normalize();
    //set to perfect distance (sum of the radii)
    collisionNormal.mult(collider.radius + part.radius);
    //put particle precisely on collider edge
    part.loc.set(PVector.add(collider.loc, collisionNormal));
    //subtract emitter location
    //part.loc.sub(emitterOffset);
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
    float speed = dx * dx  + dy * dy * aspectRatio2;    // balance the x and y components of speed with the screen aspect ratio

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
        colorMode(RGB, 1);  

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
  
  void setEnvironment(Environment environment)
  {
    this.environment = environment;
    //ensures particles have been added to teh engine before calling pushEnvironment()
    if(emitters != null)
    {
      pushEnvironment();
    }
  }
}
