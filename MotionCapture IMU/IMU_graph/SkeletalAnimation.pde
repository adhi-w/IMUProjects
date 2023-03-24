import processing.opengl.*; 
int frame_width = width/2;
int frame_height = height;

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

Body body = new Body(frame_width/2, frame_height/2-200, 0);    
Head head = new Head(0, 0, 0);
    
Hand hand_left = new Hand(0, 0, 0);    
Hand hand_right = new Hand(0, 0, 0);

Leg leg_left = new Leg(0, 0, 0);
Leg leg_right = new Leg(0, 0, 0);

// Input Data from Serial Comm
  float hip_pitch_l = 0;//180;
  float hip_roll_l = 0;
  float hip_yaw_l = 0;//180;  
  float knee_pitch_l = 0;//180;  
  float ankle_pitch_l = 0;//180;
  float ankle_yaw_l = 0;//180;
  
  float hip_pitch_r = 180;
  float hip_roll_r = 0;
  float hip_yaw_r = 180;  
  float knee_pitch_r = 180;  
  float ankle_pitch_r = 180;
  float ankle_yaw_r = 180;
//------------------------------

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

void setup_SkeletalAnimation()
{
  rol++;
  
//  // Put Your Input Data here
//  hip_pitch_l = 0;//pitch_1;//180;
//  hip_roll_l = 0;//roll_1;//180;
//  hip_yaw_l = 0;  //0
//  knee_pitch_l = 0;//yaw_1;  
//  ankle_pitch_l = 0; //180;
//  ankle_yaw_l = 0; //180;
//  
//  hip_pitch_r = 0;//pitch_2;//180;
//  hip_roll_r = 0;//roll_2;//180;
//  hip_yaw_r = 180;  
//  knee_pitch_r = 0;//yaw_2;  
//  ankle_pitch_r = 180;
//  ankle_yaw_r = 180;
  
 
  //------------------------------
  
  
  ortho(0,width, 0,height, -1000,1000);    
//  lights(); 
//  smooth();
 //draw_SkeletalAnimation();  
  draw_Motion();
  stroke(0,0,255); 
}

PVector v2, v3,vv3;
PVector pt2,pt3,ptt3;
PVector ps1,ps2,ps3;

