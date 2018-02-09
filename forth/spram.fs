\ EXAMPLE: Write/Read into/from the 16kW of SPRAM

\ Provided as-is
\ No warranties of any kind are provided
\ IgorM 9-Feb-2018

\ Single Port RAM (SPRAM)
  
: spramwr ( data16b address14b -- ) 601 io! 600 io! ;  
: spramrd ( address14b -- data16b ) 601 io! 600 io@ ;

: wrAAAA 0 do $AAAA i spramwr loop ; 
: wr5555 0 do $5555 i spramwr loop ;
: wrFFFF 0 do $FFFF i spramwr loop ;
: rdspram 0 do i spramrd cr .x loop ; 

\ Write full 16kW spram with $FFFF
tstart $3FFF wrFFFF elapsed d.

\ Write first 8kW with $5555
tstart $2000 wr5555 elapsed d.

\ Write first 4kW with $AAAA
tstart $1000 wrAAAA elapsed d.

\ List the content of the entire 16kW of spram
$3FFF rdspram

