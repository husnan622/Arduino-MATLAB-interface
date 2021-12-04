#include <Wire.h>

// definisikan alamat slave I2C
#define ALAMAT_SLAVE 2
// ukuran byte yang akan dikirim
#define JUMLAH_BYTE 1
// deklarasikan variabel untuk data sensor
byte bacaSensor[JUMLAH_BYTE];
// baca hanya satu byte jika ada request
int byteTerima = 1;

void setup()
{
  // aktifkan komunikasi I2C
  Wire.begin(ALAMAT_SLAVE);
  // kirim berdasarkan request dr master  
  Wire.onRequest(requestEvent); 
  Wire.onReceive(receiveEvent);
  pinMode(13, OUTPUT);
}

void loop()
{ 
   //tidak melakukan apa-apa 
}

void requestEvent()
{
  // jika ada request, kirim pembacaan data di A0
  bacaSensor[0] = analogRead(A0)/4;
  Wire.write(bacaSensor,JUMLAH_BYTE);
  delay(100);   
}

void receiveEvent(int byteTerima)
{
  // baca permintaan
  int request = Wire.read(); 
  if (request == 0) {
    // jika diterima 0, maka matikan led di pin 13
    digitalWrite(13, LOW);
  }  
  if (request == 1) {
    // jika diterima 1, maka hidupkan led di pin 13
    digitalWrite(13, HIGH);
  }  
  delay(100); 
}