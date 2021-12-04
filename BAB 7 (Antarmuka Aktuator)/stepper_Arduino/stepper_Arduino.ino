//definisikan pin untuk arah dan kecepatan
int pinArah = 2;
int pinStep = 3;

//untuk menampung data input ke stepper
char inputMatlab;
//varibel - variabel kontrol
int kontrolArah;
unsigned int kecepatan;
boolean proses;

void setup()
{
  pinMode(pinArah,OUTPUT);
  pinMode(pinStep,OUTPUT);  
  Serial.begin(9600);  
}

void loop()
{
  if(Serial.available())
  {
    inputMatlab = Serial.read();
    //berhenti (disconnect)
    if(inputMatlab == 'x')
    {
      digitalWrite(pinStep, LOW);
      proses = false;          
    }
    //mulai (connect)
    else if(inputMatlab == 'y')
    {
      proses = true;
    }
    //motor maju
    else if(inputMatlab == 'f')
    {
      kontrolArah = 1;
    }
    //motor mundur
    else if(inputMatlab == 'b')
    {
      kontrolArah = 0;         
    }
    //terima waktu delay untuk putaran motor
    else if(inputMatlab == 'a')
    {
      unsigned int integerTunda = 0; 
      char incomingByte;  
      while(1)
      {      
        incomingByte = Serial.read();
        if(incomingByte == 'o')
        {
          break;
        } 
        if(incomingByte == -1)
        {
          continue;
        }   
        
        integerTunda *= 10;        
        integerTunda = ((incomingByte - 48) + integerTunda);
        kecepatan = integerTunda;          
      }
      kecepatan = map(kecepatan,0,100,100,2);       
    }                
  }
  
  //motor bergerak
  if(proses == true)
  {      
    digitalWrite(pinArah, kontrolArah);
    digitalWrite(pinStep, LOW);
    digitalWrite(pinStep, HIGH);
    delay(kecepatan); 
  }
}
  
  
  
  
