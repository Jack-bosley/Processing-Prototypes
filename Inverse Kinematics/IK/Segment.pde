
class Segment
{
  PVector A, B;
  float len;
  
  Segment(float Ax, float Ay, float _len, float _angle)
  {
    A = new PVector(Ax, Ay);
    B = new PVector(Ax + _len * cos(_angle), Ay + _len * sin(_angle));
    
    len = _len;
  }
  
  Segment(PVector _A, PVector _B)
  {
    A = _A;
    B = _B;
    
    len = dist(A.x, A.y, B.x, B.y);
  }
  
  public void follow(Segment _follow)
  {
    follow(_follow.A.x, _follow.A.y);
  }
  
  public void follow(float followX, float followY)
  {
    PVector direction = new PVector(followX, followY).sub(A);
    float dist = direction.mag();
    
    direction.div(dist);
    
    B = A.copy().add(direction.copy().mult(dist));
    A = A.add(direction.copy().mult(dist - len));
  }
  
  public void show()
  {
    line(A.x, A.y, B.x, B.y);
  }
}
