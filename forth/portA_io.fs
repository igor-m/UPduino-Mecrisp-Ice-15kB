\ EXAMPLE: PORTA IO pin manipulation

\ Provided as-is
\ No warranties of any kind are provided
\ IgorM 6-Mar-2018

 : pinH ( pin -- pin=1)         \ sets PORTA pin to High
    1 swap lshift 311 bis! ;
 
 : pinL ( pin -- pin=0)         \ sets PORTA pin to Low
    1 swap lshift 311 bic! ;
 
\ Blinks with two LEDs connected to PA11 and PA15

 : blinks 0 do 
    11 pinH                    \ PA11 = 1
    15 pinL                    \ PA15 = 0
    200 ms 
    11 pinL                    \ PA11 = 0
    15 pinH                    \ PA15 = 1
    200 ms 
    loop 
 ;
 
 $8800 312 io!                 \ set PA15 and PA11 outputs, all other inputs

 1000 blinks
 