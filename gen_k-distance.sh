#!/bin/bash
#the script is to calculate the k-point distance of the k-point in plotting bandstructure
#work in the directory inside a job
#will output a file named k-distance

pi=3.141592654
#read from POSCAR
#lattice constant
a=`head -2 POSCAR|tail -1`
#lattice vector a1 a2 a3
a1x=$(echo "scale=15;$a*`head -3 POSCAR|tail -1|awk '{print $1}'`"|bc)
a1y=$(echo "scale=15;$a*`head -3 POSCAR|tail -1|awk '{print $2}'`"|bc)
a1z=$(echo "scale=15;$a*`head -3 POSCAR|tail -1|awk '{print $3}'`"|bc)
a2x=$(echo "scale=15;$a*`head -4 POSCAR|tail -1|awk '{print $1}'`"|bc)
a2y=$(echo "scale=15;$a*`head -4 POSCAR|tail -1|awk '{print $2}'`"|bc)
a2z=$(echo "scale=15;$a*`head -4 POSCAR|tail -1|awk '{print $3}'`"|bc)
a3x=$(echo "scale=15;$a*`head -5 POSCAR|tail -1|awk '{print $1}'`"|bc)
a3y=$(echo "scale=15;$a*`head -5 POSCAR|tail -1|awk '{print $2}'`"|bc)
a3z=$(echo "scale=15;$a*`head -5 POSCAR|tail -1|awk '{print $3}'`"|bc)
#echo $a1x $a1y $a1z $a2x $a2y $a2z $a3x $a3y $a3z
#volume in angstrom cube
V=$(echo "scale=15;($a1x*$a2y*$a3z+$a1y*$a1z*$a3x+$a1z*$a2x*$a3y)-($a1x*$a2z*$a3y+$a1y*$a2x*$a3z+$a1z*$a2y*$a3x)"|bc)
#echo $V

#reciprocal lattice vector
b1x=$(echo "scale=15;($a2y*$a3z-$a2z*$a3y)*2*$pi/$V"|bc)
b1y=$(echo "scale=15;($a2z*$a3x-$a2x*$a3z)*2*$pi/$V"|bc)
b1z=$(echo "scale=15;($a2x*$a3y-$a2y*$a3x)*2*$pi/$V"|bc)
b2x=$(echo "scale=15;($a3y*$a1z-$a3z*$a1y)*2*$pi/$V"|bc)
b2y=$(echo "scale=15;($a3z*$a1x-$a1z*$a3x)*2*$pi/$V"|bc)
b2z=$(echo "scale=15;($a3x*$a1y-$a3y*$a1x)*2*$pi/$V"|bc)
b3x=$(echo "scale=15;($a1y*$a2z-$a1z*$a2y)*2*$pi/$V"|bc)
b3y=$(echo "scale=15;($a1z*$a2x-$a1x*$a2z)*2*$pi/$V"|bc)
b3z=$(echo "scale=15;($a1x*$a2y-$a1y*$a2x)*2*$pi/$V"|bc)

#echo $b1x $b1y $b1z $b2x $b2y $b2z $b3x $b3y $b3z
NKpts=$(echo "`grep NKPTS OUTCAR|awk '{print $4}'`"|bc)


if [ -e k-points ]; then
  rm k-points
else
  break
fi

#for (( n=1; n<=NBand; n=n+1 ))
#do
for (( i=1; i<=$NKpts; i=i+1 ))
    do 
      if [ "$i" -ge "1" ] && [ "$i" -lt "10" ]; then
        if [ "$i" -eq "1" ]; then
          echo `grep "k-point    $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points
#          echo `grep "k-point    $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points  
        else
          echo `grep "k-point    $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points 
        fi
      elif [ "$i" -ge "10" ] && [ "$i" -lt "100" ]; then
        echo `grep "k-point   $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points
      elif [ "$i" -ge "100" ] && [ "$i" -lt "1000" ]; then
        if [ "$i" -eq "$NKpts" ]; then       
          echo `grep "k-point  $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points
#          echo `grep "k-point  $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points
        else
          echo `grep "k-point  $i" PROCAR|awk '{print $4 " " $5 " " $6}'`>>k-points
        fi
      fi 
done
  #  done
 # fi
#done
Nsec=3
Npt=$(echo "$NKpts/3"|bc)
NBand=60
dsec=0
#echo $Nsec
#echo $Npt
#echo $((1%2))
  for (( j=0; j<Nsec; j=j+1 ))
  do
    startpt=$(echo "1+$j*$Npt"|bc)
