#!/bin/bash
filename=file_list

for a in `awk '{print $1}' $filename`
do
grep -A4 "FREE ENERGIE OF THE ION-ELECTRON SYSTEM" $a/OUTCAR|tail -1|awk '{print "'$a'" " " $7}' >> test1
grep -A2 "FREE ENERGIE OF THE ION-ELECTRON SYSTEM" $a/OUTCAR|tail -1|awk '{print "'$a'" " " $5}' >> test2
done

energy=test2

Nlines=`wc -l $filename|awk '{print $1}'`
for (( i=1; i<$Nlines; i=i+1 ))
do
E1=`head -$i $energy|tail -1|awk '{print $2}'` 
E2=`head -$(echo "$i+1"|bc) $energy|tail -1|awk '{print $2}'` 
echo `head -$(echo "$i+1"|bc) $energy|tail -1|awk '{print $1}'` "	" `head -$i $energy|tail -1|awk '{print $1}'` "	" \
$(echo "scale=5;($E2+(-1)*$E1)*1000"|bc)
done

rm test1 test2
