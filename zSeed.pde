class Seed extends Particle
{
  
  //default constructor
  Seed()
  {
  }
  //constructor
  Seed(float radius, color col, float lifeSpan, float damping, char type)
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
    if(isPlanted && isSource)
    {
      if(plantIndex%6 == 0 && plantIndex<plantHeight)
      {
        emitters[0].createPlant(new PVector(this.loc.x, this.loc.y - (plantIndex)));
      }
      plantIndex+=6;
    }
    else if(isPlanted)
    {}
    else
      loc.add(vel);
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
          //if(!this.isPlanted)
            //bounce(otherParticle);
          break;
        case 'o': //collided with a oil particle
          bounce(otherParticle);
          break;
        case 's': //collided with a seed particle
          //bounce(otherParticle);
          break;
        case 'f': //collided with a fire particle
          //bounce(otherParticle);
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
