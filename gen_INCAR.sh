#!/bin/bash

for a in `awk '{print $1}' lattice`
do
cd $a
cat>INCAR<<!
System = silicene
ISTART = 0
PREC = high                #  precision normal
ENCUT = 500                #  cutoff used throughout all calculations
ISMEAR = 0                 #  method to determine partial occupancies

#Electronic Relaxation
EDIFF = 1E-05 ! stopping-criterion for ELM
LREAL = .FALSE. ! real-space projection
LWAVE = .FALSE.
LCHARG = .FALSE.
#ICHARG = 2 
#ISPIN = 2

#Ionic relaxation
EDIFFG = -1E-04 !stopping-criterion for IOM
NSW = 200 ! number of steps for IOM
IBRION = 2 !ionic relax: 0-MD 1-quasi-New 2-CG
ISIF = 2
!
cd ..
done
