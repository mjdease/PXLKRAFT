class Ice extends Particle
{

  //default constructor
  Ice()
  {
  }
  //constructor
  Ice(float radius, color col, float lifeSpan, float damping, char type)
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
          //bounce(otherParticle);
          break;
        case 'a': //collided with a arrow
          //bounce(otherParticle);
          break;
        case 'w': //collided with a water particle
          if(!otherParticle.isFrozen && !otherParticle.isMelting && !otherParticle.isBoiling && !otherParticle.isSteam && !otherParticle.isFreezing)
          {
            otherParticle.freezeBuffer+=2;
          }
          if(otherParticle.freezeBuffer>15)
          {
            println(otherParticle.freezeBuffer);
            otherParticle.isFrozen = true;
            freezeCount++;
            otherParticle.freezeBuffer = 0;
            //otherParticle.col = color(red(this.col), green(this.col), blue(this.col), 255);
            pushStyle();
            colorMode(RGB, 255);
            otherParticle.col = color(125, 230, 235, 255);
            popStyle();
          }
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
        case 'd':
          bounce(otherParticle);
          break;
        case 'i': //collided with a ice particle
          
          break;
        case 'k': //collided with a fireworks particle
          //bounce(otherParticle);
          break;
        default:
          break;
      }
    }
  }
}
