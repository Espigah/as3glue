# Introduction #

How to interface an Arduino board from Flash/Flex/AIR applications using the Arduino class in as3glue.

# Details #

1. Upload StandardFirmata.pde, which ships with Arduino 0012 and above, to your Arduino board. You can find StandardFirmata at File->Sketchbook->Examples->Library-Firmata->StandardFirmata. You can also find it in the as3Glue zip file at Glue/arduino/Firmata2/StandardFirmata/.

2. Configure and start serialProxy to enable Flash to communicate with the Arduino via a socket connection. The serialProxy is in Glue/applications/Serproxy-0.1.3-3. The configuration file is serproxy.cfg - sample config files for Windows and Max OS X are provided as serproxy.cfg.win and serproxy.cfg.mac.

3. In your Flash/Flex/Air file, Instantiate an Arduino object using the port that you set up in step (2).

4. Register event listeners for incoming Arduino data (see the SimpleIO example).

5. Read and write to the Arduino using functions similar to those in the Arduino reference (see the SimpleIO example).

6. For more information see the [reference](http://code.google.com/p/as3glue/wiki/Reference),  [FAQ](http://code.google.com/p/as3glue/wiki/FAQ) and the included SimpleIO example.