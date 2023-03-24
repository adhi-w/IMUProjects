
#define clk 3 //PIN EXT-INTERRUPT
#define id1 5
#define id2 6
#define bit0 7
#define bit1 9
#define bit2 8
#define bit3 10
#define bit4 12
#define bit5 11
#define bit6 A0
#define bit7 A1
#define bit8 A2

#define cs 13
#define r 0
#define wr 1
#define transdl 2 //Transition dellay from R to W for MAX485
#define sparator 63 //ascii of "?"
#define fin 35 //ascii of "#"

//------Starting ID = 96 --> id+96
#define id 1 //tinggal ubah ID yg ini aja, sesuaiin sama nomer yg d uC. 

//unsigned int data1 = 1134, data2 = 5678, data3 = 9012, data4 = 3456;
unsigned int myid, dw, dx, dy, dz, datain_id, rw, c, datain, val[4];
unsigned char in = 0;
bool received[4], comindata[4][9];

void setup() {
  pinMode(clk, INPUT);
  pinMode(id1, INPUT);
  pinMode(id2, INPUT);
  pinMode(bit0, INPUT);
  pinMode(bit1, INPUT);
  pinMode(bit2, INPUT);
  pinMode(bit3, INPUT);
  pinMode(bit4, INPUT);
  pinMode(bit5, INPUT);
  pinMode(bit6, INPUT);
  pinMode(bit7, INPUT);
  pinMode(bit8, INPUT);
  pinMode(13, OUTPUT);
  digitalWrite(cs, r);
  Serial.begin(115200);
  myid = id + 96;
  attachInterrupt(1, takedata, FALLING);
}

void loop() {
  //Checking system------------------------
  //  senddata();
  //  Serial.println();
  //  delay(20);
  //Checking system------------------------

  if (Serial.available()) {
    datain = Serial.read();
    if (datain == myid) { //kalo dipanggil master, kasi datanya..
      senddata();
    }
  }

}


void senddata() { //ngirim data ke master-----------------
  digitalWrite(cs, wr); //ngubah MAX485 ke mode nulis
  delay(transdl);

  Serial.write(myid);
  Serial.write(sparator);
  Serial.print(dw);
  Serial.write(sparator);
  Serial.print(dx);
  Serial.write(sparator);
  Serial.print(dy);
  Serial.write(sparator);
  Serial.print(dz);
  Serial.write(sparator);
  Serial.write(fin);

  delay(transdl);
  digitalWrite(cs, r); //ngubah MAX485 kne mode baca
}



void takedata() { //ngambil data dari uC imu, ini otomatis dari EXTERNAL INTERRUPT (ngedeteksi falling edge)
  datain_id = digitalRead(id1) + (digitalRead(id2) * 2);
  if (in == datain_id) {
    comindata[datain_id][0] = digitalRead(bit0);
    comindata[datain_id][1] = digitalRead(bit1);
    comindata[datain_id][2] = digitalRead(bit2);
    comindata[datain_id][3] = digitalRead(bit3);
    comindata[datain_id][4] = digitalRead(bit4);
    comindata[datain_id][5] = digitalRead(bit5);
    comindata[datain_id][6] = digitalRead(bit6);
    comindata[datain_id][7] = digitalRead(bit7);
    comindata[datain_id][8] = digitalRead(bit8);

    in++;
    if (in == 4) { //kalu udah komplit baca 4x
      convert2int(); //konvert data binernya ke desimal
      dw = val[0]; //nginputin data yg udah di konvert ke masing2 variabel
      dx = val[1];
      dy = val[2];
      dz = val[3];
      in = 0;
    }
  }
}

void convert2int() {
  for (rw = 0; rw < 4; rw++) {
    val[rw] = 0;
    for (c = 0; c < 9; c++) {
      val[rw] = val[rw] | (comindata[rw][c] << c);
    }
  }
}
