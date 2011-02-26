//base class for particles and colliders
class Sprite
{
  //instance properties
  PVector loc = new PVector();
  float w = 1.0;
  float h = 1.0;
  float radius = 1.0;
  color col;
  
  //default constructor
  Sprite()
  {
  }
  //constructor
  Sprite(float w, float h)
  {
    this.w = w;
    this.h = h;
  }
  //constructor
  Sprite(float radius)
  {
    this.radius = radius;
  }
  //constructor
  Sprite(float w, float h, color col)
  {
    this.w = w;
    this.h = h;
    this.col = col;
  }
  //constructor
  Sprite(PVector loc, float radius, color col)
  {
    this.loc = loc;
    this.radius = radius;
    this.col = col;
  }
  //constructor
  Sprite(float radius, color col)
  {
    this.radius = radius;
    this.col = col;
  }
  //constructor
  Sprite(color col)
  {
    this.col = col;
  }
  
  //instance methods (will likely be overridden in child classes)
  void create()
  {
    fill(col);
    rectMode(CENTER);
    rect(0,0, radius*2, radius*2);
  }
  
  //setters
  void setLoc(PVector loc)
  {
    this.loc.set(loc);
  }
  
  void setSize(float radius)
  {
    this.radius = radius;
  }
  
  void setSize(float w, float h)
  {
    this.w = w;
    this.h = h;
  }
  
  void setCol(color col)
  {
    this.col = col;
  }
}
  
