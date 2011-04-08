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
  void createFade(float val)
  {
    colA -= val;
    int colorIndex = int(map(lifeTime, 0, lifeSpan, 0, 255));
    if(!isFirework)
      col = firePalette[254-colorIndex];
    else
      col = color(colR, colG, colB, colA);
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
        {
          meltBuffer = 0;
          otherParticle.isMelting = true;
          otherParticle.vel.set(0,0,0);
        }
        if(otherParticle.boilBuffer>50)
          otherParticle.isBoiling = true;
        break;
      case 'o': //collided with a oil particle
        otherParticle.fireBuffer++;
        if(otherParticle.fireBuffer > 5 && !otherParticle.toKill)
        {
          otherParticle.toKill = true;
          engine.addForce(this.loc.x*invWidth,this.loc.y*invHeight,0,-0.05, -1);
          engine.burstEmitters.add(new Emitter(this.loc, new PVector(0, -5), 10, 10, 'f', 1000, false));
        }
        break;
      case 's': //collided with a seed particle
        otherParticle.fireBuffer++;
        if(otherParticle.fireBuffer > 10 && !otherParticle.toKill)
        {
          otherParticle.toKill = true;
          engine.addForce(this.loc.x*invWidth,this.loc.y*invHeight,0,-0.01, -1);
          engine.burstEmitters.add(new Emitter(this.loc, new PVector(0, -1), 4, 7, 'f', 1000, false));
        }
        break;
      case 'f': //collided with a fire particle

          break;
      case 'c': //collided with a concrete particle
        bounce(otherParticle);
        break;
      case 'd':
        bounce(otherParticle);
        otherParticle.fireBuffer++;
        if(otherParticle.fireBuffer > 10 && !otherParticle.toKill)
        {
          otherParticle.toKill = true;
          engine.addForce(this.loc.x*invWidth,this.loc.y*invHeight,0,-0.01, -1);
          engine.burstEmitters.add(new Emitter(this.loc, new PVector(0, -2), 20, 13, 'f', 1500, false));
        }
        break;
      case 'i': //collided with a ice particle
        bounce(otherParticle);
        break;
      case 'k': //collided with a fireworks particle
        if(!otherParticle.isIgnited)
        {
          otherParticle.igniteBuffer++;
        }
        if(otherParticle.igniteBuffer > 5)
        {
          otherParticle.isIgnited = true;
          otherParticle.igniteBuffer = 0;
        }
        break;
      default:
        break;
      }
    }
  }
}

