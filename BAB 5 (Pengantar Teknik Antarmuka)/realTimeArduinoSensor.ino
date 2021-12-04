double x;
 
void setup() {
   //kecepatan komunikasi serial 
   Serial.begin(9600);
}
 
void loop() {
   Serial.flush();
   int nilaiSensor = analogRead(A0);
   Serial.println(nilaiSensor);
   delay(50);
}

