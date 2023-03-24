class Arm
{
  int sc = 10;
  PShape base, link1,link2,link3, joint1,joint2;  
  float[] r = new float[5];  //angle rotation --> Euler or YPR
  float[] q1 = new float[4];  //angle rotation --> Quaternion
  float[] q2 = new float[4];
  
  Arm()
  {
      base = loadShape("Joint2.obj");           base.scale(sc);
      link1 = loadShape("Link2.obj");           link1.scale(sc);
      link2 = loadShape("Link1.obj");           link2.scale(sc);
      link3 = loadShape("Link3.obj");           link3.scale(sc);
      joint1 = loadShape("Joint1trial.obj");    joint1.scale(sc);
      joint2 = loadShape("Joint1trial.obj");    joint2.scale(sc);
      
      q1[0]=1.0f; q1[1]=0.0f;  q1[2]=0.0f;  q1[3]=0.0f;
      q2[0]=1.0f; q2[1]=0.0f;  q2[2]=0.0f;  q2[3]=0.0f;
  }
  
  void rotQuatArm1(float[] quat)
  {
    q1[0] = quat[0];  q1[1] = quat[1];  q1[2] = quat[2];  q1[3] = quat[3];
  }
  
  void rotQuatArm2(float[] quat)
  {
    q2[0] = quat[0];  q2[1] = quat[1];  q2[2] = quat[2];  q2[3] = quat[3];
  }
  
  void rotArm1(float yaw, float pitch, float roll)
  {
    r[0] = radians(yaw);  r[1] = radians(pitch);  r[2] = radians(roll);
  }
  
  void rotArm2(float yaw, float pitch, float roll)
  {
    r[3] = radians(yaw);  r[4] = radians(pitch);  
  }
  
  void update()
  {   pushMatrix();////////////////
      rotateZ(PI);
      
      pushMatrix();
      translate(0, height/4,0);  
      shape(base);
      
      translate(0,0,sc*2.4);  
      rotateZ(r[2]);  //---Rotate roll
      //rotate(q1[0], 0,0, q1[1]);
      //rotate(1, 0, 0 ,1);
      shape(link1);
      
      rotateY(PI/2);  
      translate(-sc*4.3,0,0);
      rotateZ(r[1]);    //---Rotate pitch
      //rotate(q1[0], 0,0, q1[2]);
      //rotate(1, 0, 0 ,1);
      shape(joint1);  
      
      rotateY(PI/2);
      rotateX(PI/2);
      translate(0,0,sc*6.6);
      rotateZ(-r[0]);  ////---Rotate yaw
      //rotate(q1[0],0,0,q1[3]);
      //rotate(1, 0, 0 ,1);
      shape(link2);
      
      ///-----------2nd Position
      rotateY(PI/2);  
      rotateX(PI);
      translate(-sc*13.8,0,0);
      rotateZ(radians(-90));
      rotateZ(-r[4]);  //---Rotate pitch
      //rotate(1, 0, 0 ,1);
      shape(joint2);  
      
      //rotateY(PI/2);
      rotateX(PI/2);
      translate(0,0,sc*6.6);
      rotateZ(-r[3]);  //---Rotate yaw
      rotate(q2[0],0,0,q2[3]);
      //rotate(1, 0, 0 ,1);
      shape(link3);
    
      popMatrix();
      
      popMatrix();  ///////////////////
  }
}
