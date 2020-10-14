

class VectorField
{
  int sizeX = 0;
  int sizeY = 0;
  PVector[][] values;
  
  VectorField(int _sizeX, int _sizeY)
  {
    sizeX = _sizeX;
    sizeY = _sizeY;
    
    values = new PVector[sizeX][sizeY];
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        values[i][j] = new PVector();
      }
    }
  } 
    
  VectorField(PVector[][] _values, int _sizeX, int _sizeY)
  {
    sizeX = _sizeX;
    sizeY = _sizeY;
    
    values = new PVector[sizeX][sizeY];
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        values[i][j] = _values[i][j].copy();
      }
    }
  } 
  
  PVector get(int i, int j) { return values[i][j]; } 
  VectorField copy() { return new VectorField(values, sizeX, sizeY); }
  
  // Addition
  VectorField add(VectorField b)
  {
    if (sizeX == b.sizeX && sizeY == b.sizeY)
    {
      for (int i = 0; i < sizeX; i++)
      {
        for (int j = 0; j < sizeY; j++)
        {
          values[i][j].add(b.values[i][j].copy());
        }
      }
      
      return this;
    }
    else
    {
      return null;
    }
  }
  VectorField add(PVector[][] _values, int _sizeX, int _sizeY)
  {
    if (sizeX == _sizeX && sizeY == _sizeY)
    {
      for (int i = 0; i < sizeX; i++)
      {
        for (int j = 0; j < sizeY; j++)
        {
          values[i][j].add(_values[i][j].copy());
        }
      }
      
      return this;
    }
    else
    {
      return null;
    }
  }
  
  
}
