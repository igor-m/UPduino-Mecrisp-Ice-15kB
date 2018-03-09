UPduino Mecrisp-Ice with full 15kB block ram.
---------------------------------------------

An Experimental version of the Mecrisp-Ice Forth running on the J1a 16bit processor.

This is an Lattice Radiant version for UP5k/15kB full version ready to build.


It does not require any other tools to be installed except the Radiant.


The ram source already contains the nucleus.fs image (from Mecrisp-Ice).


The timing estimates (max clock) are 15-20MHz based on the PAR seed.


Double check the "Place & Route Timing Analysis Report" -  the chapter

"3.2.1  Setup Constraint Slack Summary" must not indicate negative "Slack".


For reliable operation use 12-16MHz clock.


IgorM, 9-Mar-2018