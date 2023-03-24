#include <Wire.h>
#include <ESP8266WiFi.h>

WiFiClient client;

const char* ssid     = "unknown";
const char* password = "qwertyuiop";

const char* host = "192.168.137.1";
const int httpPort = 1000;

const int MPU = 0x68; //I2C address
int16_t aX, aY, aZ, temp, gX, gY, gZ;
int val;

void setup() {
  Wire.begin(4, 5);
  Wire.beginTransmission(MPU);
  Wire.write(0x6B);               // PWR_MGMT_1 register
  Wire.write(0);                  // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(115200);
  delay(10);

  // We start by connecting to a WiFi network
  Serial.println();
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

  while(!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }
}

// Use WiFiClient class to create TCP connections

void loop() {
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);               // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 14, true); // request a total of 14 registers
  aX = Wire.read() << 8 | Wire.read();
  aY = Wire.read() << 8 | Wire.read();
  aZ = Wire.read() << 8 | Wire.read();
  temp = Wire.read() << 8 | Wire.read();
  gX = Wire.read() << 8 | Wire.read();
  gY = Wire.read() << 8 | Wire.read();
  gZ = Wire.read() << 8 | Wire.read();

   //Serial.print("connecting to ");
  //Serial.println(host);

  // We now create a URI for the request
  //  String url = "/input/";
  //  url += streamId;
  //  url += "?private_key=";
  //  url += privateKey;
  //  url += "&value=";
  //  url += value;

  // This will send the request to the server
  /*  client.print(String("GET ") + url + " HTTP/1.1\r\n" +
                 "Host: " + host + "\r\n" +
                 "Connection: close\r\n\r\n");*/
  val++;

  client.print(String("@") + "  " + aX + "\r\n\r\n");
  delay(10);

    // Read all the lines of the reply from server and print them to Serial
//    if(client.available()){
//      String line = client.readStringUntil('\r');
//      Serial.print(line);
//    }
}

