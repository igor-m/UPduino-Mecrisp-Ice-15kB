\ EXAMPLE: Write/Read into/from the 4 x 16kW of SPRAM

\ Provided as-is
\ No warranties of any kind are provided
\ IgorM 9-Feb-2018

 \ Single Port RAM (SPRAM) - 4 x 16kW in 4 banks
  
: spramwr0 ( data16b address14b -- ) 610 io! 600 io! ;  
: spramrd0 ( address14b -- data16b ) 610 io! 600 io@ ; 

: spramwr1 ( data16b address14b -- ) 610 io! 601 io! ;  
: spramrd1 ( address14b -- data16b ) 610 io! 601 io@ ; 

: spramwr2 ( data16b address14b -- ) 610 io! 602 io! ;  
: spramrd2 ( address14b -- data16b ) 610 io! 602 io@ ; 

: spramwr3 ( data16b address14b -- ) 610 io! 603 io! ;  
: spramrd3 ( address14b -- data16b ) 610 io! 603 io@ ; 


\ TEST FOR BANK 0

: wrAAAA 0 do $AAAA i spramwr0 loop ; 
: wr5555 0 do $5555 i spramwr0 loop ;
: wrFFFF 0 do $FFFF i spramwr0 loop ;
: rdspram0 0 do i spramrd0 cr .x loop ;
 
\ Write full 16kW spram with $FFFF
tstart $3FFF wrFFFF elapsed d.

\ Write first 8kW with $5555
tstart $2000 wr5555 elapsed d.

\ Write first 4kW with $AAAA
tstart $1000 wrAAAA elapsed d.

\ List the content of the entire 16kW of spram
$3FFF rdspram0

\ TEST FOR BANK 1

: wrBBBB 0 do $BBBB i spramwr1 loop ; 
: wr6666 0 do $6666 i spramwr1 loop ;
: wrEEEE 0 do $EEEE i spramwr1 loop ;
: rdspram1 0 do i spramrd1 cr .x loop ; 

\ Write full 16kW spram with $EEEE
tstart $3FFF wrEEEE elapsed d.

\ Write first 8kW with $6666
tstart $2000 wr6666 elapsed d.

\ Write first 4kW with $BBBB
tstart $1000 wrBBBB elapsed d.

\ List the content of the entire 16kW of spram
$3FFF rdspram1

\ TEST FOR BANK 2

: wrCCCC 0 do $CCCC i spramwr2 loop ; 
: wr7777 0 do $7777 i spramwr2 loop ;
: wr1111 0 do $1111 i spramwr2 loop ;
: rdspram2 0 do i spramrd2 cr .x loop ; 

\ Write full 16kW spram with $CCCC
tstart $3FFF wrCCCC elapsed d.

\ Write first 8kW with $7777
tstart $2000 wr7777 elapsed d.

\ Write first 4kW with $1111
tstart $1000 wr1111 elapsed d.

\ List the content of the entire 16kW of spram
$3FFF rdspram2

\ TEST FOR BANK 3

: wrDDDD 0 do $DDDD i spramwr3 loop ; 
: wr8888 0 do $8888 i spramwr3 loop ;
: wr3333 0 do $3333 i spramwr3 loop ;
: rdspram3 0 do i spramrd3 cr .x loop ; 

\ Write full 16kW spram with $DDDD
tstart $3FFF wrDDDD elapsed d.

\ Write first 8kW with $8888
tstart $2000 wr8888 elapsed d.

\ Write first 4kW with $3333
tstart $1000 wr3333 elapsed d.

\ List the content of the entire 16kW of spram
$3FFF rdspram3

