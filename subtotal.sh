#!/bin/bash

for a in `awk '{print $1}' lattice`
do 
cd $a
qsub sub.sh
cd ..
done
