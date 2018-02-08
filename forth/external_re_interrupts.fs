
\ EXAMPLE: External INT0, INT1, INT2 and INT3 interrupts based pulse counters
\ INTs are rising edge sensitive

\ Provided as-is
\ No warranties of any kind are provided
\ IgorM 6-Feb-2018

2variable counter0 
2variable counter1
2variable counter2 
2variable counter3 


: icount0 ( -- )                            \ INT_0 interrupt  
   1. counter0 2@  d+ counter0 2!           \ ISR
   $FE intflag! $FF intflag! eint ;         \ clear the INT_0 flag and enable interrupts
   
: icount1 ( -- )                            \ INT_1 interrupt  
   1. counter1 2@  d+ counter1 2!           \ ISR
   $FD intflag! $FF intflag! eint ;         \ clear the INT_1 flag and enable interrupts

: icount2 ( -- )                            \ INT_2 interrupt  
   1. counter2 2@  d+ counter2 2!           \ ISR
   $FB intflag! $FF intflag! eint ;         \ clear the INT_2 flag and enable interrupts
   
: icount3 ( -- )                            \ INT_2 interrupt
   1. counter3 2@  d+ counter3 2!           \ ISR
   $F7 intflag! $FF intflag! eint ;         \ clear the INT_3 flag and enable interrupts
   

' icount0 1 rshift $3BF0 ! \ INT0 - JMP opcode for the interrupt vector location
' icount1 1 rshift $3BF2 ! \ INT1 - JMP opcode for the interrupt vector location
' icount2 1 rshift $3BF4 ! \ INT2 - JMP opcode for the interrupt vector location
' icount3 1 rshift $3BF6 ! \ INT3 - JMP opcode for the interrupt vector location

dint

0. counter0 2!
0. counter1 2!
0. counter2 2!
0. counter3 2!

\ $01 intmask!  \ INT0 enable
\ $02 intmask!  \ INT1 enable
\ $04 intmask!  \ INT2 enable
\ $08 intmask!  \ INT3 enable 

$80 $08 $04 $02 $01 or or or or intmask!      \ millis + INT3 + INT2 + INT1 + INT0 enabled

\ eint

\ Example:
\ Printing out the counters while the INT0-3 inputs are triggered by a pulses generator.
\ You may use the "interrupts_generator.ino" sketch for testing.
\ In order to get the exact number of pulses start the sketch when the pulse generator
\ idles (all INT0-3 inputs are low).

 : prtcounters 
  dint
  0. counter0 2! 0. counter1 2!  0. counter2 2! 0. counter3 2!
  $80 $08 $04 $02 $01 or or or or intmask! 
  0. millis 2! 
  eint cr 
  0 do
  millis 2@ d. space space counter0 2@ d. counter1 2@ d. counter2 2@ d. counter3 2@ d. cr 
  2000 ms loop ;
 


