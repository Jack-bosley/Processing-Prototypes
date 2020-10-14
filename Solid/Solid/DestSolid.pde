
class DestSolid
{
  ArrayList<PVector> bounds = new ArrayList<PVector>();
  
  ArrayList<Point> points = new ArrayList<Point>();
  ArrayList<Integer> activePointIndices = new ArrayList<Integer>();

  DestSolid(ArrayList<PVector> _bounds)
  {
    for (PVector p : _bounds)
    {
      bounds.add(p.copy());
    }
  }
  
  void Draw()
  {
    noFill();
    stroke(255);
    strokeWeight(1);
    beginShape();
    for (PVector p : bounds)
    {
      vertex(p.x, p.y);
    }
    endShape(CLOSE);
  }
}
