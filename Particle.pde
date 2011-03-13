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
  //boolean isFirstEmission = true;
  boolean isDead = false;
  boolean isEmitted = false;

  float mass = 0.5;
  //default constructor
  Particle()
  {
    super();
    setColComponents();
    //birthLoc = new PVector(mouseX, mouseY);
  }
  //constructor
  Particle(float radius, color col, float lifeSpan, float damping)
  {
    super(radius, col);
    this.lifeSpan = lifeSpan;
    this.damping = damping;
    setColComponents();
    //birthLoc = new PVector(mouseX, mouseY);
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
    println(vel);
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
  
  //used by engine for collision detection
  Particle getClone()
  {
    Particle p = new Particle();
    p.loc.set(loc);
    p.vel.set(vel);
    p.radius = radius;
    p.damping = damping;
    return p;
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
  
  boolean checkBounce(Particle otherParticle)
  {
    if (otherParticle != this)
    {  
      float newX = loc.x;
      float newY = loc.y;
      float otherNewX = otherParticle.loc.x;
      float otherNewY = otherParticle.loc.y;
      
      float dx = otherNewX - newX; 
      float dy = otherNewY - newY;
      float distSq = dx*dx + dy*dy; 
   
      if(dist(this.loc.x, this.loc.y, otherParticle.loc.x, otherParticle.loc.y) < this.radius + otherParticle.radius)
      //if(distSq <= this.radius * otherParticle.radius)
      {
        // The two balls are within a radius of each other so they are about to bounce.
        float collisionAngle = atan2(dy, dx); 
        float collisionX = cos(collisionAngle);
        float collisionY = sin(collisionAngle);
        float collisionXTangent = cos(collisionAngle+HALF_PI);
        float collisionYTangent = sin(collisionAngle+HALF_PI);
        
        PVector collisionNormal = new PVector(-dx,-dy);
        collisionNormal.normalize();
        collisionNormal.mult(this.radius + otherParticle.radius);
        this.loc.set(PVector.add(otherParticle.loc, collisionNormal));
        
        float v1 = sqrt(vel.x*vel.x+vel.y*vel.y);
        float v2 = sqrt(otherParticle.vel.x*otherParticle.vel.x+otherParticle.vel.y*otherParticle.vel.y);
        
        float d1 = atan2(vel.y, vel.x);
        float d2 = atan2(otherParticle.vel.y, otherParticle.vel.x);
        
        float v1x = v1*cos(d1-collisionAngle);
        float v1y = v1*sin(d1-collisionAngle);
        
        float v2x = v2*cos(d2-collisionAngle);
        float v2y = v2*sin(d2-collisionAngle);
        
        vel.x = 0.95*(collisionX*v2x + collisionXTangent*v1y);
        vel.y = 0.95*(collisionY*v2x + collisionYTangent*v1y);
        
        otherParticle.vel.x = 0.95*(collisionX*v1x + collisionXTangent*v2y);
        otherParticle.vel.y = 0.95*(collisionY*v1x + collisionYTangent*v2y);
        
        return true;
      } 
    }
    return false;    // No bounce.
  }
  void checkCollision(Particle otherParticle)
  {
    Particle part = this.getClone();

    float newX = loc.x + vel.x;
    float newY = loc.y + vel.y;
    float otherNewX = otherParticle.loc.x + otherParticle.vel.x;
    float otherNewY = otherParticle.loc.y + otherParticle.vel.y;
    
    float dx = otherNewX - newX; 
    float dy = otherNewY - newY;
    float distSq = dx*dx + dy*dy; 
   
    //if(dist(part.loc.x, part.loc.y, otherParticle.loc.x, otherParticle.loc.y) < this.radius + otherParticle.radius)
    if (distSq <= this.radius * otherParticle.radius)
    {
      //set particle to collider bounds to avoid overlap
      correctEdgeOverlap(this, otherParticle);
      //get reflection vector
      PVector rv = getReflection(part, otherParticle);
      //println(rv);
      this.setVel(rv);
      //damping slows particles on collisions
      //this.vel.y *= this.damping;
    }
  }
  void correctEdgeOverlap(Particle part, Particle otherParticle)
  {
    //get vector between object centers
    PVector collisionNormal = PVector.sub(part.loc, otherParticle.loc);
    //convert vecotr to unit length (0-1)
    collisionNormal.normalize();
    //set to perfect distance (sum of the radii)
    collisionNormal.mult(otherParticle.radius + part.radius);
    //put particle precisely on collider edge
    part.loc.set(PVector.add(otherParticle.loc, collisionNormal));
  }

  //non-orthogonal reflection, using rotation of coordinate system
  PVector getReflection(Particle particle, Particle otherParticle)
  {
    //get vector between object centers
    PVector collisionNormal = PVector.sub(particle.loc, otherParticle.loc);
    //calculate reflection of angle by rotating vectors to 0 on unic circle
    //initial theta of collisionNormal
    float theta = atan2(collisionNormal.y, collisionNormal.x);

    //rotate particle velocity vector by -theta ( to bring 0 on unit circle)
    float vx = cos(-theta)*particle.vel.x - sin(-theta)*particle.vel.y;
    float vy = sin(-theta)*particle.vel.x + cos(-theta)*particle.vel.y;

    //reverse x component and rotate velocity vector back to original position
    PVector temp = new PVector(vx, vy);
    vx = cos(theta) * -temp.x - sin(theta)*temp.y;
    vy = sin(theta) * -temp.x + cos(theta)*temp.y;
    return new PVector(vx, vy);
  }
}
  
