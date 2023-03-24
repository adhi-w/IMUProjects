import hypermedia.net.*;

UDP udp;
ListBox udp_flag;

void setup_UDP()
{
  cp5 = new ControlP5(this);
  
  udp_flag = cp5.addListBox("UDP_flag")
                .setPosition(width-520, 30)
                .setSize(110, 240)
                .setItemHeight(13)
                //.setBarHeight()
                .setColorBackground(#FF0F0F)
                //.setColorForeground(color(255, 100,0))
                ;                
                
  udp_flag.captionLabel().set("UDP")
                         .toUpperCase(true)
                         //.setColor(#0EFE0F)
                         //.style().marginTop = 2
                         ;
  
  udp_flag.addItem("Connect", 1);
  udp_flag.addItem("Disconnect", 0);
  
  //create new datagram connection on port 1000
  //and wait for incomming message
  udp = new UDP(this, 1000); 
  //udp.log(true;  // <--printout the connection activity
  udp.listen(true);  
  
}

void keyPressed()
{
//  if (key=='0') {}
//  String ip = "192.168.137.1";   //the remote IP address
//  int port  = 1000;              //the destination port
//
//  udp.send("My Data", ip, port);
}


void receive(byte[] data) {    //<--default handler
  //void receive(byte[] data,String ip, int port){    //<--extended handler 
    
  String d = new String(data);  
  String[] mData = d.split("x");

  ypr2[0] = int(mData[1]);
  ypr2[1] = int(mData[2]);
  ypr2[2] = int(mData[3]);
//float value1 = Float.valueOf(mData[0]).floatValue();
//float value2 = Float.valueOf(mData[1]).floatValue();
//float value3 = Float.valueOf(mData[2]).floatValue();

//println(mData);
println(ypr2[0], ypr2[1], ypr2[2]);

//  int[] ID = new int[13];
//  int[] buffer = new int[120];
//  int bytes_number = 0;  

//    data = subset(data, 0, data.length);
//    String message = new String( data );
//    
//   // print the result
//    println( "receive: \""+message+"\" from ");//+ip+" on port "+port );
}

