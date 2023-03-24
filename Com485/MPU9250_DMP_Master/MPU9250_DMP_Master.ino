#include <TimerOne.h>
#include "I2Cdev.h"
#include "MPU9250_9Axis_MotionApps41.h"

#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

MPU9250 mpu;

// class default I2C address is 0x68 = AD0 low
#define LED_PIN 13 // This is also becomes Chip Select RS485
int interrupt_pin = 0;  /////////////////////////////////////////////////////////////

//Define for communication---------------------------------------
#define clk 4 //CONNECT IT TO EXT-INT1 PIN ON ANOTHER BOARD
#define id1 5
#define id2 6
#define bit0 7
#define bit1 8
#define bit2 9
#define bit3 10
#define bit4 11
#define bit5 12
#define bit6 A0
#define bit7 A1
#define bit8 A2
//Define for communication---------------------------------------
//Varialbles for commuication-----------------------------------
bool bitdata[4][11], readysend[4][11], dataready = 0;
unsigned int a, i, b, c, r;
unsigned int w, x, y, z;
//Varialbles for commuication-----------------------------------


// MPU control/status vars
bool dmpReady = false;  // set true if DMP init was successful
uint8_t mpuIntStatus;   // holds actual interrupt status byte from MPU
uint8_t devStatus;      // return status after each device operation (0 = success, !0 = error)
uint16_t packetSize;    // expected DMP packet size (default is 42 bytes)
uint16_t fifoCount;     // count of all bytes currently in FIFO
uint8_t fifoBuffer[64]; // FIFO storage buffer

// orientation/motion vars
Quaternion q;           // [w, x, y, z]         quaternion container
VectorFloat gravity;    // [x, y, z]            gravity vector
float euler[3];         // [psi, theta, phi]    Euler angle container
float ypr[3];           // [yaw, pitch, roll]   yaw/pitch/roll container and gravity vector

//To check DMP frequency
int time1,time1old;
float freq1;


// ================================================================
// ===               INTERRUPT DETECTION ROUTINE                ===
// ================================================================

volatile bool mpuInterrupt = false;     // indicates whether MPU interrupt pin has gone high

void dmpDataReady() {
    mpuInterrupt = true;
}


// ================================================================
// ===                      INITIAL SETUP                       ===
// ================================================================

void setup() {

  //Setup1 for communication----------------------------------------
  //Setting id untuk masing masing paket 1byte----------
  bitdata[0][0] = 0;
  bitdata[0][1] = 0;
  bitdata[1][0] = 1;
  bitdata[1][1] = 0;
  bitdata[2][0] = 0;
  bitdata[2][1] = 1;
  bitdata[3][0] = 1;
  bitdata[3][1] = 1;
  //Setting id untuk masing masing paket 1byte----------

  pinMode(clk, OUTPUT);
  pinMode(id1, OUTPUT);
  pinMode(id2, OUTPUT);
  pinMode(bit0, OUTPUT);
  pinMode(bit1, OUTPUT);
  pinMode(bit2, OUTPUT);
  pinMode(bit3, OUTPUT);
  pinMode(bit4, OUTPUT);
  pinMode(bit5, OUTPUT);
  pinMode(bit6, OUTPUT);
  pinMode(bit7, OUTPUT);
  pinMode(bit8, OUTPUT);
  digitalWrite(clk, 1);
  //Setup1 for communication----------------------------------------

  
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
        TWBR = 24; // 400kHz I2C clock (200kHz if CPU is 8MHz)
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    mpu.initialize();
    devStatus = mpu.dmpInitialize();

    // supply your own gyro offsets here, scaled for min sensitivity
//    mpu.setXGyroOffset(99);
//    mpu.setYGyroOffset(-32);
//    mpu.setZGyroOffset(-8);
//    mpu.setXAccelOffset(-2561);
//    mpu.setYAccelOffset(1126);
//    mpu.setZAccelOffset(968);    

    
    // make sure it worked (returns 0 if so)
    if (devStatus == 0) {
        // turn on the DMP, now that it's ready
        mpu.setDMPEnabled(true);
        
        // enable Arduino interrupt detection
        attachInterrupt(interrupt_pin, dmpDataReady, RISING);
        mpuIntStatus = mpu.getIntStatus();

        // set our DMP Ready flag so the main loop() function knows it's okay to use it
        dmpReady = true;

        // get expected DMP packet size for later comparison
        packetSize = mpu.dmpGetFIFOPacketSize();
    } 
    else {
    }

    // configure LED for output
    pinMode(LED_PIN, OUTPUT);

    Timer1.initialize(20000);
    Timer1.attachInterrupt(senddata);
   
}



