/*
  Rangkaian:
 * LCD RS pin ke digital pin 12
 * LCD Enable pin ke digital pin 11
 * LCD D4 pin ke digital pin 5
 * LCD D5 pin ke digital pin 4
 * LCD D6 pin ke digital pin 3
 * LCD D7 pin ke digital pin 2
 * LCD R/W pin ke ground
 * LCD VSS pin ke ground
 * LCD VCC pin ke 5V
 * 10K potensiometer:
 * kaki-kaki samping ke +5V dan ground
 * kaki tengah ke LCD VO pin (pin 3)
*/

// pustaka untuk LCD
#include <LiquidCrystal.h>

// inisialisasi pustaka beserta pin2nya
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

void setup()
{
  Serial.begin(9600);
  lcd.begin(16, 2);
  lcd.setCursor(0,0); 
  lcd.print("Hello, world!");    
}

void loop()
{
  if (Serial.available()) {
    // delay sebentar
    delay(100);
    // clear the screen
    lcd.clear();
    int x = 0;
    int z = 0;
    // baca semua karakter yang ada
    while (Serial.available() > 0) {      
      x = x + 1;      
      //penuhi baris pertama
      if(x <= 16)
      {        
        // tampilkan setiap karakter ke LCD
        lcd.write(Serial.read());  
      }
      else 
      {
        //jika sudah 16, pindah ke baris kedua
        lcd.setCursor(z, 1);
        // tampilkan setiap karakter ke LCD
        lcd.write(Serial.read());
        z = z + 1; 
        Serial.println(z);        
      }     
    }
  }
}

