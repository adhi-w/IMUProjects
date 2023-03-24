void setup_UART()
{
  //Comport List Selection                   
  commListbox = cp5.addListBox("portComList",5,85,110,240); // make a listbox and populate it with the available comm ports

  commListbox.captionLabel().set("PORT COM");commListbox.setColorBackground(red_);
  
  for(int i=0;i<Serial.list().length;i++) 
  {
    
    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 ) commListbox.addItem(pn,i); // addItem(name,value)
    commListMax = i;
  }
  
  commListbox.addItem("Close Comm",++commListMax); // addItem(name,value)
  // text label for which comm port selected
  txtlblWhichcom = cp5.addTextlabel("txtlblWhichcom","No Port Selected",5,62); // textlabel(name,text,x,y)
  
}


void serialEvent (Serial usbPort) 
{
  String usbString = usbPort.readStringUntil ('\n');
  
  if (usbString != null) 
    {
    usbString = trim(usbString);
    println(usbString); //--> for debuging
    }

      float data[] = float(split(usbString, ','));
      //for (int sensorNum = 1; sensorNum < data.length; sensorNum++) { println(sensorNum + " " + data[sensorNum]);  } //--> for debuging
      
      //IMU data
      angx=data[1];
      angy=data[2];
//      gyro_y=data[3];
//      gyro_x=data[4];
//      head=data[5];
  
    
}


 //initialize the serial port selected in the listBox
 void InitSerial(float portValue) 
 {
  if (portValue < commListMax) {
    String portPos = Serial.list()[int(portValue)];
    txtlblWhichcom.setValue("Connected = " + shortifyPortName(portPos, 8));
    serial = new Serial(this, portPos, 38400);
    serial.bufferUntil('\n');
    serial_conect=1;

   

  } else 
  {
    txtlblWhichcom.setValue("Not Connected");
    serial.clear();
    serial.stop();
    serial_conect=0;

  }
 }
 
 void controlEvent(ControlEvent theControlEvent)
{
  if (theControlEvent.isGroup()) if (theControlEvent.name()=="portComList") InitSerial(theControlEvent.group().value()); // initialize the serial port selected
  
}



