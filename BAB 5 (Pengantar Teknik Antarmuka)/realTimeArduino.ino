double x; 
void setup() {
   //kecepatan komunikasi serial 
   Serial.begin(9600);
   x = 0;
}
 
void loop() {
   Serial.flush();
   Serial.println(sin(x));
   x += .05;
 
   if(x >= 2*3.14)
     x = 0;

   //Tunggu sebentar utk komunikasi serial
   delay(50);
}

