class Eraser extends Particle
{
  
  //default constructor
  Eraser()
  {
  }
  //constructor
  Eraser(float radius, float lifeSpan, char type)
  {
    super(radius, color(255,0,0,150), lifeSpan, type);
    isErasing = false;
  }
  //draws particle - (overrides Particle create())
  void create()
  {
    //fill(col);
    //rect(loc.x,loc.y,20,20);
  }
    
  //moves particle - (overrides Particle move())
  void move()
  {
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
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'a': //collided with a arrow
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'w': //collided with a water particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'o': //collided with a oil particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 's': //collided with a seed particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'f': //collided with a fire particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'c': //collided with a concrete particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'i': //collided with a ice particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        case 'k': //collided with a fireworks particle
          if(isErasing)
            otherParticle.toKill = true;
          break;
        default:
          break;
      }
    }
  }
}
