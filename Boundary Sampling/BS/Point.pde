
class Point
{
  float x, y, r = 5;
  ArrayList<AngleDomain> openAngles = new ArrayList<AngleDomain>();
  
  public Point(float _x, float _y)
  {
    this.x = _x;
    this.y = _y;
    this.r = 30 * pow(1.3, (this.x - 300) / 300);
    //if (this.y > 240) this.r = 10 + (9 * (x - 320) / 320);
    //else this.r = 10 - (9 * (x - 320) / 320);
    
    openAngles.add(new AngleDomain(0, 2 * PI));
  }
  
  public Point(float _x, float _y, float _r)
  {
    this.x = _x;
    this.y = _y;
    this.r = _r;
    
    openAngles.add(new AngleDomain(0, 2 * PI));
  }
  
  public ArrayList<AngleDomain> Invert(ArrayList<AngleDomain> input)
  {
    ArrayList<AngleDomain> not = new ArrayList<AngleDomain>();
    
    if (input.size() > 0)
    {
      if (input.get(0).thetaMin != 0) 
      {
        not.add(new AngleDomain(0, input.get(0).thetaMin));
      }
      
      for (int i = 0; i < input.size() - 1; i++)
      {
        not.add(new AngleDomain(input.get(i).thetaMax, input.get(i+1).thetaMin));
      }
      
      if (input.get(input.size() - 1).thetaMax % (2*PI) != 0) 
      {
        not.add(new AngleDomain(input.get(input.size() - 1).thetaMax, (2*PI)));
      }
    }
    else
    {
      not.add(new AngleDomain(0, 2*PI));
    }
    
    return not;
  }
  
  public ArrayList<AngleDomain> Add(ArrayList<AngleDomain> input1, ArrayList<AngleDomain> input2)
  {
    ArrayList<AngleDomain> sum = new ArrayList<AngleDomain>();
    
    int input1Index = 0;
    int input2Index = 0;
    
    while((input1Index < input1.size() || input2Index < input2.size()))
    {   
      if (input1Index == input1.size())
      {
        sum.add(input2.get(input2Index));
        input2Index++;
      }
      else if (input2Index == input2.size())
      {
        sum.add(input1.get(input1Index));
        input1Index++;
      }
      else if (input1.get(input1Index).thetaMin > input2.get(input2Index).thetaMax)
      {
        if (sum.size() > 0)
        {
          if (input2.get(input2Index).thetaMin > sum.get(sum.size() - 1).thetaMax) sum.add(input2.get(input2Index));
        }
        else sum.add(input2.get(input2Index));
        
        input2Index++;
      }
      else if (input1.get(input1Index).thetaMax < input2.get(input2Index).thetaMin)
      {
        if (sum.size() > 0) 
        {
          if (input1.get(input1Index).thetaMin > sum.get(sum.size() - 1).thetaMax) sum.add(input1.get(input1Index));
        }
        else sum.add(input1.get(input1Index));
        input1Index++;
      }
      else
      {
        boolean is1Max = input1.get(input1Index).thetaMax > input2.get(input2Index).thetaMax;
        
        float regionMin = min(input1.get(input1Index).thetaMin, input2.get(input2Index).thetaMin);
        float regionMax = is1Max ? input1.get(input1Index).thetaMax : input2.get(input2Index).thetaMax;
        
        if (sum.size() > 0 && sum.get(sum.size() - 1).thetaMax >= regionMin) sum.get(sum.size() - 1).thetaMax = regionMax;
        else sum.add(new AngleDomain(regionMin, regionMax));
        
        if (is1Max) input2Index++;
        else input1Index++;
      }
    }
    
    return sum;
  }
  
  public ArrayList<AngleDomain> Subtract(ArrayList<AngleDomain> input1, ArrayList<AngleDomain> input2)
  {
    ArrayList<AngleDomain> returnVal = Invert(Add(Invert(input1), input2));
    
    for (int i = 0; i < returnVal.size(); i++)
    {
      if (returnVal.get(i).thetaMin > returnVal.get(i).thetaMax) returnVal.remove(i);
    }
    
    return returnVal;
  }

