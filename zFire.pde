class Fire extends Particle
{

  //default constructor
  Fire()
  {
  }
  //constructor
  Fire(float radius, color col, float lifeSpan, float damping, char type)
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
    loc.add(vel);
    translate(loc.x, loc.y);
    //println(loc);
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
        if(otherParticle.isFrozen && !otherParticle.isMelting)
        {
          otherParticle.meltBuffer++;
        }
        else if(!otherParticle.isFrozen && !otherParticle.isMelting && !otherParticle.isBoiling && !otherParticle.isSteam)
        {
          otherParticle.boilBuffer++;
        }
        if(otherParticle.meltBuffer>10)
          otherParticle.isMelting = true;
        if(otherParticle.boilBuffer>30)
          otherParticle.isBoiling = true;
        break;
      case 'o': //collided with a oil particle
        otherParticle.fireBuffer++;
        if(otherParticle.fireBuffer > 10 && !otherParticle.toKill)
        {
          otherParticle.toKill = true;
          //Emitter(PVector loc, PVector birthForce, float particleNum, float sprayWidth, char type, int lifeSpan)
          //for(int i=0; i<12; i++)
          //{
          //  engine.addForce(otherParticle.loc.x*invWidth,otherParticle.loc.y*invHeight,cos(TWO_PI/(i+1))/50,sin(TWO_PI/(i+1))/50,-1);
          //}
          engine.addForce(this.loc.x*invWidth,this.loc.y*invHeight,0,-0.05, -1);
          engine.burstEmitters.add(new Emitter(this.loc, new PVector(0, -5), 10, 10, 'f', 1000));
        }
        break;
      case 's': //collided with a seed particle
        bounce(otherParticle);
        break;
      case 'f': //collided with a fire particle

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
      case 'l': //collided with a plant particle
        bounce(otherParticle);
        break;
      default:
        break;
      }
    }
  }
}

