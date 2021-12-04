double x;
 
void setup() {
   //kecepatan komunikasi serial 
   Serial.begin(9600);
   x = 0;
}
 
void loop() {
   Serial.flush();
   Serial.println(sin(x));
   //Tunggu sebentar utk komunikasi serial
   delay(50);
   Serial.flush();
   Serial.println(cos(x));
   //Tunggu sebentar utk komunikasi serial
   delay(50);
   x += .05; 
   if(x >= 2*3.14)
     x = 0;
}

