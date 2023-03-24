import processing.opengl.*;
import controlP5.*; 
import toxi.geom.*;
import toxi.processing.*;

ControlP5 cp5;

Chart acc_chart, vel_chart, pos_chart;
Quaternion quat = new Quaternion(1, 0, 0, 0);

float[] euler = new float[3];
float[] ypr = new float[3];
float[] q=new float[4];
float[] acc=new float[3];

float[] q_offset = new float[4];

//filtered data
float[] accel=new float[3];
float[] vel=new float[3];
float[] pos=new float[3];

PFont font14, font18, font24;
int d=0;
float ry;
float rotX, rotY;

float freq = 0;

PrintWriter saveData1, saveData2;
boolean btn_click = false;

float[] qe = new float[4];   //quat from euler after calibration

float last_posX, last_posY, last_posZ;


void setup() {
  size(1208, 720, P3D);  

  cp5 = new ControlP5(this);
  
  font14 = createFont("Arial bold", 14, true);
  font18 = createFont("Arial bold", 18, true);
  font24 = createFont("Arial bold", 24, true);
  saveData1 = createWriter("acc_vel_pos.txt");
  saveData2 = createWriter("dist_&_quat.txt");
   
  setOffsetAngle();  
  btn();
  chart();
  setup_UART();
}

void draw() {
  
  long t_now = millis();
  long last_time = t_now;  
  float dt = (t_now - last_time)/1000.0;
  //Background  
  background(200, 200, 200);
  serialFlag();
  label();
  lights();
  
  accel[0]=worldAccel[0];    accel[1]=worldAccel[1];    accel[2]=worldAccel[2];
  vel[0]=HPF_Velocity[0];    vel[1]=HPF_Velocity[1];    vel[2]=HPF_Velocity[2];
  pos[0]=HPF_Position[0];    pos[1]=HPF_Position[1];    pos[2]=HPF_Position[2];
    
  
  pushMatrix();
  translate(width/4, height/2-50, 0);
  rotateX(rotX);
  rotateY(-rotY);
  //rotateY(ry);
  
    quat.set(q[0], -q[1], q[2], q[3]);
    float[] axis = quat.toAxisAngle();

    CyclicMotion();

    translate(pos[1], pos[2],0);
    rotate(axis[0], -axis[2], axis[3], axis[1]);      
    box(80,20,40);
  //ypr = convert.ypr(q); 
  

  popMatrix();
    
//    qe=convert.euler2quat(th);

  acc_chart.push("Acc_X", accel[0]);    //Red
  acc_chart.push("Acc_Y", accel[1]);    //Green
  acc_chart.push("Acc_Z", accel[2]);    //Blue
  
  vel_chart.push("Vel_X", vel[0]);    //Red
  vel_chart.push("Vel_Y", vel[1]);    //Red
  vel_chart.push("Vel_Z", vel[2]);    //Red
  
  pos_chart.push("Pos_X", pos[0]);      //Red
  pos_chart.push("Pos_Y", pos[1]);      //Red
  pos_chart.push("Pos_Z", pos[2]);      //Red
  

  
  pushMatrix();
  translate(width/2-10,height-150,0);
  
  textFont(font14);  fill(40); 
  text("World Accel", 10, 0);
  text("x-axis", 0, 25);  text(acc[0], 50, 25); 
  text("y-axis",0, 45);  text(acc[1], 50, 45); 
  text("z-axis", 0, 65);  text(acc[2], 50, 65);
  text("freq", 0, 85);  text(freq, 50, 85);
  
  fill(10,20,230);
  text("q", 0, 115);  text(q[0], 30, 115);   text(q[1], 100, 115); 
                      text(q[2], 170, 115);   text(q[3],240, 115);
  
  popMatrix();
  
  pushMatrix();
  translate(200,height-150,0);
  
  textFont(font14);  fill(40); 
  text("Distance", 10, 0);
  text("x-pos", 0, 25);  text(last_posX, 50, 25); 
  text("y-pos",0, 45);  text(last_posY, 50, 45); 
  text("z-pos", 0, 65);  text(last_posZ, 50, 65);

   
  popMatrix();
  
  
  
    if (flag_save==1||btn_click)  
    { 
      
      last_posX+=pos[0];    last_posY+=pos[1];    last_posZ+=pos[2];
      
      saveData1.println(accel[0]+","+ accel[1] +","+ accel[2] +","+   //YPR
                        vel[0] +","+ vel[1] +","+ vel[2] +","+    //Encoder
                        pos[0]+","+pos[1]+","+pos[2]);
                        
//      saveData2.println(last_posX+","+last_posY+","+last_posZ+","+q[0]+","+
//                        q[1]+","+q[2]+","+q[3]); 
       saveData2.println(acc[0]+","+acc[1]+","+acc[2]+","+
                         q[0]+","+q[1]+","+q[2]+","+q[3]  +","+freq ); 
      
    } else 
    { saveData1.close();  saveData2.close(); }

  ry += 0.02;
}

