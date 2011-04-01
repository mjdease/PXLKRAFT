class Oil extends Particle
{
  
  //default constructor
  Oil()
  {
  }
  //constructor
  Oil(float radius, color col, float lifeSpan, float damping, char type)
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
          if(otherParticle.loc.y < this.loc.y && !otherParticle.isFrozen)
          {
            float temp = this.loc.y;
            this.loc.y = otherParticle.loc.y;
            otherParticle.loc.y = temp;
          }
          break;
        case 'o': //collided with a oil particle
          bounce(otherParticle);
          break;
        case 's': //collided with a seed particle
          if(otherParticle.isPlanted)
            break;
          bounce(otherParticle);
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
