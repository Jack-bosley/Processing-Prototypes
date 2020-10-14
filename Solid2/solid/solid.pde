
Object o = new Object(50);

void setup() {
  size(640, 480);
}

void draw() {
  translate(width / 2, height / 2);
  background(0);
  
  o.draw();
}