void chart()
{  
  acc_chart = cp5.addChart("Acc_Graph")
    .setPosition(width-470, 100)
      .setSize(450, 150)
        .setRange(-40, 40)  //.setRange(-12000, 12000)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  vel_chart = cp5.addChart("Vel_Graph")
    .setPosition(width-470, 290)
      .setSize(450, 150)
        .setRange(-150, 150)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  pos_chart = cp5.addChart("Pos_Graph")
    .setPosition(width-470, 480)
      .setSize(450, 150)
        .setRange(-600, 600)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;
  acc_chart.getColor().setBackground(color(250, 250, 250));
  vel_chart.getColor().setBackground(color(250, 250, 250));
  pos_chart.getColor().setBackground(color(250, 250, 250));

  acc_chart.addDataSet("Acc_X");
  acc_chart.setColors("Acc_X", color(255, 0, 0), color(255));
  acc_chart.setData("Acc_X", new float[255]);

  acc_chart.addDataSet("Acc_Y");
  acc_chart.setColors("Acc_Y", color(0, 255, 0), color(255));   
  acc_chart.setData("Acc_Y", new float[255]);
  
  acc_chart.addDataSet("Acc_Z");
  acc_chart.setColors("Acc_Z", color(0, 0, 255), color(255));   
  acc_chart.setData("Acc_Z", new float[255]);

  vel_chart.addDataSet("Vel_X");
  vel_chart.setColors("Vel_X", color(255, 0, 0), color(255)); 
  vel_chart.setData("Vel_X", new float[255]);

  vel_chart.addDataSet("Vel_Y");
  vel_chart.setColors("Vel_Y", color(0, 255, 0), color(255));   
  vel_chart.setData("Vel_Y", new float[255]);
  
  vel_chart.addDataSet("Vel_Z");
  vel_chart.setColors("Vel_Z", color(0, 0, 255), color(255));   
  vel_chart.setData("Vel_Z", new float[255]);

  pos_chart.addDataSet("Pos_X");
  pos_chart.setColors("Pos_X", color(255, 0, 0), color(255));  
  pos_chart.setData("Pos_X", new float[255]);

  pos_chart.addDataSet("Pos_Y");
  pos_chart.setColors("Pos_Y", color(0, 255, 0), color(255));  
  pos_chart.setData("Pos_Y", new float[255]);
  
  pos_chart.addDataSet("Pos_Z");
  pos_chart.setColors("Pos_Z", color(0, 0, 255), color(255));  
  pos_chart.setData("Pos_Z", new float[255]);
}

void setOffsetAngle()
{
  cp5.addButton("SetOffset")
     .setPosition(width-100,640)
     .setSize(50,25)     
     .setValue(1)
     ;
      
}

public void SetOffset(int value) 
{   
    d=value;
}

void btn()
{
   cp5.addToggle("btn_click")
     .setPosition(width-200,height-80)
     .setSize(50,20)
     ;
}

void label()
{ 

  fill(#FF0000);  
  textFont(font24);
  text("Cyclic Motion", width/2-50, 30); 

  fill(#FF0000);  
  textFont(font18);
  text("Acceleration", width-470, 97);    //Z-axis    Acceleration
  fill(#FF00FF);  
  textFont(font18);
  text("Velocity", width-470, 287);   //Y-axis    Velocity
  fill(#0000FF);  
  textFont(font18);
  text("Position ", width-470, 477);  //X-axis  Position

  String s = "MRL";
  textSize(20);  
  fill(255,0,0);
  text(s, 10, height-20);  // Text wraps within text box
}

void mouseDragged() {
  rotY -= (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

