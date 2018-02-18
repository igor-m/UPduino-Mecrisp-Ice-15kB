\ Mandelbrot by Richard Wesley Todd, 2015
\ Believed to be in the public domain
\ IgorM Feb-2018: mod for Upduino FP lib

fvariable x 
fvariable y
fvariable zx 
fvariable zy

: xs! fdup x f! zx f! ;  
: ys! fdup y f! zy f! ;
: nextx x f@ f# 0.04 f+ xs! y f@ zy f! ;
: nexty cr y f@ f# 0.1 f+ ys! f# -2.0 xs! ;
: fsq fdup f* ;  
: 2sq fover fsq fover fsq ;
: next zx f@ zy f@  2sq f- x f@ f+ zx f! f* f# 2.0 f* y f@ f+ zy f! ;
: mag zx f@ fsq zy f@ fsq f+ fsqrt ;
: mandel cr f# -1.0 ys! f# -2.0 xs!
  21 0 DO 76 0 DO 31 126 DO
  next mag f# 2.0 f> IF I EMIT LEAVE ELSE
  I 32 = IF I EMIT THEN THEN
 -1 +LOOP nextx LOOP nexty LOOP ;

fclear 
mandel

