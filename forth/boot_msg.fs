\ Example: A boot message via "init" word
\ Requires basisdefinitions.fs and millis.fs loaded first
\ IgorM 15-Mar-2018


: boot cr s" Mecrisp-Ice v1.2, j1a 16bit CPU @24MHz, 115k2 8n1" type 
    24000. timer1 $80 intmask! eint cr 
    s" Free: " type unused . cr  ;

' boot init !

3 save


\ Mecrisp-Ice v1.2, j1a 16bit CPU @24MHz, 115k2 8n1
\ Free: 1594