#include <Firmata.h>
#include <SoftwareSerial.h>

/**
* Prallax RFID reader code for Arduino 
* Wiring version by BARRAGAN <http://people.interaction-ivrea.it/h.barragan>, modified for Arudino by djmatic
* Modified to use SoftwareSerial and Firmata by Erik Sjodin, eriksjodin.net
*
* Connect:
* Arduino Pin 3 to RFID SOUT
* Arduino GND to RFID GND
* Arduino Digital pin 2 to RFID /ENABLE
* Arduino 5v to RFID VCC
*/

int  val = 0; // temporary storage variable
boolean wait = false;

// --- Reader One
char rfidOneTag[10]; 
int rfidOneBytesRead = 0; 
int rfidOneEnablePin = 2;
int rfidOneRxPin=3;
int rfidOneTxPin=12;

// set up a new serial port, we won't ever transmit anything to the reader but let's set the tx pin anyway
SoftwareSerial rfidOneSerial =  SoftwareSerial(rfidOneRxPin, rfidOneTxPin);

void setup() { 

  Serial.begin(115200);
  
  // --- Reader One
  pinMode(rfidOneRxPin, INPUT);
  pinMode(rfidOneTxPin, OUTPUT);
  rfidOneSerial.begin(2400);    // RFID reader SOUT pin connected to Serial RX pin at 2400bps
  
  // --- Reader One
  pinMode(rfidOneEnablePin,OUTPUT);     // set digital pin 2 as OUTPUT to connect it to the RFID /ENABLE pin 
  digitalWrite(rfidOneEnablePin, LOW);  // initialise the reader with a reset cycle
  delay(100);
  digitalWrite(rfidOneEnablePin, HIGH);
  delay(100);
  digitalWrite(rfidOneEnablePin, LOW);
  delay(100);  
} 

void loop() { 

  // --- Reader One
  digitalWrite(rfidOneEnablePin, LOW);   // activate reader
  val = rfidOneSerial.read();
  if(val == 10) {                        // check for header 
    rfidOneBytesRead = 0; 
  } 
  else {
      if(val == 13) {                    // if header or stop bytes before the 10 digit reading 
        if(rfidOneBytesRead == 10) {                   // if 10 digit read is complete 
            digitalWrite(rfidOneEnablePin, HIGH);      // deactivate the reader
            // transmit the tag as a SysEx message
            Serial.print(START_SYSEX,BYTE);     
            Serial.print(rfidOneTag);       
            Serial.print(END_SYSEX,BYTE);         
            wait = true;
        } 
        rfidOneBytesRead = 0;                          // stop collecting the tag 
      }
      else {
        rfidOneTag[rfidOneBytesRead] = val;            // add the digit 
        rfidOneBytesRead++;                            // ready to read next digit
      }          
  }
  
  // common delay
  if(wait){
    delay(250); 
    wait=false;
  }
  
}
