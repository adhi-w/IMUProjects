class robot
{
  float sc=5;
  PShape hip, legU, legL, ankle, lfoot, rfoot, waist, body;
  PShape neck, head, shoulder, uarm, larm, conarm; 
  
  // Rotation for Foot --> Euler or YPR
  float[] r1=new float[6];  //Rotation for Right Foot
  float[] r2=new float[6];  //Rotation for Left Foot
  float[] h1=new float[4];  //Rotation for Right Hand
  float[] h2=new float[4];  //Rotation for Right Hand
  float[] hd=new float[2];  //Rotation for Head
  float rb;  // Rotation for Body
     
  robot()
  {
    hip = loadShape("HIP_Servo.obj");    hip.scale(sc);
    legU = loadShape("LEGupper.obj");    legU.scale(sc);
    legL = loadShape("LEGlower.obj");    legL.scale(sc);
    ankle = loadShape("HIP_Servo.obj");  ankle.scale(sc);
    lfoot = loadShape("Foot.obj");       lfoot.scale(sc); 
    rfoot = loadShape("RightFoot.obj");  rfoot.scale(sc);  
    waist =  loadShape("Waist.obj");     waist.scale(sc);
    body =  loadShape("Body.obj");     body.scale(sc);
    
    neck =  loadShape("Neck.obj");     neck.scale(sc);
    head = loadShape("Head.obj");     head.scale(sc);
    shoulder = loadShape("Shoulder.obj");     shoulder.scale(sc);
    uarm = loadShape("UpperArm.obj");     uarm.scale(sc);
    conarm = loadShape("ArmConnector.obj");     conarm.scale(sc);
    larm = loadShape("ARMlower.obj");     larm.scale(sc);
    
  }
  
  void rotBody(float rbody)
  {
    rb = radians(rbody);
  }
  
  void rotHead(float pan, float tilt)
 {
   hd[0] = radians(pan);    hd[1] = radians(tilt);
 } 
  
  //-------------Hand Input Rotation------------------
  void rotHand_Right(float pitch_up, float roll_up, float yaw_up, float pitch_low  )
  {
    h1[0] = radians(pitch_up);    h1[1] = radians(roll_up);
    h1[2] = radians(yaw_up);    h1[3] = radians(pitch_low);
  }
  
  void rotHand_Left(float pitch_up, float roll_up, float yaw_up, float pitch_low  )
  {
    h2[0] = radians(pitch_up);    h2[1] = radians(roll_up);
    h2[2] = radians(yaw_up);    h2[3] = radians(pitch_low);
  }
  
  //-------------Foot Input Rotation------------------
  void rotFoot_Right(float hip_yaw, float hip_pitch, float hip_roll,
                      float knee, float ankle_pitch, float ankle_roll)
  {
    r1[0] = radians(hip_yaw);  r1[1] = radians(hip_pitch);   r1[2] = radians(hip_roll); 
    r1[3] = radians(knee);  r1[4] = radians(ankle_pitch);   r1[5] = radians(ankle_roll);
  }
  
  void rotFoot_Left(float hip_yaw, float hip_pitch, float hip_roll,
                      float knee, float ankle_pitch, float ankle_roll)
  {
    r2[0] = radians(hip_yaw);  r2[1] = radians(hip_pitch);   r2[2] = radians(hip_roll); 
    r2[3] = radians(knee);  r2[4] = radians(ankle_pitch);   r2[5] = radians(ankle_roll);
  }
  
  void update()
  { pushMatrix();
  
    rotateZ(PI/2);
    rotateX(PI);
    
    waist();  // --> contains body(head & hand) & foot
    
    popMatrix();
  }
  
  //-----------Body Segments Drawing---------------
  
  ///====================================================
  void waist()    //Center of Movement
  {
    pushMatrix();
    rotateZ(PI/2);
    rotateY(PI);
    translate(0,sc*10,0);
    shape(waist);
    
    //-----Put Body function here------//
    body();
    
    //-----Put Foot function here------//
    leg_Right();    
    leg_Left();
    popMatrix();
  }
  //============================================================
  
  void head()
  {
    pushMatrix();
    rotateX(PI/2);
    rotateY(PI);  
    translate(-sc*0.35, sc*0.2, sc*23); 
    rotateZ(-hd[0]);    // Rotate Pan Head    
     shape(neck);
    
    rotateX(-PI/2);
    rotateZ(PI);
    rotateZ(-hd[1]);    // Rotate Tilt Head    
    shape(head); 
    
    fill(0,0,200); 
    translate(sc*3.6, sc*3.4,0);
    box(0.5, sc*2, sc*6);
    popMatrix();    
  }
  
  
  void body()
  {
    pushMatrix();
    rotateY(-PI/2);
    rotateZ(-rb);    // Rotate body
    shape(body);
    
    //-----Put Head function here------//
    head();
    
    //-----Put Hand function here------//
    hand_Right();
    hand_Left();
    
    popMatrix();
  }
  
  void hand_Right()
  {
    pushMatrix();
    translate(sc*0.4, sc*13.8, -sc*13);
    rotateZ(h1[0]);    // Rotate Pitch Upper Hand
    shape(shoulder);
    
    rotateY(PI/2);
    translate(0,0,sc*0.8);
    rotateZ(h1[1]);  // Rotate roll Upperhand
    shape(uarm);
    
    rotateX(PI/2);
    translate(0,0, sc*25.5);
    rotateZ(h1[2]);  //rotate yaw Upper hand
    shape(conarm);
    
    rotateY(PI/2);
    rotateZ(PI);
    rotateZ(-h1[3]);  //Rotate pitch lower hand
    shape(larm);
    popMatrix();
  }
  
    void hand_Left()
  {
    pushMatrix();
    //rotateZ(PI/2);
    //rotateY(PI/2);
    rotateX(PI);
    translate(sc*0.4, -sc*13.8, -sc*13.3);
    
    rotateZ(-h2[0]);    // Rotate Pitch Upper Hand
    shape(shoulder);
    
    rotateY(PI/2);
    rotateZ(PI);
    translate(0,0,sc*0.8);
    rotateZ(-h2[1]);  // Rotate roll Upperhand
    shape(uarm);
    
    rotateX(PI/2);
    translate(0,0, sc*25.5);
    rotateZ(h2[2]);  //rotate yaw Upper hand
    shape(conarm);
    
    rotateY(PI/2);
    rotateX(PI);
    rotateZ(PI);
    rotateZ(h2[3]);  //Rotate pitch lower hand
    shape(larm);
    popMatrix();
  }
  
  void leg_Right()
  {    
    pushMatrix();
    translate(sc*5.5,-sc*10.2,0);
    
    rotateZ(-PI/2);
    rotateX(-PI/2);
    rotateX(-r1[0]);    //// Rotate Hip_Yaw    
    rotateY(-r1[2]);    // Rotate Hip_Roll
    shape(hip);
    
    rotateZ(-r1[1]);    // Rotate Hip_Pitch
    shape(legU);
    
    rotateZ(PI/2);
    rotateY(PI);    
    translate(0,-sc*25,0);
    rotateZ(-r1[3]);    // Rotate Knee
    shape(legL);  
    
    rotateZ(PI/2);
    translate(-sc*25, 0,0);
    rotateZ(-r1[4]);    // Rotate Ankle Pitch
    shape(ankle);  
    
    rotateZ(PI);    
    rotateX(PI/2);
    rotateX(PI);    
    rotateZ(r1[5]);    // Rotate Ankle Roll
    shape(lfoot); 
    
    popMatrix();
  }
  
  void leg_Left()
  {         
    pushMatrix();
    translate(-sc*5.5, -sc*10.2,0);
    
    rotateZ(-PI/2);
    rotateX(-PI/2);
    rotateX(-r2[0]);    //// Rotate Hip_Yaw    
    rotateY(-r2[2]);    // Rotate Hip_Roll
    shape(hip);
    
    rotateZ(-r2[1]);    // Rotate Hip_Pitch
    shape(legU);
    
    rotateZ(PI/2);
    rotateY(PI);
    translate(0,-sc*25,0);
    rotateZ(-r2[3]);    // Rotate Knee
    shape(legL);  
    
    rotateZ(PI/2);
    translate(-sc*25, 0,0);
     rotateZ(-r2[4]);    // Rotate Ankle Pitch
    shape(ankle);  
    
    rotateZ(PI);    
    rotateX(PI/2);
    rotateY(PI);     
    rotateZ(r2[5]);    // Rotate Ankle Roll
    shape(rfoot); 
    
    popMatrix();
  }
  

  
}
