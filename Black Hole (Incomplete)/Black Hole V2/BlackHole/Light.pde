
class Light
{
  PVector position, velocity;
  PVector prevPos;
  Light(PVector _position, PVector _velocity)
  {
    position = _position;
    velocity = _velocity;
  }
  
  void Step(float timeStep)
  {
    prevPos = position.copy();
    
    position = position.add(velocity.copy().mult(timeStep));
  }
  
  void DrawStep()
  {
    stroke(255, 255, 255, 100);
    line(prevPos.x / lengthScale,   prevPos.y / lengthScale,    
         position.x / lengthScale,  position.y / lengthScale); 
  }
}
