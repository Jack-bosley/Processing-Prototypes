
class LightSource
{
  ArrayList<Light> lights = new ArrayList<Light>();
  PVector position;
  AngleDomain angles;
  
  LightSource(PVector _position, AngleDomain _angles)
  {
    position = _position;
    angles = _angles;
  }
  
  public void StepRays(float timeStep)
  {
    for(Light l : lights)
    {
      l.Step(timeStep);
      l.DrawStep();
    }
  }
  
  public void Emit(int _quantity)
  {    
    lights.clear();
    if (angles.RandomVectorWithAngle() != null)
    {
      for (int i = 0; i < _quantity; i++)
      {
        lights.add(new Light(position.copy(), angles.RandomVectorWithAngle()));
      }
    }
  }
}
