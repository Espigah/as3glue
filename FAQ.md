**Q:** I need more information.

**A:**

Read the [Reference](http://code.google.com/p/as3glue/wiki/Reference) and the [Instructions](http://code.google.com/p/as3glue/wiki/Instructions). Also have a look at the documentation at [protolab](http://protolab.pbwiki.com/FirmataAndFlash). And [Bret Forsyths](http://thestem.ca/) ASDoc documentation at: [http://thestem.ca/as3gluedocs/](http://thestem.ca/as3gluedocs/)

**Q:**

The serial proxy sees a connection but I can't send/receive data to/from the Arduino.

**A:**

1. Make sure you are connecting to the port your Arduino is on (check serproxy.cfg).

2. If you don't use the included StandardFirmata.pde or serproxy.cfg example then you might need to change some settings. Double check that the baud setting in serproxy.cfg and Standard\_Firmata.pde is the same. Data will be scrambled and no events will be triggered if the settings differ. The default baud rate in the StandardFirmata firmware that ships with the Arduino IDE is at the time of writing 115200. The baud rate in the firmware and serproxy.cfg example that is  redistributed with as3Glue is also 115200.

3. Make sure that newlines\_to\_nils=false in serproxy.cfg. If it is set to true then the serial proxy will convert the "new lines" ascii character (0a in hexadecimal, 10 in decimal) to 0.

**Q:** I can't get serial proxy configured correctly.

**A:**

OS X: Some people using Intel Macs are [reportedly](http://protolab.pbwiki.com/Arduino2Flash) unable to get serproxy configured correctly. Try using [Arduino2Flash](http://protolab.pbwiki.com/Arduino2Flash) instead of serialProxy.

Windows: Try [tinkerProxy](http://tinker.it/now/2007/06/03/new-tinkerproxy-for-windows).

**Q:** What is the version of StandardFirmata.pde that ships with as3Glue?

**A:**

There is some confusion surrounding different versions of the Firmata firmware. It will hopefully sort itself out soon. The version that ships with as3Glue v2 is Firmata 2.0 beta 3. The version that ships with as3Glue v1 is Pd\_firmware 1.32 from the Pure Data CVS, with serial communication set to 57600.