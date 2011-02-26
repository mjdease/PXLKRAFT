//this calss should me extended by other perticle types
class Particle extends Sprite
{
  //color components to calculate fade
  float colR, colG, colB, colA;
  float initAlpha;
  //particle dynamics
  float lifeSpan = 1000;
  float damping = 0.825;
  PVector vel = new PVector();
  
  //default constructor
  Particle()
  {
    super();
    setColComponents();
  }
  //constructor
  Particle(float radius, color col, float lifeSpan, float damping)
  {
    super(radius, col);
    this.lifespan = lifeSpan;
    this.damping = damping;
    setColComponents();
  }
  
  Particle(color col, float lifeSpan, float damping)
  {
    //'super' accesses the parent class (in this case calling the constructor)
    super(col);
    this.lifeSpan = lifeSpan;
    this.damping = damping;
    setColComponents();
  }
  
  //instance methods
  void setColComponents()
  {
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
    ellipse(0, 0, radius*2, radius*2);
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
    colA = initalpha;
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
}
  
