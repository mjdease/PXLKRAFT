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
    rect(0, 0, radius, radius);
  }
  
  void move()
  {
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
    isDead = true;
  }
  public PVector getLocation()
  {
    return loc;
  }
  
  boolean checkBounce(Particle otherParitcle)
  {
    if (otherParitcle != this)
    {  
      float newX = loc.x + vel.x;
      float newY = loc.y + vel.y;
      float otherNewX = otherParitcle.loc.x + otherParitcle.vel.x;
      float otherNewY = otherParitcle.loc.y + otherParitcle.vel.y;
      
      float dx = otherNewX - newX; 
      float dy = otherNewY - newY;
      float distSq = dx*dx + dy*dy; 
   
      if (distSq <= this.radius * otherParitcle.radius)
      {
        // The two balls are within a radius of each other so they are about to bounce.
        float collisionAngle = atan2(dy, dx); 
        float collisionX = cos(collisionAngle);
        float collisionY = sin(collisionAngle);
        float collisionXTangent = cos(collisionAngle+HALF_PI);
        float collisionYTangent = sin(collisionAngle+HALF_PI);
        
        float v1 = sqrt(vel.x*vel.x+vel.y*vel.y);
        float v2 = sqrt(otherParitcle.vel.x*otherParitcle.vel.x+otherParitcle.vel.y*otherParitcle.vel.y);
        
        float d1 = atan2(vel.y, vel.x);
        float d2 = atan2(otherParitcle.vel.y, otherParitcle.vel.x);
        
        float v1x = v1*cos(d1-collisionAngle);
        float v1y = v1*sin(d1-collisionAngle);
        
        float v2x = v2*cos(d2-collisionAngle);
        float v2y = v2*sin(d2-collisionAngle);
         
        vel.x = collisionX*v2x + collisionXTangent*v1y;
        vel.y = collisionY*v2x + collisionYTangent*v1y;
        
        otherParitcle.vel.x = collisionX*v1x + collisionXTangent*v2y;
        otherParitcle.vel.y = collisionY*v1x + collisionYTangent*v2y;
        
        return true;
      } 
    }
    return false;    // No bounce.
  }
}
  
