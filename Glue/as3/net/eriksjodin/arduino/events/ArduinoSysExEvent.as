package net.eriksjodin.arduino.events
{
	
	import flash.utils.ByteArray;
	import flash.events.Event;
	
	public class ArduinoSysExEvent extends Event{
	
		public static const SYSEX_MESSAGE : String = "ARD_SYSEX_MESSAGE";
		
		private var _port:int;
		private var _data:ByteArray;
		
		public function ArduinoSysExEvent(type:String, port:int, data:ByteArray){
			super(type);
			_port = port;
			_data = data;
		}
		
		// mandatory override of the inherited clone() method
	    override public function clone():Event{
	    	return new ArduinoSysExEvent(type, port, data);
	    }
		
		public function set data(d:ByteArray):void{
			_data = d;
		}
		
		public function set port(n:int):void{
			_port = n;
		}
		
		public function get data():ByteArray {
			return _data;
		}
		
		public function get port():int {
			return _port;
		}
		
	}
}