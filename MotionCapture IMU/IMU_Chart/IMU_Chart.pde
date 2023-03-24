import processing.serial.Serial; // serial library
import controlP5.*; // controlP5 library

Serial serial;
ControlP5 cp5;

PFont font9,font10,font12,font14,font15,font20;

PImage mi_balanceLogo,ugmLogo;

Button buttonCALIBRATE_ACC,buttonCALIBRATE_MAG;

Chart IMU_chart;

color yellow_ = color(200, 200, 20), green_ = color(46, 209, 2), red_ = color(120, 30, 30), blue_ = color (0, 102, 200);
color white_ = color(255, 255, 255), black_ = color(0, 0, 0), pink_ = color(255, 0, 255);


//UART Variable
int serial_conect = 0;
int commListMax;
int[] data = null;

Textlabel txtlblWhichcom; 
ListBox commListbox;
ListBox portlist;

// coded by Eberhard Rensch
// Truncates a long port name for better (readable) display in the GUI
String shortifyPortName(String portName, int maxlen)  
{
  String shortName = portName;
  if(shortName.startsWith("/dev/")) shortName = shortName.substring(5);  
  if(shortName.startsWith("tty.")) shortName = shortName.substring(4); // get rid off leading tty. part of device name
  if(portName.length()>maxlen) shortName = shortName.substring(0,(maxlen-1)/2) + "~" +shortName.substring(shortName.length()-(maxlen-(maxlen-1)/2));
  if(shortName.startsWith("cu.")) shortName = "";// only collect the corresponding tty. devices
  return shortName;
}

int i,j;


//int tabHeight=20; // Extra height needed for Tabs

int xLevelObj   = 100;              int yLevelObj   = 180; 
int xCompass    = xLevelObj;        int yCompass    = yLevelObj+240;


//angx-->Roll
//angy-->Pitch
float a,b,h,head,angx,angy,angCalc;

float angx_no_filter,angy_no_filter;
float gyro_x,gyro_y;

float size = 38.0;

int GPS_directionToHome=0;

boolean Calib_Accelero,toggleCalibAcc,toggleCalibMag;

void setup()
{
 
  size(800,520,OPENGL);
  cp5 = new ControlP5(this);
  
 
  font9 = createFont("Arial bold",9,false);
  font10 = createFont("Arial bold",10,false);
  font12 = createFont("Arial bold",12,false);
  font14 = createFont("Arial bold",12,false);
  font15 = createFont("Arial bold",15,false);
  font20 = createFont("Arial bold",20,false);
  
  
     // make chart IMU Chart
 IMU_chart = cp5.addChart("IMU_GRAPH")
         .setPosition(170, 100)
         .setSize(550, 280)
         .setRange(-250, 250)
         .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
         ;
         
 IMU_chart.getColor().setBackground(color(255, 100));

 IMU_chart.addDataSet("angx");
 IMU_chart.setColors("angx", color(255,255,0),color(255));
 IMU_chart.setData("angx", new float[255]);
 
 IMU_chart.addDataSet("angy");
 IMU_chart.setColors("angy", color(0,255,0) ,color(255));
 IMU_chart.updateData("angy", new float[255]); 
 
 IMU_chart.addDataSet("gyro_x");
 IMU_chart.setColors("gyro_x", color(255,0,0),color(255));
 IMU_chart.setData("gyro_x", new float[255]);
 
 IMU_chart.addDataSet("gyro_y");
 IMU_chart.setColors("gyro_y", color(0,0,255),color(255));
 IMU_chart.updateData("gyro_y", new float[255]);
 
  setup_UART();
  
}

void draw()
{
  background(128);
  
  
  textFont(font12);text("@copright2016", 700, 490);
  textFont(font20);text("Chart IMU", 120, 30);
  textFont(font14);text("MRL 2016", 120, 50);
 
  
  IMU_chart.push("angx", angx);
  IMU_chart.push("angy", angy);
//  IMU_chart.push("gyro_x", gyro_x);
//  IMU_chart.push("gyro_y", gyro_y);

  }
  
