
\ millis() using the timer1 interrupt on Mecrisp-Ice

\ Interrupt frequency = CPU_clk[Hz] / timer1

\ Provided as-is
\ No warranties of any kind are provided
\ IgorM 31-Jan-2018


30000. timer1           \ 1ms interrupt with 30MHz CPU clock

2variable millis        \ millis is a double

: imill ( -- )          \ timer1 interrupt
   1. millis 2@  d+ millis 2! ;

2variable elpsd
: tstart millis 2@ elpsd 2! ;
: elapsed millis 2@ elpsd 2@ d- ;

' imill 1 rshift $3BFE ! \ Generate JMP opcode for interrupt vector location

eint

\ Examples:
\ millis 2@ d. 22387  ok.
\ millis 2@ d. 23309  ok.
\ millis 2@ d. 24117  ok.

\ tstart 3000 ms elapsed d. 3008  ok.