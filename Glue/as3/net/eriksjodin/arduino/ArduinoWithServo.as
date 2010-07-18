/*
 * Copyright 2008 (c) 2008 Bjoern Hartmann, bjoern.org
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
package net.eriksjodin.arduino
{

	/**
	 * ArduinoWithServo class is a proxy objecr for Firmata2  protocol
	 * and StandardPlusServoFirmata firmware (included with this project).
	 * Currently only works on pins 9 or 10.
	 * @author Bjoern Hartmann, bjoern.org
	 */
	public class ArduinoWithServo extends Arduino
	{
		public static const SERVO:int=4;
		private static const SERVO_CONFIG:int=0x70;

		public function ArduinoWithServo(host:String="127.0.0.1", port:int=5331)
		{
			super(host, port);
		}

		//Send SysEx Message to configure servo
		// Ercan Bozoglu, why use Numbers in parameters and then convert all to int?
		public function setupServo(pin:int, angle:int, minPulse:int=544, maxPulse:int=2400):void
		{
			if (!destroyed)
			{
				if (pin == 9 || pin == 10)
				{
					/*TODO: i believe min, max have to be divisible by 16 */
					writeByte(ARD_SYSEX_MESSAGE_START);
					writeByte(SERVO_CONFIG);
					writeByte(pin);
					writeIntAsTwoBytes(minPulse);
					writeIntAsTwoBytes(maxPulse);
					writeIntAsTwoBytes(angle);
					writeByte(ARD_SYSEX_MESSAGE_END);
					flush();
				}
				else
				{
					trace("ArduinoWithServo:setupServo error: can only attach servo to pins 9 or 10.");
				}
			}
			else
			{
				trace("ArduinoWithServo:setupServo is destroyed");
			}
		}
	}
}