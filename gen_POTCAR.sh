#!/bin/bash

for a in `awk '{print $1}' lattice`
do
cp POTCAR $a
done
