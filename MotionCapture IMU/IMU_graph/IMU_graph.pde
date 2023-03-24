import controlP5.*; // controlP5 library
ControlP5 cp5;

import toxi.geom.*;
import toxi.processing.*;

Quaternion quat1 = new Quaternion(1, 0, 0, 0);
Quaternion quat2 = new Quaternion(1, 0, 0, 0);

PFont font18, font24;

int width = 1280;
int height = 800;

Chart Yaw_chart, Pitch_chart, Roll_chart;

float[] ypr_offset1 = new float[3];
float[] ypr_offset2 = new float[3];
float[] quat_offset = new float[4];

float[] grav1 = new float[3];
float[] grav2 = new float[3];
float[] euler = new float[3];

float[] ypr1 = new float[3];
float[] ypr2 = new float[3];
float[] theta = new float[5];

float[] q1=new float[4];
float[] q2=new float[4];

float[] acc=new float[3];
float[] gyro=new float[3];

float[] apos=new float[3];

float heading, attitude, bank;

float freq = 0;
int d=0;

int roll_1 = 0, roll_2 = 0;
int pitch_1 = 0, pitch_2 = 0;
int yaw_1 = 0, yaw_2 = 0;
int rotx =0, roty=0, rotb=0;

PVector pt1,v1, pp;

PrintWriter saveData_1, saveData_2;


void setup()
{  
  size(width, height, P3D);  

  cp5 = new ControlP5(this);  

  font18 = createFont("Arial bold", 18, false);
  font24 = createFont("Arial bold", 24, false);
 
  saveData_1 = createWriter("IMU_data.txt");
  saveData_2 = createWriter("Encoder_data.txt");
  
  setOffsetQuaternion();
  chart();
 // scrollBar();
  setup_UDP();
  setup_UART();
 
}

void draw()
{
  background(180); //RGB  
   
  serialFlag();
  label();
  
  setup_SkeletalAnimation(); 

  
   convert_YPR(ypr1, grav1, q1);
 //  convert_YPR(ypr2, grav2, q2);
  convert_Euler(euler, q1);
  
     
  textFont(font18);  fill(0); 
  text("q.w = ", 30, 600);  text(q1[0], 100, 600); 
  text("q.x = ", 30, 640);  text(q1[1], 100, 640); 
  text("q.y = ", 30, 680);  text(q1[2], 100, 680);
  text("q.z = ", 30, 720);  text(q1[3], 100, 720); 
  
  textFont(font18);  fill(0);   
  text("x = ", 280, 600);  text(pt1.x, 320, 600);   //text(pp.x, 420, 600);
  text("y = ", 280, 640);  text(pt1.y, 320, 640);   //text(pp.y, 420, 640);
  text("z = ", 280, 680);  text(pt1.z, 320, 680);   //text(pp.z, 420, 680);
  
//  textFont(font18);  fill(#F0FFFF);   
//  text("Yaw = ", 320, 600);  text(ypr1[0], 400, 600); 
//  text("Pitch = ", 320, 640);  text(ypr1[1], 400, 640); 
//  text("Roll = ", 320, 680);  text(ypr1[2], 400, 680);
  
//  textFont(font18);  fill(#FF000F);
//  text("Heading = ", 495, 600);  text(heading, 590, 600); 
//  text("Attitude = ", 495, 640);  text(attitude, 590, 640); 
//  text("Bank = ", 495, 680);  text(euler[2], 590, 680); 
  
  
  Yaw_chart.push("Yaw", ypr1[0]);  //q1[0]  ypr1  euler    Red
  Pitch_chart.push("Pitch", ypr1[1]);    //Green
  Roll_chart.push("Roll", ypr1[2]);      //Blue
  
//  Yaw_chart.push("Yaw_ref", ypr2[0]);      // Blue Line
//  Pitch_chart.push("Pitch_ref", ypr2[1]);     //Magenta Line
//  Roll_chart.push("Roll_ref", ypr2[2]);        //Red Line

//  Yaw_chart.push("Yaw_ref", heading);      // Blue Line
//  Pitch_chart.push("Pitch_ref", attitude);     //Magenta Line
//  Roll_chart.push("Roll_ref", bank);        //Red Line
//  
      if (flag_save==1)  
    { 
//      saveData_1.println(q1[0]+","+q1[1]+","+q1[2]+","+q1[3]+","+q2[0]+","+q2[1]+","+q2[2]+","+q2[3]);
        saveData_1.println(ypr1[0]+","+ypr1[1]+","+ypr1[2]+","+ypr2[0]+","+ypr2[1]+","+ypr2[2]);
//      saveData_1.println(heading+","+attitude+","+bank+","+theta[1]+","+theta[3]+","+theta[2]);
//      saveData_2.println(theta[1]+","+theta[3]+","+theta[4]);      
    } else 
    {

      saveData_1.close();     
//      saveData_2.close();
    }
    
  
//  Yaw_chart.push("Yaw", cMotion.linearAccel[0]);
//  Pitch_chart.push("Pitch", cMotion.linearVelocity[0]);
//  Roll_chart.push("Roll", cMotion.linearPosition[0]);
//
//  Yaw_chart.push("Yaw_ref", cMotion.realAccel[0]);
//  Pitch_chart.push("Pitch_ref", cMotion.HPF_Velocity[0]);
//  Roll_chart.push("Roll_ref", cMotion.HPF_Position[0]);
}

