UPduino Mecrisp-Ice Forth with 8kB block ram.
---------------------------------------------

An Experimental version of the Mecrisp-Ice Forth running on the J1a 16bit processor.

This is an Lattice Radiant Mini version for UP5k/8kB version ready to build.


It does not require any other tools to be installed except the Radiant.


The ram source already contains the nucleus.fs image (from Mecrisp-Ice).


The timing estimates (max clock) are >24MHz (Synplify Pro).


Double check the "Place & Route Timing Analysis Report" -  the chapter

"3.2.1  Setup Constraint Slack Summary" must not indicate negative "Slack".


IgorM, 15-Mar-2018