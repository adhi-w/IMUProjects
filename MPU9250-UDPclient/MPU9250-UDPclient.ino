#include <ESP8266WiFi.h>
#include <WiFiUdp.h>

const char* ssid = "mpu";
const char* password = "qwertyuiop";

const char* IP = "192.168.137.1";
const int Port = 1000;      // local port to listen for UDP packets

WiFiUDP udp;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(38400);
  // We start by connecting to a WiFi network
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");

  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  Serial.println("Starting UDP");
  udp.begin(Port);
  Serial.print("Local port: ");
  Serial.println(udp.localPort());

}

void loop() {
  // put your main code here, to run repeatedly:
  int data[120];
  static unsigned int data_number = 0;
  int d[4];
  
  udp.beginPacket(IP, Port);

  for (int i = data_number; i < (data_number + Serial.available()); i++)
  {
    data[i] = Serial.read();
    data_number++;
    if (i >= 119)
      break;
  }
  if (data_number > 6 )
  {
    int max_buffer = data_number - 1;
    if (max_buffer > 119)   max_buffer = 119;
    
    for (int i = max_buffer; i >= 8; i--)
    {
      if (data[i] == 255 && data[i - 8] == 254)
      {
        d[0] = data[i - 7];
        d[1] = data[i - 6] * 10 + data[i - 5];
        d[2] = data[i - 4] * 10 + data[i - 3];
        d[3] = data[i - 2] * 10 + data[i - 1];

        udp.print(d[0]);    udp.print("x");
        udp.print(d[1]);    udp.print("x");
        udp.print(d[2]);    udp.print("x");
        udp.print(d[3]);    udp.print("x");

        //delay(5);
      }
      data_number = 0;
      break;
    }
  }
  if (data_number >= 120)   data_number = 0;

  udp.endPacket();

}
