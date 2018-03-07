# UPduino (v1, v2) FPGA board with Mecrisp-Ice Forth

## An experimental version of the Mecrisp-Ice Forth running on the J1a 16bit processor.

Includes the essential files for a build with IceCube2 or Radiant and UPduino board (Lattice iCE40UP5k).

Complete setup for an easy build with IceStorm tools under Linux.

The UPduino v2 includes an onboard FT232H chip for easy programming.


## News

Added:   Lattice Radiant version - major changes in all primitives (ie. io, bram, spram)

Added:   IceStorm version - the 16x16 multiplier made of an MAC16 DSP module

Added:   All versions - 4 x 16kWords of Single Port RAM (SPRAM) available

Added:   8 interrupts (4 external) with a priority encoder and an interrupt enable/disable mask

Added:   "TEK4010/4014 Vector Graphics Library"

Added:   "48-bit Floating Point Library"

Added:   "millis" and friends (based on the hw timer1 interrupt)

## Build

The build does not require any other tools except the IceCube2, Radiant or the IceStorm. The bram's verilog source
includes the nucleus.fs image already (the Mecrisp-Ice Forth latest).

Note: The UPduino v1 board requires an additional decoupling at VCCPLL and VCC..

Update 16-JAN-2018: It works under the IceCube2 with PLL at 30MHz, the board has been enhanced with a better decoupling.
Under the IceStorm it works fine at 20MHz external clock.

Update 1-FEB-2018: Tested with 24MHz (48/2) internal oscillator under the IceCube2 and IceStorm. 
Oscillator's frequency measured is 23.960MHz with +/-30kHz jitter (at ambient temperature).

Modifications done:

1. full 15kB of block ram (bram) availbable for the Forth
2. changes for load/save with UPduino (onboard bitstream SPI flash, the "Files")
3. experiments with linear io addressing (instead of one-hot)
4. experiments with 48bit wide ticks, atomic timestamp with "now"
5. millis with hw timer1 interrupt (works up to 100kHz interrupt freq)
6. the ram_test.v prepared for IceCube2 and IceStorm (includes the nucleus.fs image)
7. etc.

With the IceCube2 and Radiant:

1. create a project
2. copy the icecube version verilog files into the project (as the source files)
3. copy the /ram directory into the project
4. build the bitstream
5. flash the bitstream into the UPduino's SPI flash (with your preffered method, ie. FT232H)
6. connect to a terminal (ie. TeraTerm), while in Forth upload the "basisdefinition15k.fs" words
7. option: upload the "floating_point_lib.fs"
8. "3 save" - it saves the current dictionary into the onboard SPI flash, the File #3
9. upon Reset or Power On the Forth always loads the dictionary from the File #3 (when not empty).

With the IceStorm:

0. you must have the latest yosys/arachne-pnr/icestorm tools installed (see the IceStorm project)
1. copy the icestorm version files into a directory
2. cd to the directory and do build it with "sh compile"
3. upload the j1a0.bin bitstream into the SPI flash.

## CPU clock sources and frequency settings

There are 3 options in j1a.v (or top.v) with the CPU clock sources (clk signal)
```
   // ### Option 1: External 30MHz oscillator (3.3V level)
   // ### Option 2: Internal PLL based (max 30MHz with IceCube2)
   // ### Option 3: Internal 24MHz (48MHz/2) oscillator
```
Uncomment the code based on your choice. Note: the max CPU clock freqency depends on several factors, 20-24MHz shall work in most cases.

As of today there are 3 places you have to touch in order to set the CPU clock frequency of choice.

1. in uart.v 
```
`define CLKFREQ   30000000                 // frequency of 'clk'
`define BAUD      115200
```
2. in \forth\basisdefinitions15k.fs, line 274
```
: ms   ( u -- ) 0 do 2727 0 do loop loop ; \ 11 cycles per loop run.. For 30 MHz / 11 = 2727
```
3. in \forth\millis.fs, line 11
```
30000. timer1                              \ 1ms interrupt with 30MHz CPU clock
```

## PORTA - IO

There is a 16bit wide Port A available. The individual bits can be set to an input or output.

The io address 310 is the PORT A read address.

