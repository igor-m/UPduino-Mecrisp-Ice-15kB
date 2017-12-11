# UPduino-Mecrisp-Ice-15kB


An Experimental version of the Mecrisp-Ice Forth running on the J1a processor.

Essential files for a build with IceCube2 and UPduino board (Lattice iCE40UP5k).

Modification by IgorM:
a. for full 15kB block ram usage
b. changes for Load/Save with UPduino
c. experiments with linear io addressing
d. experiments with 48bit ticks
e. the ram_test.v prepared for IceCube2 (includes the nucleus.fs already)
f. replaced the uart.v

With IceCube2:
a. create a project
b. copy the verilog files into the project as the source files
c. copy the /build directory into the project
d. build the bitstream
e. flash the bitstream into the UPduino board
f. upload the basisdefinition15k.fs
g. 3 save - it saves the actual dictionary to the spi flash, block 3 (a block size is 64kB)
h. next time the mecrisp forth loads itself from block 3

You may save in any block higher than 2, it loads upon reset always from block 3.
You may load manually from any block higher than 2.

For more information see:

http://mecrisp.sourceforge.net/

https://github.com/jamesbowman/swapforth


Thanks Matthias for his support with Mecrisp-Ice, and James for providing the j1a forth cpu.

Provided as-is.
No warranties of any kind are provided.
IgorM Dec 2017

