

int sizeX = 50;
int sizeY = 60;

float worldSizeX = 2;
float worldSizeY;

float velocityFieldDisplayVectorSize = 20;

VectorField velocities;
ScalarField densities;

int ScreenPosX(int i) { return 10 + (((width  - 20) * i) / sizeX); }
int ScreenPosY(int j) { return 10 + (((height - 20) * j) / sizeY); }
PVector ScreenPosition(int i, int j) { return new PVector(ScreenPosX(i), ScreenPosY(j)); }

float WorldPosX(int i) { return ((float)i / sizeX) * worldSizeX; }
float WorldPosY(int j) { return ((float)j / sizeY) * worldSizeY; }
PVector WorldPosition(int i, int j) { return new PVector(WorldPosX(i), WorldPosY(j)); }

void setup()
{
  size(640, 480);
  worldSizeY = worldSizeX * ((float)height / width);
  
  velocities = new VectorField(sizeX, sizeY);
  densities = new ScalarField(sizeX, sizeY);
  
  PVector[][] initialVelocities = new PVector[sizeX][sizeY];
  PVector worldPos;
  for (int i = 0; i < sizeX; i++)
  {
    for (int j = 0; j < sizeY; j++)
    {
      worldPos = WorldPosition(i, j);
      initialVelocities[i][j] = new PVector(velocityFieldDisplayVectorSize * map(noise(worldPos.x, worldPos.y), 0, 1, -1, 1), velocityFieldDisplayVectorSize * map(noise(worldPos.x + (20 * worldSizeX), worldPos.y + (20 * worldSizeY)), 0, 1, -1, 1));
    }
  }
  velocities.add(initialVelocities, sizeX, sizeY);
  
}

void draw()
{
  background(0);
  
  stroke(255);
  
  for (int i = 0; i < sizeX; i++)
  {
    for (int j = 0; j < sizeY; j++)
    {
      PVector pos = ScreenPosition(i, j);
      line(pos.x, pos.y, pos.x + velocities.get(i, j).x, pos.y + velocities.get(i, j).y);
    }
  }
}