// ================================================================
// ===                    MAIN PROGRAM LOOP                     ===
// ================================================================

void loop() {

  digitalWrite(LED_PIN, 1);
    // if programming failed, don't try to do anything
    if (!dmpReady) return;
        
    // wait for MPU interrupt or extra packet(s) available
    while (!mpuInterrupt && fifoCount < packetSize) {
        // other program behavior stuff here
    }    

    // reset interrupt flag and get INT_STATUS byte
    mpuInterrupt = false;
    mpuIntStatus = mpu.getIntStatus();

    // get current FIFO count
    fifoCount = mpu.getFIFOCount();

    // check for overflow (this should never happen unless our code is too inefficient)
    if ((mpuIntStatus & 0x10) || fifoCount == 1024) {
        // reset so we can continue cleanly
        mpu.resetFIFO();

    // otherwise, check for DMP data ready interrupt (this should happen frequently)
    } else if (mpuIntStatus & 0x02) {
        // wait for correct available data length, should be a VERY short wait
        while (fifoCount < packetSize) fifoCount = mpu.getFIFOCount();

        // read a packet from FIFO
        mpu.getFIFOBytes(fifoBuffer, packetSize);
        
        // track FIFO count here in case there is > 1 packet available
        // (this lets us immediately read more without waiting for an interrupt)
        fifoCount -= packetSize;


        //////////// Check DMP frecuency
        time1=micros()-time1old;
        time1old=micros();
        freq1=1000000/time1;
            
        //////////

        mpu.dmpGetQuaternion(&q, fifoBuffer);
        //Programku mulai dari sini-------------------------------------------------
        w = (q.w + 2) * 100;
        x = (q.x + 2) * 100;
        y = (q.y + 2) * 100;
        z = (q.z + 2) * 100;
        //    Serial.print("?");
        //    Serial.print(w);
        //    Serial.print("?");
        //    Serial.print(x);
        //    Serial.print("?");
        //    Serial.print(y);
        //    Serial.print("?");
        //    Serial.print(z);
        //    Serial.print("#");
        //    Serial.println();
        convert2bin(w, 0); //ngonvert data quaternion jadi data biner
        convert2bin(x, 1);
        convert2bin(y, 2);
        convert2bin(z, 3);
    
        transferbuffer(); //nyimpen data biner yang tadi dikonvert ke buffer biar aman
        //nanti datanya dikirim ke slave sama Timer interrupt tiap 20ms
        //Sampe sini-------------------------------------------------
        digitalWrite(LED_PIN, 0);
    } 
    delay(5);
}


//Conversion function-------------------------------------
void convert2bin(unsigned int intdata, unsigned int row) {
  for (i = 0; i < 9; i++) {
    b = intdata & (1 << i);
    if (b > 0) {
      bitdata[row][i + 2] = 1;
    }
    else {
      bitdata[row][i + 2] = 0;
    }
  }
}
//Conversion function-------------------------------------

//Transmit data function----------------------------------
void senddata() {
  if (dataready) {
    digitalWrite(clk, 1);
    for (a = 0; a < 4; a++) {
      digitalWrite(clk, 1);
      delay(1);
      digitalWrite(id1, readysend[a][0]);
      digitalWrite(id2, readysend[a][1]);
      digitalWrite(bit0, readysend[a][2]);
      digitalWrite(bit1, readysend[a][3]);
      digitalWrite(bit2, readysend[a][4]);
      digitalWrite(bit3, readysend[a][5]);
      digitalWrite(bit4, readysend[a][6]);
      digitalWrite(bit5, readysend[a][7]);
      digitalWrite(bit6, readysend[a][8]);
      digitalWrite(bit7, readysend[a][9]);
      digitalWrite(bit8, readysend[a][10]);
      digitalWrite(clk, 0);
      delay(1);
    }
    digitalWrite(clk, 1);
  }
}
//Transmit data function----------------------------------

//Transfer buffer function--------------------------------
void transferbuffer() {
  dataready = 0;
  for (r = 0; r < 4; r++) {
    for (c = 0; c < 11; c++) {
      readysend[r][c] = bitdata[r][c];
      b = readysend[r][c];
    }
  }
  dataready = 1;
}
//Transfer buffer function--------------------------------