void draw_Motion()
{

  pushMatrix();  
//  translate(apos[0]/1, apos[2]/1, 0);
  
//  convert_Euler(euler, q1); 
//  rotateY(radians(ypr1[0])); 
//  rotateX(radians(ypr1[1]));
//  rotateZ(radians(ypr1[2]));
//  
//  println(q1[0] +"\t"+ q1[1] +"\t"+ q1[2] +"\t"+ q1[3]);
  
  quat1.set(q1[0], q1[1], q1[2], q1[3]);
    float[] axis1 = quat1.toAxisAngle();
  
  translate(frame_width/2-150, frame_height/2-roll_1, 0);  //
  fill(#0000FF);
  textFont(font18);
  text("Quaternion", 0, 150);
  
  //rotate(axis1[0], -axis1[2], axis1[3], -axis1[1]);   
  rotate(axis1[0], -axis1[1], -axis1[2], -axis1[3]);  
  //rotate(axis1[0], axis1[1], axis1[2], axis1[3]);
  fill(255,0,0);
  box(55,100,200);
  popMatrix();
  /////////////////////////////////////////////////////
  
  
  pushMatrix();

  
  fill(#00FF00);
  translate(frame_width/2+150, frame_height/2-roll_1, 0);
  textFont(font18);
  //text("YPR", 0, 150);

//  rotateY(radians(ypr1[0])); //ypr1  ypr2  euler
//  rotateX(radians(ypr1[1]));
//  rotateZ(radians(-euler[2]));

    quat2.set(q2[0], q2[1], q2[2], q2[3]);
    float[] axis2 = quat2.toAxisAngle();
    
  //  rotate(axis2[0], -axis2[2], axis2[3], -axis2[1]);  
   
   v1 = new PVector(100,0,0);
   v2 = new PVector(0,100,0);
   v3 = new PVector(0,0,100);
   vv3 = new PVector(0,0,-100);
   
   
   PVector d1=new PVector(20,20,0);
   PVector d2=new PVector(20,-20,0);
   PVector d3=new PVector(-20,-20,0);
   PVector d4=new PVector(-20,20,0);
   
   PVector a1=quat2rotmatrix(q1,d1);
   PVector a2=quat2rotmatrix(q1,d2);
   PVector a3=quat2rotmatrix(q1,d3);
   PVector a4=quat2rotmatrix(q1,d4);
   
    // Trial--
    
    pp = rotMatrix_ZYX(euler,v1);
   
   //-----First joint
   pt1 = quat2rotmatrix(q1,v1);
    pt2 = quat2rotmatrix(q1,v2);
     pt3 = quat2rotmatrix(q1,v3);
     ptt3 = quat2rotmatrix(q1,vv3);
     
     PVector vv1 = new PVector(200,0,0);
     PVector vv2 = new PVector(0,200,0);
     PVector vv3 = new PVector(0,0,200);
     
     //PVector c1=quat2rotmatrix(q2,v1);
     float[] qq = new float[4];
     qq[0]=q1[0]+q2[0];
     qq[1]= q1[1]+q2[1];
     qq[2]= q1[2]+q2[2];
     qq[3]= q1[3]+q2[3];
     
    //------2nd Joint
    ps1 = quat2rotmatrix(qq,v1);
     ps2 = quat2rotmatrix(q2,vv2);
      ps3 = quat2rotmatrix(q2,vv3);
     
   strokeWeight(4);     
   stroke(255,0,0);
   line(0,0,0, pt1.x, pt1.y, pt1.z);        //line(pt3.x, pt3.y, pt3.z, ps1.x, ps1.y, ps1.z);     
     stroke(0,0,255);
     line(0,0,0, pt2.x, pt2.y, pt2.z);      //line(pt3.x, pt3.y, pt3.z, ps2.x, ps2.y, ps2.z);
       stroke(0,255,0);
       line(0,0,0, pt3.x, pt3.y, pt3.z);    //line(pt3.x, pt3.y, pt3.z, ps3.x, ps3.y, ps3.z);
       //line(0,0,0, ptt3.x, ptt3.y, ptt3.z); 
        
        stroke(255,0,0);
//        line(0, 0, 0, a.x, a.y, a.z);
//        line(pt3.x, pt3.y, pt3.y, pt2.x+a.x, pt3.y+a.y, pt3.y+a.z);
//        line(a1.x, a1.y, a1.z, pt3.x+a1.x, pt3.y+a1.y, pt3.y+a1.z);  //correct
//         line(a2.x, a2.y, a2.z, pt3.x+a2.x, pt3.y+a2.y, pt3.y+a2.z);
//          line(a3.x, a3.y, a3.z, pt3.x+a3.x, pt3.y+a3.y, pt3.y+a3.z);
//           line(a4.x, a4.y, a4.z, pt3.x+a4.x, pt3.y+a4.y, pt3.y+a4.z);
           
//           line(ptt3.x+a4.x, ptt3.y+a4.y, ptt3.z+a4.z, ptt3.x+a1.x, ptt3.y+a1.y, ptt3.z+a1.z);
//           line(ptt3.x+a1.x, ptt3.y+a1.y, ptt3.z+a1.z, ptt3.x+a2.x, ptt3.y+a2.y, ptt3.z+a2.z);
//           line(ptt3.x+a2.x, ptt3.y+a2.y, ptt3.z+a2.z, ptt3.x+a3.x, ptt3.y+a3.y, ptt3.z+a3.z);
//           line(ptt3.x+a3.x, ptt3.y+a3.y, ptt3.z+a3.z, ptt3.x+a4.x, ptt3.y+a4.y, ptt3.z+a4.z);
           
           beginShape(QUAD);
           fill(0,0,255);
           vertex(ptt3.x+a1.x, ptt3.y+a1.y, ptt3.z+a1.z);            
           vertex(ptt3.x+a2.x, ptt3.y+a2.y, ptt3.z+a2.z); 
           vertex(ptt3.x+a3.x, ptt3.y+a3.y, ptt3.z+a3.z);           
           vertex(ptt3.x+a4.x, ptt3.y+a4.y, ptt3.z+a4.z);  
            
           vertex(pt3.x+a1.x, pt3.y+a1.y, pt3.y+a1.z);
           vertex(pt3.x+a2.x, pt3.y+a2.y, pt3.y+a2.z); 
           vertex(pt3.x+a3.x, pt3.y+a3.y, pt3.y+a3.z); 
           vertex(pt3.x+a4.x, pt3.y+a4.y, pt3.y+a4.z);
           
           vertex(ptt3.x+a1.x, ptt3.y+a1.y, ptt3.z+a1.z);
           vertex(ptt3.x+a2.x, ptt3.y+a2.y, ptt3.z+a2.z);            
           vertex(pt3.x+a2.x, pt3.y+a2.y, pt3.y+a2.z); 
           vertex(pt3.x+a1.x, pt3.y+a1.y, pt3.y+a1.z);
           
           vertex(ptt3.x+a2.x, ptt3.y+a2.y, ptt3.z+a2.z); 
           vertex(ptt3.x+a3.x, ptt3.y+a3.y, ptt3.z+a3.z); 
           vertex(pt3.x+a3.x, pt3.y+a3.y, pt3.y+a3.z); 
           vertex(pt3.x+a2.x, pt3.y+a2.y, pt3.y+a2.z);
           
           vertex(ptt3.x+a3.x, ptt3.y+a3.y, ptt3.z+a3.z);           
           vertex(ptt3.x+a4.x, ptt3.y+a4.y, ptt3.z+a4.z);           
           vertex(pt3.x+a4.x, pt3.y+a4.y, pt3.y+a4.z);
           vertex(pt3.x+a3.x, pt3.y+a3.y, pt3.y+a3.z); 
           
           vertex(ptt3.x+a4.x, ptt3.y+a4.y, ptt3.z+a4.z);
           vertex(ptt3.x+a1.x, ptt3.y+a1.y, ptt3.z+a1.z);
           vertex(pt3.x+a1.x, pt3.y+a1.y, pt3.y+a1.z);
           vertex(pt3.x+a4.x, pt3.y+a4.y, pt3.y+a4.z);
           
           endShape();
    
//    rotateX(PI/2);
//     stroke(0,255,0);
//      line(0,0,0, pt.x, pt.y, pt.z);
//  box(40,40,100);
  popMatrix();
  
}

void draw_SkeletalAnimation()
{    
  
  fill(#FF8800);  
    
    pushMatrix();       
//    directionalLight(255, 255, 255, -1, 1, -1);
//    directionalLight(128, 128, 128, 1, -1, 1);
   
    quat1.set(q1[0], q1[1], q1[2], q1[3]);
    float[] axis1 = quat1.toAxisAngle();
    
    quat2.set(q2[0], q2[1], q2[2], q2[3]);
    float[] axis2 = quat2.toAxisAngle();


   //  simulation();
   
    // Initialization  --> Rotation
     //input_data();
      
    head.Rotation(0,0,0);    
    
    body.AllBodyRotation(0, 0, 0);//rotb
    body.UpperBodyRotation(rotx, roty, 0);    
    
    hand_left.Rotation(ypr1[2], ypr1[0] , ypr1[1] ,
                  ypr2[2], ypr2[0] , -bend_z*0.5);  
                  
    hand_left.QuatRotation(axis1[0], -axis1[2], axis1[3], -axis1[1],
                          axis2[0], -axis2[2], axis2[3], -axis2[1]);     

   hand_right.QuatRotation(axis1[0], -axis1[1], -axis1[3], -axis1[2],
                         // axis2[0], -axis2[1], -axis2[3], -axis2[2]);
                       axis2[0]-axis1[0], -axis2[1]+axis1[1], -axis2[3]+axis1[3], -axis2[2]+axis1[2]);   
                          
    hand_right.Rotation(0, 0 , 0,
                  0, 0 , bend_z*0.5);
                   
    leg_left.HipRotation(hip_l[0], hip_l[1] , hip_l[2] -bend_z);
    leg_left.KneeRotation(knee_l[0], knee_l[1], knee_l[2] +bend_z*1.2 );
    leg_left.AnkleRotation(ankle_l[0], ankle_l[1] , ankle_l[2] );
           
    leg_right.HipRotation(hip_r[0], hip_r[1] , hip_r[2] +bend_z);
    leg_right.KneeRotation(knee_r[0], knee_r[1], knee_r[2] -bend_z*1.2);  
    leg_right.AnkleRotation(ankle_r[0], ankle_r[1] , ankle_r[2] );    
    
    body.PelvisTrans(0,0,0);
    //body.PelvisTrans(pelv[0], pelv[1], pelv[2]);  //pelv[1]
    body.Update();
         
    popMatrix();
}

void input_data()
{ 
  float[] hl = new float[3];  // {0,1,2} --> x,y,z
  float[] kl = new float[3];
  float[] al = new float[3];
  
  float[] hr = new float[3];
  float[] kr = new float[3];
  float[] ar = new float[3];
  
  
  //--------------- LEFT FOOT ---------------
//  hl[0] = hip_pitch_l;  //180+
//        if(hl[0]>=310)  hl[0] = 310;
//        if(hl[0]<=145)  hl[0] = 145;
//        
//  hl[1] = hip_yaw_l;  //180
//        if(hl[1]>=210)  hl[1] = 210;
//        if(hl[1]<=150)  hl[1] = 150;
//        
//  hl[2] = hip_roll_l;
//  
//  kl[0] = 180+knee_pitch_l;
//      if(kl[0]>=180+180)  kl[0] = 180+180;
//      if(kl[0]<=180+30)  kl[0] = 180+30;
//      
//   al[0] = 180+ankle_pitch_l;      
//        if(al[0]>=180+210)  al[0] = 180+210;
//        if(al[0]<=180+90)  al[0] = 180+90;
//        
//   al[2] = 180+ankle_yaw_l; 
// //----------------------------------------------------
// 
//   //--------------- RIGHT FOOT ---------------
//  hr[0] = 180+hip_pitch_r;  
//        if(hr[0]>=180+310)  hr[0] = 180+310;
//        if(hr[0]<=180+145)  hr[0] = 180+145;
//        
//  hr[1] = 180+hip_yaw_r;  
//        if(hr[1]>=180+210)  hr[1] = 180+210;
//        if(hr[1]<=180+150)  hr[1] = 180+150;
//        
//  hr[2] = -hip_roll_r;
//  
//  kr[0] = knee_pitch_r;
//      if(kr[0]>=180)  kr[0] = 180;
//      if(kr[0]<=30)  kr[0] = 30;
//      
//   ar[0] = 180+ankle_pitch_r;      
//        if(ar[0]>=180+210)  ar[0] = 180+210;
//        if(ar[0]<=180+90)  ar[0] = 180+90;
//        
//   ar[2] = 180+ankle_yaw_r; 
   
   //----------------------------------------------------
   
   //------------Send to Skeletal Angle
   //----  x-axis  ----------  y-axis  ----------------  z-axis  -------
//   hip_l[0] = hl[0];        hip_l[1] = hl[1];        hip_l[2] = hl[2];
//   hip_r[0] = hr[0];        hip_r[1] = hr[1];        hip_r[2] = hr[2];
//   knee_l[0] = kl[0];
//   knee_r[0] = kr[0];
//   ankle_l[0] = al[0];                               ankle_l[2] = al[2];
//   ankle_r[0] = ar[0];                               ankle_r[2] = ar[2];
//   
   //--------------------------------------
   
   //----------Find Pelvis Point------
   //--Find Hip L/R
   float l1 = Hleg;       float l2 = Hleg;    float leg =  2*Hleg;
   float xal, xar, yal, yar, zal, zar;     // ankle position 
   float px, py, pz;
   float ht = hl[2] + hr[2];
   
   yal = l1*cos(radians(hl[0])) + l2*cos(radians(180+hl[0] + 180+kl[0]));
   zal = l1*sin(radians(hl[0])) + l2*sin(radians(180+hl[0] + 180+kl[0]));
   
   yar = l1*cos(radians(hr[0])) + l2*cos(radians(180+hr[0] + 180+kr[0]));
   zar = l1*sin(radians(hr[0])) + l2*sin(radians(180+hr[0] + 180+kr[0]));
   
   if(ht >0)  // Left
   {
     pelv[0] = leg*sin(radians(hl[2]));
     pelv[1] = leg-yal;
   }
   if(ht <0)  // Right
   {
     pelv[0] = leg*sin(radians(hr[2]));
     pelv[1] = leg-yar;
   }
    
   pelv[2] = (zal + zar)/2;   
 
}

void simulation()
{
  
  hr_x++;
  hl_x++;
  hip_l[0] = 50*sin(hl_x);
  hip_r[0] = 50*cos(hl_x); myDelay(80);
}

class Head
{
  PVector p, r;
  
  Head(float x, float y, float z)
  {  p = new PVector(x, y, z);  }  
    
  void Rotation(float rx, float ry, float rz)
  {  r = new PVector(rx, ry, rz);  }
  
  void Update()
  {
    pushMatrix();    
    translate(p.x, p.y, p.z); 
    rotateX(radians(r.x));
    rotateY(radians(r.y));
    rotateZ(radians(r.z));  
    
    prism(Hhead,180);   
    
   // noFill();
   // box(Whead, Hhead, Dhead);
    popMatrix();
  }
}

class Body
{
  PVector p, pelvis, r, mr;
  float bend = 5; //degree
  float[] b = new float[7];
  
  Body(float x, float y, float z)
  {  p = new PVector(x, y, z); }  
  
  void PelvisTrans(float x, float y, float z)
  {  pelvis = new PVector(x, y, z);  }
  
  void AllBodyRotation(float rx, float ry, float rz)
  {  mr = new PVector(rx, ry, rz);  }
  
  void UpperBodyRotation(float rx, float ry, float rz)
  {  r = new PVector(rx, ry, rz);  }
  
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
    translate(p.x, p.y, p.z); 
    translate(pelvis.x, pelvis.y, pelvis.z); 
      rotateX(radians(mr.x));
      rotateY(radians(mr.y));
      rotateZ(radians(mr.z));
       
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
        prism(Hbody/6,180);  translate(0, -Hbody/6, 0);    rotateX(radians(a[2].x));
        prism(Hbody/6,180);  translate(0, -Hbody/6, 0);    rotateX(radians(a[3].x));
        prism(Hbody/6,180);  translate(0, -Hbody/6, 0);    rotateX(radians(a[4].x));
        prism(Hbody/6,180);  translate(0, -Hbody/6, 0);    rotateX(radians(a[5].x));
        
           // Collar right ------------HAND------------------
           pushMatrix();
           rotateZ(radians(135));
           prism(Wbody/4,0);    
           translate(0,Wbody/4,0);    rotateZ(radians(-35));
           prism(Wbody/4,0); 
           
           ////  Update Right Hand Value
           translate(0,Wbody/4,0);    rotateZ(radians(-100));  rotateX(radians(15));       
           hand_right.Update();
           popMatrix();
            
           // Collar left
           pushMatrix();
           rotateZ(radians(-135));
           prism(Wbody/4,0);    
           translate(0,Wbody/4,0);    rotateZ(radians(35));
           prism(Wbody/4,0); 
           
           ////  Update Left Hand Value
           translate(0,Wbody/4,0);    rotateZ(radians(100));  rotateX(radians(15));       
           hand_left.Update();
           popMatrix();    
    
           // -----------------------------------------------------
           
        prism(Hbody/6,180);  translate(0, -Hbody/6, 0);    rotateX(radians(a[6].x));
        prism(Hbody/10,180); translate(0, -Hbody/10, 0);   
        
        //---------------HEAD----------------
        head.Update();    
        popMatrix(); 
        
            //---------------Pelvis--------
            //--------------RIGHT LEG-------------------
            pushMatrix();   
            translate(0, Hbody/6 * 5, 0);          
            rotateZ(radians(55));
            prism(Hbody/4,0);    translate(0, Hbody/4, 0); rotateZ(radians(-55));
            leg_right.Update();
            popMatrix();
            
            //--------------LEFT LEG------------------
            pushMatrix();  
            translate(0, Hbody/6 * 5, 0); 
            rotateZ(radians(-55));
            prism(Hbody/4,0);    translate(0, Hbody/4, 0); rotateZ(radians(55));
            leg_left.Update();
            popMatrix();
    
    popMatrix();  
  }
}

class Hand
{
  PVector p, r1, r2; 
  float[] axis1 = new float[4];
  float[] axis2 = new float[4];
  float bend = 5; //degree
  
  Hand(float x, float y, float z)
  {  p = new PVector(x, y, z);  }
  
  void Rotation(float rx1, float ry1, float rz1,
                float rx2, float ry2, float rz2)
  {
    r1 = new PVector(rx1, ry1, rz1);
    r2 = new PVector(rx2, ry2, rz2);
  }
  
  void QuatRotation(float ax0, float ax1, float ax2, float ax3,
                float axx0, float axx1, float axx2, float axx3)
  {
    axis1[0] = ax0;    axis1[1] = ax1;    axis1[2] = ax2;    axis1[3] = ax3;  
    axis2[0] = axx0;    axis2[1] = axx1;    axis2[2] = axx2;    axis2[3] = axx3; 
  }
  
  void Update()
  {
    pushMatrix();
    
    
    translate(p.x, p.y, p.z);
    rotateX(radians(r1.x-bend));
    rotateY(radians(r1.y));
    rotateZ(radians(r1.z));      
   
    rotate(axis1[0], axis1[1], axis1[2], axis1[3]);  
    prism(Hhand,0);  // Joint    
    
    noFill();    
    //fill(#FF8800);
  
    translate(0, Hhand, 0);
    rotateX(radians(r2.x+bend*1.5-r1.x));
    rotateY(radians(r2.y-r1.y));
    rotateZ(radians(r2.z));  
    
    rotate(axis2[0], axis2[1], axis2[2], axis2[3]); 
    prism(Hhand,0);  // Joint
    //fill(#00FF00);
    
    translate(0, Hhand, 0);     
    sphere(Hhand*0.08);  
   // box(Whand/1.5, Hhand/4, Dhand/2.5);
    
    popMatrix();
  }  
}

class Leg
{
  PVector p, hr, kr, ar; 
  float bend = 5; //degree
  
  Leg(float x, float y, float z)
  {  p = new PVector(x, y, z);  }
  
  void HipRotation(float rx, float ry, float rz)
  {  hr = new PVector(rx, ry, rz);  }
  
  void KneeRotation(float rx, float ry, float rz)
  {  kr = new PVector(rx, ry, rz);  }
  
  void AnkleRotation(float rx, float ry, float rz)
  {  ar = new PVector(rx, ry, rz);  }
  
  void Update()
  {
    pushMatrix();
    
    translate(p.x, p.y, p.z);
    rotateX(radians(hr.x + bend));
    rotateY(radians(hr.y));
    rotateZ(radians(hr.z));        
    prism(Hleg,0);    //Joint
   
    //fill(#00FF00);
    noFill();    
    
    translate(0, Hleg, 0);
    rotateX(radians(kr.x - bend*2));
    rotateY(radians(kr.y));
    rotateZ(radians(kr.z));
    prism(Hleg,0);    //Joint 
  
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
  
  stroke(0,255,0);
   
  rotateX(radians(rot));
  sphere(b);
  translate(0, a, 0);
  beginShape();
  vertex(-b, -c, -b);
  vertex( b, -c, -b);
  vertex( 0,  0,  0);
  
  vertex( b, -c, -b);
  vertex( b, -c,  b);
  vertex( 0,  0,  0);
  
  vertex(b,  -c, b);
  vertex(-b, -c, b);
  vertex( 0,  0, 0);
  
  vertex( -b, -c, b);
  vertex( -b, -c, -b);
  vertex( 0,  0,  0);
  endShape();
  stroke(0,0,255);
  
  popMatrix();
}

void myDelay(int ms)
{
  try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e) {
  }
}







