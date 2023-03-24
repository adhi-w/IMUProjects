
float ry;
float rotX, rotY;
robot rob;
  
public void setup() {
  size(1204, 800, P3D);
      
  rob = new robot();
  
  
}

public void draw() {
  background(80,100,240);
  lights();
  
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(-rotY);
  //rotateY(ry);
  
   rob.rotBody(40);
   
   rob.rotHead(20,40);
   
   //-------Format Hand-->(pitch_up, roll_up, yaw_up, pitch_low)
   rob.rotHand_Right(60,0,40,30);
   rob.rotHand_Left(-20,0,0,30);
   
  //-----Format Foot-->(hip_yaw, hip_pitch, hip_roll, knee, ankle_pitch, ankle_roll)---------
  rob.rotFoot_Left(0, -20, 0, 45, 20, 0);
  rob.rotFoot_Right(0, 20, 0, 45, -20, 0);
  rob.update();
  
  ry += 0.02;
}

void mouseDragged(){
    rotY -= (mouseX - pmouseX) * 0.01;
    rotX -= (mouseY - pmouseY) * 0.01;
}
