/**
 * Rotary Encoder example, to be used with an rotary encoder connected to an
 * Arduino board loaded with RotEnc.pde. 
 * The angle from the rotary encoder is sent from the arduino as analog data on pin 1.
 * @author erik.sjodin, www.eriksjodin.net
 */
package
{
	import net.eriksjodin.arduino.Arduino;
	import net.eriksjodin.arduino.events.ArduinoPinEvent;
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class RotEnc extends Sprite
	{
		private var a:Arduino;
		
		public function RotEnc()
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
		 	
		 	// the angle from the rotary encoder is sent as analog data on pin 0
			a.addEventListener(ArduinoPinEvent.ANALOG_DATA, onReceiveAnalogData); 
		}
	
		// trace out the data when it arrives...	
		public function onReceiveAnalogData(e:ArduinoPinEvent):void {
			trace("Analog pin " + e.pin + ": " + e.value);
		}
		
	}
}