/**
 * Rotary Encoder example, to be used with an rotary encoder connected to an
 * Arduino board loaded with RotEnc.pde. 
 * The angle from the rotary encoder is sent from the arduino as analog data on pin 1.
 * @author erik.sjodin, www.eriksjodin.net
 */
package
{
	import net.eriksjodin.arduino.events.ArduinoPinEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.eriksjodin.arduino.Arduino;
	
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class SimpleIO extends Sprite
	{
		private var a:Arduino;
		
		public function SimpleIO()
		{
			this.setupArduino();
		}
		
		/**
		 * Configures the Arduino object
		 */
		private function setupArduino(): void
		{	
			// connect to a serial proxy on port 5331
		 	a = new Arduino("127.0.0.1", 5331);
		 	
		 	a.addEventListener(ArduinoPinEvent.FIRMWARE_VERSION, onReceiveFirmwareVersion);
		 	a.addEventListener(ArduinoPinEvent.DIGITAL_DATA, onReceiveDigitalData);
		 	a.addEventListener(ArduinoPinEvent.ANALOG_DATA, onReceiveAnalogData);
			a.addEventListener(Event.CONNECT,onSocketConnect); 
			a.addEventListener(Event.CLOSE,onSocketClose);  
		}
	
		// The firmware version is requested when the ArduinoProxy is initialized. 
		// When we receive this event we know that the Arduino has been successfully connected.
		// I.e. this is a good place to do initial setups on the board
		public function onReceiveFirmwareVersion(e:ArduinoPinEvent):void {
			trace("Firmware version: " + e.value);
			
			// the port value of an event can be used to determine which board the event was dispatched from
			// this is one way of dealing with multiple boards, another is to add different listener methods
			trace("Port: " + e.port);
			
			// do some stuff on the Arduino...
			initArduino();
		}
		
		public function initArduino():void {
				
				// set a pin to output
				a.setPinMode(13, Arduino.OUTPUT);
				
				// set a pin to high
				a.writeDigitalPin(13, Arduino.HIGH);
				
				// turn on pull ups
				//a.writeDigitalPin(2, Arduino.HIGH);
				//a.writeDigitalPin(4, Arduino.HIGH);
				
				// set digital pin 4 to input
				a.setPinMode(4, Arduino.INPUT);
				a.setPinMode(2, Arduino.INPUT);
				
				// enable reporting for digital pins
				a.enableDigitalPinReporting();
				
				// disable reporting for digital pins
				//a.disableDigitalPinReporting();
				
				// enable reporting for an analog pin
				// a.setAnalogPinReporting(3, Arduino.ON);
				//a.setAnalogPinReporting(3, 1);
				
				// disable reporting for an analog pin
				//a.setAnalogPinReporting(3, Arduino.OFF);
				
				// set a pin to PWM
				//a.setPinMode(11, Arduino.PWM);
				a.setPinMode(11, 2)
				
				// write to PWM
				a.writeAnalogPin(11, 255);
				
				// trace out the most recently received data
				
				trace("Firmware version is: " + a.getFirmwareVersion());
				trace("Analog pin 3 is: " + a.getAnalogData(3));
				trace("Digital pin 4 is: " + a.getDigitalData(4));	
		}
		
		// triggered when a serial socket connection has been established
		public function onSocketConnect(e:Object):void {
			trace("Socket connected!");
			initArduino();
		}
		
		// triggered when a serial socket connection has been closed
		public function onSocketClose(e:Object):void {
			trace("Socket closed!");
		}
		
		// trace out the data when it arrives...	
		public function onReceiveAnalogData(e:ArduinoPinEvent):void {
			trace("Analog pin " + e.pin + " on port: " + e.port +" = " + e.value);
		}
		
		// triggered when digital data is received from an Arduino
		public function onReceiveDigitalData(e:ArduinoPinEvent):void {
			trace("Digital pin " + e.pin + " on port: " + e.port +" = " + e.value);
		}
		
	}
}