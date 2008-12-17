package
{
	import net.eriksjodin.arduino.events.ArduinoEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.eriksjodin.arduino.Arduino;
	
	/**
	 * Arduino input / output example. 
	 * To be used with an Arduino board loaded with th Standard Firmata firmware.
	 * @author erik.sjodin, eriksjodin.net
	 */
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class SimpleIO extends Sprite
	{
		private var a:Arduino;
		
		public function SimpleIO()
		{
			this.setupArduino();
		}
		
		private function setupArduino(): void
		{	
			// connect to a serial proxy on port 5331
		 	a = new Arduino("127.0.0.1", 5331);
		 	
		 	// listen 
		 	a.addEventListener(Event.CONNECT,onSocketConnect); 
			a.addEventListener(Event.CLOSE,onSocketClose);
			
		 	// listen for data
		 	a.addEventListener(ArduinoEvent.FIRMWARE_VERSION, onReceiveFirmwareVersion);
		 	a.addEventListener(ArduinoEvent.DIGITAL_DATA, onReceiveDigitalData);
		 	a.addEventListener(ArduinoEvent.ANALOG_DATA, onReceiveAnalogData); 
		}
	
		// triggered when a serial socket connection has been established
		public function onSocketConnect(e:Object):void {
			trace("Socket connected!");
			
			// request the firmware version
			a.requestFirmwareVersion();
		}
		
		// triggered when a serial socket connection has been closed
		public function onSocketClose(e:Object):void {
			trace("Socket closed!");
		}
		
		// trace out data when it arrives...	
		public function onReceiveAnalogData(e:ArduinoEvent):void {
			trace("Analog pin " + e.pin + " on port: " + e.port +" = " + e.value);
		}
		
		// trace out data when it arrives...
		public function onReceiveDigitalData(e:ArduinoEvent):void {
			trace("Digital pin " + e.pin + " on port: " + e.port +" = " + e.value);
		}
		
		// the firmware version is requested when the Arduino class has made a socket connection.
		// when we receive this event we know that the Arduino has been successfully connected.
		public function onReceiveFirmwareVersion(e:ArduinoEvent):void {
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
			a.setAnalogPinReporting(3, Arduino.ON);
			
			// disable reporting for an analog pin
			//a.setAnalogPinReporting(3, Arduino.OFF);
			
			// set a pin to PWM
			a.setPinMode(11, Arduino.PWM);
			
			// write to PWM
			a.writeAnalogPin(11, 255);
			
			// trace out the most recently received data
			trace("Firmware version is: " + a.getFirmwareVersion());
			trace("Analog pin 3 is: " + a.getAnalogData(3));
			trace("Digital pin 4 is: " + a.getDigitalData(4));	
		}
		
	}
}