  public void Invalidate(float _thetaMin, float _thetaMax)
  {
    if (_thetaMin < 0 && _thetaMax <= 2*PI) 
    { 
      // thetaMin < 0 -> delete (min -> 0) and (0 -> max) (mod 2PI)
      //ArrayList<AngleDomain> toRemove = new ArrayList<AngleDomain>();
      //toRemove.add(new AngleDomain(0, _thetaMax));
      //toRemove.add(new AngleDomain((2*PI) + _thetaMin, 2*PI));
            
      //openAngles = Subtract(openAngles, toRemove);
      
      Invalidate(0, _thetaMax);
      Invalidate(((2*PI) + _thetaMin) % (2*PI), 2*PI);
    } 
    else if (_thetaMin >= 0 && _thetaMax > 2*PI) 
    {
      // thetaMax > 2Pi -> delete (min -> 2PI) and (2PI -> max) (mod 2PI)
      //ArrayList<AngleDomain> toRemove = new ArrayList<AngleDomain>();
      //toRemove.add(new AngleDomain(0, _thetaMax % (2*PI)));
      //toRemove.add(new AngleDomain(_thetaMin, 2*PI));
      
      Invalidate(0, _thetaMax % (2*PI));
      Invalidate(_thetaMin, 2*PI);
      //openAngles = Subtract(openAngles, toRemove);
    } 
    else if (_thetaMin >= 0 && _thetaMax <= 2*PI)
    {
      // just remove specified region, no boundary conditions
      ArrayList<AngleDomain> toRemove = new ArrayList<AngleDomain>();
      toRemove.add(new AngleDomain(_thetaMin, _thetaMax));
      
      openAngles = Subtract(openAngles, toRemove);
    }
    else
    {
      println("Error occured in invalidation " + _thetaMin + " - " + _thetaMax);
    }
  }

  public void InvalidateUnionsAgainst(Point b)
  {
    float dx = b.x - x;
    float dy = b.y - y;
    float dSq = (dx * dx) + (dy * dy);

    float d = sqrt(dSq);
    if (dSq < ((r*r) + (b.r * b.r) + 2 * r * b.r))
    {      
      if (r > d + b.r) 
      {
        b.Invalidate(0, 2*PI);
      } 
      else if (b.r > d + r)
      {
        Invalidate(0, 2*PI);
      } 
      else
      {
        float angleAB = (atan2(dy, dx) + (2*PI)) % (2*PI);
        float angleBA = (atan2(-dy, -dx) + (2*PI)) % (2*PI);
        float unionAngleAB = acos((dSq + (r*r) - (b.r * b.r)) / (2 * r * d));
        float unionAngleBA = acos((dSq - (r*r) + (b.r * b.r)) / (2 * b.r * d));

        Invalidate(angleAB - unionAngleAB, angleAB + unionAngleAB);
        b.Invalidate(angleBA - unionAngleBA, angleBA + unionAngleBA);
      }
    }
  }

  public Point Random()
  {
    if (openAngles.size() != 0)
    {
      int i = int(random(openAngles.size()));
      float theta = random(openAngles.get(i).thetaMin, openAngles.get(i).thetaMax);
      
      return new Point(x + (r * cos(theta)), y + (r * sin(theta)));
    }
    else
    {
      println("Finished");
      return new Point(x + (r * cos(0)), y + (r * sin(0)));
    }
  }
  
  public void Domains()
  {
    for (AngleDomain ad : openAngles)
    {
      print(ad.ToString() + ", ");
    }
    println();
  }
}

class AngleDomain
{
  float thetaMin, thetaMax;

  public AngleDomain(float _thetaMin, float _thetaMax)
  {
    this.thetaMin = _thetaMin;
    this.thetaMax = _thetaMax;
  }
  
  public String ToString()
  {
    return "[ " + thetaMin + ", " + thetaMax + " ]";
  }
  
}
