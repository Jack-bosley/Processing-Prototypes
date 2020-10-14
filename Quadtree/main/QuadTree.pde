
class QuadTree
{
  Rect boundary;
  
  int capacity, maxCapacity;
  PVector[] points;
  boolean isDivided = false;
  
  QuadTree[] children;
  
  
  QuadTree(Rect boundary, int maxCapacity)
  {
    this.boundary = boundary;
    this.maxCapacity = maxCapacity;
    this.capacity = 0;
    
    points = new PVector[maxCapacity];
  }
  
  private void Subdivide()
  {
    children = new QuadTree[4];
    for (int i = 0; i < 4; i++) children[i] = new QuadTree(boundary.GetQuadrant(i), this.maxCapacity);
    
    isDivided = true;
  }
  
  public boolean Insert(PVector point)
  {
    if (!this.boundary.Contains(point)) return false;
        
    if (capacity < maxCapacity) 
    {
      points[capacity++] = point;
      return true;
    }
    else
    {
      if (!isDivided) Subdivide();
      
      for (int i = 0; i < 4; i++) if (children[i].Insert(point)) return true;
    }
    
    return false;
  }
  
  public ArrayList<PVector> AllPoints()
  {
    ArrayList<PVector> contained = new ArrayList<PVector>();
    AllPoints(contained);
    
    return contained;
  }
  public void AllPoints(ArrayList<PVector> all)
  {    
    for (int i = 0; i < this.capacity; i++) all.add(this.points[i]);
    if (isDivided) for (int i = 0; i < 4; i++) children[i].AllPoints(all);
  }
  
  
  public ArrayList<PVector> Query(Rect range)
  {
    ArrayList<PVector> contained = new ArrayList<PVector>();
    Query(range, contained);
    
    return contained;
  }
  private void Query(Rect range, ArrayList<PVector> contained)
  {
    if (!range.Intersects(this.boundary)) return;
    for (int i = 0; i < this.capacity; i++) if (range.Contains(this.points[i])) contained.add(this.points[i]);
    if (isDivided) for (int i = 0; i < 4; i++) children[i].Query(range, contained);
  }
  
  public PVector ClosestPoint(PVector test)
  {
    if (capacity == 0) return null;
    
    PVector closest = points[0];
    float dx = abs(closest.x - test.x);
    float dy = abs(closest.y - test.y);
    Rect testRect = new Rect((int)test.x, (int)test.y, (int)dx, (int)dy);
    
    ClosestPointData cpd = new ClosestPointData(closest, (dx * dx) + (dy * dy), testRect);
    cpd = ClosestPointRecursive(test, cpd);
    
    return cpd.closest;
  }
  private ClosestPointData ClosestPointRecursive(PVector test, ClosestPointData cpd)
  {
    if (!cpd.testRect.Intersects(this.boundary)) return cpd;
    
    for (int i = 0; i < capacity; i++)
    {
       float dx = abs(test.x - points[i].x);
       float dy = abs(test.y - points[i].y);
       
       float distanceSquared = (dx * dx) + (dy * dy);
       
       if (distanceSquared > 0 && distanceSquared < cpd.closestDistanceSquared)
       {
         cpd.closest = points[i];
         cpd.closestDistanceSquared = distanceSquared;
         cpd.testRect.x = (int)dx;
         cpd.testRect.y = (int)dy;
       }
    }
      
    if (isDivided)
    {
      for (int i = 0; i < 4; i++) cpd = children[i].ClosestPointRecursive(test, cpd);
    }
    
    return cpd;
  }
  
  
  public void draw()
  {
    strokeWeight(1);
    stroke(255);
    noFill();
    rect(this.boundary.x, this.boundary.y, this.boundary.w * 2, this.boundary.h * 2);
    
    strokeWeight(2);
    for (int i = 0; i < this.capacity; i++) point(this.points[i].x, this.points[i].y);
    
    if (isDivided) for (int i = 0; i < 4; i++) children[i].draw();
  }
}


class ClosestPointData
{
  PVector closest;
  float closestDistanceSquared;
  Rect testRect;
  
  public ClosestPointData(PVector closest, float closestDistSquared, Rect testRect)
  {
    this.closest= closest;
    this.closestDistanceSquared = closestDistSquared;
    this.testRect = testRect;
  }
}
