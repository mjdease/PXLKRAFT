class Collider extends Sprite
{
  //use to control collider visibility
  boolean isRendered;
  
  Collider()
  {
  }
  //constructor - smooth circle
  Collider(PVector loc, float radius, color col, boolean isRendered)
  {
    super(loc, radius, col);
    this.isRendered = isRendered;
  }
  
  void create()
  {
    noStroke();
    //only draw if true
    if(isRendered)
    {
      fill(col);
      pushMatrix();
      translate(loc.x, loc.y);
      ellipse(0, 0, radius*2, radius*2);
      popMatrix();
    }
  }
}
