class Environment
{
  float gravity = 0.05;
  float friction = 0.875;
  PVector wind = new PVector(0, 0);
  float resistance = 0.985;
  float turbulence = 0.04;
  
  //default constructor
  Environment()
  {
  }
  //constructor
  Environment(float gravity, float friction, PVector wind, float resistance, float turbulence)
  {
    this.gravity = gravity;
    this.friction = friction;
    this.wind = wind;
    this.resistance = resistance;
    this.turbulence = turbulence;
  }
  //constructor
  Environment(float gravity, float friction, PVector wind)
  {
    this.gravity = gravity;
    this.friction = friction;
    this.wind = wind;
  }
  
  //setter methods
  void setGravity(float gravity)
  {
    this.gravity = gravity;
  }
  void setFriction(float friction)
  {
    this.friction = friction;
  }
  void setWind(PVector wind)
  {
    this.wind = wind;
  }
  void setResistance(float resistance)
  {
    this.resistance = resistance;
  }
  void setTurbulence(float turbulence)
  {
    this.turbulence = turbulence;
  }
}