void chart()
{  
  Yaw_chart = cp5.addChart("Yaw_Graph")
    .setPosition(width-470, 100)
      .setSize(450, 150)
        .setRange(-360, 0)  //.setRange(-12000, 12000)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  Pitch_chart = cp5.addChart("Pitch_Graph")
    .setPosition(width-470, 290)
      .setSize(450, 150)
        .setRange(-180, 180)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  Roll_chart = cp5.addChart("Roll_Graph")
    .setPosition(width-470, 480)
      .setSize(450, 150)
        .setRange(-180, 180)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;
  Yaw_chart.getColor().setBackground(color(250, 250, 250));
  Pitch_chart.getColor().setBackground(color(250, 250, 250));
  Roll_chart.getColor().setBackground(color(250, 250, 250));

  Yaw_chart.addDataSet("Yaw");
  Yaw_chart.setColors("Yaw", color(255, 0, 0), color(255));
  Yaw_chart.setData("Yaw", new float[255]);

  Yaw_chart.addDataSet("Yaw_ref");
  Yaw_chart.setColors("Yaw_ref", color(0, 255, 0), color(255));    //color(0, 0, 255), color(255));    // Blue Line
  Yaw_chart.setData("Yaw_ref", new float[255]);

  Pitch_chart.addDataSet("Pitch");
  Pitch_chart.setColors("Pitch", color(255, 0, 0), color(255));  //color(0, 255, 0), color(255));
  Pitch_chart.setData("Pitch", new float[255]);

  Pitch_chart.addDataSet("Pitch_ref");
  Pitch_chart.setColors("Pitch_ref", color(0, 255, 0), color(255));    //color(255, 0, 255), color(255));    //Magenta Line
  Pitch_chart.setData("Pitch_ref", new float[255]);

  Roll_chart.addDataSet("Roll");
  Roll_chart.setColors("Roll", color(255, 0, 0), color(255));    //color(0, 0, 255), color(255));
  Roll_chart.setData("Roll", new float[255]);

  Roll_chart.addDataSet("Roll_ref");
  Roll_chart.setColors("Roll_ref", color(0, 255, 0), color(255));    //color(255, 0, 0), color(255));    //Red Line
  Roll_chart.setData("Roll_ref", new float[255]);
}

void setOffsetQuaternion()
{
  cp5.addButton("SetOffset")
     .setPosition(width-100,640)
     .setSize(50,25)     
     .setValue(1)
     ;
      
}

public void SetOffset(int value) 
{   
    d = value;
}

void scrollBar()
{

  cp5.addSlider("roll_1")
    .setPosition(10, 80)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(0)
            //.setNumberOfTickMarks(12)
            .setSliderMode(Slider.FLEXIBLE)
              ;
  cp5.addSlider("pitch_1")
    .setPosition(10, 110)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(180)
            .setSliderMode(Slider.FLEXIBLE)
              ;
  cp5.addSlider("yaw_1")
    .setPosition(10, 140)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(180)
            .setSliderMode(Slider.FLEXIBLE)
              ;
  ////////////////////////
  
  cp5.addSlider("roll_2")
    .setPosition(10, 170)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(0)
            //.setNumberOfTickMarks(12)
            .setSliderMode(Slider.FLEXIBLE)
              ;
  cp5.addSlider("pitch_2")
    .setPosition(10, 200)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(180)
            .setSliderMode(Slider.FLEXIBLE)
              ;
  cp5.addSlider("yaw_2")
    .setPosition(10, 230)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(180)
            .setSliderMode(Slider.FLEXIBLE)
              ;
              
  cp5.addSlider("rotx")
    .setPosition(10, 260)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(0)
            .setSliderMode(Slider.FLEXIBLE)
              ;
   
     cp5.addSlider("roty")
    .setPosition(10, 290)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(180)
            .setSliderMode(Slider.FLEXIBLE)
              ;
      cp5.addSlider("rotb")
    .setPosition(10, 320)
      .setSize(120, 20)
        .setRange(0, 360) // values can range from big to small as well
          .setValue(0)
            .setSliderMode(Slider.FLEXIBLE)
              ;
  
}

void label()
{ 

  fill(#FF0000);  
  textFont(font24);
  text("IMU Graph", width/2-50, 30); 

  fill(#FF0FF0);  
  textFont(font18);
  text("Yaw", width-470, 97);    //Z-axis    Acceleration
  fill(#00FF00);  
  textFont(font18);
  text("Pitch", width-470, 287);   //Y-axis    Velocity
  fill(#0000FF);  
  textFont(font18);
  text("Roll ", width-470, 477);  //X-axis  Position

  String s = "MRL";
  textSize(20);  
  fill(30);
  text(s, 10, height-20);  // Text wraps within text box
}

