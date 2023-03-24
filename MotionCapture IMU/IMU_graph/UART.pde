/*
Solving multiple serial bug:
 1. In serialEvent 
 --> in all of port NUmber --> give accumulator
 e.g. float a = data1[1];  -->portNumber 0 
 float b = data2[1];  -->portNumber 1
 float c = data3[1];  -->portNumber 2
 */
import processing.serial.Serial; // serial library
Serial[] serial=new Serial[3];

int baudrate = 115200;  //38400

int uflag = 0;

//UART Variable
int[] serial_conect= new int[3];
int[] commListMax=new int[3];
float[] data1 = new float[20];
float[] data2 = new float[20];
float[] data3 = new float[20];

Textlabel[] m_Comm = new Textlabel[3]; 
ListBox[] commListbox = new ListBox[3];
ListBox[] portlist = new ListBox[3];
ListBox saveBtn; 

int flag_save = 1;
String encoderString, imuString;

String shortifyPortName(String portName, int maxlen)  
{
  String shortName = portName;
  if (shortName.startsWith("/dev/")) shortName = shortName.substring(5);  
  if (shortName.startsWith("tty.")) shortName = shortName.substring(4); // get rid off leading tty. part of device name
  if (portName.length()>maxlen) shortName = shortName.substring(0, (maxlen-1)/2) + "~" +shortName.substring(shortName.length()-(maxlen-(maxlen-1)/2));
  if (shortName.startsWith("cu.")) shortName = "";// only collect the corresponding tty. devices
  return shortName;
}

