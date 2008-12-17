#include <Firmata.h>

/*
   Reads a rotary encoder with interrupts
   The encoder should be hooked up with common to GROUND,
   encoder0PinA to pin 3 and encoder0PinB to pin 4 
   
   Uses Arduino pullups on A & B channel outputs
   The pullups saves having to hook up resistors 
   to the A & B channel outputs.
   
   Data is transmitted via firmata encoded as analog data from pin one.
   
   @author erik.sjodin, www.eriksjodin.net
*/ 

#define encoder0PinA  3
#define encoder0PinB  4

#define ANALOG_MESSAGE  224 // Send data for an analog pin (or PWM)

volatile unsigned int encoder0Pos = 0;

void setup() { 

  pinMode(encoder0PinA, INPUT); 
  digitalWrite(encoder0PinA, HIGH);       // turn on pullup resistor
  pinMode(encoder0PinB, INPUT); 
  digitalWrite(encoder0PinB, HIGH);       // turn on pullup resistor
  attachInterrupt(1, doEncoder, CHANGE);  // encoder pin on interrupt 1, i.e. pin 3
  Serial.begin(115200);
} 

void loop(){
  // do nothing
}


void doEncoder(){
  if (digitalRead(encoder0PinA) == HIGH) {   // found a low-to-high on channel A
    // check channel B to see which way the encoder is turning
    if (digitalRead(encoder0PinB) == LOW) { // turning CCW 
       
      if(encoder0Pos <= 0){
        encoder0Pos = 359;
      }
      else  {                                  
        encoder0Pos = encoder0Pos - 1;         
      }
      
    } 
    else {  // turning CW
      if(encoder0Pos >= 359){
        encoder0Pos = 0;
      }
      else {     
       encoder0Pos = encoder0Pos + 1;         
      }
    }
  }
  Firmata.sendAnalog(1,encoder0Pos);                                  
}
