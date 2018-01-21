# UPduino Mecrisp-Ice with full 15kB ram


An Experimental version of the Mecrisp-Ice Forth running on the J1a 16bit processor.

Essential files for a build with IceCube2 and UPduino board (Lattice iCE40UP5k).

Complete setup for a build with IceStorm tools under Linux.

NEW: 48bit Floating Point Library

The build does not require any tools except IceCube2 or IceStorm. The ram source
includes the nucleus.fs words image (Mecrisp-Ice Forth).

Works fine at 30MHz (an external oscillator) and 115k2 serial.

It may require a better VCCPLL decoupling and pcb layout.
(Update 16.1.2018: works with PLL at 30MHz, the board enhanced with a better decoupling).

Modifications done:
1. full 15kB block ram usage now
2. changes for Load/Save with UPduino (complete dictionary saved into the SPI flash)
3. experiments with linear io addressing
4. experiments with 48bit ticks, atomic timestamp with "now"
5. the ram_test.v prepared for IceCube2 and IceStorm (includes the nucleus.fs image)
6. replaced the original uart.v with a more stable version

Within IceCube2:
1. create a project
2. copy the verilog files into the project as the source files
3. copy the /build directory into the project
4. build the bitstream (size ~383 PLBs, and the timing estimate ~31.5MHz)
5. flash the bitstream into the UPduino board
6. upload the "basisdefinition15k.fs"
7. option: upload the "floating_point_lib.fs"
8. "3 save" - it saves the current dictionary into the onboard SPI flash, block #3
9. next time upon reset the Mecrisp forth always loads itself from the block #3

You may save your actual dictionary in any block higher than #2 with "save" (ie. "10 save").
A block here is 64kB.

When the block #3 contains a saved dictionary, it loads the disctionary upon reset from there.

You may load a dictionary manually from any block higher than #2 with "load" (ie. "7 load").

Mind the UPduino's SPI flash is only 4MB large.

The save/load always work with complete 15kB (the content of entire ram).

The best Serial settings for fastest upload: 115k2, 8n2 (2 stopbits).

Used with ie. TeraTerm: set LF/LF, 50ms line tx delay, when 8n1 used set char delay to 1ms.

For more information on Mecrisp-Ice and Swapforth (J1a CPU model) you may see:

http://mecrisp.sourceforge.net/

https://github.com/jamesbowman/swapforth
```
Mecrisp-Ice 1.0

 ok.
 
words falog f** flog fln (log) fraction integer> >integer lbase epsilon fexp ^fraction 
^integer (!) d>u d0< fpow fatan2 facos fasin (fasin) fatan dom2|3 dom3 dom2 (fatan) (taylor2) 
2degrees ftan fsincos fcos fsin >range -taylor +taylor (taylor) >taylor rad>deg deg>rad e pi 
F# (f#) _f# F.S fd abort" FVARIABLE FCONSTANT >FLOAT -trailing flfrac flexp flint fdigit? flgood 
fsign FSQRT d< FE. FS. (E.) R. F. (F.) fsplit F~ F/ F* FMAX FMIN FROUND FLOOR F= F< F- F+ tneg 
FROT FNIP FPICK FOVER FSWAP FALIGNED FALIGN FABS F0> F0< F0= F0<> FSIGN? F! F@ FLOATS FLOAT+ S>F 
F>D D>F FNEGATE FDROP FDUP FDEPTH FCLEAR SET-PRECISION PRECISION F2/ F2* normalize fshift >exp1 
ftemp' expx2 expx1 m1sto m1get fmove 'e2 'e1 'm3 'm2 'm1 longdiv *norm lstemp t+ t2/ t2* sign>exp 
exp>sign frshift ud2/ d2/ du< ferror &esign &sign &unsign mxdig bicl ftemp fstak fsp digits -byfp 
byfp fpmxst see seec disasm-step memstamp alu. name. disasm-cont disasm-$ insight .s dump new 
cornerstone save erase spiwe waitspi m*/ t/ t* 2r@ 2r> 2>r tnegate 2constant 2variable random 
randombit tickshh ticksh ticksl now ms endcase endof of case s" within pad unused ." mod / /mod move 
u.r .r d.r rtype u. . d. ud. (d.) #> #s # sign hold <# hld BUF BUF0 pick roll spaces */ */mod fm/mod 
sm/rem sgn constant variable m* >body create repeat while else <= >= u<= u>= ( [char] ['] eint? dint 
eint load spi> >spi spix idle xor! bic! bis! quit evaluate refill accept number \ char ' postpone 
literal abort rdrop r@ r> >r hex binary decimal unloop j i +loop loop ?do leave do recurse does> 
until again begin then if ahead ; exit :noname : ] [ immediate foldable sliteral s, compile, c, , 
allot parse parse-name source 2! 2@ cmove> cmove fill sfind align aligned words here tib init forth 
>in base state /string type count .x .x2 bl cr space c! c@ emit key key? emit? um/mod * um* d2* d0= 
m+ s>d dabs d- dnegate d+ depth io@ io! nip over dup swap u< < = invert not or and xor - + ! 2/ 2* 
cells abs bounds umax umin max min 2over 2swap +! 2dup ?dup 2drop tuck -rot rot true false drop u> 
0> 0< > 0<> <> cell+ 0= rdepth @ 1- negate 1+ arshift rshift lshift execute  ok.
  ok.
here . 11828  ok.
unused . 3532  ok.
  ok.
pi f# 1.23456e-775 f/ fdup fs. fe.  2.544706e775 25.447065e774  ok.
```

Thanks Matthias for his support with Mecrisp-Ice, and James for providing the j1a CPU.

Provided as-is.

No warranties of any kind are provided.

by IgorM, Dec 2017

