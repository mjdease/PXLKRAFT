//this calss should me extended by other perticle types
class Particle extends Sprite implements Locatable
{
  //color components to calculate fade
  float colR, colG, colB, colA;
  float initAlpha;
  //particle dynamics
  float lifeSpan = 1000;
  float birthTime = 0;
  float lifeTime = 0;
  float damping = 0.825;
  PVector vel = new PVector();
  boolean isDead = false;
  boolean toKill = false;
  char type = 'p';
  
  //water vars
  boolean isFrozen = false;
  boolean isFreezing = false;
  boolean isMelting = false;
  boolean isBoiling = false;
  boolean isSteam = false;
  boolean isIgnited = false;
  boolean isPlanted = false;
  boolean isSource = false;
  boolean isFirework = false;
  boolean isErasing = false;
  boolean stopGrowing = false;
  int meltBuffer = 0;
  int meltIndex = 0;
  int boilBuffer = 0;
  int boilIndex = 0;
  int freezeBuffer = 0;
  int freezeIndex = 0;
  int fireBuffer = 0;
  int igniteBuffer = 0;
  int igniteIndex = 0;
  int plantBuffer = 0;
  int plantIndex = 0;
  int plantHeight = int(random(100, 250));
  

  //default constructor
  Particle()
  {
    super();
    setColComponents();
  }
  //constructor
  Particle(float radius, color col, float lifeSpan, float damping, char type)
  {
    super(radius, col);
    this.lifeSpan = lifeSpan;
    this.damping = damping;
    this.type = type;
    setColComponents();
  }
  
  Particle(color col, float lifeSpan, float damping)
  {
    //'super' accesses the parent class (in this case calling the constructor)
    super(col);
    this.lifeSpan = lifeSpan;
    this.damping = damping;
    setColComponents();
    //birthLoc = new PVector(mouseX, mouseY);
  }
  Particle(float radius, color col, float lifeSpan, char type)
  {
    super(radius, col);
    this.lifeSpan = lifeSpan;
    this.type = type;
    setColComponents();
  }
  
  //instance methods
  void setColComponents()
  {
    colorMode(RGB);
    colR = red(col);
    colG = green(col);
    colB = blue(col);
    colA = initAlpha = alpha(col);
  }
  
  //overrides method in Sprite class
  void create()
  {
    fill(col);
    noStroke();
    //ellipse(0, 0, radius*2, radius*2);
    rect(0, 0, 2*radius, 2*radius);
  }
  
  void move()
  {
    //println(vel);
    loc.add(vel);
    translate(loc.x, loc.y);
  }
  
  //decreases alpha
  void createFade(float val)
  {
    colA -= val;
    col = color(colR, colG, colB, colA);
  }
  
  //resets alpha component
  void resetFade()
  {
    colA = initAlpha;
    col = color(colR, colG, colB, colA);
  }
  
  void setVel(PVector vel)
  {
    this.vel = vel;
  }

  void kill()
  {
    this.isDead = true;
    this.loc.set(-100,-100, 0);
  }
  public PVector getLocation()
  {
    return loc;
  }
  void checkHit(Particle otherParticle)
  {
    if(isHit(otherParticle))
    {
      bounce(otherParticle);
    }
  }
  boolean isHit(Particle otherParticle)
  {
    if (otherParticle != this)
    {  
      if(dist(this.loc.x, this.loc.y, otherParticle.loc.x, otherParticle.loc.y) < this.radius + otherParticle.radius)
      {
        // The two balls are within a radius of each other so they are about to bounce
        return true;
      } 
    }
    return false;
  }
  void bounce(Particle otherParticle)
  {
    float newX = loc.x + vel.x;
    float newY = loc.y + vel.y;
    float otherNewX = otherParticle.loc.x + otherParticle.vel.x;
    float otherNewY = otherParticle.loc.y + otherParticle.vel.y;
    
    float dx = otherNewX - newX; 
    float dy = otherNewY - newY;
    float distSq = dx*dx + dy*dy;
    
    float collisionAngle = atan2(dy, dx); 
    float collisionX = cos(collisionAngle);
    float collisionY = sin(collisionAngle);
    float collisionXTangent = cos(collisionAngle+HALF_PI);
    float collisionYTangent = sin(collisionAngle+HALF_PI);
    
      PVector collisionNormal = new PVector(-dx,-dy);
      collisionNormal.normalize();
      collisionNormal.mult(this.radius + otherParticle.radius);
    //if(this.type != 'c' && otherParticle.type != 'c')
    if(otherParticle.type == 'c' || otherParticle.isFrozen || otherParticle.isPlanted)
    {
      if(
        (otherParticle.type == 'c' && this.isFrozen) ||
        (otherParticle.type == 'c' && this.isPlanted) ||
        (otherParticle.isFrozen && this.isPlanted)
        )
      {
        this.loc.set(PVector.add(otherParticle.loc, collisionNormal));
      }
      else if(
        (this.type == 'c' && otherParticle.isFrozen) ||
        (this.type == 'c' && otherParticle.isPlanted) ||
        (this.isFrozen && otherParticle.isPlanted)
        )
      {
        collisionNormal.mult(-1);
        otherParticle.loc.set(PVector.add(this.loc, collisionNormal));
      }
      else
      {
        this.loc.set(PVector.add(otherParticle.loc, collisionNormal));
      }
    }
    else
    {
      collisionNormal.mult(-1);
      otherParticle.loc.set(PVector.add(this.loc, collisionNormal));
    }
    
    float v1 = sqrt(vel.x*vel.x+vel.y*vel.y);
    float v2 = sqrt(otherParticle.vel.x*otherParticle.vel.x+otherParticle.vel.y*otherParticle.vel.y);
    
    float d1 = atan2(vel.y, vel.x);
    float d2 = atan2(otherParticle.vel.y, otherParticle.vel.x);
    
    float v1x = v1*cos(d1-collisionAngle);
    float v1y = v1*sin(d1-collisionAngle);
    
    float v2x = v2*cos(d2-collisionAngle);
    float v2y = v2*sin(d2-collisionAngle);
    
    vel.x = damping*(collisionX*v2x + collisionXTangent*v1y);
    vel.y = damping*(collisionY*v2x + collisionYTangent*v1y);
    
    otherParticle.vel.x = damping*(collisionX*v1x + collisionXTangent*v2y);
    otherParticle.vel.y = damping*(collisionY*v1x + collisionYTangent*v2y);
  }
}
  
