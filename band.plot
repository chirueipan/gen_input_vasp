#!/bin/bash
NBAND=80
EFermi="-3.1101"
echo $NBAND

for (( band=1; band<=80; band=$band+1 ))
do
echo $band
  for (( i=1; i<=60; i=i+1 ))
  do 
    if [ "$i" -lt "10" ]; then
      echo $(echo "scale=4; `grep -A $band "k-point   $i" OUTCAR|tail -1|awk '{print $2}'`+(-1)*$EFermi"|bc) >> band
    elif [ "$i" -ge "10" ] && [ "$i" -lt "100" ]; then
      echo $(echo "scale=4; `grep -A $band "k-point  $i" OUTCAR|tail -1|awk '{print $2}'`+(-1)*$EFermi"|bc) >> band
    elif [ "$i" -ge "100" ] && [ "$i " -lt "1000" ]; then
      echo $(echo "scale=4; `grep -A $band "k-point $i" OUTCAR|tail -1|awk '{print $2}'`+(-1)*$EFermi"|bc) >> band
    fi
  done
done
