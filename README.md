# UPduino Mecrisp-Ice with full 15kB ram


An Experimental version of the Mecrisp-Ice Forth running on the J1a 16bit processor.

Essential files for a build with IceCube2 and UPduino board (Lattice iCE40UP5k).
Complete setup for a build with IceStorm tools under Linux.

Works fine at 30MHz (an external oscillator) and 115k2 serial.
The PLL clocking unreliable yet, issues under investigation.
It may require better VCCPLL blocking and pcb layout.

Modifications done:
1. full 15kB block ram usage now
2. changes for Load/Save with UPduino (complete dictionary saved into the SPI flash)
3. experiments with linear io addressing
4. experiments with 48bit ticks
5. the ram_test.v prepared for IceCube2 and IceStorm (includes the nucleus.fs image)
6. replaced the original uart.v with a more stable version

Within IceCube2:
1. create a project
2. copy the verilog files into the project as the source files
3. copy the /build directory into the project
4. build the bitstream
5. flash the bitstream into the UPduino board
6. upload the basisdefinition15k.fs
7. "3 save" - it saves the current dictionary into the onboard SPIflash, block #3
8. next time upon reset the Mecrisp forth always loads itself from the block #3

You may save in any block higher than #2 (ie. "10 save"). A block here is 64kB.
It loads upon reset always from block #3.
You may load a dictionary manually from any block higher than #3 (ie. "7 load").
Mind the UPduino's SPIflash is 4MB large.
The save/load always work with complete 15kB (the content of entire ram).

The best Serial settings for fastest upload: 115k2, 8n2.
Used with TeraTerm, LF/LF, 50ms line delay, when 8n1 used set char delay to 1ms.

For more information see:

http://mecrisp.sourceforge.net/

https://github.com/jamesbowman/swapforth
```
Mecrisp-Ice 1.0

 ok.
 
words m*/ t/ t* 2r@ 2r> 2>r tnegate see seec disasm-step memstamp alu. name. disasm-cont 
disasm-$ insight .s dump new cornerstone save erase spiwe waitspi random randombit tickshh 
ticksh ticksl now leds ms endcase endof of case s" within pad unused ." mod / /mod move u.r 
.r d.r rtype u. . d. ud. (d.) #> #s # sign hold <# hld BUF BUF0 pick roll spaces */ */mod 
fm/mod sm/rem sgn constant variable m* >body create repeat while else <= >= u<= u>= ( [char] 
['] eint? dint eint load spi> >spi spix idle xor! bic! bis! quit evaluate refill accept number 
\ char ' postpone literal abort rdrop r@ r> >r hex binary decimal unloop j i +loop loop ?do 
leave do recurse does> until again begin then if ahead ; exit :noname : ] [ immediate foldable 
sliteral s, compile, c, , allot parse parse-name source 2! 2@ cmove> cmove fill sfind align 
aligned words here tib init forth >in base state /string type count .x .x2 bl cr space c! c@ 
emit key key? emit? um/mod * um* d2* d0= m+ s>d dabs d- dnegate d+ depth io@ io! nip over dup 
swap u< < = invert not or and xor - + ! 2/ 2* cells abs bounds umax umin max min 2over 2swap +! 
2dup ?dup 2drop tuck -rot rot true false drop u> 0> 0< > 0<> <> cell+ 0= rdepth @ 1- negate 1+ 
arshift rshift lshift execute  ok.
 ok.
here . 7042  ok.
unused . 8318  ok.
```

Thanks Matthias for his support with Mecrisp-Ice, and James for providing the j1a CPU.

Provided as-is.

No warranties of any kind are provided.

by IgorM, Dec 2017

