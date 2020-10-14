
enum AngleDomainPrefabs
{
  CIRCULAR, LEFT_HALF, RIGHT_HALF, TOP_HALF, BOTTOM_HALF, NONE
}

class AngleDomain
{
  ArrayList<AngleSection> openAngles = new ArrayList<AngleSection>();
    
  public AngleDomain()
  {    
    openAngles.add(new AngleSection(0, 2 * PI));
  }
  
  public AngleDomain(AngleDomainPrefabs prefabID)
  {
    switch(prefabID)
    {
      case CIRCULAR:
        openAngles.add(new AngleSection(0, 2 * PI));
        break;
      case LEFT_HALF:
        openAngles.add(new AngleSection(0.5 * PI, 1.5 * PI));
        break;
      case RIGHT_HALF:
        openAngles.add(new AngleSection(0, 0.5 * PI));
        openAngles.add(new AngleSection(1.5, 2 * PI));
        break;
      case TOP_HALF:
        openAngles.add(new AngleSection(0, PI));
        break;
      case BOTTOM_HALF:
        openAngles.add(new AngleSection(PI, 2 * PI));
        break;
      case NONE:
        break;
    }
  }
  
  public ArrayList<AngleSection> Invert(ArrayList<AngleSection> input)
  {
    ArrayList<AngleSection> not = new ArrayList<AngleSection>();
    
    if (input.size() > 0)
    {
      if (input.get(0).thetaMin != 0) 
      {
        not.add(new AngleSection(0, input.get(0).thetaMin));
      }
      
      for (int i = 0; i < input.size() - 1; i++)
      {
        not.add(new AngleSection(input.get(i).thetaMax, input.get(i+1).thetaMin));
      }
      
      if (input.get(input.size() - 1).thetaMax % (2*PI) != 0) 
      {
        not.add(new AngleSection(input.get(input.size() - 1).thetaMax, (2*PI)));
      }
    }
    else
    {
      not.add(new AngleSection(0, 2*PI));
    }
    
    return not;
  }
  
  public ArrayList<AngleSection> Add(ArrayList<AngleSection> input1, ArrayList<AngleSection> input2)
  {
    ArrayList<AngleSection> sum = new ArrayList<AngleSection>();
    
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
        else sum.add(new AngleSection(regionMin, regionMax));
        
        if (is1Max) input2Index++;
        else input1Index++;
      }
    }
    
    return sum;
  }
  
  public ArrayList<AngleSection> Subtract(ArrayList<AngleSection> input1, ArrayList<AngleSection> input2)
  {
    ArrayList<AngleSection> returnVal = Invert(Add(Invert(input1), input2));
    
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
      //ArrayList<AngleSection> toRemove = new ArrayList<AngleSection>();
      //toRemove.add(new AngleSection(0, _thetaMax));
      //toRemove.add(new AngleSection((2*PI) + _thetaMin, 2*PI));
            
      //openAngles = Subtract(openAngles, toRemove);
      
      Invalidate(0, _thetaMax);
      Invalidate(((2*PI) + _thetaMin) % (2*PI), 2*PI);
    } 
    else if (_thetaMin >= 0 && _thetaMax > 2*PI) 
    {
      // thetaMax > 2Pi -> delete (min -> 2PI) and (2PI -> max) (mod 2PI)
      //ArrayList<AngleSection> toRemove = new ArrayList<AngleSection>();
      //toRemove.add(new AngleSection(0, _thetaMax % (2*PI)));
      //toRemove.add(new AngleSection(_thetaMin, 2*PI));
      
      Invalidate(0, _thetaMax % (2*PI));
      Invalidate(_thetaMin, 2*PI);
      //openAngles = Subtract(openAngles, toRemove);
    } 
    else if (_thetaMin >= 0 && _thetaMax <= 2*PI)
    {
      // just remove specified region, no boundary conditions
      ArrayList<AngleSection> toRemove = new ArrayList<AngleSection>();
      toRemove.add(new AngleSection(_thetaMin, _thetaMax));
      
      openAngles = Subtract(openAngles, toRemove);
    }
    else
    {
      println("Error occured in invalidation " + _thetaMin + " - " + _thetaMax);
    }
  }
  
  public float RandomAngle()
  {
    if (openAngles.size() != 0)
    {
      int i = int(random(openAngles.size()));
      float theta = random(openAngles.get(i).thetaMin, openAngles.get(i).thetaMax);
      
      return theta;
    }
    else
    {
      print("Error, no sections remaining");
      return 0;
    }
  }
  
  public PVector RandomVectorWithAngle()
  {
    if (openAngles.size() != 0)
    {
      int i = int(random(openAngles.size()));
      float theta = random(openAngles.get(i).thetaMin, openAngles.get(i).thetaMax);
      
      return new PVector(cos(theta), sin(theta));
    }
    else
    {
      println("Finished");
      return null;
    }
  }
  
  public void Domains()
  {
    for (AngleSection ad : openAngles)
    {
      print(ad.ToString() + ", ");
    }
    println();
  }
}


class AngleSection
{
  float thetaMin, thetaMax;

  public AngleSection(float _thetaMin, float _thetaMax)
  {
    this.thetaMin = _thetaMin;
    this.thetaMax = _thetaMax;
  }
  
  public String ToString()
  {
    return "[ " + thetaMin + ", " + thetaMax + " ]";
  }
  
}
