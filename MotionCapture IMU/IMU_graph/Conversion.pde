float[] qq = new float[4];


void setup_Conversion()
{
  convert_YPR(ypr1, grav1, q1);
  convert_YPR(ypr2, grav2, q2);
  
  print(ypr1[0], ypr1[1], q1[2]);
  print("\t");
  println(theta[0], theta[1], theta[2]);
}

void convert_YPR(float[] ypr, float[] grav, float[] q)
{  
    grav[0] = 2 * (q[1]*q[3] - q[0]*q[2]);
    grav[1] = 2 * (q[0]*q[1] + q[2]*q[3]);
    grav[2] = q[0]*q[0] - q[1]*q[1] - q[2]*q[2] + q[3]*q[3];

    // calculate yaw/pitch/roll angles
    float yaw = atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1) * 180.0f/PI +180;
    float pitch= atan(grav[0] / sqrt(grav[1]*grav[1] + grav[2]*grav[2])) * 180.0f/PI;// +180;
    float roll = atan(grav[1] / sqrt(grav[0]*grav[0] + grav[2]*grav[2])) * 180.0f/PI;// +180;
    
    //println(q);
    qq[0]=q[0];
    qq[1]=q[1];
    qq[2]=q[3];
    qq[3]=q[2];
    
    float test = qq[1]*qq[2] + qq[3]*qq[0];
  
     if (test > 0.499) { // singularity at north pole
        heading = 2 * atan2(qq[1],qq[0]);
        attitude = PI/2;
        bank = 0;
        return;
      }
      if (test < -0.499) { // singularity at south pole
        heading = -2 * atan2(qq[1],qq[0]);
        attitude = - PI/2;
        bank = 0;
        return;
      }
        float sqx = qq[1]*qq[1];
        float sqy = qq[2]*qq[2];
        float sqz = qq[3]*qq[3];
        heading = atan2(2*qq[2]*qq[0]-2*qq[1]*qq[3] , 1 - 2*sqy - 2*sqz) * 180.0f/PI +180 -360;
//        //attitude = asin(2*test) * 180.0f/PI +180;                                         //Euler: Phi
//        //bank = atan2(2*qq[1]*qq[0]-2*qq[2]*qq[3] , 1 - 2*sqx - 2*sqz) * 180.0f/PI +180;   //Euler: Psi
        attitude = -atan(grav[0] / sqrt(grav[1]*grav[1] + grav[2]*grav[2])) * 180.0f/PI;// +180;  //Pitch
        bank = atan(grav[1] / sqrt(grav[0]*grav[0] + grav[2]*grav[2])) * 180.0f/PI;// +180;      //Roll
        
//      if(d==1)
//      {
//        ypr_offset1[0] = yaw;
//        ypr_offset1[1] = pitch;
//        ypr_offset1[2] = roll;
//      }
//     
//      d=0;
//    
    ypr[0] = -yaw; // angleCorrection(-yaw, ypr_offset1[0]);  
    ypr[1] = -pitch; //angleCorrection(-pitch, ypr_offset1[1]);
    ypr[2] = roll; //angleCorrection(-roll, ypr_offset1[2]);
    
  fill(#FFFF0F);  
  textFont(font18);
  //text("Singularity Indicator", 320, 730); 
 // text(test, 520, 730); 

    //println(ypr[0], ypr[1], ypr[2]); 
}

void convert_Euler(float[] euler, float[] q)
{
    // calculate Euler angles
    euler[0] = -atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1)*180.0f/PI+180;
    euler[1] = asin(2*q[1]*q[3] + 2*q[0]*q[2])*180.0f/PI;//+180;
    euler[2] = atan2(2*q[2]*q[3] - 2*q[0]*q[1], 2*q[0]*q[0] + 2*q[3]*q[3] - 1)*180.0f/PI;//+180;
}

float correct(float data){
     float offset=0;
     if(d==1)  offset = data;      
     d=0;   
     return offset;      
}

float angleCorrection(float data , float offset)
{
   float angle = data + (360-offset);

  if(angle>=360) angle = data-offset;
  return angle;    
}

float quatCorrection(float data , float offset)
{
   float quat = data + offset;

  if(quat>1) quat = offset-1;
  return quat;    
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
  p.x =v.x*(1-(2*q[2]*q[2])-(2*q[3]*q[3]))+
       v.y*2*((q[1]*q[2])+(q[0]*q[3]))+
       v.z*2*((q[1]*q[3])-(q[0]*q[2])); 
       
  p.y=v.x*2*((q[1]*q[2])-(q[0]*q[3]))+
      v.y*(1-(2*q[1]*q[1])-(2*q[3]*q[3]))+
      v.z*2*((q[2]*q[3])+(q[0]*q[1]));
  
  p.z=v.x*2*((q[1]*q[3])+(q[0]*q[2]))+
      v.y*2*((q[2]*q[3])-(q[0]*q[1]))+
      v.z*(1-(2*q[1]*q[1])-(2*q[2]*q[2]));
  
   return p;
   
//  //Don't use this
//  float s;
//  float n = q[0]*q[0] + q[1]*q[1] + q[2]*q[2] + q[3]*q[3];
//  if(n==0) s=0;
//  else s=2/n;
//  
//  float wx,wy,wz, xx,xy,xz, yy,yz,zz;
//  
//  wx=s*q[0]*q[0];   wy=s*q[0]*q[2];   wz=s*q[0]*q[3];
//  xx=s*q[1]*q[1];   xy=s*q[1]*q[2];   xz=s*q[1]*q[3];
//  yy=s*q[2]*q[2];   yz=s*q[2]*q[3];   zz=s*q[3]*q[3]; 
//  
//  p.x = v.x*(1-(yy+zz)) +
//        v.y*(xy-wz) +
//        v.z*(xz+wy);
//  p.y = v.x*(xy+wz) +
//        v.y*(1-(xx+zz)) +
//        v.z*(yz-wx);
//  p.z = v.x*(xz-wy) +
//        v.y*(yz+wx) +
//        v.z*(1-(xx+yy)); 
    
 
}



