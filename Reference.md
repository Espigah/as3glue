Contributed by [Bjoern Hartmann](http://bjoern.org), originally written for [protolab](http://protolab.pbwiki.com/As3glueReference)

# Creation #

Create an arduino object with the following line:

arduino = new Arduino("127.0.0.1", 5331);

"127.0.0.1" is the IP address where serialproxy is running - in this case, localhost. 5331 is the port number that the serialproxy TCP socket server uses as defined in serproxy.cfg.

# Digital I/O #

  * To set a pin to input or output, use

> arduino.setPinMode(pin, Arduino.INPUT);
> arduino.setPinMode(pin, Arduino.OUTPUT);

> where pin is a Number variable with value between 2 and 13.
  * To set an output pin high or low, use

> arduino.writeDigitalPin(pin, Arduino.HIGH);
> arduino.writeDigitalPin(pin, Arduino.LOW);

  * To enable or disable pin reporting for all digital input pins(you'll have to enable if you have input pins and want to read inputs), use

> arduino.enableDigitalPinReporting();
> arduino.disableDigitalPinReporting();

  * To read a value from a digital input pin use

> arduino.getDigitalData(pin);


# Analog I/O #

  * To set a pin between 9 and 11 to PWM output, use

> arduino.setPinMode(pin, Arduino.PWM);

  * To write a PWM value to a pin previously initialized for PWM output, use

> arduino.writeAnalogPin(pin, value);

> where value is a Number variable between 0 and 255.
  * To enable or disable pin reporting for individual analog input pins, use:

> arduino.setAnalogPinReporting(aPin, Arduino.ON);
> arduino.setAnalogPinReporting(aPin, Arduino.OFF);

> where aPin is a Number variable with value between 0 and 6.
  * To read an analog value from an analog input pin use

> arduino.getAnalogData(aPin);

# Event listener functions #

Instead of reading values through getAnalogData() and getDigitalData(), as3glue can also use event listener functions you supply whenever a digital or analog pin changes. You have to do two things: write a callback function and register that function with the object. Here are examples:

  * To add an event listener that is called whenever a digital input changes, fist declare the callback function:

> public function onReceiveDigitalData(e:ArduinoEvent):void {
> > trace("Digital pin " + e.pin + " on port: " + e.port +" = " + e.value);

> }

> Then register it with the arduino object:

> arduino.addEventListener(ArduinoEvent.DIGITAL\_DATA, onReceiveDigitalData);

  * To add an event listener that is called whenever an analog input changes, fist declare the callback function:

> public function onReceiveAnalogData(e:ArduinoEvent):void {
> > trace("Analog pin " + e.pin + " on port: " + e.port +" = " + e.value);

> }

> Then register it with the arduino object:

> arduino.addEventListener(ArduinoEvent.ANALOG\_DATA, onReceiveAnalogData);