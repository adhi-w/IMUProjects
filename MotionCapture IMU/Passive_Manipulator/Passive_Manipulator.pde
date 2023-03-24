import processing.opengl.*;
import controlP5.*; 
import toxi.geom.*;
import toxi.processing.*;

ControlP5 cp5;

Chart Yaw_chart, Pitch_chart, Roll_chart;
Quaternion quat1 = new Quaternion(1, 0, 0, 0);
Quaternion quat2 = new Quaternion(1, 0, 0, 0);

PVector grav;
float[] euler = new float[3];
float[] ypr = new float[3];
float[] theta = new float[5];
float[] q1=new float[4];
float[] q2=new float[4];

float[] t_offset = new float[3];
float[] q_offset = new float[4];

PFont font14, font18, font24;
int d=0;
float ry;
float rotX, rotY;

float freq = 0;

PrintWriter saveData1, saveData2;

Converter convert = new Converter();
Arm arm;

float[] qt = new float[4];   //quat from encoder after calibration
float[] qe = new float[4];   //quat from euler after calibration

PVector xyz_qt = new PVector();
PVector xyz_qe = new PVector();
PVector xyz_e = new PVector();
PVector xyz_t = new PVector();

void setup() {
  size(1208, 800, P3D);     


  cp5 = new ControlP5(this);
  arm = new Arm();
  
  font14 = createFont("Arial bold", 14, true);
  font18 = createFont("Arial bold", 18, true);
  font24 = createFont("Arial bold", 24, true);
  saveData1 = createWriter("euler,theta.txt");
  saveData2 = createWriter("Rotmatrix.txt");

  setOffsetAngle();  
  chart();
  setup_UART();
}

void draw() {
  //Background  
  background(164, 201, 215);
  serialFlag();
  label();
  lights();

  pushMatrix();
  translate(width/2, height/2-50, 0);
  rotateX(rotX);
  rotateY(-rotY);
  //rotateY(ry);
  
  quat1.set(q1[0], -q1[1], q1[2], q1[3]);
    float[] axis1 = quat1.toAxisAngle();
  
  ypr = convert.ypr(q1); 
  
  //arm.rotQuatArm1(axis1);

  arm.rotArm1(0, 0, 0);
  arm.rotArm2(0, 0, 0);
  arm.update();
  popMatrix();
  
//   ypr = convert.ypr(q1);   
   
    //----Calculate xyz-->end position
   PVector v=new PVector(0,500,0);  // Init length
   float[] th = new float[3]; 
   
   th[0] = theta[2];   th[1] = theta[1];   th[2] = theta[0];  //Swap
  
   // qe=convert.euler2quat(ypr);
    qt=convert.euler2quat(th);
  
   xyz_qe=quat2rotmatrix(qe, v); 
   xyz_qt=quat2rotmatrix(qt, v);
   
   xyz_e=rotMatrix_ZYX(ypr, v);
   xyz_t=rotMatrix_ZYX(th, v);
  
  Yaw_chart.push("Yaw", ypr[0]);    //   Red
  Pitch_chart.push("Pitch", ypr[1]);    //Red
  Roll_chart.push("Roll", ypr[2]);      //Red
  
  Yaw_chart.push("Yaw_ref",th[0]);  //Green
  Pitch_chart.push("Pitch_ref", th[1]);    //Green
  Roll_chart.push("Roll_ref", th[2]);      //Green
  
  pushMatrix();
  translate(width/2+200,height-150,0);
  
  textFont(font14);  fill(40); 
  text("YPR Angle", 10, 0);
  text("yaw", 0, 25);  text(ypr[0], 50, 25); 
  text("pitch",0, 45);  text(ypr[1], 50, 45); 
  text("roll", 0, 65);  text(ypr[2], 50, 65);
  text("freq", 0, 85);  text(freq, 50, 85);
  
  fill(10,20,230);
  text("q", 0, 115);  text(q1[0], 30, 115);   text(q1[1], 100, 115); 
                      text(q1[2], 170, 115);   text(q1[3],240, 115);
  
  translate(150,0,0);  fill(40);
  text("Encoder Angle", 0, 0);
  text("e1", 0, 25);  text(th[0], 30, 25); 
  text("e2",0, 45);  text(th[1], 30, 45); 
  text("e3", 0, 65);  text(th[2], 30, 65);
  
  popMatrix();
  
  pushMatrix();
  translate(10,100,0);
  textFont(font14);  fill(10,10,200);  
  
  text("Enc Theta", 10, 0);
  text("x", 0, 25);  text(xyz_t.x, 30, 25); 
  text("y",0, 45);  text(xyz_t.y, 30, 45); 
  text("z", 0, 65);  text(xyz_t.z, 30, 65);
  
  translate(100,0,0);
  text("IMU YPR", 10, 0); 
  text(xyz_e.x, 10, 25); 
  text(xyz_e.y, 10, 45); 
  text(xyz_e.z, 10, 65);
  
  translate(100,0,0);
  text("Enc quat", 10, 0); 
  text(xyz_qt.x, 10, 25);  
  text(xyz_qt.y, 10, 45); 
  text(xyz_qt.z, 10, 65);
  
  translate(100,0,0);
  text("IMU Quat", 10, 0); 
  text(xyz_qe.x, 10, 25);  
  text(xyz_qe.y, 10, 45); 
  text(xyz_qe.z, 10, 65);
    
  popMatrix();
  
  
    if (flag_save==1)  
    { 
      saveData1.println(ypr[0]+","+ypr[1]+","+ypr[2]+","+freq+","+
                        th[0]+","+th[1]+","+th[2]); 
      saveData2.println(xyz_e.x+","+xyz_e.y+","+xyz_e.z+","+    //YPR
                        xyz_t.x+","+xyz_t.y+","+xyz_t.z+","+    //Encoder
                        xyz_qe.x+","+xyz_qe.y+","+xyz_qe.z+","+
                        xyz_qt.x+","+xyz_qt.y+","+xyz_qt.z);
    } else 
    { saveData1.close();  saveData2.close(); }

  ry += 0.02;
}

void chart()
{  
  Yaw_chart = cp5.addChart("Yaw_Graph")
    .setPosition(width-470, 100)
      .setSize(450, 150)
        .setRange(90, 270)  //.setRange(-12000, 12000)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  Pitch_chart = cp5.addChart("Pitch_Graph")
    .setPosition(width-470, 290)
      .setSize(450, 150)
        .setRange(90, 270)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  Roll_chart = cp5.addChart("Roll_Graph")
    .setPosition(width-470, 480)
      .setSize(450, 150)
        .setRange(90, 270)
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
    convert.calibrate = value;
}

void label()
{ 

  fill(#FF0000);  
  textFont(font24);
  text("Passive Manipulator", width/2-50, 30); 

  fill(#FF0000);  
  textFont(font18);
  text("Yaw", width-470, 97);    //Z-axis    Acceleration
  fill(#FF00FF);  
  textFont(font18);
  text("Pitch", width-470, 287);   //Y-axis    Velocity
  fill(#0000FF);  
  textFont(font18);
  text("Roll ", width-470, 477);  //X-axis  Position

  String s = "MRL";
  textSize(20);  
  fill(255,0,0);
  text(s, 10, height-20);  // Text wraps within text box
}

void mouseDragged() {
  rotY -= (mouseX - pmouseX) * 0.01;
  rotX -= (mouseY - pmouseY) * 0.01;
}

