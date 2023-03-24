import controlP5.*; // controlP5 library
ControlP5 cp5;
import toxi.geom.*;
import toxi.processing.*;

Quaternion quat = new Quaternion(1, 0, 0, 0);
Quaternion quats = new Quaternion(1, 0, 0, 0);
Converter convert = new Converter();

Chart Yaw_chart, Pitch_chart, Roll_chart;

PVector grav;
float[] euler = new float[3];
float[] ypr = new float[3];
float[] theta = new float[5];

float[] q=new float[4];
float[] qs=new float[4];

PFont font18, font24;

PShape aircraft;
float sc = 20;  //scale

int d=0;
PrintWriter saveData_1, saveData_2;

void setup()
{  
  size(1208, 800, P3D); 
  cp5 = new ControlP5(this);  
  ortho(0,width, 0,height, -1000,1000);
  aircraft = loadShape("FA-22_Raptor.obj");
  aircraft.scale(sc);

  font18 = createFont("Arial bold", 18, false);
  font24 = createFont("Arial bold", 24, false);
  
//  saveData_1 = createWriter("euler&theta.txt");
//  saveData_2 = createWriter("xyz_quat&rotmat.txt");
  
  setOffsetAngle();  
  chart();
  setup_UART();
}

void draw()
{
  background(200,180,250); //RGB  
  serialFlag();
  label();

  //------------------------------
  quat.set(q[0], q[1], q[2], q[3]);
  float[] axis = quat.toAxisAngle();
  
  euler = convert.euler(q);
  
  //----------------------
  qs = convert.euler2quat(theta);
  quats.set(qs[0], qs[1], qs[2], qs[3]);
  float[] axiss = quats.toAxisAngle();
  
  //------------------------------------
    
  pushMatrix();
  translate(width/4+150, height/2, 0);
//  rotateY(PI/2);
//  rotateX(PI/2);
  
  rotate(axis[0], -axis[1], axis[3], axis[2]);
//  rotateY(radians(euler[0])); 
//  rotateX(radians(euler[2]));
//  rotateZ(radians(euler[1]));
  fill(255,0,0);
    box(120,40,60);
//  shape(aircraft);
  popMatrix();
  
  pushMatrix();
  translate(width/4-150, height/2, 0);
//  rotateY(PI/2);
//  rotateX(PI/2);
  
  rotate(axiss[0], axiss[1], -axiss[2], -axiss[3]);
//  rotateY(radians(360-theta[0])); 
//  rotateX(radians(-theta[1]));
//  rotateZ(radians(theta[2]));
  fill(0,0,255);
  box(120,40,60);
 
//  shape(aircraft);
  popMatrix();
  
  textFont(font18);  fill(0); 
  text("Uranus", 70, 500);
  text("w = ", 60, 600);  text(axiss[0], 100, 600); 
  text("x = ", 60, 640);  text(axiss[1], 100, 640); 
  text("y = ", 60, 680);  text(-axiss[2], 100, 680);
  text("z = ", 60, 720);  text(-axiss[3], 100, 720);

  
  textFont(font18);  fill(0);   
  text("MRL ", 400, 500);
  text("w =", 380, 600);  text(axis[0], 420, 600);   
  text("x = ", 380, 640);  text(-axis[1], 420, 640);   
  text("y = ", 380, 680);  text(axis[3], 420, 680); 
  text("z = ", 380, 720);  text(axis[2], 420, 720);  
  /*
  textFont(font18);  fill(0); 
  text("Uranus", 70, 500);
  text("Yaw = ", 60, 600);  text(theta[0], 130, 600); 
  text("Pitch = ", 60, 640);  text(theta[1], 130, 640); 
  text("Roll = ", 60, 680);  text(theta[2], 130, 680);

  
  textFont(font18);  fill(0);   
  text("MRL ", 400, 500);
  text("Yaw", 380, 600);  text(euler[0], 450, 600);   
  text("Pitch = ", 380, 640);  text(euler[2] , 450, 640);   
  text("Roll = ", 380, 680);  text(euler[1], 450, 680);   
  */
  
  Yaw_chart.push("Yaw", euler[0]);    //   Red
  Pitch_chart.push("Pitch", euler[2]);    //Red
  Roll_chart.push("Roll", euler[1]);      //Red
  
  Yaw_chart.push("Yaw_ref",360-theta[0]);  //Green
  Pitch_chart.push("Pitch_ref", -theta[1]);    //Green
  Roll_chart.push("Roll_ref", theta[2]);      //Green
  
  
//    if (flag_save==1)  
//    { 
//      saveData_1.println(acc[0]+","+acc[1]+","+acc[2]+","+acc_f[0]+","+acc_f[1]+","+acc_f[2]+","+
//      gyro[0]+","+gyro[1]+","+gyro[2]+","+gyro_f[0]+","+gyro_f[1]+","+gyro_f[2]+","+
//      mag[0]+","+mag[1]+","+mag[2]+","+mag_f[0]+","+mag_f[1]+","+mag_f[2]); 
//    } else 
//    { saveData_1.close(); }
  
}

void chart()
{  
  Yaw_chart = cp5.addChart("Yaw_Graph")
    .setPosition(width-470, 100)
      .setSize(450, 150)
        .setRange(0, 360)  //.setRange(-12000, 12000)
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
    d = value;
}

void label()
{ 

  fill(#FF0000);  
  textFont(font24);
  text("Aircraft", width/2-50, 30); 

  fill(#FF0000);  
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
  fill(255,0,0);
  text(s, 10, height-20);  // Text wraps within text box
}
