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
```
Mecrisp-Ice 1.0

 ok.
 
words m*/ t/ t* 2r@ 2r> 2>r tnegate see seec disasm-step memstamp alu. name. disasm-cont disasm-$ insight .s dump new cornerstone save erase spiwe waitspi random randombit tickshh ticksh ticksl now leds ms endcase endof of case s" within pad unused ." mod / /mod move u.r .r d.r rtype u. . d. ud. (d.) #> #s # sign hold <# hld BUF BUF0 pick roll spaces */ */mod fm/mod sm/rem sgn constant variable m* >body create repeat while else <= >= u<= u>= ( [char] ['] eint? dint eint load spi> >spi spix idle xor! bic! bis! quit evaluate refill accept number \ char ' postpone literal abort rdrop r@ r> >r hex binary decimal unloop j i +loop loop ?do leave do recurse does> until again begin then if ahead ; exit :noname : ] [ immediate foldable sliteral s, compile, c, , allot parse parse-name source 2! 2@ cmove> cmove fill sfind align aligned words here tib init forth >in base state /string type count .x .x2 bl cr space c! c@ emit key key? emit? um/mod * um* d2* d0= m+ s>d dabs d- dnegate d+ depth io@ io! nip over dup swap u< < = invert not or and xor - + ! 2/ 2* cells abs bounds umax umin max min 2over 2swap +! 2dup ?dup 2drop tuck -rot rot true false drop u> 0> 0< > 0<> <> cell+ 0= rdepth @ 1- negate 1+ arshift rshift lshift execute  ok.

 ok.

here . 7042  ok.
unused . 8318  ok.
```

Thanks Matthias for his support with Mecrisp-Ice, and James for providing the j1a forth cpu.

Provided as-is.

No warranties of any kind are provided.

IgorM, Dec 2017

