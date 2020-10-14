
enum TYPE
{
  STAR, BHOLE
}


class Mass
{
  float mass, radius;
  PVector position;
  float prevTime;

  TYPE type;
  
  LightSource rays;
  
  Mass(PVector _position, float _mass, float _radius)
  {
    position = _position;
    mass = _mass;
    radius = _radius;
    
    if (2 * G * mass / pow(c, 2) > radius) 
    {
      rays = new LightSource(position.copy(), new AngleDomain(AngleDomainPrefabs.NONE));
      type = TYPE.BHOLE;
    }
    else 
    {
      rays = new LightSource(position.copy(), new AngleDomain(AngleDomainPrefabs.CIRCULAR));
      type = TYPE.STAR;
    }
  }
  
  void EmitRays(int count)
  {
    rays.Emit(count);
    prevTime = (float)frameRateLastNanos;
  }
  
  void Draw()
  {
    if (type == TYPE.BHOLE) noFill();
    else fill(255);
    
    float delta = (-prevTime + (prevTime = (float)frameRateLastNanos))/1e6;
    
    rays.StepRays(1 * delta);
    
    stroke(255);
    circle(position.x / lengthScale, position.y / lengthScale, radius / lengthScale);
  }
}
