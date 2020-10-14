
public float G = 6.674e-11; 
public float c = 3e8;

public PVector viewPos;
public float lengthScale = 1;

public PVector mousePos;
public boolean isMouseDown;
public boolean isSpacePressed;

ArrayList<Mass> masses = new ArrayList<Mass>();



void setup()
{
  background(0);
  size(640, 480);
  viewPos =  new PVector(320, 240);
  
  mousePos = new PVector(mouseX, mouseY);
  isMouseDown = false;
  isSpacePressed = false;
  
  
  masses.add(new Mass(new PVector(-1e2, 0), 1e10, 5e1));
  masses.add(new Mass(new PVector(1e2, 0), 1e32, 5e1));
}

void mouseWheel(MouseEvent event) 
{
  background(0);
  
  lengthScale *= pow(1.2, event.getCount());
}

void draw()
{
  translate(viewPos.x, viewPos.y);
  
  if (mousePressed && !isMouseDown)
  {
    mousePos.x = mouseX;
    mousePos.y = mouseY;
    isMouseDown = true;
  }
  if (!mousePressed && isMouseDown) 
  {
    isMouseDown = false;
  }
  
  if (isMouseDown)
  {
    background(0);
    
    viewPos.x += (mouseX - mousePos.x);
    viewPos.y += (mouseY - mousePos.y);
    
    mousePos.x = mouseX;
    mousePos.y = mouseY;
  }
    
  for (Mass m : masses)
  {
    m.Draw();
  }
  
  if (keyPressed && key == (char)32 && !isSpacePressed)
  {
    isSpacePressed = true;
    
    for (Mass m : masses)
    {
      m.EmitRays(500);
    }
    background(0);
    
  }
  if (!keyPressed && isSpacePressed) isSpacePressed = false;
  
}
