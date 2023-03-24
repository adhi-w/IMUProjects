
import processing.serial.Serial; // serial library
Serial serial;

int baudrate = 115200;  //38400


//UART Variable
int serial_conect;
int commListMax;
float[] data = new float[20];
int[][] comindata=new int[13][12];
int [] combuff=new int[10];

Textlabel m_Comm ; 
ListBox commListbox;
ListBox portlist;
ListBox saveBtn; 

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
  
   /////////////////////////////////////////
  ///    Save Button //////////  
  saveBtn = cp5.addListBox("Save_Btn", 10, 30, 110, 240); 
  saveBtn.captionLabel().set("Save Data");
  saveBtn.setColorBackground(#FF00FF);

  saveBtn.addItem("start recording", 1);
  saveBtn.addItem("stop", 0);

  /////////////////////////////////////////

  //Comport List Selection                   
  commListbox = cp5.addListBox("portComList1", width-130, 30, 110, 240); // make a listbox and populate it with the available comm ports
  commListbox.captionLabel().set("PORT COM 1");
  commListbox.setColorBackground(#0000FF);


  for (int i=0; i<Serial.list ().length; i++) 
  {

    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 )
    { 
      commListbox.addItem(pn, i); // addItem(name,value)
    }
    commListMax = i;
  }

  commListbox.addItem("Close Comm 1", ++commListMax); // addItem(name,value)
  // text label for which comm port selected
  m_Comm = cp5.addTextlabel("Comm Port 1", "No Port Selected", width-131, 8).setColor(0xffff0000); // textlabel(name,text,x,y)
}
float[] last_data = new float[5];
void serialEvent (Serial usbPort) 
{  
  try {
    
    String usbString = usbPort.readStringUntil ('#'); 
      
    if (usbString != null) 
    {
      usbString= trim(usbString);

    } 
   
      data = float(split(usbString, '?'));

      data[1]=(data[1]/100)-2;
      data[2]=(data[2]/100)-2;
      data[3]=(data[3]/100)-2;
      data[4]=(data[4]/100)-2;
      
      if(data[0]==1)  //-------ID 1
      {  
        q[1][0]=data[1];    q[1][1]=data[2];    q[1][2]=data[3];    q[1][3]=data[4];
      }
      else if(data[0]==2)  //-------ID 2
      {  
        q[2][0]=data[1];    q[2][1]=data[2];    q[2][2]=data[3];    q[2][3]=data[4];
      }
      else if(data[0]==3)  //-------ID 3
      {  
        q[3][0]=data[1];    q[3][1]=data[2];    q[3][2]=data[3];    q[3][3]=data[4];
      }
      else if(data[0]==4)  //-------ID 4
      {  
        q[4][0]=data[1];    q[4][1]=data[2];    q[4][2]=data[3];    q[4][3]=data[4];
      }
      else if(data[0]==5)  //-------ID 5
      {  
        q[5][0]=data[1];    q[5][1]=data[2];    q[5][2]=data[3];    q[5][3]=data[4];
      }
      else if(data[0]==6)  //-------ID 6
      {  
        q[6][0]=data[1];    q[6][1]=data[2];    q[6][2]=data[3];    q[6][3]=data[4];
      }
       else if(data[0]==7)  //-------ID 7
      {  
        q[7][0]=data[1];    q[7][1]=data[2];    q[7][2]=data[3];    q[7][3]=data[4];
      }
       else if(data[0]==8)  //-------ID 8
      {  
        q[8][0]=data[1];    q[8][1]=data[2];    q[8][2]=data[3];    q[8][3]=data[4];
      }
       else if(data[0]==9)  //-------ID 9
      {  
        q[9][0]=data[1];    q[9][1]=data[2];    q[9][2]=data[3];    q[9][3]=data[4];
      }
       else if(data[0]==10)  //-------ID 10
      {  
        q[10][0]=data[1];    q[10][1]=data[2];    q[10][2]=data[3];    q[10][3]=data[4];
      }
       else if(data[0]==11)  //-------ID 11
      {  
        q[11][0]=data[1];    q[11][1]=data[2];    q[11][2]=data[3];    q[11][3]=data[4];
      }
        else if(data[0]==12)  //-------ID 12
      {  
        q[12][0]=data[1];    q[12][1]=data[2];    q[12][2]=data[3];    q[12][3]=data[4];
      }
        else if(data[0]==13)  //-------ID 13
      {  
        q[13][0]=data[1];    q[13][1]=data[2];    q[13][2]=data[3];    q[13][3]=data[4];
      }


    //      println(q[0] +"\t"+ q[1] +"\t"+ q[2] +"\t"+ q[3]);
  }

  catch (RuntimeException  e)
  {
    println("Waiting For Clean Serial Packet");
  }
}

//initialize the serial port selected in the listBox
void InitSerial(float portValue, int n) 
{
  if (portValue < commListMax) {
    String portPos = Serial.list()[int(portValue)];
    m_Comm.setValue("Connected = " + shortifyPortName(portPos, 8));
    serial = new Serial(this, portPos, baudrate);
    serial.bufferUntil('\n');
    serial_conect=1;
  } else 
  {
    m_Comm.setValue("Not Connected");
    serial.clear();
    serial.stop();
    serial_conect=0;
  }
}


void serialFlag()
{
  if (serial_conect==1)
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
}

void controlEvent(ControlEvent theControlEvent)
{
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList1") InitSerial(theControlEvent.group().value(), 0); // initialize the serial port selected
  if (theControlEvent.isGroup() && theControlEvent.name().equals("Save_Btn")) flag_save = (int)theControlEvent.group().value();
}

