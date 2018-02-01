\ A Basic TEK4010/4014 Vector Graphics Terminal Library
\ 
\ You want ie. TeraTerm or Xterm switched into the TEK4010/14 Emulation
\ The current vector's addressing mode is 1024x1024 pixels/points (10bit)
\
\ For more information search the "TEK4010/4014 Vector Graphics Terminal"
\ or look at http://www.stm32duino.com/viewtopic.php?f=18&t=2336
\
\ Provided as-is
\ No warranties of any kind are provided
\ by IgorM 30-Jan-2018

\ Colors for emit, plot, dot, mark
0 constant paper  \ the current paper color set in the TEK emulator
1 constant red
2 constant green
3 constant yellow
4 constant blue
5 constant magenta
6 constant cyan
7 constant ink    \ the current ink color set in the TEK emulator

\ Line styles
0 constant solid
1 constant dotted
2 constant dash_dotted
3 constant short_dashed
4 constant long_dashed

\ Font sizes
0 constant large
1 constant normal
2 constant small
3 constant smallest

: tekcls ( -- )                     \ Clean the Tek window
		$1b emit $0c emit ;
		
: tekcolor ( color -- )             \ Select a line/dot/mark color [0-7]
		$1b emit $5b emit 
		$33 emit $30 + emit 
		$6d emit ;
		
: tekgraph ( style -- )             \ Select graphics mode with line style [0-4]
		$1d emit $1b emit $60 or emit ;
		
: tekfont ( size -- )               \ Select font size [0-3]
		$1b emit $38 + emit ;
		
: tekstyle ( style -- )             \ Select line style [0-4]
		$1b emit $60 + emit ;
		
: tekbstyle ( bstyle -- )           \ Select bold line style [0-4]
		$1b emit $68 + emit ;
		
: tekalpha ( -- )                   \ Switch to the alphanumeric mode
		$1f emit ;
		
: tekplot ( x y -- )                \ Continue to draw towards X Y
		dup 
		5 rshift $1f and $20 + emit
		$1f and $60 + emit
		dup 
		5 rshift $1f and $20 + emit
		$1f and $40 + emit ;
		
: tekmark ( x y -- )                \ Draw a small cross/mark at X Y
		$1c emit 
		tekplot ;
		
: tekdot  ( x y -- )                \ Draw a single dot at X Y
		$1d emit
		dup 
		5 rshift $1f and $20 + emit
		$1f and $60 + emit
		dup dup 
		5 rshift $1f and $20 + emit
		$1f and $40 + emit 
		$1f and $40 + emit ;
		
: tekline ( x1 y1 x2 y2 -- )        \ Draw a line from X1 Y1 to X2 Y2
		$1d emit
		tekplot
		tekplot ;
		
: teklocate ( x y -- )              \ Locate the alpha string origin
		$1d emit                    \ and switch into the alpha mode
		tekplot
		tekalpha ;
	
: teksprite ( addr u -- )           \ Draw a "sprite" (sprite is coded inside a string)
		$1e emit
		type ; 
		
\ P - beam on
\ space - beam off
\ A, B, D, E, F, I, J, H - 45deg vector directions in 6 points displacements, the vector's 
\ direction are as follows:
\
\      F  D  E
\     B       A
\      J  H  I

: tekgin ( -- )                     \ Go to the Grapics-In mode
		$1b emit
		$1a emit ;

\ Examples:

: rnd  ( u1 -- u2 ) random um* nip ; \ returns u2 from [0..u1-1]

\ : test1 ( n -- ) 0 do 600 rnd 600 rnd 600 rnd 600 rnd 8 rnd tekcolor tekline loop 7 tekcolor tekalpha ;
\ : test2 ( n -- ) 0 do 600 rnd 600 rnd tekdot loop tekalpha ;
\ : test3 ( n -- ) 0 do 500 rnd 500 rnd tekmark loop tekalpha ;
\ s" PAAAAAAAAAAAAAADDBBBDDBBBHHBBBDDBBBHHBBHH" teksprite    \ draws a small ship

\ 1000 test1 \ draws 1000 random lines inside a 600x600 area

\ 500 test4 draws 500 quite miniscule inviders in random color
: test4 ( n -- )
     0 do 700 rnd 700 rnd 8 rnd tekcolor teklocate
     s" PDEEFIAAAEJIIH DFPHHJ EPBBBBBIFDD APAHBD AAPAHBD DDDD" teksprite
     loop ink tekcolor 50 720 teklocate ;
