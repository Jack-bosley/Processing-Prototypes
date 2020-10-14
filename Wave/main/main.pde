
void setup() {
  size(256, 256);
}


void draw() {
  loadPixels();
  
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      pixels[i + (j * width)] = color(255, 255, 255);
    }
  }
  
  updatePixels();
}
