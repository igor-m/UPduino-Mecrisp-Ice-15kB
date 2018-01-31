 \ ########### 48bit FOATING POINT LIBRARY #####################################
 \ To be used with Mecrisp-Ice Forth running on 16bit j1a CPU (UPduino board)
 \ Based on https://github.com/ForthHub/ForthFreak
 \ and https://sourceforge.net/projects/forth-4th/
 \ Assembled, modified, fixed and tested by IgorM, 11 DEC 2017
 \ Provided as-is
 \ No warranties of any kind are provided
 \ ########### 48bit FOATING POINT LIBRARY #####################################

 \ 48bit Floating Point representation uses three cells:
 \ 0 upper mantissa
 \ 1 lower mantissa
 \ 2 exponent: MSB = sign of mantissa, others = signed exponent
 
 \ mantissa is 32bit normalised
 \ exponent is 15bit 
 \ Zero is with all 48bits = 0
 
 \ mantissa is normalized: 0.5 <= mantissa <= 1.0
 \ no implicit bit in mantissa
 \ the exponent has a bias of 2^14
 
 \ max precision is 9 sign. digits
 \ range: 2^(-16384)-0.5 <= X <= 2^(16384)-1 or X = 0
 \        or approx: 10^-4920 < X < 10^4920
 
 16 CONSTANT fpmxst     \ the size of the sw floating point stack

 \ some useful constants
 3 CELLS CONSTANT byfp                     \ bytes per float
 byfp NEGATE CONSTANT -byfp
 6 VARIABLE digits                         \ # of digits to display (see F., R.)
 0 VARIABLE fsp                            \ stack pointer
 CREATE fstak fpmxst byfp * ALLOT          \ floating point stack
 CREATE ftemp 6 CELLS ALLOT                \ temporary float variable
 16 CONSTANT bicl                          \ 16-bit per cell
 9 CONSTANT mxdig                          \ max decimal digits
 $7FFF CONSTANT &unsign
 $8000 CONSTANT &sign
 $4000 CONSTANT &esign      
 
 \ A variable called ferror stores error codes in the event of an error