#  echo "startpt" $startpt
    k1x=$(echo "scale=15;`head -$startpt k-points|tail -1|awk '{print $1}'`*$b1x+`head -$startpt k-points|tail -1|awk '{print $2}'`*$b2x+`head -$startpt k-points|tail -1|awk '{print $3}'`*$b3x"|bc)
    k1y=$(echo "scale=15;`head -$startpt k-points|tail -1|awk '{print $1}'`*$b1y+`head -$startpt k-points|tail -1|awk '{print $2}'`*$b2y+`head -$startpt k-points|tail -1|awk '{print $3}'`*$b3y"|bc)
    k1z=$(echo "scale=15;`head -$startpt k-points|tail -1|awk '{print $1}'`*$b1z+`head -$startpt k-points|tail -1|awk '{print $2}'`*$b2z+`head -$startpt k-points|tail -1|awk '{print $3}'`*$b3z"|bc)
    for (( i=1; i<=Npt; i=i+1 ))
    do
      kpt=$(echo "$j*$Npt+$i"|bc)
      k2x=$(echo "scale=15;`head -$kpt k-points|tail -1|awk '{print $1}'`*$b1x+`head -$kpt k-points|tail -1|awk '{print $2}'`*$b2x+`head -$kpt k-points|tail -1|awk '{print $3}'`*$b3x"|bc)
      k2y=$(echo "scale=15;`head -$kpt k-points|tail -1|awk '{print $1}'`*$b1y+`head -$kpt k-points|tail -1|awk '{print $2}'`*$b2y+`head -$kpt k-points|tail -1|awk '{print $3}'`*$b3y"|bc)
      k2z=$(echo "scale=15;`head -$kpt k-points|tail -1|awk '{print $1}'`*$b1z+`head -$kpt k-points|tail -1|awk '{print $2}'`*$b2z+`head -$kpt k-points|tail -1|awk '{print $3}'`*$b3z"|bc)
      dkx=$(echo "scale=15;$k2x+(-1)*$k1x"|bc)
      dky=$(echo "scale=15;$k2y+(-1)*$k1y"|bc)
      dkz=$(echo "scale=15;$k2z+(-1)*$k1z"|bc)
      dk=$(echo "scale=15;$dsec+sqrt($dkx*$dkx+$dky*$dky+$dkz*$dkz)"|bc)
      echo $dk >> test1
    done   
    dsec=$dk
  done
  
  for (( j=$Nsec; j>0; j=j-1 ))
  do
    startpt=$(echo "$j*$Npt"|bc)
  echo "startpt" $startpt
    k1x=$(echo "scale=15;`head -$startpt k-points|tail -1|awk '{print $1}'`*$b1x+`head -$startpt k-points|tail -1|awk '{print $2}'`*$b2x+`head -$startpt k-points|tail -1|awk '{print $3}'`*$b3x"|bc)
    k1y=$(echo "scale=15;`head -$startpt k-points|tail -1|awk '{print $1}'`*$b1y+`head -$startpt k-points|tail -1|awk '{print $2}'`*$b2y+`head -$startpt k-points|tail -1|awk '{print $3}'`*$b3y"|bc)
    k1z=$(echo "scale=15;`head -$startpt k-points|tail -1|awk '{print $1}'`*$b1z+`head -$startpt k-points|tail -1|awk '{print $2}'`*$b2z+`head -$startpt k-points|tail -1|awk '{print $3}'`*$b3z"|bc)
    for (( i=0; i<Npt; i=i+1 ))
    do
      kpt=$(echo "$j*$Npt-$i"|bc)
#      echo "kpt" $kpt
      k2x=$(echo "scale=15;`head -$kpt k-points|tail -1|awk '{print $1}'`*$b1x+`head -$kpt k-points|tail -1|awk '{print $2}'`*$b2x+`head -$kpt k-points|tail -1|awk '{print $3}'`*$b3x"|bc)
      k2y=$(echo "scale=15;`head -$kpt k-points|tail -1|awk '{print $1}'`*$b1y+`head -$kpt k-points|tail -1|awk '{print $2}'`*$b2y+`head -$kpt k-points|tail -1|awk '{print $3}'`*$b3y"|bc)
      k2z=$(echo "scale=15;`head -$kpt k-points|tail -1|awk '{print $1}'`*$b1z+`head -$kpt k-points|tail -1|awk '{print $2}'`*$b2z+`head -$kpt k-points|tail -1|awk '{print $3}'`*$b3z"|bc)
      dkx=$(echo "scale=15;$k2x+(-1)*$k1x"|bc)
      dky=$(echo "scale=15;$k2y+(-1)*$k1y"|bc)
      dkz=$(echo "scale=15;$k2z+(-1)*$k1z"|bc)
      dk=$(echo "scale=15;$dsec-sqrt($dkx*$dkx+$dky*$dky+$dkz*$dkz)"|bc)
      #echo "dk" $dk
      echo $dk >> test2
    done
    dsec=$dk
  done


if [ -e k-distance ]; then
  rm k-distance
else
  break
fi



if [ "$(($NBand%2))" == "1" ]; then
   for (( i=1; i<=$(echo "($NBand-1)/2"|bc); i=i+1 ))
   do
     cat test1 >> k-distance
     cat test2 >> k-distance
   done
   cat test1 >> k-distance
elif [ "$(($NBand%2))" == "0" ]; then
   for (( i=1; i<=$(echo "$NBand/2"|bc); i=i+1 ))
   do 
    cat test1 >> k-distance
    cat test2 >> k-distance
   done 
fi

rm test1
rm test2 
