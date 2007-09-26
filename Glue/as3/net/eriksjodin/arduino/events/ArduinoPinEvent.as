/* 
 *	ArduinoEvent - version 1.1 - 2007-04-08
 *
 *	Erik Sjodin (www.eriksjodin.net)
 *
 *	Revision history:
 *	Version 1.0 - 2007-03-24
 *
 */

package net.eriksjodin.arduino.events {

import flash.events.Event;

public class ArduinoPinEvent extends Event {

	// the pin that triggered the event
	private var _pin:int;
	
	// the value of the pin that triggered the event
	private var _value:Number;
	
	// the port number identifies the board that dispatched the event
	private var _port:int;
	
	// event identifiers
	public static const ANALOG_DATA : String = "ARD_ANALOG_DATA";
	public static const DIGITAL_DATA : String = "ARD_DIGITAL_DATA";
	public static const FIRMWARE_VERSION : String = "ARD_FIRMWARE_VERSION";
	
	public function ArduinoPinEvent(type:String, pin:int, value:Number, port:int){
		super(type);
		_pin = pin;
		_value = value;
		_port = port;
	}
	
	// mandatory override of the inherited clone() method
    override public function clone():Event{
    	return new ArduinoPinEvent(type, pin , value, port);
    }
             
	public function set pin(n:int):void{
		_pin = n;
	}
	
	public function set value(n:Number):void{
		_value = n;
	}
	
	public function set port(n:int):void{
		_port = n;
	}
	
	public function get pin():int {
		return _pin;
	}
	
	public function get value():Number {
		return _value;
	}
	
	public function get port():int {
		return _port;
	}
	
}

}
