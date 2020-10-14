
class Rect{
  int x, y, w, h;
  public Rect(int x, int y, int w, int h)
  {
    this.x = x; this.y = y;
    this.w = w; this.h = h;
  }
  
  // index: 0 - nw, 1 - ne, 2 - sw, 3 - se
  public Rect GetQuadrant(int index)
  {
    int dx = this.w / 2, dy = this.h / 2;
    int x = this.x, y = this.y, w = this.w / 2, h = this.h / 2;
    
    switch (index)
    {
      case 0:
        x -= dx; y += dy; break;
      case 1:
        x += dx; y += dy; break;
      case 2:
        x -= dx; y -= dy; break;
      case 3:
        x += dx; y -= dy; break;
      default:
        print("Error, index does not correspond to a quadrant");
        break;
    }
    
    return new Rect(x, y, w, h);
  }
  
  public boolean Contains(PVector point)
  {
    return point.x <= this.x + this.w &&
      point.x >= this.x - this.w &&
      point.y <= this.y + this.h &&
      point.y >= this.y - this.w;
  }
  
  
  public boolean Intersects(Rect other)
  {
    return !(this.x + this.w < other.x - other.w || 
      this.x - this.w > other.x + other.w ||
      this.y + this.h < other.y - other.h ||
      this.y - this.h > other.y + other.h);
  }
}
