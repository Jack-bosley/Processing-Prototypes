
QuadTree qTree;

Rect queryBox;

void setup()
{
  size(512, 512);
  rectMode(CENTER);
  
  Rect boundary = new Rect(width / 2, height / 2, width / 2, height / 2);
  
  qTree = new QuadTree(boundary, 1);
  
  for (int i = 0; i < 50; i++) qTree.Insert(new PVector(random(width), random(height)));
  
  queryBox = new Rect(width / 2, height / 2, 10, 10);
}

void draw()
{
  background(0);
  
  queryBox.x = mouseX;
  queryBox.y = mouseY;
  
  qTree.draw();
  
  strokeWeight(1);
  stroke(255);
  rect(queryBox.x, queryBox.y, queryBox.w * 2, queryBox.h * 2);
  
  strokeWeight(1);
  stroke(255, 255, 0);
  for (PVector point : qTree.AllPoints())
  {
    PVector closest = qTree.ClosestPoint(point);
    line(point.x, point.y, closest.x, closest.y);
  }
  
  strokeWeight(4);
  stroke(0, 255, 0);
  ArrayList<PVector> points = qTree.Query(queryBox);
  for (PVector point : points)
  {
    point(point.x, point.y);
  }
  strokeWeight(1);
  stroke(0, 255, 0);
  for (PVector point : points)
  {
    PVector closest = qTree.ClosestPoint(point);
    line(point.x, point.y, closest.x, closest.y);
  }
  
  
}
