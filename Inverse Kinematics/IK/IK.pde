
ArrayList<Segment> segments;

void setup()
{
  size(640, 480);
  segments = new ArrayList<Segment>();
  
  Segment initial = new Segment(320, 240, 5, 0);
  segments.add(initial);
  Segment current = initial;
  
  for (int i = 0; i < 100; i++)
  {
    Segment next = new Segment(current.B.x, current.B.y, 5, 0);
    segments.add(next);
    current = next;
  }
}

void draw()
{
  background(0);
  stroke(255);
  
  Segment current = segments.get(0);
  current.follow(mouseX, mouseY);
  current.show();
  
  for (int i = 1; i < segments.size(); i++)
  {
    current = segments.get(i);
    current.follow(segments.get(i-1));
    current.show();
  }
  
}
