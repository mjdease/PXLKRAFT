class Arrow extends Particle
{
  int tailFinCount = 4;
  float len = 20.0;
  
  //default constructor
  Arrow()
  {
    super(#0000DD, 5000, .875);
    //required for collision detection
    radius = len/2;
  }
  //constructor
  Arrow(float w, color col, float lifeSpan, float damping, int tailFinCount)
  {
    super(w, col, lifeSpan, damping);
    len = w;
    this.tailFinCount = tailFinCount;
    radius = len/2;
  }
  //draws arrow (overrides Particle create())
  void create()
  {
    float gap = 0.0;
    stroke(col);
    noFill();
    //draw arrow at 0 degress (facing right)
    //arrow shaft
    beginShape();
    vertex(-len/2,0);
    vertex(len/2, 0);
    //tail
    if(tailFinCount > -1)
    {
      //add tail feathers to las wuarter of arrow shaft
      if(tailFinCount >1)
      {
        gap = len * 0.25/(tailFinCount-1);
      }
      for (int i=0; i<tailFinCount; i++)
      {
        //top
        vertex(-len/2 + gap*1, 0);
        vertex(-len/2 - len/10.0 + gap *i, -len/10.0);
        //bottom
        vertex(-len/2 + gap*i, 0);
        vertex(-len/2 - len/10.0 + gap*1, len/10.0);
      }
      endShape();
      //head
      float theta = 0;
      float radius = len/8.0;
      fill(col);
      beginShape();
      for(int i=0; i<3; i++)
      {
        vertex(len/2.0 + cos(theta)*radius, sin(theta)*radius);
        theta += PI/1.5;
      }
      endShape(CLOSE);
    }
  }
    
  //overrides Particle move()
  // arrow rotation alignment
  void move()
  {
    loc.add(vel);
    translate(loc.x, loc.y);
    rotate(atan2(vel.y, vel.x));
  }
  
  //setters
  void setTailFinCount(int tailFinCount)
  {
    this.tailFinCount = tailFinCount;
  }
  
  void setLen(float len)
  {
    this.len = len;
    radius = len/2;
  }
}
        
