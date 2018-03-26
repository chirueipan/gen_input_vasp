#!/bin/bash

for a in `awk '{print $1}' lattice`
do
cd $a
rm WAVECAR
rm CHG
cd ..
done
