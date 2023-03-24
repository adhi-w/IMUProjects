import controlP5.*; // controlP5 library
ControlP5 cp5;

Chart acc_chart, gyro_chart, mag_chart;
float[] acc=new float[3];
float[] gyro=new float[3];
float[] mag=new float[3];

float[] acc_f=new float[3];
float[] gyro_f=new float[3];
float[] mag_f=new float[3];

float[] acc_kf=new float[3];
float[] gyro_kf=new float[3];
float[] mag_kf=new float[3];
Filter fl;

float freq = 0;

PFont font18, font24;

PrintWriter saveData_1, saveData_2;

void setup()
{  
  size(1024, 720, P3D); 
  cp5 = new ControlP5(this);  

  font18 = createFont("Arial bold", 18, false);
  font24 = createFont("Arial bold", 24, false);
  
  saveData_1 = createWriter("9_axis.txt");
  chart();
  setup_UART();
}

void draw()
{
  background(#000000); //RGB  
  serialFlag();
  label();
  
  fl=new Filter();
  
  acc_f = fl.LPF(acc, 0.001,freq);
  gyro_f = fl.HPF(gyro, 0.001,freq);
  mag_f = fl.LPF(mag, 0.0001,freq);
  
  for(int i=0; i<=2; i++)
  {
    acc_kf[i] = fl.Kalman_Estimate(acc[i]);
    gyro_kf[i] = fl.Kalman_Estimate(gyro[i]);
    mag_kf[i] = fl.Kalman_Estimate(mag[i]);
  }
  acc_chart.push("Acc", acc[0]);    //   Red
  gyro_chart.push("Gyro", gyro[0]);    //Red
  mag_chart.push("Magneto", mag[0]);      //Red
  
  acc_chart.push("Acc_Filter", acc_f[0]);  //Green
  gyro_chart.push("Gyro_Filter", gyro_f[0]);    //Green
  mag_chart.push("Magneto_Filter", mag_f[0]);      //Green
  
  
    if (flag_save==1)  
    { 
      saveData_1.println(acc[0]+","+acc[1]+","+acc[2]+","+acc_f[0]+","+acc_f[1]+","+acc_f[2]+","+
      gyro[0]+","+gyro[1]+","+gyro[2]+","+gyro_f[0]+","+gyro_f[1]+","+gyro_f[2]+","+
      mag[0]+","+mag[1]+","+mag[2]+","+mag_f[0]+","+mag_f[1]+","+mag_f[2]+","+freq); 
    } else 
    { saveData_1.close(); }
  
}

void chart()
{  
  acc_chart = cp5.addChart("Acc_Graph")
    .setPosition(width-470, 100)
      .setSize(450, 150)
        .setRange(-2000, 2000)  //.setRange(-12000, 12000)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  gyro_chart = cp5.addChart("Gyro_Graph")
    .setPosition(width-470, 290)
      .setSize(450, 150)
        .setRange(-250, 250)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;

  mag_chart = cp5.addChart("Magneto_Graph")
    .setPosition(width-470, 480)
      .setSize(450, 150)
        .setRange(-1000, 1000)
          .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
            ;
  acc_chart.getColor().setBackground(color(#FFFFFF));
  gyro_chart.getColor().setBackground(color(#FFFFFF));
  mag_chart.getColor().setBackground(color(255, 255, 255));

  acc_chart.addDataSet("Acc");
  acc_chart.setColors("Acc", color(255, 0, 0), color(255));
  acc_chart.setData("Acc", new float[255]);

  acc_chart.addDataSet("Acc_Filter");
  acc_chart.setColors("Acc_Filter", color(0, 255, 0), color(255));    //color(0, 0, 255), color(255));    // Blue Line
  acc_chart.setData("Acc_Filter", new float[255]);

  gyro_chart.addDataSet("Gyro");
  gyro_chart.setColors("Gyro", color(255, 0, 0), color(255));  //color(0, 255, 0), color(255));
  gyro_chart.setData("Gyro", new float[255]);

  gyro_chart.addDataSet("Gyro_Filter");
  gyro_chart.setColors("Gyro_Filter", color(0, 255, 0), color(255));    //color(255, 0, 255), color(255));    //Magenta Line
  gyro_chart.setData("Gyro_Filter", new float[255]);

  mag_chart.addDataSet("Magneto");
  mag_chart.setColors("Magneto", color(255, 0, 0), color(255));    //color(0, 0, 255), color(255));
  mag_chart.setData("Magneto", new float[255]);

  mag_chart.addDataSet("Magneto_Filter");
  mag_chart.setColors("Magneto_Filter", color(0, 255, 0), color(255));    //color(255, 0, 0), color(255));    //Red Line
  mag_chart.setData("Magneto_Filter", new float[255]);
}

void label()
{ 

  fill(#FF0000);  
  textFont(font24);
  text("9_Axis Data", width/2-50, 30); 

  fill(#FF0FF0);  
  textFont(font18);
  text("Acc", width-470, 97);    //Z-axis    Acceleration
  fill(#00FF00);  
  textFont(font18);
  text("Gyro", width-470, 287);   //Y-axis    Velocity
  fill(#FFFF0F);  
  textFont(font18);
  text("Magneto ", width-470, 477);  //X-axis  Position

  String s = "MRL";
  textSize(20);  
  fill(30);
  text(s, 10, height-20);  // Text wraps within text box
}
