class Converter
{  
  float[] offset = new float[3];
  int calibrate=0;
  
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
    PVector g = new PVector();  
    
    g = gravity(q);
    
    ypr[0] = atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1) * 180.0f/PI;
    ypr[1]= atan(g.x / sqrt(g.y*g.y + g.z*g.z)) * 180.0f/PI;        // +180;
    ypr[2] = atan(g.y / sqrt(g.x*g.x  + g.z*g.z)) * 180.0f/PI;      // +180;
    
    if(calibrate==1)
      {
        offset[0] = ypr[0];
        offset[1] = ypr[1];
        offset[2] = ypr[2];
      }     
      calibrate=0;
      
    ypr[0] = 360-angleCorrection(ypr[0], offset[0]);  
    ypr[1] = angleCorrection(ypr[1], offset[1]);
    ypr[2] = 360-angleCorrection(ypr[2], offset[2]);
    
    return ypr;
  }
  
  float[] euler(float[] q)  // calculate Euler angles -->> Has a problem
  {
    float[] euler = new float[3];
    
    euler[0] = -atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1)*180.0f/PI+180;
    euler[2] = asin(2*q[1]*q[3] + 2*q[0]*q[2])*180.0f/PI;        //+180;
    euler[1] = atan2(2*q[2]*q[3] - 2*q[0]*q[1], 2*q[0]*q[0] + 2*q[3]*q[3] - 1)*180.0f/PI;    //+180;
    
    if(calibrate==1)
    {
        offset[0] = euler[0];
        offset[1] = euler[1];
        offset[2] = euler[2];
    }     
    calibrate=0;
      
    euler[0] = angleCorrection(euler[0], offset[0]);  
    euler[1] = angleCorrection(euler[1], offset[1]);
    euler[2] = angleCorrection(euler[2], offset[2]);
    
    return euler;
  }
  
  float angleCorrection(float data , float offset)
  {
   float angle = data + (360-offset);    // to create "0/360 degree" to be initial position

  if(angle>=360) angle = data-offset;
  
  float correct_angle = angle + 180;   // to create "180 degree" to be initial position

  if(correct_angle>=360) correct_angle= angle-180;
  return correct_angle;    
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

PVector rotMatrix_ZYX(float[] angle, PVector v) //z-y-x
{  
  PVector p = new PVector();
  float a = angle[0];   //alpha
  float b = angle[1];   //beta
  float g = angle[2];   //gamma
  
  // | m1  m2  m3  0 |
  // | m4  m5  m6  0 |
  // | m7  m8  m9  0 |
  // | 0   0   0   1 |
  
  float m1 = cos(radians(b))*cos(radians(g));
  float m2 = cos(radians(g))*sin(radians(a))*sin(radians(b)) - 
              cos(radians(a))*sin(radians(g));
  float m3 = cos(radians(a))*cos(radians(g))*sin(radians(b)) + 
              sin(radians(a))*sin(radians(g));
  float m4 = cos(radians(b))*sin(radians(g));
  float m5 = cos(radians(a))*cos(radians(g)) +
              sin(radians(a))*sin(radians(b))*sin(radians(g));
  float m6 = -cos(radians(g))*sin(radians(a)) +
              cos(radians(a))*sin(radians(b))*sin(radians(g));
  float m7 = -sin(radians(b));
  float m8 = cos(radians(b))*sin(radians(a));
  float m9 = cos(radians(a))*cos(radians(b));
  
  p.x = v.x*m1 + v.y*m2 + v.z*m3;
  p.y = v.x*m4 + v.y*m5 + v.z*m6;
  p.z = v.x*m7 + v.y*m8 + v.z*m9;
  
  return p;
}

PVector rotMatrix_XYZ(float[] angle, PVector v) //x-y-z
{  
  PVector p = new PVector();
  float a = angle[0];   //alpha
  float b = angle[1];   //beta
  float g = angle[2];   //gamma
  
  // | m1  m2  m3  0 |
  // | m4  m5  m6  0 |
  // | m7  m8  m9  0 |
  // | 0   0   0   1 |
  
  float m1 = cos(radians(b))*cos(radians(g));
  float m2 = -cos(radians(b))*sin(radians(g));
  float m3 = sin(radians(b));
  float m4 = cos(radians(a))*sin(radians(g)) +
              sin(radians(a))*sin(radians(b))*cos(radians(g));
  float m5 = cos(radians(a))*cos(radians(g)) -
              sin(radians(a))*sin(radians(b))*sin(radians(g));
  float m6 = -sin(radians(a))*cos(radians(b));
  float m7 = sin(radians(b))*sin(radians(g)) -
             cos(radians(a))*sin(radians(b))*cos(radians(g));
  float m8 = sin(radians(a))*cos(radians(g))+
              cos(radians(a))*sin(radians(b))*sin(radians(g));
  float m9 = cos(radians(a))*cos(radians(b));
  
  p.x = v.x*m1 + v.y*m2 + v.z*m3;
  p.y = v.x*m4 + v.y*m5 + v.z*m6;
  p.z = v.x*m7 + v.y*m8 + v.z*m9;
  
  return p;
}

PVector quat2rotmatrix(float[] q, PVector v)
{  
  PVector p;
  p=new PVector();
  
      //----From Matlab Rotation Matrix
  p.z =v.x*(1-(2*q[2]*q[2])-(2*q[3]*q[3]))+
       v.y*2*((q[1]*q[2])+(q[0]*q[3]))+
       v.z*2*((q[1]*q[3])-(q[0]*q[2])); 
       
  p.y=v.x*2*((q[1]*q[2])-(q[0]*q[3]))+
      v.y*(1-(2*q[1]*q[1])-(2*q[3]*q[3]))+
      v.z*2*((q[2]*q[3])+(q[0]*q[1]));
  
  p.x=v.x*2*((q[1]*q[3])+(q[0]*q[2]))+
      v.y*2*((q[2]*q[3])-(q[0]*q[1]))+
      v.z*(1-(2*q[1]*q[1])-(2*q[2]*q[2]));
  //We swap x-->z, z-->x
   return p;  
}
