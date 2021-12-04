byte dataKu;
byte buffer;
boolean prosesSensor = false;
boolean prosesLED = false;
boolean ledState = false;

const int ledPin =  7; 

const int PinSS = 10;
const int PinMOSI = 11;
const int PinMISO = 12;
const int PinSCK = 13;

void setup (void)
{
  // bersihkan register SPI Control
  SPCR = 0;
  // (1<<SPE) --> aktifkan SPI
  // (1<<SPIE) --> aktifkan interupsi
  SPCR = (1<<SPIE)|(1<<SPE);
  // definisikan arah pin
  pinMode(PinMISO, OUTPUT);
  pinMode(PinMOSI, INPUT);
  pinMode(PinSS, INPUT);
  pinMode(PinSCK, INPUT);
  // sebuah led akan ditempatkan disini
  pinMode(ledPin, OUTPUT);  

}  

// Routine untuk interupsi
ISR (SPI_STC_vect)
{
  //ambil nilai dari register data
  buffer = SPDR;
    //jika 100 maka padamkan LED
    if (buffer == 100) 
    {
      prosesLED = true;
      ledState = false;
    }
    //jika 101 maka nyalakan LED
    else if (buffer == 101) 
    {
      prosesLED = true;
      ledState = true;
    }
    //jika 1 maka baca sensor
    else if (buffer == 1)
    {
      prosesSensor = true;
    }
    //baca sensor berhenti
    else if (buffer == 0)
    {
      prosesSensor = false;
    }
    //jika selain itu maka diamkan saja
    else
    {      
    } 
}  

void loop (void)
{
  //Baca sensor
  if(prosesSensor == true){      
    dataKu = analogRead(A0)/4;
    SPDR =  dataKu;
    prosesSensor = true; //kunci 
  }
  //Nyala/padamkan LED
  if(prosesLED == true){     
    if (ledState == true){
      digitalWrite(ledPin, HIGH);
    }
    else if (ledState == false){
      digitalWrite(ledPin, LOW);
    }
  prosesLED = false;      
  }
delay(50);
} 
