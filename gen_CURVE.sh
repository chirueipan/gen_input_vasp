#!/bin/bash
echo "This script generates points for searching stablized lattice size."


if [ -e lattice ]; then
  rm lattice
else
  break
fi

read -p "Input the INITIAL GUESS lattice constant (A):" L
read -p "Input the INTERVAL (A):" D
read -p "Input the number of points:" N
#read -p "How many points to generate?" N

for (( i=-N/2;i<N/2;i=i+1 ))
do
P=$(echo "scale=3;$L+$i*$D"|bc )
echo $P
cat>>lattice<<!
$P
!
done

for a in `awk '{print $1}' lattice`
do 
mkdir $a
done


