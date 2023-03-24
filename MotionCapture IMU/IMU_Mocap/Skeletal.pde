float size = 10;

float Hmodel = 50 * size;

float Hleg = 0.25 * Hmodel;
float Wleg = 0.15 * Hmodel;
float Dleg = 0.15 * Hmodel;

float Hbody = 0.4 * Hmodel;
float Wbody = 0.32 * Hmodel;
float Dbody = 0.2 * Hmodel;

float Hhand = 0.18 * Hmodel;
float Whand = 0.14 * Hmodel;
float Dhand = 0.14 * Hmodel;

float Hhead = 0.15 * Hmodel;
float Whead = 0.14 * Hmodel;
float Dhead = 0.12 * Hmodel;

float HfootSole = Wleg/3;
float WfootSole = Wleg;
float DfootSole = Wleg*1.7;

float gap = Whand;
float bend_z = 5; //degree

float[] pelv = new float[3];

Body body = new Body();    
Head head = new Head();

Hand hand_left = new Hand();    
Hand hand_right = new Hand();

Leg leg_left = new Leg();
Leg leg_right = new Leg();

// Input Data from Serial Comm
float head_pitch;
float head_roll;
float head_yaw;

float upper_body_pitch;

float shoulder_pitch_l;
float shoulder_roll_l;
float shoulder_yaw_l;
float elbow_pitch_l;

float shoulder_pitch_r;
float shoulder_roll_r;
float shoulder_yaw_r;
float elbow_pitch_r;

float hip_pitch_l;
float hip_roll_l=0;
float hip_yaw_l;
float knee_pitch_l;
float ankle_pitch_l;
float ankle_roll_l;

float hip_pitch_r;
float hip_roll_r;
float hip_yaw_r;  
float knee_pitch_r;  
float ankle_pitch_r;
float ankle_roll_r;
//------------------------------

//--Initialize quaternion input----
Quaternion q1=new Quaternion(1,0,0,0);
Quaternion q2=new Quaternion(1,0,0,0);
Quaternion q3=new Quaternion(1,0,0,0);
Quaternion q4=new Quaternion(1,0,0,0);
Quaternion q5=new Quaternion(1,0,0,0);
Quaternion q6=new Quaternion(1,0,0,0);
Quaternion q7=new Quaternion(1,0,0,0);
Quaternion q8=new Quaternion(1,0,0,0);
Quaternion q9=new Quaternion(1,0,0,0);
Quaternion q10=new Quaternion(1,0,0,0);
Quaternion q11=new Quaternion(1,0,0,0);
Quaternion q12=new Quaternion(1,0,0,0);
Quaternion q13=new Quaternion(1,0,0,0);

float shoulder_rot_l;
float shoulder_pitch_ql;
float shoulder_roll_ql;
float shoulder_yaw_ql;

//--right hand
float shoulder_rot_r;
float shoulder_pitch_qr;
float shoulder_roll_qr;
float shoulder_yaw_qr;

float elbow_rot;
float elbow_pitch_ql;

float[][] qc=new float[14][3];  //store ypr2quat here from converted body angle
float[][] aq=new float[14][3];
   
float rol = 0;  
// Angle of Foot
float[] hip_l = new float[3];  // {0,1,2} --> x,y,z
float[] knee_l = new float[3];
float[] ankle_l = new float[3];

float[] hip_r = new float[3];
float[] knee_r = new float[3];
float[] ankle_r = new float[3];

float hl_x, kl_x, al_x;
float hr_x, kr_x, ar_x;

