/**
 * Parallax RFID example, to be used with an Parallax RFID reader connected to an
 * Arduino board loaded with ParallaxRFID.pde. 
 * RFID tags are sent from the arduino as SysEx messages.
 * @author erik.sjodin, www.eriksjodin.net
 */
package
{
	import net.eriksjodin.arduino.Arduino;
	import flash.display.Sprite;
	import net.eriksjodin.arduino.events.ArduinoSysExEvent;
	
	[SWF(backgroundColor="#000000", frameRate="60")]
	public class ParallaxRFID extends Sprite
	{
		private var a:Arduino;
		
		public function ParallaxRFID()
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
		 	
		 	// tags are sent as sysex messages
			a.addEventListener(ArduinoSysExEvent.SYSEX_MESSAGE, onReceiveSysEx); 
		}
	
		// triggered when a tag is received from the Arduino
		public function onReceiveSysEx(e:ArduinoSysExEvent):void {
			trace("Received tag: " + e.data);
		}
		
	}
}