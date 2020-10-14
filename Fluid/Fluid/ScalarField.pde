
class ScalarField
{
  int sizeX = 0;
  int sizeY = 0;
  float[][] values;
  
  ScalarField(int _sizeX, int _sizeY)
  {
    sizeX = _sizeX;
    sizeY = _sizeY;
    
    values = new float[sizeX][sizeY];
  }
  
  ScalarField(float[][] _values, int _sizeX, int _sizeY)
  {
    sizeX = _sizeX;
    sizeY = _sizeY;
    
    values = new float[sizeX][sizeY];
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        values[i][j] = _values[i][j];
      }
    }
  }
  
  ScalarField copy()
  {
    return new ScalarField(values, sizeX, sizeY);
  }
  
  ScalarField add(ScalarField a, ScalarField b)
  {
    if (a.sizeX == b.sizeX && a.sizeY == b.sizeY)
    {
      for (int i = 0; i < sizeX; i++)
      {
        for (int j = 0; j < sizeY; j++)
        {
          a.values[i][j] += b.values[i][j];
        }
      }
      
      return a;
    }
    else
    {
      return null;
    }
  }
  
  
}
