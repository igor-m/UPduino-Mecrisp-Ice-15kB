\ Distance and Bearing calculation
\ Example for Mecrisp-Ice with floating point library installed
\ Calculates distance in meters and initial bearing in degrees based on
\ latidute and longitude (decimal) of two points on Earth.
\ Uses the Haversine formula
\ by IgorM 5/2015
\ by IgorM 12/2017
\ GNU GPL v3
\ No warranties of any kind
\ Provided as-is

fclear
6 set-precision

f# 6.371e6 fconstant R_E

f# 0.0 fvariable lat1
f# 0.0 fvariable lon1

f# 0.0 fvariable lat2
f# 0.0 fvariable lon2

: torad PI f# 180.0 f/ f* ;
: todeg f# 180.0 PI f/ f* ;

\ PHI1,2
: PHI1 lat1 f@ torad ;
: PHI2 lat2 f@ torad ;

: DPHI lat2 f@ lat1 f@ f- torad ;
: DLAMBDA lon2 f@ lon1 f@ f- torad ;

: A_ DPHI f# 2.0 f/ fsin fdup f* 
  PHI1 fcos PHI2 fcos DLAMBDA f# 2.0 f/ fsin fdup
  f* f* f* f+ ;
  
: C_ A_ fsqrt f# 1.0 A_ f- fsqrt fatan2 f# 2.0 f* ;

: distance lon2 f! lat2 f! lon1 f! lat1 f! R_E C_ f* ;

: inibearing \ lon2 f! lat2 f! lon1 f! lat1 f!
  DLAMBDA fsin PHI2 fcos f* 
  PHI1 fcos PHI2 fsin f* 
  PHI1 fsin PHI2 fcos DLAMBDA fcos f* f* 
  f- fatan2 todeg ;

\ lat1     lon1     lat2        lon2 (degree) distance (meters)    initial_bearing (degree)
\ f# 50.0e f# 15.0e f# 50.0001e f# 15.0001e   distance fs.    inibearing fe. (13.22m, 32 43 56 = 32.73222)   
\ f# 50.0e f# 15.0e f# 60.0e    f# 80.0e      distance fs.    inibearing fe. (4108km, 48 56 13 = 48.93694)   
\ f# 50.0e f# 15.0e f# -60.0e   f# -170.0e    distance fs.    inibearing fe. (18860km, 166 01 30 = 166.025)   

\ f# 50.0e f# 15.0e f# 50.0001e f# 15.0001e distance fe. inibearing fe.   \ 1.321721e1   32.734021e0   
\ f# 50.0e f# 15.0e f# 60.0e    f# 80.0e      distance fe. inibearing fe. \ 4.107800e6   48.936862e0   
  f# 50.0e f# 15.0e f# -60.0e   f# -170.0e    distance fe. inibearing fe. \ 18.859125e6  166.074586e0   
\ f# 50.0e f# 15.0e f# 50.00001e f# 15.00001e distance fe. inibearing fe. \ 1.321678e0   32.767700e0   
  
  
  



