
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Integer> activePointIndices = new ArrayList<Integer>();

void setup()
{
  size(1920, 1080);
   
   /*
  Point math = new Point(0, 0);
  
  ArrayList<AngleDomain> ad1 = new ArrayList<AngleDomain>();
  ad1.add(new AngleDomain(0, 2*PI));
  
  ArrayList<AngleDomain> ad2 = new ArrayList<AngleDomain>();
  ad2.add(new AngleDomain(0, 2));
  ad2.add(new AngleDomain(4, 2*PI));
    
  ad1 = math.Subtract(ad1, ad2);
    
  for (AngleDomain ad : ad1)
  {
    println(ad.ToString());
  }*/
    
  points.add(new Point(300, 540, 30));
  activePointIndices.add(0);
}

void Add()
{
  int I = points.size();
  
  if (activePointIndices.size() > 0)
  {
    while (points.get(activePointIndices.get(0)).openAngles.size() == 0) activePointIndices.remove(0);
    
    points.add(points.get(activePointIndices.get(0)).Random());
    
    for (int i = 0; i < points.size()-1; i++)
    {
      points.get(I).InvalidateUnionsAgainst(points.get(i));
    }
    
    activePointIndices.add(I);
  }
}

void keyPressed()
{

  if(key == ENTER)
  {
    println(points.size());
    
  }
}

void draw()
{
  background(0);
  
  if (keyPressed && key == (char)32)
  {
    for (int i = 0; i < 100; i++) Add();
  }
  drawPoints();
}

void drawPoints()
{  
  stroke(10);
  strokeWeight(1);
  for (Point p : points)
  {
    ellipse(p.x, p.y, 2*p.r, 2*p.r);
  }
  
  stroke(255);
  strokeWeight(1);
  noFill();
  for (Point p : points)
  {
    for (AngleDomain ad : p.openAngles)
    {
      arc(p.x, p.y, 2 * p.r, 2 * p.r, ad.thetaMin, ad.thetaMax);
      //line(p.x, p.y, p.x + (p.r * cos(ad.thetaMin)), p.y + (p.r * sin(ad.thetaMin)));
     // line(p.x, p.y, p.x + (p.r * cos(ad.thetaMax)), p.y + (p.r * sin(ad.thetaMax)));
    }
  }

  stroke(255);
  strokeWeight(1);
  for (Point p : points)
  {
    point(p.x, p.y);
  }
}
