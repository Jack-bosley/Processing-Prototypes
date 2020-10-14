
DestSolid d;
PosVector f = new PosVector();

void setup()
{
  size(640, 480);
  
  ArrayList<PVector> bounds = new ArrayList<PVector>();
  bounds.add(new PVector(200, 200));
  bounds.add(new PVector(400, 200));
  bounds.add(new PVector(400, 400));
  bounds.add(new PVector(200, 400));
  
  d = new DestSolid(bounds);
  
  
  f.position = new PVector(100, 100);
  f.value = new PVector(1, 0);
  
}

void draw()
{
  background(0);
  
  d.Draw();
}
