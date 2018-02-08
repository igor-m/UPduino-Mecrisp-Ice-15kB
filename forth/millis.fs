
\ millis() using the Timer1 interrupt INT_7

\ Interrupt frequency = CPU_clk[Hz] / timer1

\ Provided as-is
\ No warranties of any kind are provided
\ IgorM 31-Jan-2018
\ IgorM  5-Feb-2018 - added clearing the interrupt via flags

30000. timer1                      \ 1ms interrupt with 30MHz CPU clock

2variable millis                   \ millis is a double

: imill ( -- )                     \ INT_7 Timer1 interrupt
   1. millis 2@  d+ millis 2!      \ ISR: increment the millis counter
   $7F intflag! $FF intflag! eint  \ clear the INT_7 flag and enable interrupts
   ;

' imill 1 rshift $3BFE !           \ Generate JMP opcode for INT_7 vector location

2variable elpsd                    \ tstart..elapsed helpers
: tstart millis 2@ elpsd 2! ;
: elapsed millis 2@ elpsd 2@ d- ;

$80 intmask!                       \ Enable the Timer1 interrupt INT_7

eint                               \ Global interrupt enable

\ Examples:
\ millis 2@ d. 22387  ok.
\ millis 2@ d. 23309  ok.
\ millis 2@ d. 24117  ok.

tstart 3000 ms elapsed d.          \ 3008  ok.