
class Object {
  PVector[] vertices;
  PVector[] internalVertices;
    
  Object(float size) {
    vertices = new PVector[] {
      new PVector(-1 * size, -1 * size),
      new PVector(-1 * size,  1 * size),
      new PVector( 1 * size,  1 * size),
      new PVector( 1 * size, -1 * size),
    };
    
    
    internalVertices = new PVector[] {
      new PVector(-1 * size, -1 * size),
      new PVector(-1 * size,  1 * size),
      new PVector( 1 * size,  1 * size),
      new PVector( 1 * size, -1 * size),
    };
    
  }
  
  void draw() {
    stroke(255);
    fill(0);
    beginShape();
    for (PVector v : this.vertices) vertex(v.x, v.y);
    vertex(this.vertices[0].x, this.vertices[0].y);
    endShape();
    
    stroke(255, 0, 0);
    float crossSize = 5;
    for (PVector v : this.vertices)
    {
      line(v.x + crossSize, v.y + crossSize, v.x - crossSize, v.y - crossSize);
      line(v.x - crossSize, v.y + crossSize, v.x + crossSize, v.y - crossSize);
    }
    
  }
  
}
