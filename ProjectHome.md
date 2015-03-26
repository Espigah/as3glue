# Why #

as3Glue gives Flash, Flex and AIR applications physical interaction capabilities.

# Details #

as3Glue is an ActionScript 3 library that enables communication between Flash/Flex/AIR applications and Arduino boards. It can together with one or several Arduino boards be used to monitor sensors (such as rotary encoders and motion detectors), control actuators (such as LEDs and motors) and interface other electronics (such as RFID readers) from Flash, Flex and AIR applications.

The library includes Arduino sketches and ActionScript 3 code examples as well as the http://arduino.cc/en/Reference/Firmata Arduino firmware and a serial proxy.

## Tutorial ##

http://www.kasperkamperman.com/blog/arduino/arduino-flash-communication-as3/

# Firmata 1.0 vs Firmata 2.0 #
The latest version of this library was developed for Firmata 2.0.
Arduino 0012 and later are distributed with Firmata 2.0. Earlier versions shipped with Firmata 1.0, which is NOT compatible with 2.0. If your project requires Firmata 1.0, you can find an earlier version of as3Glue the downloads section, although we do not recommend it for new projects.

If you are comfortable with Subversion, /trunk/ is compatible with Firmata 2.0, while /branches/firmata1/ contains the library for Firmata 1.0.

# Features #

**new** Now supports Arduino Mega as well.

Monitor and control digital and analog pins on Arduino boards from ActionScript 3 application without any Arduino programming.

Quickly send and receive data to and from Arduino boards using the efficient http://arduino.cc/en/Reference/Firmata protocol.

Interface multiple Arduino boards.

# Problems? #
Please read the [FAQ](http://code.google.com/p/as3glue/wiki/FAQ) first.

# License #
as3Glue is an open source library licensed under the MIT license.

# Roadmap #


# Authors #

Bjoern Hartmann, [http://bjoern.org/](http://bjoern.org/)