void SkeletalAnimation()
{ 
  fill(#FF8800);  
  input_data();
  ortho(0,width, 0,height, -1000,1000);    
  
  pushMatrix();       

  head.Rotation(0, 0, 0);    

  body.UpperBodyRotation(0, 0, 0);    
  
 
  hand_left.Rotation(shoulder_pitch_l, shoulder_yaw_l, shoulder_roll_l, 
      elbow_pitch_l, 0, -bend_z*0.5);
  
//   hand_left.Rotation(0, 0, 0, 
//  0, 0, -bend_z*0.5); 
    
  hand_right.Rotation(shoulder_pitch_r, shoulder_yaw_r, shoulder_roll_r, 
  elbow_pitch_r, 0, bend_z*0.5);
//  
  
//  hand_right.Rotation(0, 0, 0, 
//  0, 0, bend_z*0.5); 
//  
//  hand_left.Rotation(90, 0, -ypr[1][0]+180, 0+
//  0, 0, (-ypr[2][0])-bend_z*0.5 +180);

  hand_left.QuatRotation(shoulder_rot_l, shoulder_pitch_ql, shoulder_roll_ql, shoulder_yaw_ql,    //correct
                            0, 0, 0, 0);
                            
  hand_right.QuatRotation(shoulder_rot_r, shoulder_pitch_qr, shoulder_roll_qr, shoulder_yaw_qr,    //correct
                            0, 0, 0, 0); //-aq[9][2], aq[9][3]);
                            
  leg_left.HipRotation(0, 0, 0 -bend_z);
  leg_left.KneeRotation(0, 0, bend_z*1.2 );
  leg_left.AnkleRotation(0, 0, 0);

  leg_right.HipRotation(0, 0, 0 +bend_z);        //Pitch-Yaw-Roll
  leg_right.KneeRotation(0, 0, -bend_z*1.2);    // Pitch
  leg_right.AnkleRotation(0, 0, 0 );    //Pitch -....-Roll

//  leg_left.HipRotation(hip_pitch_l, hip_yaw_l, hip_roll_l -bend_z);
//  leg_left.KneeRotation(knee_pitch_l, 0, bend_z*1.2 );
//  leg_left.AnkleRotation(ankle_pitch_l, 0, ankle_roll_l);
//
//  leg_right.HipRotation(hip_pitch_r, hip_yaw_r, hip_roll_r +bend_z);        //Pitch-Yaw-Roll
//  leg_right.KneeRotation(knee_pitch_r, 0, -bend_z*1.2);    // Pitch
//  leg_right.AnkleRotation(ankle_pitch_r, 0, ankle_roll_r );    //Pitch -....-Roll

  body.PelvisTrans(0, 0, 0);
  //body.PelvisTrans(pelv[0], pelv[1], pelv[2]);  //pelv[1]
  body.Update();

  popMatrix();
}

////-----------------------------------
void input_data()
{ 
   head_pitch = ypr[12][1];
   head_roll = ypr[12][2];
   head_yaw =  ypr[12][0];
  
   upper_body_pitch =  ypr[11][2];
  
   shoulder_pitch_l =  -ypr[10][2];
   shoulder_roll_l = -ypr[10][1];
   shoulder_yaw_l = ypr[10][0];
   elbow_pitch_l = -ypr[9][2]   ;
  
   shoulder_pitch_r = ypr[8][2];
   shoulder_roll_r = ypr[8][1];
   shoulder_yaw_r = ypr[8][0];
   elbow_pitch_r = ypr[7][2];

  hip_pitch_l = -ypr[6][2];
  hip_roll_l = -ypr[6][1];
  hip_yaw_l = ypr[6][0];
  knee_pitch_l = -ypr[5][2] - hip_pitch_l;
  ankle_pitch_l = -ypr[4][2] - knee_pitch_l;
  ankle_roll_l = -ypr[4][1] - hip_roll_l;

   hip_pitch_r = ypr[3][2];
   hip_roll_r = ypr[3][1];
   hip_yaw_r = ypr[3][0];  
   knee_pitch_r = ypr[2][2] - hip_pitch_r;  
   ankle_pitch_r = ypr[1][2] - knee_pitch_r;
   ankle_roll_r = ypr[1][1] - hip_roll_r;
   
    
  // Input quaternion-------
  
  q7.set(qt[7][0], qt[7][1], qt[7][2], qt[7][3]);
  q8.set(qt[8][0], qt[8][1], qt[8][2], qt[8][3]);
  
  q9.set(qt[9][0], qt[9][1], qt[9][2], qt[9][3]);
  q10.set(qt[10][0], qt[10][1], qt[10][2], qt[10][3]);  
  
  aq[7] = q7.toAxisAngle();
  aq[8] = q8.toAxisAngle();
  aq[9] = q9.toAxisAngle();
  aq[10] = q10.toAxisAngle();
  
  shoulder_rot_l = aq[10][0];
  shoulder_pitch_ql =  -aq[10][1]; 
  shoulder_roll_ql = -aq[10][2]; 
  shoulder_yaw_ql = -aq[10][3];
  
  // -right hand
  shoulder_rot_r = aq[8][0];
  shoulder_pitch_qr =  aq[8][1]; 
  shoulder_roll_qr = aq[8][2]; 
  shoulder_yaw_qr = aq[8][3];
  
  elbow_rot = shoulder_rot_l-aq[9][0];
  elbow_pitch_ql =  shoulder_pitch_ql+aq[9][1];//+shoulder_pitch_ql; 
  //------------------------

  float[] hl = new float[3];  // {0,1,2} --> x,y,z
  float[] kl = new float[3];
  float[] al = new float[3];

  float[] hr = new float[3];
  float[] kr = new float[3];
  float[] ar = new float[3];

  //----------Find Pelvis Point------
  //--Find Hip L/R
  float l1 = Hleg;       
  float l2 = Hleg;    
  float leg =  2*Hleg;
  float xal, xar, yal, yar, zal, zar;     // ankle position 
  float px, py, pz;
  float ht = hl[2] + hr[2];

  yal = l1*cos(radians(hl[0])) + l2*cos(radians(180+hl[0] + 180+kl[0]));
  zal = l1*sin(radians(hl[0])) + l2*sin(radians(180+hl[0] + 180+kl[0]));

  yar = l1*cos(radians(hr[0])) + l2*cos(radians(180+hr[0] + 180+kr[0]));
  zar = l1*sin(radians(hr[0])) + l2*sin(radians(180+hr[0] + 180+kr[0]));

  if (ht >0)  // Left
  {
    pelv[0] = leg*sin(radians(hl[2]));
    pelv[1] = leg-yal;
  }
  if (ht <0)  // Right
  {
    pelv[0] = leg*sin(radians(hr[2]));
    pelv[1] = leg-yar;
  }

  pelv[2] = (zal + zar)/2;
}
//-------------------------------------------------------

class Head
{
  PVector r;

  Head()
  {
  }  

  void Rotation(float rx, float ry, float rz)
  {  
    r = new PVector(rx, ry, rz);
  }

  void Update()
  {
    pushMatrix();    
    rotateX(radians(r.x));
    rotateY(radians(r.y));
    rotateZ(radians(r.z));  

    prism(Hhead, 180);   

    popMatrix();
  }
}

class Body
{
  PVector pelvis, r, mr;
  float bend = 5; //degree
  float[] b = new float[7];

  Body()
  {
  }  

  void PelvisTrans(float x, float y, float z)
  {  
    pelvis = new PVector(x, y, z);
  }

  void UpperBodyRotation(float rx, float ry, float rz)
  {  
    r = new PVector(rx, ry, rz);
  }

  void Update()
  {
    PVector[] a = new PVector[7];

    b[0]= 0;
    b[1]= -bend*3 - r.x*0.8;
    b[2]=  bend*5 - r.x*0.3; 
    b[3]=  bend*2 - r.x*0.1;
    b[4]= -bend*4 + r.x*0.18;
    b[5]= -bend*3 + r.x*0.1;
    b[6]=  bend*3 - r.x*0.1;

    a[1] = new PVector(b[1], 0, 0);  
    a[2] = new PVector(b[2], 0, 0);  
    a[3] = new PVector(b[3], 0, 0);  
    a[4] = new PVector(b[4], 0, 0);  
    a[5] = new PVector(b[5], 0, 0);  
    a[6] = new PVector(b[6], 0, 0);  

    pushMatrix();
    translate(0, -height/4, 0);
    translate(pelvis.x, pelvis.y, pelvis.z); 


    // Back Bone
    pushMatrix();   

    // textSize(24*size/8);  
    // fill(200,0,0);
    // text("MRL", Wbody/8-gap/2, Hbody/8-gap/4, Dbody/2+1);

    //noFill();
    // box(Wbody, Hbody, Dbody);
    translate(0, Hbody/6 * 5, 0);   
    //rotateX(radians(r.x));
    rotateY(radians(r.y));
    rotateZ(radians(r.z));  

    rotateX(radians(a[1].x));
    prism(Hbody/6, 180);  
    translate(0, -Hbody/6, 0);    
    rotateX(radians(a[2].x));
    prism(Hbody/6, 180);  
    translate(0, -Hbody/6, 0);    
    rotateX(radians(a[3].x));
    prism(Hbody/6, 180);  
    translate(0, -Hbody/6, 0);    
    rotateX(radians(a[4].x));
    prism(Hbody/6, 180);  
    translate(0, -Hbody/6, 0);    
    rotateX(radians(a[5].x));

    // Collar right ------------HAND------------------
    pushMatrix();
    rotateZ(radians(135));
    prism(Wbody/4, 0);    
    translate(0, Wbody/4, 0);    
    rotateZ(radians(-35));
    prism(Wbody/4, 0); 

    ////  Update Right Hand Value
    translate(0, Wbody/4, 0);    
    rotateZ(radians(-100));  
    rotateX(radians(15));       
    hand_right.Update();
    popMatrix();

    // Collar left
    pushMatrix();
    rotateZ(radians(-135));
    prism(Wbody/4, 0);    
    translate(0, Wbody/4, 0);    
    rotateZ(radians(35));
    prism(Wbody/4, 0); 

    ////  Update Left Hand Value
    translate(0, Wbody/4, 0);    
    rotateZ(radians(100));  
    rotateX(radians(15));       
    hand_left.Update();
    popMatrix();    

    // -----------------------------------------------------

    prism(Hbody/6, 180);  
    translate(0, -Hbody/6, 0);    
    rotateX(radians(a[6].x));
    prism(Hbody/10, 180); 
    translate(0, -Hbody/10, 0);   

    //---------------HEAD----------------
    head.Update();    
    popMatrix(); 

    //---------------Pelvis--------
    //--------------RIGHT LEG-------------------
    pushMatrix();   
    translate(0, Hbody/6 * 5, 0);          
    rotateZ(radians(55));
    prism(Hbody/4, 0);    
    translate(0, Hbody/4, 0); 
    rotateZ(radians(-55));
    leg_right.Update();
    popMatrix();

    //--------------LEFT LEG------------------
    pushMatrix();  
    translate(0, Hbody/6 * 5, 0); 
    rotateZ(radians(-55));
    prism(Hbody/4, 0);    
    translate(0, Hbody/4, 0); 
    rotateZ(radians(55));
    leg_left.Update();
    popMatrix();

    popMatrix();
  }
}

class Hand
{
  PVector r1, r2; 
  float[] axis1 = new float[4];
  float[] axis2 = new float[4];
  float bend = 5; //degree

  Hand()
  {
  }

  void Rotation(float rx1, float ry1, float rz1, 
  float rx2, float ry2, float rz2)
  {
    r1 = new PVector(rx1, ry1, rz1);
    r2 = new PVector(rx2, ry2, rz2);
  }

  void QuatRotation(float ax0, float ax1, float ax2, float ax3, 
  float axx0, float axx1, float axx2, float axx3)
  {
    axis1[0] = ax0;    
    axis1[1] = ax1;    
    axis1[2] = ax2;    
    axis1[3] = ax3;  
    axis2[0] = axx0;    
    axis2[1] = axx1;    
    axis2[2] = axx2;    
    axis2[3] = axx3;
  }

  void Update()
  {
    pushMatrix();

    rotateX(radians(r1.x-bend));
    rotateY(radians(r1.y));
    rotateZ(radians(r1.z));      

//    rotate(axis1[0], axis1[1], axis1[2], axis1[3]);  
    prism(Hhand, 0);  // Joint    

    // noFill();    
    //fill(#FF8800);

    translate(0, Hhand, 0);
    rotateX(radians(r2.x+bend*1.5));
    rotateY(radians(r2.y));
    rotateZ(radians(r2.z));  

//    rotate(axis2[0], axis2[1],0,0); 
    prism(Hhand, 0);  // Joint
    //fill(#00FF00);

    translate(0, Hhand, 0);     
    sphere(Hhand*0.08);  
    // box(Whand/1.5, Hhand/4, Dhand/2.5);
    popMatrix();
  }
}

class Leg
{
  PVector hr, kr, ar; 
  float bend = 5; //degree

  Leg()
  {
  }

  void HipRotation(float rx, float ry, float rz)
  {  
    hr = new PVector(rx, ry, rz);
  }

  void KneeRotation(float rx, float ry, float rz)
  {  
    kr = new PVector(rx, ry, rz);
  }

  void AnkleRotation(float rx, float ry, float rz)
  {  
    ar = new PVector(rx, ry, rz);
  }

  void Update()
  {
    pushMatrix();
    rotateX(radians(hr.x + bend));
    rotateY(radians(hr.y));
    rotateZ(radians(hr.z));        
    prism(Hleg, 0);    //Joint

    //fill(#00FF00);
    //noFill();    

    translate(0, Hleg, 0);
    rotateX(radians(kr.x - bend*2));
    rotateY(radians(kr.y));
    rotateZ(radians(kr.z));
    prism(Hleg, 0);    //Joint 

    //fill(#FF8800);
    translate(0, Hleg, 0); // Ankle   
    rotateX(radians(ar.x + bend/2)); 
    rotateZ(radians(ar.z));
    prism(WfootSole, 90);

    //  box(WfootSole, HfootSole, DfootSole);
    popMatrix();
  }
}

void prism(float a, float rot)
{   

  float b = a*0.08;
  float c = sqrt((a-b)*(a-b) + b*b);
  pushMatrix();

  stroke(255, 0, 0);


  rotateX(radians(rot));
  sphere(b);
  translate(0, a, 0);
  beginShape(TRIANGLE);    
  fill(0, 255, 0);
  vertex(-b, -c, -b);
  vertex( b, -c, -b);
  vertex( 0, 0, 0);

  vertex( b, -c, -b);
  vertex( b, -c, b);
  vertex( 0, 0, 0);

  vertex(b, -c, b);
  vertex(-b, -c, b);
  vertex( 0, 0, 0);

  vertex( -b, -c, b);
  vertex( -b, -c, -b);
  vertex( 0, 0, 0);
  endShape();
  stroke(0, 0, 255);

  popMatrix();
}

