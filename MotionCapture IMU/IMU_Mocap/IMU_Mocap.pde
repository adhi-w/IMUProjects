import processing.opengl.*;
import controlP5.*; 
import toxi.geom.*;
import toxi.processing.*;

ControlP5 cp5;

float[][] q=new float[14][4];    // serial data storage [id+1][quat]

Chart Yaw_chart, Pitch_chart, Roll_chart;

float[][] qt = new float[14][4];
float[][] ypr = new float[14][3];
float[][] euler = new float[14][3];
float[][] offset_euler = new float[14][3];
float[][] offset_ypr = new float[14][3];

float[] q_offset = new float[4];

PFont font14, font18, font24;
int d=0;
float rotX, rotY;

boolean btn_save = false;
PrintWriter saveData1, saveData2;
int flag_save = 1;

Converter convert = new Converter();


void setup() {
  size(1208, 800, P3D);    


  cp5 = new ControlP5(this);

  
  font14 = createFont("Arial bold", 14, true);
  font18 = createFont("Arial bold", 18, true);
  font24 = createFont("Arial bold", 24, true);
  saveData1 = createWriter("euler.txt");
  saveData2 = createWriter("quat.txt");

  setOffsetAngle();  
  click_save();
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
  translate(width/2-200, height/2-50, 0);
  rotateX(rotX);
  rotateY(-rotY);
  
  SkeletalAnimation();

  popMatrix();
  
  for(int i=1; i<=13; i++)
  {
    ypr[i] = convert.ypr(q[i]);
    euler[i] = convert.euler(q[i]); 
  } 
  
  
  if(d==1)
  {
    for(int i=1; i<=13; i++)
    {  
      offset_euler[i][0] =0;    offset_euler[i][1] =0;    offset_euler[i][2] =0;
      offset_ypr[i][0] =0;    offset_ypr[i][1] =0;    offset_ypr[i][2] =0;
      
      offset_euler[i][0]= euler[i][0];
      offset_euler[i][1]= euler[i][1];
      offset_euler[i][2]= euler[i][2];
      
      offset_ypr[i][0]= ypr[i][0];
      offset_ypr[i][1]= ypr[i][1];
      offset_ypr[i][2]= ypr[i][2];
    }
  }
  d=0;
  
  for(int i=1; i<=13; i++)
  {
    ypr[i][0] = 360-convert.angleCorrection(ypr[i][0], offset_ypr[i][0]);  
    ypr[i][1] = convert.angleCorrection(ypr[i][1], offset_ypr[i][1]);
    ypr[i][2] = convert.angleCorrection(ypr[i][2], offset_ypr[i][2]); 
    
    euler[i][0] = 360-convert.angleCorrection(euler[i][0], offset_euler[i][0]);  
    euler[i][1] = convert.angleCorrection(euler[i][1], offset_euler[i][1]);
    euler[i][2] = convert.angleCorrection(euler[i][2], offset_euler[i][2]); 
    
    qt[i]=convert.euler2quat(euler[i]);
  }
  
  
  Yaw_chart.push("Yaw", ypr[1][0]);    //   Red
  Pitch_chart.push("Pitch", ypr[1][1]);    //Red
  Roll_chart.push("Roll", ypr[1][2]);      //Red
  
  Yaw_chart.push("Yaw_ref",ypr[2][0]);  //Green
  Pitch_chart.push("Pitch_ref", ypr[2][1]);    //Green
  Roll_chart.push("Roll_ref", ypr[2][2]);      //Green
  
  pushMatrix();
  translate(100,height-150,0);
  
  textFont(font14);  fill(40); 
  text("euler Angle", 10, 0);
  text("yaw", 0, 25);  text(ypr[1][0], 50, 25); 
  text("pitch",0, 45);  text(ypr[1][1], 50, 45); 
  text("roll", 0, 65);  text(ypr[1][2], 50, 65);
  
  text(ypr[2][0], 150, 25); 
  text(ypr[2][1], 150, 45); 
  text(ypr[2][2], 150, 65);
  
   text(ypr[10][0], 250, 25); 
  text(ypr[10][1], 250, 45); 
  text(ypr[10][2], 250, 65);
  
  fill(10,20,230);
  text("q", 0, 115);  text(q[10][0], 30, 115);   text(q[10][1], 100, 115); 
                      text(q[10][2], 170, 115);   text(q[10][3],240, 115);
  
  popMatrix(); 
  
    if (flag_save==1)  
   { 
     saveData1.println(ypr[1][0]+","+ypr[1][1]+","+ypr[1][2]+","+
                        ypr[2][0]+","+ypr[2][1]+","+ypr[2][2]);
     /*
      saveData1.println(ypr[1][0]+","+ypr[1][1]+","+ypr[1][2]+","+"!"+
                        ypr[2][0]+","+ypr[2][1]+","+ypr[2][2]+","+"!"+
                        ypr[3][0]+","+ypr[3][1]+","+ypr[3][2]+","+"!"+
                        ypr[4][0]+","+ypr[4][1]+","+ypr[4][2]+","+"!"+
                        ypr[5][0]+","+ypr[5][1]+","+ypr[5][2]+","+"!"+
                        ypr[6][0]+","+ypr[6][1]+","+ypr[6][2]+","+"!"+
                        ypr[7][0]+","+ypr[7][1]+","+ypr[7][2]+","+"!"+
                        ypr[8][0]+","+ypr[8][1]+","+ypr[8][2]+","+"!"+
                        ypr[9][0]+","+ypr[9][1]+","+ypr[9][2]+","+"!"+
                        ypr[10][0]+","+ypr[10][1]+","+ypr[10][2]+","+"!"+
                        ypr[11][0]+","+ypr[11][1]+","+ypr[11][2]+","+"!"+
                        ypr[12][0]+","+ypr[12][1]+","+ypr[12][2]+","+"!"+
                        ypr[13][0]+","+ypr[13][1]+","+ypr[13][2]);
                        
      saveData2.println(q[1][0]+","+q[1][1]+","+q[1][2]+","+"!"+
                        q[2][0]+","+q[2][1]+","+q[2][2]+","+"!"+
                        q[3][0]+","+q[3][1]+","+q[3][2]+","+"!"+
                        q[4][0]+","+q[4][1]+","+q[4][2]+","+"!"+
                        q[5][0]+","+q[5][1]+","+q[5][2]+","+"!"+
                        q[6][0]+","+q[6][1]+","+q[6][2]+","+"!"+
                        q[7][0]+","+q[7][1]+","+q[7][2]+","+"!"+
                        q[8][0]+","+q[8][1]+","+q[8][2]+","+"!"+
                        q[9][0]+","+q[9][1]+","+q[9][2]+","+"!"+
                        q[10][0]+","+q[10][1]+","+q[10][2]+","+"!"+
                        q[11][0]+","+q[11][1]+","+q[11][2]+","+"!"+
                        q[12][0]+","+q[12][1]+","+q[12][2]+","+"!"+
                        q[13][0]+","+q[13][1]+","+q[13][2]);
      */
    } else 
    { saveData1.close();  saveData2.close(); }

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
    //convert.calibrate = value;
}

void click_save()
{
   cp5.addToggle("btn_save")
     .setPosition(width-200,height-150)
     .setSize(50,20)
     ;
}

void label()
{ 

  fill(#FF0000);  
  textFont(font24);
  text("Skeletal", width/2-50, 30); 

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

