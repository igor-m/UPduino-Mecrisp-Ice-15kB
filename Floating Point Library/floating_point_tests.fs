 \ ########### 48bit FOATING POINT LIBRARY - SIMPLE TESTS #####################################
 \ To be used with Mecrisp-Ice Forth running on 16bit j1a CPU (UPduino b0ard)
 \ by IgorM, 11 DEC 2017
 \ Provided as-is
 \ No warranties of any kind are provided
 \ ############################################################################################

fclear

6 SET-PRECISION 

F# -1.0e-100 e f* fs.  \ -2.718281812E-100      

e pi f# -1.23456e-34 f* f/ fs.  \ -7.008618301E33      

e pi f# 1.23456e-34 f* f/ fsqrt fs.  \ 8.371749E16      

f# 0.5 fsincos fs. fs. \ 8.775826e-1 4.794255e-1      

f# -0.5 fsincos fs. fs. \ 8.775826e-1 -4.794255e-1      

f# 0.0 fsincos fs. fs. \ 1.000000e0 0.0     

f# -100.0 fsincos fs. fs. \ 8.623190e-1 5.063655e-1      

f# 0.001 fsincos fs. fs. \ 9.999995e-1 9.999998e-4      

f# 0.7 ftan fs. \ 8.422884e-1      

f# -0.7 ftan fs. \ -8.422884e-1      

f# 0.5 fasin fs. \ 5.235988e-1      

f# 0.5 facos fs. \ 1.047198e0      

f# -0.7 fatan fs. \ -6.107260e-1      

1 S>F 7 S>F F/ R.     

1 S>F 3 S>F F/ R.     

2 S>F 3 S>F F/ R.     

355 S>F 113 S>F F/ R.     

2 S>F FSQRT R.    

12345 S>F 10000 S>F F/ FE.     

F# -.0001 FE.      

F# 10000 F# .0001 F* F.      

F# 1d6 FS. F# 1D-6 FS.     

F# -1.23e6 FS. F# 1.23e-6 FS.     

F# 1e99 FSQRT FS.     

F# 123 F# 456 F+ F.     

F# 123 F# 456 F- F.     

F# 456 F# 123 F- F.     

2 S>F 3 S>F F/ R. \ 0.666666667      

-23456 s>f -31999 s>f f/ fe. \ 733.022907019E-3      

 9 set-precision
 
-23456 s>f -31999 s>f f/ fe. \ 733.022907019E-3      

 6 SET-PRECISION
 
-23456 s>f -31999 s>f f/ fe. \ 733.022907E-3      

-23456 s>f -31999 s>f f* fe. \ 750.568544E6      

-123456789. d>f 567483923. d>f f+ fe. \ 444.027134E6      

-123456789. d>f 567483923. d>f f+ r. \ 444027134.000000      

-123456789. d>f 567483923. d>f f+ fs. \ 4.440271E8      

-123456789. d>f 567483923. d>f f- r. \ -690940712.000000      

-123456789. d>f 567483923. d>f f- fe. \ -690.940712E6      

-123456789. d>f 567483923. d>f f- fs. \ -6.909407E8      

 9 set-precision

355000. D>F 113000. D>F F/ r. \ 3.141592921      

355000. D>F 113000. D>F F/ fe. \ 3.141592921E0      

-123456789. d>f 567483923. d>f f* fe. \ -70.059742928E15      

F# 1000.0 fsqrt fs. \ 3.162277661E1      

f# -222.0 fsqrt fe. \ -222.000000000E0      

f# 987654.321e112 fsqrt fe. \ 99.380799174E57      

f# 987654.321e-234 fsqrt fe. \ 993.807979345E-117      

f# 987654.321e-234 fsqrt fs. \ 9.938080E-115      

 6 set-precision

\ 9.000 degree test must return 9.000 degree
\ not with 9digits mantissa precision, however :)
\ 30ms @30MHz with 9.000 degree input

: d2r pi f# 180.0 f/ ;
: r2d f# 180.0 pi f/ ;

: TRIG9
		d2r f* fsin
		d2r f* fcos
		d2r f* ftan
		fatan r2d f*
		facos r2d f*
		fasin r2d f*
;
f# 9.000 trig9 fs. \ 9.000156e0      

f# 123.456e3 7 fpow fs.  \ 4.371046e35      
 
f# 12345.567e345 fln fs.  \ 8.038129e2      
 
  
  
  

