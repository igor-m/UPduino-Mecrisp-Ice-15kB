# UPduino-Mecrisp-Ice-15kB


An Experimental version of the Mecrisp-Ice Forth running on the J1a processor.

Essential files for a build with IceCube2 and UPduino board (Lattice iCE40UP5k).
Works fine at 30MHz (an external oscillator) and 115k2 serial.

Modification by IgorM:
1. for full 15kB block ram usage
2. changes for Load/Save with UPduino
3. experiments with linear io addressing
4. experiments with 48bit ticks
5. the ram_test.v prepared for IceCube2 (includes the nucleus.fs already)
6. replaced the uart.v with a more stable version

Within IceCube2:
1. create a project
2. copy the verilog files into the project as the source files
3. copy the /build directory into the project
4. build the bitstream
5. flash the bitstream into the UPduino board
6. upload the basisdefinition15k.fs
7. 3 save - it saves the actual dictionary to the spi flash, block 3 (a block size is 64kB)
8. next time the mecrisp forth loads itself from block 3

You may save in any block higher than 2, it loads upon reset always from block 3.
You may load manually from any block higher than 2.

For more information see:

http://mecrisp.sourceforge.net/

https://github.com/jamesbowman/swapforth


Thanks Matthias for his support with Mecrisp-Ice, and James for providing the j1a forth cpu.

Provided as-is.
No warranties of any kind are provided.
IgorM, Dec 2017

