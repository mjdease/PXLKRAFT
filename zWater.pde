class Water extends Particle
{
  //default constructor
  Water()
  {
  }
  //constructor
  Water(float radius, color col, float lifeSpan, float damping, char type)
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
    if(!isFrozen)
      loc.add(vel);
    else if(isMelting)
    {
      melt();
    }
    if(isBoiling)
    {
      boil();
    }
    if(isSteam)
    {
      vel.normalize();
      vel.add(0,-4,0);
      loc.add(vel);
      if(loc.y <= radius)
        toKill = true;
    }
    translate(loc.x, loc.y);
  }
  void melt()
  {
    meltIndex++;
    colorMode(RGB, 255, 255, 255,50);
    col = color(red(col), green(col), blue(col), 50-(2*meltIndex));
    colorMode(RGB, 255);
    if(meltIndex >12)
    {
      isFrozen = false;
      isMelting = false;
      meltBuffer = 0;
      meltIndex = 0;
      col = color(0, 0, 255);
    }
  }
  void boil()
  {
    boilIndex++;
    colorMode(RGB, 255, 255, 255,50);
    //col = color(red(col), green(col), blue(col), 50-boilIndex);
    colorMode(RGB, 255);
    if(boilIndex >20)
    {
      isSteam = true;
      isBoiling = false;
      boilBuffer = 0;
      boilIndex = 0;
      col = color(0, 255, 255, 128);
      lifeSpan = lifeTime + 30000;
    }
  }
  void createFade(float val)
  {
    colA-=3;
    col = color(colR, colG, colB, colA);
    if(colA < 10)
      toKill = true;
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
        if(otherParticle.isFrozen && !otherParticle.isMelting && !this.isFrozen)
        {
          this.freezeBuffer+=2;
          if(this.freezeBuffer>20)
          {
            this.isFrozen = true;
            this.freezeBuffer = 0;
            this.col = color(red(otherParticle.col), green(otherParticle.col), blue(otherParticle.col), 255);
          }
          break;
        }
        else
        {
          bounce(otherParticle);
        }
        if(!otherParticle.isFrozen && !this.isFrozen)
        {
          this.freezeBuffer--;
        }
        break;
      case 'o': //collided with a oil particle
        bounce(otherParticle);
        break;
      case 's': //collided with a seed particle
        if(!otherParticle.isPlanted)
        {
          otherParticle.plantBuffer++;
        }
        if(otherParticle.plantBuffer > 20)
        {
          otherParticle.isPlanted = true;
          otherParticle.plantBuffer = 0;
        }
        //if(!otherParticle.isPlanted)
        //bounce(otherParticle);
        break;
      case 'f': //collided with a fire particle
        //bounce(otherParticle);
        break;
      case 'c': //collided with a concrete particle
        bounce(otherParticle);
        break;
      case 'i': //collided with a ice particle
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

