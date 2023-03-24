#include <TimerOne.h>


#define me 13
#define r 0
#define w 1
#define limtime 20000 //nentuin waktu timeout nya
#define transdl 2
#define ldata 25
#define sparator 63 //ascii of "?"
#define fin 35 //ascii of "#"

#define startid 97
#define slavenum 12


unsigned int a, i, p, bctimsk, bctifr, lastid;
bool timeout = 0, stpcnt;
unsigned int dataarray[ldata];

void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(115200);
  Serial1.begin(115200);
  lastid = startid + slavenum - 1;
}


void loop() {

  delay(20); //selang waktu sebelum membaca ke-13 sensor

  timeron();

  for (i = startid; i <= lastid; i++) {
    resetval(); 
    callslave(i); //containing delay "transdl(ms)" //minta data ke slave bersangkutan "i"
    Sreadmode(); //containing delay "transdl(ms)" 

    TCNT1 = 1;
    stpcnt = 0;
    //Checking respon form the slaves-----------------the limit is, the timeout value or got a respon from slave
    while (!timeout) {

      if (Serial1.available()) {
        dataarray[a] = Serial1.read();

        if (stpcnt) { //akan aktif kalo ID yg dikirim sm ID yang diminta sama
          TCNT1 = 1;  //ulang timer
        }

        if (dataarray[a] == i) { //kalo ID yang dikirim sm uC imu, sama dengan ID yg diminta program ini
          stpcnt = 1;
          timeout = 0;
          dataarray[0] = i;          a = 0;
        }

        if (dataarray[a] == fin) {
          Serial.print(i-96); //Untuk mengirim ID, nilainya dari program sini, bukan dari uC imu
  
          for (p = 1; p <= a; p++) { //Untuk nampilin data yang dikirim sama uC imu, nggak termasuk ID, termasuk sparator sama karakter penutup "#"
            Serial.write(dataarray[p]);
            dataarray[p] = 0;
          }
          
          timeout = 1;
          Serial.println(); //Akhir untuk 1 paket data----------
        }

        a++;
      }
    }
    //-----------------------------------------------------------------------
  }
  timeroff();


}

void callslave(unsigned int tid) {
  digitalWrite(me, w);
  delay(transdl);
  Serial1.write(tid);
}

void timeron() {
  //  Timer1.restart();
  Timer1.initialize(limtime);
  Timer1.attachInterrupt(timeup);
}

void timeroff() {
  Timer1.stop();
}

void Sreadmode() {
  delay(transdl);
  digitalWrite(me, r);
}

void timeup() {
  timeout = 1;
  a = 0;
  Serial.println("x");
}

void resetval() {
  timeout = 0;
  a = 0;
}
