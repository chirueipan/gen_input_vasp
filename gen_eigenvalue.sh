#!/bin/bash
#this scripy is to collect the eigenvalue in the PROCAR file
#create a file named eigenvalue

NBand=`grep NBANDS OUTCAR|awk '{print $15}'`

for (( i=1; i<=$NBand; i=i+1 ))
do 
  if [ "$(($i%2))" == "1" ]; then
    if [ "$i" -ge "1" ] && [ "$i" -lt "10" ]; then
      grep "band   $i" PROCAR|awk '{print $5}' >> eigenvalue
    elif [ "$i" -ge "10" ] && [ "$i" -lt "100" ]; then
      grep "band  $i" PROCAR|awk '{print $5}' >> eigenvalue
    elif [ "$i" -ge "100" ] && [ "$i" -lt "1000" ]; then
      grep "band $i" PROCAR|awk '{print $5}' >> eigenvalue
    fi
  elif [ "$(($i%2))" == "0" ]; then 
    if [ "$i" -ge "1" ] && [ "$i" -lt "10" ]; then
      grep "band   $i" PROCAR|awk '{print $5}'|tac >> eigenvalue
    elif [ "$i" -ge "10" ] && [ "$i" -lt "100" ]; then
      grep "band  $i" PROCAR|awk '{print $5}'|tac >> eigenvalue
    elif [ "$i" -ge "100" ] && [ "$i" -lt "1000" ]; then
      grep "band $i" PROCAR|awk '{print $5}'|tac >> eigenvalue
    fi
  fi
done


#cat test1 >> band.dat