The io address 311 is the PORT A write address.

The io address 312 sets the PORT A pin direction (1-output, 0-input).

```
$8800 312 io!               \ set PA15 and PA11 to output, all others are inputs
$8000 311 io!               \ set PA15=1 and PA11=0
$8800 311 io!               \ set PA15=1 and PA11=1
$0000 311 io!               \ set PA15=0 and PA11=0
$0800 311 io!               \ set PA15=0 and PA11=1
310 io@ .x 7FFF             \ read PORTA and print out hex result
$8000 311 io!               \ set PA15=1 and PA11=0
310 io@ .x F7FF             \ read PORTA and print out hex result

: pulses 0 do 
    11 pinH                 \ PA11 = 1
    11 pinL                 \ PA11 = 0
    loop ;
tstart 0 pulses elapsed d.  \ 108 ok. fyi: 0.108sec/65536 = 1.6usecs period
```

## Single Port RAM 

You may use 4 x 16kWords of an internal single port ram, called SPRAM.

Note: The Forth address is a 16bits word. The SPRAM addr range is 14bits only (0..$3FFF).
Here the address range wraps around when the 2 higher address bits are used (4 mirrors).

See the "spram.fs" with the examples how to write/read the 4 banks of sram memory.

```
$ABCD $3000 spramwr0   \ writes $ABCD to the Bank0, address $3000
$3000 spramrd0 .x      \ reads and prints out data from the Bank0, address $3000
$7777 $1000 spramwr3   \ writes $7777 to the Bank3, address $1000
$1000 spramrd3 .x      \ reads and prints out data from the Bank3, address $1000
```

## Interrupts

There are 8 interrupts, INT_7 (bit 7) with the highest priority, INT_0 the lowest one. The "eint" and "dint" 
are global, and the particular interrupt can be enabled/disabled via an interrupt mask register, ie.:
```
$80 intmask!     \ enable the highest interrupt (INT_7 Timer1)
intmask@ .x      \ 0080 read the int mask reg
$00 intmask!     \ disable the highest interrupt (INT_7 Timer1)
dint             \ global int disable
eint             \ global int enable
```
All pending interrupts are being processed, the one with higher priority first.

Note: There are ..duino sketches in this repo with patterns generators used with the interrupts testing. So far 5 concurrently
random firing interrupts (INT_7 w/ millis, and INT_0-3 external rising edge sensitive ) with 4usecs period are processed
such no single interrupt is lost (the 4 ISRs are simple counters counting the incomming edges). See the test results.

## Load/Save

You may save your current dictionary into any "File" with number higher than #2 with "N save" (ie. "10 save") anytime.
A File size here is always 64kB. The Files n. 0, 1, 2 are used foir the FPGA bitstream.

You may load a dictionary manually from any File n. higher than #2 with "N load" (ie. "7 load") anytime.

Note: Mind the UPduino's SPI flash is only 4MB large..

The save/load always works with complete 15kB - the content of the entire bram.

## Serial console

The best Serial settings for the fastest upload: 115k2, 8n2 (2 stopbits) with interrupts disabled (dint).

Settings with ie. TeraTerm: set LF/LF, 50ms line tx delay, when 8n1 used set char tx delay to 1ms.

When interrupts are enabled (eint) always use 1ms char delay.

You may change the baudrate in the uart.v (see the params - cpu freq and baudrate).

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
pi fs. 3.141593e0  ok.
pi f# 1.23456e-775 f/ fs. 2.544706e775  ok.
```

## Credits

For more information on Mecrisp-Ice, J1a CPU, UPduino boards and IceStorm tools:

http://mecrisp.sourceforge.net/

https://github.com/jamesbowman/swapforth

http://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/GnarlyGreyUPDuinoBoard.aspx

https://github.com/cliffordwolf/icestorm

My thanks to MatthiasK for his kind support with Mecrisp-Ice Forth, JamesB for creating the j1a CPU, 
GrantJ for creating and shipping the UPduino v1 and v2 boards, DaveS and CliffordW for their support with the IceStorm tools..


Provided as-is.

None warranties of any kind are provided.

by IgorM, Dec 2017

