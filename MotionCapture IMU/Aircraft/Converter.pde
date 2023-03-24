class Converter
{    
  Converter(){}
  
  PVector gravity(float[] q)
  {  
    PVector g = new PVector();
    
    g.x = 2 * (q[1]*q[3] - q[0]*q[2]);
    g.y = 2 * (q[0]*q[1] + q[2]*q[3]);
    g.z = q[0]*q[0] - q[1]*q[1] - q[2]*q[2] + q[3]*q[3];

    return g;
  }
  
  float[] ypr(float[] q)
  { 
    float[] ypr = new float[3];
    float[] offset = new float[3];
    PVector g = new PVector();  
    
    g = gravity(q);
    
    ypr[0] = atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1) * 180.0f/PI +180;
    ypr[1]= atan(g.x / sqrt(g.y*g.y + g.z*g.z)) * 180.0f/PI;        // +180;
    ypr[2] = atan(g.y / sqrt(g.x*g.x  + g.z*g.z)) * 180.0f/PI;      // +180;
    
    if(d==1)
      {
        offset[0] = ypr[0];
        offset[1] = ypr[1];
        offset[2] = ypr[2];
      }     
      d=0;
      
    ypr[0] = angleCorrection(ypr[0], offset[0]);  
    ypr[1] = angleCorrection(ypr[1], offset[1]);
    ypr[2] = angleCorrection(ypr[2], offset[2]);
    
    return ypr;
  }
  
  float[] euler(float[] q)  // calculate Euler angles
  {
    float[] euler = new float[3];
    float[] euler_a = new float[3];
    float[] offset = new float[3];
    
    euler[0] = -atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1)*180.0f/PI+180;
    euler[1] = asin(2*q[1]*q[3] + 2*q[0]*q[2])*180.0f/PI;        //+180;
    euler[2] = atan2(2*q[2]*q[3] - 2*q[0]*q[1], 2*q[0]*q[0] + 2*q[3]*q[3] - 1)*180.0f/PI;    //+180;
    
//    if(d==1)
//    {
//        offset[0] = euler_a[0];
//        offset[1] = euler_a[1];
//        offset[2] = euler_a[2];
//    }     
//    d=0;
      
//    euler[0] = angleCorrection(euler_a[0], offset[0]);  
//    euler[1] = angleCorrection(euler_a[1], offset[1]);
//    euler[2] = angleCorrection(euler_a[2], offset[2]);
    
    return euler;
  }
  
  float angleCorrection(float data , float offset)
  {
   float angle = data + (360-offset);

  if(angle>=360) angle = data-offset;
  return angle;    
  }
  
  float[] euler2quat(float[] euler)
  {
    float c1,c2,c3, s1,s2,s3;
    float[] q=new float[4];
    
    c1=cos(radians(euler[0]/2));    c2=cos(radians(euler[2]/2));    c3=cos(radians(euler[1]/2));
    s1=sin(radians(euler[0]/2));    s2=sin(radians(euler[2]/2));    s3=sin(radians(euler[1]/2));
    
    q[0]= c1*c2*c3-s1*s2*s3;
    q[1]= s1*s2*c3+c1*c2*s3;
    q[2]= s1*c2*c3+c1*s2*s3;
    q[3]= c1*s2*c3-s1*c2*s3;
    
    return q;
  }
}
