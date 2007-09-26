/*
 * Copyright 2007 (c) Erik Sjodin, eriksjodin.net
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
package net.eriksjodin.arduino {
	
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	import net.eriksjodin.arduino.events.ArduinoEvent;
	import net.eriksjodin.arduino.events.ArduinoSysExEvent;
	import flash.utils.ByteArray;
	import net.eriksjodin.helpers.Log;
	
	 /**
	 * The Arduino class acts as a proxy for Arduino boards that communicate over a serial proxy using the Firmata protocol.
	 * @author Erik Sjodin, eriksjodin.net
	 */
	public class Arduino extends Socket {
		
		// enumerations
		public static const OUTPUT : int = 1;
		public static const INPUT	: int = 0;
		public static const HIGH : int = 1;
		public static const LOW : int = 0;
		public static const ON : int = 1;
		public static const OFF : int = 0;
		public static const PWM : int = 2;
		 	
		private var _host			: String  = "127.0.0.1"; 	
		private var _port			: uint  = 5333;		 
		
		// data processing variables
		private var _waitForData 				: int = 0;
		private var _executeMultiByteCommand 	: int = 0;	
		private var _multiByteChannel			: int = 0; 		// indicates which pin the data came from
		
		// data holders
		private var _storedInputData		: Array = new Array();
		private var _analogData				: Array = new Array();
		private var _previousAnalogData		: Array = new Array();
		private var _digitalData			: Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private var _previousDigitalData	: Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		private var _firmwareVersion		: int = 0;
		private var _digitalPins			: int = 0;
		private var _sysExData				: ByteArray = new ByteArray();
		
		// private enums
		private static const ARD_TOTAL_DIGITAL_PINS			: uint = 14; 
		
		// computer <-> arduino messages
		private static const ARD_DIGITAL_MESSAGE			: int = 144; 
		private static const ARD_REPORT_DIGITAL_PORTS		: int = 208; 
		private static const ARD_REPORT_ANALOG_PIN			: int = 192; 
		private static const ARD_REPORT_VERSION				: int = 249; 
		private static const ARD_SET_DIGITAL_PIN_MODE		: int = 244; 	
		private static const ARD_ANALOG_MESSAGE				: int = 224; 
		private static const ARD_SYSTEM_RESET				: int = 255; 
		private static const ARD_SYSEX_MESSAGE_START		: int = 240;
		private static const ARD_SYSEX_MESSAGE_END			: int = 247;
		
		public function Arduino(host:String = "127.0.0.1", port:int = 5333) {
			super();			
	
			if ((_port < 1024) || (_port > 65535)) {
				trace("Arduino: Port must be from 1024 to 65535!")		
			} else {
				_port = port;
			}
			
			// auto connect
			super.connect(_host,_port);
			
			// listen for socket data
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler, false, 0, true);			
		}
		
		//---------------------------------------
		//	PUBLIC FUNCTIONS
		//---------------------------------------
				
		// GETTERS
		
		public function getFirmwareVersion (): int{
			return _firmwareVersion;
		}
		
		public function getAnalogData (pin:int): int{
			return _analogData[pin];
		}
		
		public function getDigitalData (pin:int): int{
			return _digitalData[pin];
		}
		
		public function setAnalogPinReporting (pin:int, mode:int):void{
			writeByte(ARD_REPORT_ANALOG_PIN+pin);
			writeByte(mode);
		}
	
		public function enableDigitalPinReporting ():void{
			writeByte(ARD_REPORT_DIGITAL_PORTS);
			writeByte(1);
		}
		
		public function disableDigitalPinReporting ():void{
			writeByte(ARD_REPORT_DIGITAL_PORTS);
			writeByte(1);
		}
		
		public function setPinMode (pin:Number, mode:Number):void{
			writeByte(ARD_SET_DIGITAL_PIN_MODE);
			writeByte(pin);
			writeByte(mode);
		}
		
		public function writeDigitalPin (pin:int, mode:int):void{
		
			var mask:Number = mode << pin;  // get pins 8-13
			
			// set the bit
			if(mode==1)
				_digitalPins |= (mode << pin);
				
			// clear the bit	
			if(mode==0)
				_digitalPins &= ~(1 << pin);
	
			// transmit
	  		writeByte(ARD_DIGITAL_MESSAGE);
	  		writeByte(_digitalPins % 128); // Tx pins 0-6
	  		writeByte(_digitalPins >> 7);  // Tx pins 7-13
	
		}
		
		public function writeDigitalPins (mask:Number):void{
			// TODO
		}
		
		public function writeAnalogPin (pin:Number, value:Number):void{
			writeByte(ARD_ANALOG_MESSAGE+pin);
			writeByte(value % 128);
			writeByte(value >> 7);		
		}
		
		// TODO apply filters...
		public function setAnalogPinSmoothing (pin:Number, alpha:Number):void{
	
		}
		
		public function requestFirmwareVersion ():void{
			writeByte(ARD_REPORT_VERSION);
		}
		
		public function resetBoard ():void{
			writeByte(ARD_SYSTEM_RESET);
		}
		
		//---------------------------------------
		//	PRIVATE FUNCTIONS
		//---------------------------------------
		private function socketDataHandler(event:ProgressEvent):void {
	    	while (bytesAvailable>0)
				processData(readByte());
		}
	
		private function processData (inputData:int) : void{
			
			if(inputData<0) 
				inputData=256+inputData;	
				
			// we have command data
			if(_waitForData>0 && inputData<128) {
				_waitForData--;
				
				// collect the data
				_storedInputData[_waitForData] = inputData;
				
				// we have all data executeMultiByteCommand
				if(_waitForData==0) {
					switch (_executeMultiByteCommand) {
						case ARD_DIGITAL_MESSAGE:
							processDigitalBytes(_storedInputData[1], _storedInputData[0]); //(LSB, MSB)	
						break;
						case ARD_REPORT_VERSION: // report version
							_firmwareVersion = _storedInputData[0]+_storedInputData[1] / 10;
							dispatchEvent(new ArduinoEvent(ArduinoEvent.FIRMWARE_VERSION, 0, _firmwareVersion, _port));
						break;
						case ARD_ANALOG_MESSAGE: 
							// TODO apply smoothing
							_analogData[_multiByteChannel] = (_storedInputData[0] << 7) | _storedInputData[1];
							if(_analogData[_multiByteChannel]!=_previousAnalogData[_multiByteChannel])
								dispatchEvent(new ArduinoEvent(ArduinoEvent.ANALOG_DATA, _multiByteChannel, _analogData[_multiByteChannel], _port));
							_previousAnalogData[_multiByteChannel] = _analogData[_multiByteChannel];
						break;
					}
				
				}
			}
			// we have SysEx command data
			else if(_waitForData<0){
					// we have all sysex data
					if(inputData==ARD_SYSEX_MESSAGE_END){
						_waitForData=0;
						dispatchEvent(new ArduinoSysExEvent(ArduinoSysExEvent.SYSEX_MESSAGE, _port, _sysExData));
						_sysExData = new ByteArray();
					}
					// still have data, collect it
					else {
						_sysExData.writeByte(inputData);
					}
			}
			// we have a command
			else{
				
				var command:int;
				
				// extract the command and channel info from a byte if it is less than 0xF0
				if(inputData < 240) {
				  command = inputData & 240;
				  _multiByteChannel = inputData & 15;
				} 
				else {
				  // commands in the 0xF* range don't use channel data
				  command = inputData; 
				}
	
				switch (command) {
					case ARD_REPORT_VERSION:
					case ARD_DIGITAL_MESSAGE:
					case ARD_ANALOG_MESSAGE:
						_waitForData = 2;  // 2 bytes needed 
						_executeMultiByteCommand = command;
					break;
					case ARD_SYSEX_MESSAGE_START:
						_waitForData = -1;  // n bytes needed 
						_executeMultiByteCommand = command;
					break;
				}
				
			}	
		}
		
		private function processDigitalBytes(pin0_6:int, pin7_13:int) : void{
	  		var i:int;
	  		var mask:int;
	  		var twoBytesForPorts:int;
			
		  // this should be converted to use PORTs (?)
		  twoBytesForPorts = pin0_6 + (pin7_13 << 7);
		  
		  for(i=2; i<ARD_TOTAL_DIGITAL_PINS; ++i) { // ignore Rx,Tx pins (0 and 1)
			mask = 1 << i;
			_digitalData[i]=(twoBytesForPorts & mask)>>i;
			if(_digitalData[i]!=_previousDigitalData[i])
				dispatchEvent(new ArduinoEvent(ArduinoEvent.DIGITAL_DATA, i, _digitalData[i], _port));
			_previousDigitalData[i] = _digitalData[i];
		  }
		}
	}
}