void setup_UART()
{

  //Comport List Selection                   
  commListbox[0] = cp5.addListBox("portComList1", width-130, 30, 110, 240); // make a listbox and populate it with the available comm ports
  commListbox[1] = cp5.addListBox("portComList2", width-260, 30, 110, 240);
  commListbox[2] = cp5.addListBox("portComList3", width-390, 30, 110, 240);

  commListbox[0].captionLabel().set("PORT COM 1");
  commListbox[0].setColorBackground(#0000FF);

  commListbox[1].captionLabel().set("PORT COM 2");
  commListbox[1].setColorBackground(#0000FF);

  commListbox[2].captionLabel().set("PORT COM 3");
  commListbox[2].setColorBackground(#0000FF);

  /////////////////////////////////////////
  ///    Save Button //////////  
  saveBtn = cp5.addListBox("Save_Btn", 10, 30, 110, 240); 
  saveBtn.captionLabel().set("Save Data");
  saveBtn.setColorBackground(#FF00FF);

  saveBtn.addItem("start recording", 1);
  saveBtn.addItem("stop", 0);

  /////////////////////////////////////////


  for (int i=0; i<Serial.list ().length; i++) 
  {

    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 )
    { 
      commListbox[0].addItem(pn, i); // addItem(name,value)
      commListbox[1].addItem(pn, i);
      commListbox[2].addItem(pn, i);
    }
    commListMax[0] = i;
    commListMax[1] = i;
    commListMax[2] = i;
  }

  commListbox[0].addItem("Close Comm 1", ++commListMax[0]); // addItem(name,value)
  commListbox[1].addItem("Close Comm 2", ++commListMax[1]);
  commListbox[2].addItem("Close Comm 3", ++commListMax[2]);

  // text label for which comm port selected
  m_Comm[0] = cp5.addTextlabel("Comm Port 1", "No Port Selected", width-131, 8); // textlabel(name,text,x,y)
  m_Comm[1] = cp5.addTextlabel("Comm Port 2", "No Port Selected", width-260, 8);
  m_Comm[2] = cp5.addTextlabel("Comm Port 3", "No Port Selected", width-390, 8);
}

void serialEvent (Serial usbPort) 
{  
  try {
    int portNumber =-1;

    for (int p=0; p<serial.length; p++)
    {
      if (usbPort == serial[p]) { 
        portNumber = p;
      }
    }

    String[] usbString = new String[3];
    usbString[portNumber] = usbPort.readStringUntil ('\n'); 

    if (usbString[portNumber] != null) 
    {
      usbString[portNumber] = trim(usbString[portNumber]);
      //    print(0, usbString[0]); //--> for debuging
      //    print("\t");
      //    println(1, usbString[1]);
    }

    if (portNumber == 0)
    {  

      data1 = float(split(usbString[0], ','));
      
      imuString = usbString[0];    // accumulator for saving data
      
      //for (int sensorNum = 1; sensorNum < data.length; sensorNum++) { println(sensorNum + " " + data[sensorNum]);  } //--> for debuging
      
//      ypr1[0] = angleCorrection(data1[1],230);
//      ypr1[1] = data1[2];
//      ypr1[2] = data1[3];
//      
//      println(ypr1[0],ypr1[1],ypr1[2]); 

      q1[0] = data1[1];
      q1[1] = data1[2];
      q1[2] = data1[3];
      q1[3] = data1[4];
      
      
//      acc[0] = data1[5];
//      acc[1] = data1[6];
//      acc[2] = data1[7];
//
//      gyro[0] = data1[8];
//      gyro[1] = data1[9];
//      gyro[2] = data1[10];
//
//      freq = data1[11];

      //println(data1);
      //println(acc[0] +"\t"+ acc[1] +"\t"+ acc[2]);
      println(q1[0] +"\t"+ q1[1] +"\t"+ q1[2] +"\t"+ q1[3]);

      //Encoder Data
      //    theta[0] = data1[1];  
      //    theta[1] = data1[2];
      //    theta[2] = data1[3];
      //    theta[3] = data1[4];
      //    theta[4] = data1[5];
      //    print(theta[0], theta[1], theta[2], theta[3],theta[4]);
      //    print("\t");
    }
    if (portNumber == 1)
    {
      data2 = float(split(usbString[1], ','));
      
      encoderString = usbString[1];  // accumulator for saving data      
      
//      ypr2[0] = data2[1];  
//      ypr2[1] = data2[2]*2;
//      ypr2[2] = data2[3];
//      println(ypr2[0]+", "+ypr2[1]+", "+ypr2[2]); 
      
      q2[0] = data2[1];
      q2[1] = data2[2];
      q2[2] = data2[3];
      q2[3] = data2[4];
    //Encoder Data
//      theta[0] = data2[1];  
//      theta[1] = data2[2];
//      theta[2] = data2[3];
//      theta[3] = data2[4];
//      theta[4] = data2[5]; 
//      print(theta[0], theta[1], theta[2], theta[3],theta[4]);
      //    println(ypr1[0], ypr1[1], ypr1[2]); //print("\t");
    }

    if (portNumber == 2)
    {
      data3 = float(split(usbString[2], ','));

      //    // get quaternion from data packet
      //     q2[0] = ((data3[1] << 8) | data3[2]) / 16384.0f;
      //     q2[1] = ((data3[3] << 8) | data3[4]) / 16384.0f;
      //     q2[2] = ((data3[5] << 8) | data3[6]) / 16384.0f;
      //     q2[3] = ((data3[7] << 8) | data3[8]) / 16384.0f;
      //     for (int i = 0; i < 4; i++) if (q2[i] >= 2) q2[i] = -4 + q2[i];

      //    convert_YPR(ypr2, gravity2, q2);    
      ypr2[0] = data3[1];
      ypr2[1] = data3[2];
      ypr2[2] = data3[3];        
      //    println(ypr2[0], ypr2[1], ypr2[2]);
    }  

//    if (flag_save==1)  
//    { 
//
//      saveData_1.println(imuString);
//      saveData_2.println(encoderString);      
//    } else 
//    {
//
//      saveData_1.close();     
//      saveData_2.close();
//    }
  }
  
  catch (RuntimeException  e)
  {
    println("Waiting For Clean Serial Packet");
  }
}

//initialize the serial port selected in the listBox
void InitSerial(float portValue, int n) 
{
  if (portValue < commListMax[n]) {
    String portPos = Serial.list()[int(portValue)];
    m_Comm[n].setValue("Connected = " + shortifyPortName(portPos, 8));
    serial[n] = new Serial(this, portPos, baudrate);
    serial[n].bufferUntil('\n');
    serial_conect[n]=1;
  } else 
  {
    m_Comm[n].setValue("Not Connected");
    serial[n].clear();
    serial[n].stop();
    serial_conect[n]=0;
  }
}


void serialFlag()
{//----------Serial 0
  if (serial_conect[0]==1)
  {
    fill(0, 255, 0);
    ellipse(width-35, 12, 10, 10);
    noFill();
  } else
  {
    fill(0, 0, 255);
    ellipse(width-35, 12, 10, 10);
    noFill();
  }

  //----------Serial 1
  if (serial_conect[1]==1)
  {   
    fill(0, 255, 0);
    ellipse(width-160, 12, 10, 10);
    noFill();
  } else
  {
    fill(0, 0, 255);
    ellipse(width-160, 12, 10, 10);
    noFill();
  }

  //----------Serial 2
  if (serial_conect[2]==1)
  {
    fill(0, 255, 0);
    ellipse(width-290, 12, 10, 10);
    noFill();
  } else
  {
    fill(0, 0, 255);
    ellipse(width-290, 12, 10, 10);
    noFill();
  }
}

void controlEvent(ControlEvent theControlEvent)
{
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList1") InitSerial(theControlEvent.group().value(), 0); // initialize the serial port selected
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList2") InitSerial(theControlEvent.group().value(), 1);
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList3") InitSerial(theControlEvent.group().value(), 2);

  if (theControlEvent.isGroup() && theControlEvent.name().equals("UDP_flag")) uflag = (int)theControlEvent.group().value();
  if (theControlEvent.isGroup() && theControlEvent.name().equals("Save_Btn")) flag_save = (int)theControlEvent.group().value();
}

