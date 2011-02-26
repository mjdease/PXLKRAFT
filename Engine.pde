class Engine
{
  //properties
  Emitter emitter;
  Emitter[] emitters;
  Collider[] collider;
  
  //create default environment
  Environment environment = new Environment();
  
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
  }
  //constructor
  Engine(Emitter[] emitters, Environment environment)
  {
    this.emitters = emitters;
    this.environment = environment;
  }
  Engine(Emitter emitter, Collider[] colliders, Environment environment)
  {
    this.emitter = emitter;
    this.colliders = colliders;
    this.environment = environment;
    init();
  }
  //constructor
  Engine(Emitter[] emitters, Collider[] colliders, Environment environment)
  {
    this.emitters = emitters;
    this.colliders = colliders;
    this.environment = environment;
  }
  
  // if only one emitter added to engin, add to emitters array
  void init()
  {
    emitters = new Emitter[1];
    emitters[0] = emitter;
  }
  
  //called in draw function to run engine
  void run()
  {
    if(emitters != null && emitters.length >0)
    {
      for(int i=0; i<emitters.length; i++)
      {
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
  }
  
  //setters
  void setEmitter(Emitter emitter)
  {
    this.emitter = emitter;
    //create emitters array and adds emitter at [0]
    init();
  }
  
  void setEmitter(Emitter[] emitters)
  {
    this.emitters = emitters;
  }
  
  void setColliders(Collider[] colliders)
  {
    this.colliders = colliders;
  }
  
  void setEnvironment(Environment environment)
  {
    this.environment = environment;
  }
}
