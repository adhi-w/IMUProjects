#include<Wire.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h> 
#include <ESP8266WebServer.h>


/* Set these to your desired credentials. */
const char *ssid = "Unknown device";
const char *password = "";

const int MPU=0x68; //I2C address
int16_t aX, aY, aZ, temp, gX, gY,gZ;

ESP8266WebServer server(80);

/* Just a little test message.  Go to http://192.168.4.1 in a web browser
 * connected to this access point to see it.
 */

void setup() {
  // put your setup code here, to run once:
  Wire.begin(4,5);
  Wire.beginTransmission(MPU);
  Wire.write(0x6B);               // PWR_MGMT_1 register
  Wire.write(0);                  // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(9600);

  delay(20);
  Serial.println();
  Serial.print("Configuring access point...");
  /* You can remove the password parameter if you want the AP to be open. */
  WiFi.softAP(ssid, password);
  
  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
  server.on("/", handleRoot);
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(20);
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);               // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,14,true);  // request a total of 14 registers
  aX = Wire.read()<<8|Wire.read();
  aY = Wire.read()<<8|Wire.read();
  aZ = Wire.read()<<8|Wire.read();
  temp = Wire.read()<<8|Wire.read();
  gX = Wire.read()<<8|Wire.read();
  gY = Wire.read()<<8|Wire.read();
  gZ = Wire.read()<<8|Wire.read();

server.handleClient();

  
//  Serial.print("aX= "); Serial.print(aX); Serial.print("\t");
//  Serial.print("aY= "); Serial.print(aY); Serial.print("\t");
//  Serial.print("aZ= "); Serial.print(aZ);
//  Serial.print ("\n");
//  //Serial.print("Temp= "); Serial.print(temp/340.00+36.53);   //equation for temperature in degrees C from datasheet
//  //Serial.print ("\n");
//  Serial.print("gX= "); Serial.print(gX); Serial.print("\t");
//  Serial.print("gY= "); Serial.print(gY); Serial.print("\t");
//  Serial.print("gZ= "); Serial.print(gZ);
//  Serial.print ("\n");
 
  
//  delay(20);
  
}

void handleRoot() {
  String xX = "setTimeout(function(){gx++;},1000);";
  String GX = "var gx=2;";
   
  String XX = "while(true){document.write(gx);}</script>";
  server.send(200, "text/html", "<script>" + GX + XX);
  
}
