# UPduino FPGA Mecrisp-Ice Forth with full 15kB of block ram

## An experimental version of the Mecrisp-Ice Forth running on the J1a 16bit processor.

Includes the essential files for a build with IceCube2 and UPduino board (Lattice iCE40UP5k).

Complete setup for a build with IceStorm tools under Linux.

## News

Added: 8 interrupts with a priority encoder and an interrupt enable/disable mask

Added: "millis" and friends (based on the hw timer1 interrupt)

Added: "TEK4010/4014 Vector Graphics Library"

Added: "48bit Floating Point Library"

## Build

The build does not require any other tools except the IceCube2 or the IceStorm. The ram's verilog source
includes the nucleus.fs image already (the Mecrisp-Ice Forth latest).

Note: The UPduino board requires a much better decoupling and pcb layout..

Update 16-JAN-2018: Works under the IceCube2 with PLL at 30MHz, the board has been enhanced with a better decoupling.
Under the IceStorm it works fine at 20MHz external clock.

Update 1-FEB-2018: Tested with 24MHz (48/2) internal oscillator under the IceCube2. 
Oscillator's frequency 23.960MHz with +/-30kHz jitter (at ambient temperature). Works fine.

Modifications done:

1. full 15kB of block ram availbale for the Forth now
2. changes for load/save with UPduino (s/l into the onboard bitstream SPI flash, the "Files")
3. experiments with linear io addressing (instead of one-hot)
4. experiments with 48bit ticks, atomic timestamp with "now"
5. millis with hw timer1 interrupt (works with 100kHz interrupt freq too)
6. the ram_test.v prepared for IceCube2 and IceStorm (includes the nucleus.fs image)
7. etc.

With the IceCube2:

1. create a project
2. copy the icecube version verilog files into the project (as the source files)
3. copy the /ram directory into the project
4. build the bitstream (size ~383 PLBs, and the timing estimate ~31.5MHz)
5. flash the bitstream into the UPduino's SPI flash (with your preffered method)
6. upload the "basisdefinition15k.fs"
7. option: upload the "floating_point_lib.fs" when required
8. "3 save" - it saves the current dictionary into the onboard SPI flash, the File #3
9. upon Reset the Mecrisp Forth always loads itself from the File #3 (when not empty).

With the IceStorm:

0. you must have the latest yosys/arachne-pnr/icestorm tools installed (see the IceStorm project)
1. copy the icestorm version files into a directory
2. cd to the directory and build it with sh compile
3. upload the bitstream j1a0.bin into the SPI flash (with your preffered method).

## Interrupts

There are 8 interrupts now, one-hot coding, 8th (bit 7) with the highest priority. The "eint" and "dint" are now
global, and the particular interrupt can be enabled/disabled via the interrupt mask register, ie.:
```
$80 intmask!     \ enable the highest interrupt (INT_7 Timer1)
intmask@ .x      \ 0080 read the int mask reg
$00 intmask!     \ disable the highest interrupt (INT_7 Timer1)
dint             \ global int disable
eint             \ global int enable
```
Note: the Timer1 interrupt INT_7 works (see millis), not tested with several interrupts firing yet..

## Load/Save

You may save your current dictionary into any "File" with number higher than #2 with "save" (ie. "10 save") anytime.
A File size here is 64kB.

You may load a dictionary manually from any File higher than #2 with "load" (ie. "7 load") anytime.

Note: Mind the UPduino's SPI flash is only 4MB large.

The save/load always works with complete 15kB - the content of entire ram.

## Serial console

The best Serial settings for the fastest upload: 115k2, 8n2 (2 stopbits) with interrupt disabled (dint).

With ie. TeraTerm: set LF/LF, 50ms line tx delay, when 8n1 used set char tx delay to 1ms.

When interrupt is enabled (eint) always use 1ms char delay.

You may change the baudrate in the uart.v (see the params - cpu freq and baudrate).

## More info

For more information on Mecrisp-Ice and J1a CPU you may see:

http://mecrisp.sourceforge.net/

https://github.com/jamesbowman/swapforth
```
Mecrisp-Ice 1.2

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
cornerstone save erase spiwe waitspi m*/ t/ t* 2r@ 2r> 2>r tnegate 2constant 2variable timer1 random 
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
pi f# 1.23456e-775 f/ fs. 2.544706e775  ok.
```

My thanks to Matthias for his kind support with Mecrisp-Ice, to James for providing the j1a cpu,
to Grant for creating the UPduino v1 and v2 boards, and Dave and Clifford for their support with 
the IceStorm tools.

Provided as-is.

None warranties of any kind are provided.

by IgorM, Dec 2017

