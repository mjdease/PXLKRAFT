class Firework extends Particle
{
  
  //default constructor
  Firework()
  {
  }
  //constructor
  Firework(float radius, color col, float lifeSpan, float damping, char type)
  {
    super(radius, col, lifeSpan, damping, type);
  }
  //draws particle - (overrides Particle create())
  void create()
  {
    fill(col);
    noStroke();
    rect(0, 0, 2*radius, 2*radius);
  }
    
  //moves particle - (overrides Particle move())
  void move()
  {
    if(isIgnited)
    {
      vel.normalize();
      vel.add(0,-11,0);
      loc.add(vel);
      igniteIndex++;
      if(igniteIndex > 40)
      {
        //i=1 forces in all diretions, but bad for dye
        for(int i=2; i<9; i++)
        {
          //println(cos(i*PI/4)+"+"+sin(i*PI/4));
          engine.addForce(this.loc.x*invWidth,this.loc.y*invHeight,cos(i*PI/4)*5,sin(i*PI/4)*5,-1);
        }
        engine.burstEmitters.add(new Emitter(new PVector(loc.x, loc.y), new PVector(0, 0), 40, 30, 'f', 1000, true));
        toKill = true;
      }
    }
    else
    {
      loc.add(vel);
    }
    translate(loc.x, loc.y);
    
  }
  //handle particle-particle collisions/reactions
  void checkHit(Particle otherParticle)
  {
    if(isHit(otherParticle))
    {
      switch(otherParticle.type)
      {
        case 'p': //collided with a base particle
          bounce(otherParticle);
          break;
        case 'a': //collided with a arrow
          bounce(otherParticle);
          break;
        case 'w': //collided with a water particle
          bounce(otherParticle);
          break;
        case 'o': //collided with a oil particle
          bounce(otherParticle);
          break;
        case 's': //collided with a seed particle
          bounce(otherParticle);
          break;
        case 'f': //collided with a fire particle
          bounce(otherParticle);
          break;
        case 'c': //collided with a concrete particle
          bounce(otherParticle);
          break;
        case 'i': //collided with a ice particle
          bounce(otherParticle);
          break;
        case 'k': //collided with a fireworks particle
          bounce(otherParticle);
          break;
        default:
          break;
      }
    }
  }
}
