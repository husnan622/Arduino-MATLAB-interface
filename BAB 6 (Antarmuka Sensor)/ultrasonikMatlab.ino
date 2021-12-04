const int trigPin = 6;
const int echoPin = 5;
int matlabData;
long durasi, cm;
 
void setup() {
  // inisialisasi komunikasi serial
  Serial.begin(9600);
}
 
void loop()
{
    if (Serial.available() > 0) {
    // baca data jika ada request
    matlabData = Serial.read();
   // jika request benar, kirim ke MATLAB
    if (matlabData ==1) 
    {
      cm = cariJarak();      
      Serial.println(cm);     
    }
  } 
}
 
//=================== Fungsi =======================
long mikrodetikKeCentimeter(long mikrodetik)
{

  // Kecepatan suara sebesar 340 m/s 
  // atau 29 mikro detik tiap centimeter
  // Bagi dua untuk mendapatkan jarak yang benar
  // (Ingat, ini adalah waktu sinyal bolak-balik)

  return mikrodetik / 29 / 2;
}


long cariJarak()
{

  // Triger dgn memberikan pulsa HIGH selama 10 us
  // Lalu, beri sinyal LOW utk mendapatkan sinyal yg tepat

  pinMode(trigPin, OUTPUT);
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
 
  //Baca sinyal HIGH yang ditangkap sensor
  pinMode(echoPin, INPUT);
  durasi = pulseIn(echoPin, HIGH);
 
  // Ubah dari waktu ke jarak 
  cm = mikrodetikKeCentimeter(durasi);
  return cm;
}

