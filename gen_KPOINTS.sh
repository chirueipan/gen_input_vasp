#!/bin/bash

for a in `awk '{print $1}' lattice`
do
cd $a
cat>KPOINTS<<!
COMMENTS
0
Monkhorst-Pack
25 25 1
0 0 0
!
cd ..
done