0 VARIABLE ferror                          \ last seen error

 \ | Code | Meaning             |
 \ | 0    | no error            |
 \ | 1    | F>D overflow        |
 \ | 2    | division by zero    |
 \ | 3    | sqrt of negative    |
 \ | 4    | undefined           |

 : du<   ( u_1 . u_2 . -- flag )          
    ROT 2DUP = IF 2DROP U< ELSE U> NIP NIP THEN ;
 : d2/  
    >r 1 rshift r@  
    [ 8 cells 1- ] literal lshift  
    or r> 2/ ;
 : ud2/          ( d -- d' )
                 D2/ &unsign AND ;
 : frshift       ( count 'man -- )               \ right shift mantissa
                 SWAP 0 MAX bicl 2* MIN
                 >R DUP 2@ R> 0 ?DO  ud2/ LOOP  ROT 2! ;
 : exp>sign      ( exp -- exp' sign )
                 DUP &unsign AND                 \ mask off exponent
                 DUP &esign AND 2* OR            \ sign extend exponent
                 SWAP &sign AND ;                \ get sign of mantissa
 : sign>exp      ( exp sign -- exp' )
                 SWAP &unsign AND OR ;
 : t2*           ( triple -- triple' )
                 D2* ROT DUP 0< 1 AND >R 2* ROT ROT R> 0 D+ ;
 : t2/           ( triple -- triple' )
                 OVER 1 AND 0<> &sign AND >R D2/ ROT       \ MHL|C
                 1 RSHIFT R> OR ROT ROT ;
 : t+            ( t1 t2 -- t3 )
                 2>R >R ROT 0 R> 0 D+ 0 2R> D+
                 ROT >R D+ R> ROT ROT ;
 : lstemp        ( -- )                          \ 6-cell left shift FTEMP
                ftemp 6 CELLS + 0                ( *LSB carry . . )
                6 0 ?DO >R -1 CELLS +            \ LSB in high memory
                 DUP @ 0 D2* SWAP R> +           ( a co n ) \ ROL
                 ROT TUCK ! SWAP                 \ a carry
                LOOP 2DROP ;
 : *norm         ( triple exp -- double exp' )   \ normalize triple
                >R BEGIN   DUP 0< 0=
                WHILE   t2* R> 1- >R
                REPEAT  2DUP AND 1+ IF &sign 0 0 t+ THEN \ round
                 ROT DROP R> ;
 : longdiv       ( DA DB -- DA/DB )              \ fractional divide
                0 0 ftemp 2!
                bicl 2* 1+                  \ long division
                0 ?DO 2OVER 2OVER DU<            \ double/double
                IF 0
                ELSE 2DUP 2>R D- 2R> 1           \ a b --> a-b b
                THEN 0 ftemp 2@ D2* D+ ftemp 2!
                2SWAP D2* 2SWAP
                LOOP DU< 0= 1 AND 0              \ round
                ftemp 2@ D+ ;
 : 'm1           ( -- addr )      fsp @ 3 cells - ;     \ -> 1st stack mantissa
 : 'm2           ( -- addr )      fsp @ 6 cells - ;     \ -> 2nd stack mantissa
 : 'm3           ( -- addr )      fsp @ 9 cells - ;     \ -> 3rd stack mantissa
 : 'e1           ( -- addr )      fsp @ 1 cells - ;     \ -> 1st stack exponent
 : 'e2           ( -- addr )      fsp @ 4 cells - ;     \ -> 2nd stack exponent
 : fmove         ( a1 a2 -- )     byfp MOVE ;
 : m1get         ( addr -- )      'm1 fmove ;           \ move to M1
 : m1sto         ( addr -- )      'm1 SWAP fmove ;      \ move from M1
 : expx1         ( -- exp sign )  'e1 @ exp>sign ;
 : expx2         ( -- exp sign )  'e2 @ exp>sign ;
 : ftemp'        ( -- addr )      ftemp 2 CELLS + ;
 : >exp1         ( exp sign -- )  sign>exp 'e1 ! ;
 : fshift        ( n -- )         expx1 >R + R> >exp1 ; \ F = F * 2^n
 : normalize     ( -- )
                'm1 2@ 2DUP OR
                IF 0 ROT ROT expx1 >R *norm
                R> >exp1 'm1 2!
                ELSE 2DROP                  \ zero is a special case
                THEN ;

 \ Floating Point Words

 : F2*           ( fs: r1 -- r3 )  1 fshift ;
 : F2/           ( fs: r1 -- r3 ) -1 fshift ;
 : PRECISION     ( -- n )         digits @ ;
 : SET-PRECISION ( n -- )         mxdig MIN digits ! ;
 : FCLEAR        ( -- )           fstak fsp ! 0 ferror ! ;
 : FDEPTH        ( -- )           fsp @ fstak - byfp / ;
 : FDUP          ( fs: r -- r r ) byfp fsp +! 'm2 m1get ;
 : FDROP         ( fs: r -- )    -byfp fsp +! ;
 : FNEGATE       ( fs: r1 -- r3 ) 'e1 @ &sign XOR 'e1 ! ; 
 : D>F           ( d -- | -- r )  FDUP DUP 0< IF DNEGATE &sign ELSE 0 THEN
                                  'e1 ! 'm1 2!  normalize ;								  
 : F>D           ( -- d | r -- )  expx1 >R DUP 1- 0<
                IF NEGATE &unsign AND 'm1 frshift 'm1 2@ R> IF DNEGATE THEN
                ELSE R> 2DROP -1 &unsign  1 ferror !   \ overflow: return maxdint
                THEN FDROP ;
 : S>F           ( n -- | -- r )  S>D D>F ; 
 : FLOAT+        ( n1 -- n2 )     byfp + ;
 : FLOATS        ( n1 -- n2 )     byfp * ;
 : F@            ( a -- | -- r )  FDUP m1get ;
 : F!            ( a -- | r -- )  m1sto FDROP ;
 : FSIGN?        ( -- t | r -- r) 'e1 @ 0< ; 
 : F0<>          ( -- t | r -- )  'm1 2@ OR 0<> FDROP ;
 : F0=           ( -- t | r -- )  F0<> 0= ;
 : F0<           ( -- t | r -- )  FSIGN? F0<> AND ;
 : F0>           ( -- t | r -- )  FSIGN? 0= F0<> AND ;
 : FABS          ( fs: r1 -- r3 ) FSIGN? IF FNEGATE THEN ;
 : FALIGN        ( -- )           ALIGN ;
 : FALIGNED      ( addr -- addr ) ALIGNED ;
 : FSWAP         ( fs: r1 r2 -- r2 r1 )
                 'm1 ftemp fmove 'm2 m1get ftemp 'm2 fmove ;
 : FOVER         ( fs: r1 r2 -- r1 r2 r3 )
                 byfp fsp +! 'm3 m1get ;
 : FPICK         ( n -- ) ( fs: -- r )
                 byfp fsp +! 2 + -byfp * fsp @ + m1get ;
 : FNIP          ( fs: r1 r2 -- r2 ) FSWAP FDROP ;
 : FROT          ( fs: r1 r2 r3 -- r2 r3 r1 )
                 'm3 ftemp fmove 'm2 'm3 byfp 2* MOVE  ftemp m1get ;				 
 : tneg          ( d flag -- t )  \ conditionally negate d to form 3-cell t
                 0<> >R 2DUP OR 0<> R> AND IF DNEGATE -1 ELSE 0 THEN ;
 : F+            ( fs: r1 r2 -- r3 ) \ Add two floats
                FDUP F0= IF FDROP EXIT THEN                      \ r2 = 0
                FOVER F0= IF FNIP EXIT THEN                      \ r1 = 0
                expx1 >R expx2 >R -  DUP 0<
                IF NEGATE 'm1 frshift 0                    \ align exponents
                ELSE DUP 'm2 frshift
                THEN 'e2 @ +
                'm2 2@ R> tneg
                'm1 2@ R> tneg
                t+ DUP >R                               ( exp L M H | sign )
                DUP IF t2/ IF DNEGATE THEN 'm2 2! 1+
                ELSE DROP 'm2 2!
                THEN R> &sign AND sign>exp 'e2 !
                FDROP normalize ;
 : F-           ( fs: r1 r2 -- r3 )            \ Subtract two floats
                FNEGATE F+ ;
 : F<           ( -- flag ) ( F: r1 r2 -- )    \ Compare two floats
                F- F0< ;
 : F=           ( -- flag ) ( F: r1 r2 -- )      \ Compare two floats
                F- F0= ;
 : FLOOR        FDUP F0< FDUP F>D D>F FOVER F- F0= 0= AND F>D ROT
                IF -1 S>D D+ THEN D>F ;
 : FROUND        ( fs: r1 -- r2 )                   \ Round to the nearest integer
                 expx1 >R NEGATE 1- 'm1 frshift          \ convert to half steps
                 'm1 2@ 1 0 D+  SWAP -2 AND SWAP         \ round
                 'm1 2! -1 R> >exp1 normalize ;          \ re-float
 : FMIN          ( F: r1 r2 -- rmin ) FOVER FOVER F<
                 IF FDROP ELSE FNIP THEN ;
 : FMAX          ( F: r1 r2 -- rmax ) FOVER FOVER F<
                 IF FNIP ELSE FDROP THEN ;
 : F*            ( fs: r1 r2 -- r3 )                \ Multiply two floats
                'm1 2@ 'm2 2@
                OVER >R ftemp' 2!
                OVER >R ftemp  2!
                R> R> OR                                \ need long multiply?
                IF FTEMP CELL+ @ FTEMP' CELL+ @ UM* &sign 0 D+ NIP \ round
                FTEMP @ FTEMP' @ UM*
                FTEMP CELL+ @ FTEMP' @ UM* 0 t+
                FTEMP @ FTEMP' CELL+ @ UM* 0 t+
                ELSE 0 ftemp @ ftemp' @ UM*                  \ lower parts are 0
                THEN 2DUP OR 3 PICK OR                       \ zero?
                IF expx1 >R expx2 >R + bicl 2* + *norm
                R> R> XOR sign>exp 'e2 !
                ELSE DROP                                    \ zero result
                THEN 'm2 2! FDROP ;
 : F/           ( fs: r1 r2 -- r3 )              \ Divide r1 by r2
                FDUP F0=
                IF FDROP -1 -1 'm1 2!  2 ferror !          \ div by 0, man= umaxint
                'e1 @ &sign AND &esign 1- OR 'e1 !         \   exponent = maxint/2
                ELSE 'm2 2@ 'm1 2@
                DU< 0= IF 1 'm2 frshift F2/ THEN           \ divisor<=dividend
                'm1 CELL+ @
                IF 'm2 2@ ud2/ 'm1 2@ ud2/  longdiv        \ max divisor = dmaxint
                ELSE 0 'm2 2@ 'm1 @ DUP >R UM/MOD          \ 0 rem quot | divisor
                 ROT ROT R@ UM/MOD ROT ROT R> 1 RSHIFT U> IF 1 0 D+ THEN \ round
                THEN expx2 >R expx1 >R - bicl 2* -
                >R 'm2 2! R> R> R> XOR sign>exp 'E2 !
                FDROP
                THEN ;
 : F~           ( f: r1 r2 r3 -- ) ( -- flag ) \ f-proximate
                FDUP F0<                              
                IF FABS FOVER FABS 3 FPICK FABS F+ F*      \ r1 r2 r3*(r1+r2)
                FROT FROT F- FABS FSWAP F<
                ELSE FDUP F0=
                IF      FDROP 'e1 @ 0< 'e2 @ 0< = F- F0= AND
                ELSE    FROT FROT F- FABS FSWAP F<
                THEN
                THEN ;

 \ For fixed-width fields, it makes sense to use fsplit and (F.) for output.
 \ fsplit converts a float to integers suitable for pictured numeric output.
 \ Fracdigits is the number of digits to the right of the decimal.

 : fsplit        ( F: r -- ) ( fracdigits -- sign Dint Dfrac )
 \ Split float into integer component parts.
                >R expx1 NIP FABS               \ int part must fit in a double
                FDUP F>D 2DUP D>F F-            \ get int, leave frac
                2 0 R> 0 ?DO  D2* 2DUP D2* D2* D+ LOOP     \ 2 * 10^precision
                D>F F* F>D  1 0 D+ ud2/ ;       \ round

 \ (F.) uses PRECISION as the number of digits after the decimal. F. clips off
 \ the result to avoid displaying extra (possibly garbage) digits. However,
 \ this defeats last-digit rounding. (F.) TYPE is the prefered display method.
 \ F. is included for completeness.

 : (F.)          ( F: r -- ) ( -- addr len )
 \ Convert float to a string
                 <# FDEPTH 1- 0< IF 0 0 EXIT THEN \ empty stack -> blank
                 PRECISION fsplit
                 PRECISION 0 ?DO  # LOOP  D+
                 PRECISION IF [CHAR] . HOLD THEN
                 #S ROT SIGN #> ;
 : F.            ( F: r -- )  (F.) PRECISION 1+ MIN TYPE SPACE ;
 : R.            ( F: r -- )  (F.) TYPE SPACE ;
 : (E.)          ( stepsize resolution -- | F: r -- ) \ X.XXXXXXEYY format
                fdup f0= if 2drop fdrop ." 0.0 " else
                >R FDUP FABS 0                  ( step 0 )
                BEGIN   FDUP 1 S>F F<
                WHILE   OVER - R@ S>F F*
                REPEAT
                BEGIN   FDUP R@ S>F F< 0=
                WHILE   OVER + R@ S>F F/
                REPEAT  R> DROP NIP
                FSWAP F0< IF FNEGATE THEN
                (F.) TYPE
                DUP ABS S>D <# #S rot SIGN
                [CHAR] e HOLD #> TYPE SPACE 
                then ;				 
 : FS.   ( F: r -- ) 1   10 (E.) ; \ scientific notation
 : FE.   ( F: r -- ) 3 1000 (E.) ; \ engineering notation 
 : d< d- nip 0< ;
 : FSQRT        ( fs: r -- r' )        \ Square root
                expx1 IF drop 4 ferror ! EXIT THEN \ sqrt of negative
                DUP 1 AND DUP >R +     \ round up exponent/2
                2/ bicl - 0 >exp1
                ftemp 6 BOUNDS DO 0 I ! LOOP
                'm1 2@                 \ x
                R> IF ud2/ THEN        \ exponent was rounded
                ftemp 2 CELLS + 2!     \ x*2^(2*bits/cell)
                0 0  bicl 2 *           \ p = 0
                0 ?DO lstemp lstemp    \ shift left x into a 2 places
                D2*                    \ shift left p one place
                2DUP D2* ftemp 2@ D<
                IF ftemp 2@ 2OVER D2* 1 0 D+ D-
                ftemp 2!               \ a:=a-(2*p+1)
                1 0 D+                 \ p:=p+1
                THEN
                LOOP 'm1 2! normalize ;
        
 \ String to floating point conversion ---------------------------------------

 : fsign         ( a n -- a' n' sign )   \ get sign from the input string
                OVER C@ OVER 0<> AND
                CASE [CHAR] - OF 1 /STRING -1 ENDOF
                [CHAR] + OF 1 /STRING  0 ENDOF
                0 SWAP
                ENDCASE ;
 0 variable flgood
 : fdigit?      ( a len -- a len n f )     \ get digit from the input string
                DUP 0<> >R
                OVER C@ [CHAR] 0 - DUP 0< OVER 9 > OR 0=
                R> AND  DUP
                IF 2SWAP 1 /STRING 2SWAP   \ good digit, use it
                1 flgood +!
                THEN ;
 : flint         ( addr len -- addr' len' )
                BEGIN fdigit?                 \ get integer part
                WHILE 10 S>F F* S>F F+
                REPEAT DROP ;
 : flexp         ( addr len -- addr' len' ) \ get exponent
                OVER C@ [CHAR] D -          \ expect 0,1,20,21
                -34 AND 0=                  \ and invert(0x21)
                flgood @ 1 <> AND           \ some mantissa digits are required
                IF 1 /STRING fsign >R 0 >R  \ E,e,D,d is valid
                BEGIN  fdigit?              \ get exponent
                WHILE  R> 10 * + >R
                REPEAT DROP R> R>
                IF 0 ?DO  10 S>F F/ LOOP    \ positive exponent
                ELSE 0 ?DO  10 S>F F* LOOP  \ negative exponent
                THEN
                THEN DUP
                IF 0 flgood !               \ unknown text left to convert
                THEN ;
 : flfrac        ( addr len -- addr' len' )
                1 /STRING 1 S>F             \ convert after the decimal
                BEGIN fdigit?
                WHILE 10 S>F F/             ( F: num digitmul )
                FDUP S>F F*                 ( F: num digitmul delta )
                FROT F+ FSWAP
                REPEAT FDROP DROP DUP       \ more to convert?
                IF flexp
                THEN ;
 : -trailing  ( c_addr u1 -- c_addr u2 ) \ string dash-trailing
    \ Adjust the string specified by @i{c-addr, u1} to remove all
    \ trailing spaces. @i{u2} is the length of the modified string.
                BEGIN
                dup
                WHILE
                1- 2dup + c@ bl <>
                UNTIL  1+  THEN ;
 : >FLOAT        ( addr len -- f ) ( f: -- r | <nothing> )
    \ Convert base 10 string to float regardless of BASE.
                -TRAILING  0 S>F
                fsign >R   1 flgood !
                flint DUP
                IF OVER C@ [CHAR] . =
                IF flfrac ELSE flexp THEN
                THEN 2DROP
                R> IF FNEGATE THEN
                flgood @ IF -1 ELSE FDROP 0 THEN ;
 : FCONSTANT     ( -<name>- ) ( F: r -- )        \ compile time
                              ( F: -- r )        \ runtime
                 CREATE HERE F! byfp ALLOT DOES> F@ ;
 : FVARIABLE     ( -<name>- )                    \ compile time
                              ( F: -- r )        \ runtime
                 CREATE byfp ALLOT ;
 : abort"
        postpone if
        postpone ."
        postpone abort
        postpone then
        ; immediate
 : fd            fstak fdepth byfp * DUMP ;   \ dump stack
 : F.S           ( -- ) FDEPTH BEGIN ?DUP WHILE 1- DUP FPICK F. REPEAT ;
 : _f#           ( a -- a' )     DUP CELL+ SWAP @ POSTPONE LITERAL ;
 : (f#)          ( mh ml e -- )  FDUP 'e1 ! SWAP 'm1 2! ;
 : F#            ( <number> -- ) BL PARSE >FLOAT 0= ABORT" Bogus float"
                 STATE @ IF 'm1 _f# _f# _f# DROP FDROP POSTPONE (f#) THEN
                 ; IMMEDIATE
fclear				 
 : pi ( r -- ) F# 3.1415926535897932384626433832795 ;
 : e  ( r -- ) F# 2.7182818284590452353602874713527 ; 
 : deg>rad pi f* 180 s>f f/ ;
 : rad>deg 180 s>f f* pi f/ ;
\ TRIGONOMETRIC FUNCTIONS 
 : >taylor fdup f* fover ;              \ setup for Taylor series
 : (taylor) fover f* frot fover d>f f/ ;
 : +taylor (taylor) f+ frot frot ;      \ add Taylor iteration
 : -taylor (taylor) f- frot frot ;      \ subtract Taylor iteration
 : >range                               \ Albert van der Horst
  pi fdup f+                           ( x pi2)
  fover fover f/                       ( x pi2 x/pi2)
  floor fover f*                       ( x pi2 mod)
  frot fswap f-                        ( pi2 mod)
  pi fover                             ( pi2 mod pi mod)
  f< if fswap f- else fnip then ;
 : fsin 
  >range fdup >taylor                   ( x x2 x)
         6. -taylor                     ( x-3 x2 x3)
       120. +taylor                     ( x+5 x2 x5)
      5040. -taylor                     ( x-7 x2 x7)
    362880. +taylor                     ( x+9 x2 x9)
  39916800. -taylor                     ( x-11 x2 x11)
  fdrop fdrop ;                         ( x-11)
 : fcos
  1 s>f fswap >range >taylor            ( 1 x2 1)
          2. -taylor                    ( 1-2 x2 x2)
         24. +taylor                    ( 1+4 x2 x4) 
        720. -taylor                    ( 1-6 x2 x6)
      40320. +taylor                    ( 1+8 x2 x8)
    3628800. -taylor                    ( 1-10 x2 x10)
  479001600. +taylor                    ( 1+12 x2 x12)
  fdrop fdrop ;                         ( 1+12)
 : fsincos fdup fsin fswap fcos ;
 : ftan fsincos f/ ;                    \ ftan = fsin / fcos
 : 2degrees 2. d+ 2dup -taylor 2. d+ 2dup +taylor ;
 : (taylor2) 1. 2degrees 2degrees 2degrees 2degrees 2degrees 2drop fdrop fdrop ;
 : (fatan) fdup >taylor (taylor2) ;
 : dom2 1 s>f fover fdup f* fover f+ fsqrt f+ f/ (fatan) fdup f+ ;
 : dom3 1 s>f fswap f/ pi f2/ fover f0< if fnegate then fswap dom2 f- ;
 : dom2|3 1 s>f fover fabs f< if dom3 else dom2 then ;
 : fatan 1 s>f f2/ f2/ fover fabs f< if dom2|3 else (fatan) then ;
 : (fasin) 1 s>f fover fdup f* fover fswap f- fsqrt f+ f/ fatan fdup f+ ;
 : fasin fdup fabs 1 s>f f= if pi f2/ f* else (fasin) then ;
 : facos fasin pi f2/ fswap f- ;
 : fatan2                               ( sin[y] cos[x] -- rad)
  fdup f0= if                          \ if x equals 0          
    fdrop fdup f0= if 4 ferror ! exit then
    f0< pi 2 s>f f/ if fnegate then    \ calculate the radian (equals pi/2)
  else                                 \ if x doesn't equal zero
    fover fover f/ fatan               \ calculate arctan(y/x)
    fswap f0< if pi frot f0< if fnegate then f+ else fnip then
  then  ;                              \ adjust accordingly
 : f**                                 ( f -- f') ( n --)
  dup
  if dup 1 = if drop else 2 /mod fdup fdup f* recurse fswap recurse f* then
  else drop fdrop 1 s>f
  then ;
 : d0< nip 0< ;
 : d>u drop ;
 : (!) over * swap 1+ swap ;
 : ^integer               ( float -- integer fraction )
  fdup f>d 2dup d>f f- 1 s>f 2dup d0< -rot dabs d>u
  0 ?do e f* loop if 1 s>f fswap f/ then fswap ;
 : ^fraction              ( integer fraction -- float )
  1 dup dup s>f fswap fover
  begin over 13 < while (!) dup s>d +taylor repeat
  drop drop fdrop fdrop f* ;
: fexp ^integer ^fraction ;
fvariable epsilon
fvariable lbase
 : >integer begin fdup f# 1.0 f< while lbase f@ f* 1- repeat ;
 : integer> begin fdup lbase f@ f< 0= while lbase f@ f/ 1+ repeat ;
 : fraction
  f# 0.0 f# 1.0 f2/ frot fdup f*
  begin
    fover epsilon f@ fswap f<
  while
    fdup lbase f@ f< 0=
    if fswap frot fover f+ fswap frot lbase f@ f/ then
    fswap f2/ fswap fdup f*
  repeat fdrop fdrop ;
 : (log)                                \ set epsilon to 1e-34
  lbase f! f# 1.0e-34 epsilon f!
  fdup f0> 0= if 4 ferror ! exit then
  0 >integer integer> fraction s>f f+ ;
 : fln e (log) ;
 : flog f# 10.0 (log) ;
 : fpow fdup f0= if fdrop fdrop f# 1.0 exit then fswap fln f* fexp ;
 : falog f# 10.0 fswap fpow ;
\ ########### END OF 48bit FOATING POINT LIBRARY #######################
