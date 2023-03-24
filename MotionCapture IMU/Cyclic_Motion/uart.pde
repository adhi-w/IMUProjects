
import processing.serial.Serial; // serial library
Serial serial;

int baudrate = 115200;  //38400

int uflag = 0;

//UART Variable
int serial_conect;
int commListMax;
float[] data = new float[20];

Textlabel m_Comm ; 
ListBox commListbox;
ListBox portlist;
ListBox saveBtn; 

int flag_save = 1;

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
  commListbox = cp5.addListBox("portComList1", width-130, 30, 110, 240); // make a listbox and populate it with the available comm ports
  commListbox.captionLabel().set("PORT COM 1");
  commListbox.setColorBackground(#0000FF);

  /////////////////////////////////////////
  ///    Save Button //////////  
  saveBtn = cp5.addListBox("Save_Btn", 10, 30, 110, 240); 
  saveBtn.captionLabel().set("Save Data");
  saveBtn.setColorBackground(#FF0000);

  saveBtn.addItem("start recording", 1);
  saveBtn.addItem("stop", 0);

  /////////////////////////////////////////


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

void serialEvent (Serial usbPort) 
{  
  try {
    
    String usbString = usbPort.readStringUntil ('\n'); 

    if (usbString != null) 
    {
      usbString= trim(usbString);

    }   
      data = float(split(usbString, ','));
      
      q[0] = data[1];
      q[1] = data[2];
      q[2] = data[3];
      q[3] = data[4];
      acc[0]  = data[5]/4096;
      acc[1]  = data[6]/4096;
      acc[2]  = (data[7]/4096)-0.878;
      freq = data[8];

//      ypr[0] = -data1[1];
//      ypr[2] = data1[2]-180;
//      ypr[1] = data1[3]-180;
//      
//       if(d==1)
//      {
//        q_offset[0] = ypr[0];
//        q_offset[1] = ypr[1];
//        q_offset[2] = ypr[2];
//      }     
//      d=0;
//      
//    ypr[0] = convert.angleCorrection(ypr[0], q_offset[0]);  
//    ypr[1] = 360-convert.angleCorrection(ypr[1], q_offset[1]);
//    ypr[2] = 360-convert.angleCorrection(ypr[2], q_offset[2]);     
      
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

