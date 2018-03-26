#!/bin/bash

echo "Please input the number of dimer lines of bottom ribbon:"
read no_of_dimerlines1
echo "Please input the number of dimer lines of top ribbon:"
read no_of_dimerlines2
echo "Please input the width of vacuum region:"
read vac_vertical


#no_of_atoms=$(echo "$no_of_dimerlines*2"|bc)
lattice_constant=3.32
bond_length=$(echo "scale=15;$lattice_constant/sqrt(3)"|bc)
layer_distance=6.9
xperiod=$lattice_constant
yperiod=$(echo "scale=15;$bond_length*$no_of_dimerlines1*3/2"|bc)
zperiod=$(echo "scale=15;$layer_distance+$vac_vertical"|bc)
d=1.68
cat>test_POSCAR_II<<!
zigzag nanoribbon
  1.0
    $xperiod  0.0      0.0
    0.0     $yperiod   0.0
    0.0     0.0      $zperiod
  W   Se
  $(($no_of_dimerlines1+$no_of_dimerlines2)) $((($no_of_dimerlines1+$no_of_dimerlines2)*2))
Selective dynamics
Direct
!

for (( i=0; i<$(($no_of_dimerlines1*2)); i=i+1 ))
do
if [ "$(echo "$i%4"|bc)" == 0 ]; then
echo "   0.0  $(echo "scale=15;($bond_length*0.0+$(($i/4))*3*$bond_length)/$yperiod"|bc) 0.0 T T T">>test_POSCAR_II
elif [ "$(echo "$i%4"|bc)" == 2 ]; then
echo "   0.5  $(echo "scale=15;($bond_length*1.5+$(($i/4))*3*$bond_length)/$yperiod"|bc) 0.0 T T T">>test_POSCAR_II
fi
done

for (( i=$((($no_of_dimerlines1-$no_of_dimerlines2))); i<$((($no_of_dimerlines1+$no_of_dimerlines2))); i=i+1 ))
do
if [ "$(echo "$i%4"|bc)" == 1 ]; then
echo "   0.5 $(echo "scale=15;($bond_length*0.5+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;$layer_distance/$zperiod"|bc) T T T">>test_POSCAR_II
elif [ "$(echo "$i%4"|bc)" == 3 ]; then
echo "   0.0 $(echo "scale=15;($bond_length*2.0+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;$layer_distance/$zperiod"|bc) T T T">>test_POSCAR_II
fi
done



for (( i=0; i<$(($no_of_dimerlines1*2)); i=i+1 ))
do
if [ "$(echo "$i%4"|bc)" == 1 ]; then
echo "   0.5 $(echo "scale=15;($bond_length*0.5+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;$d/$zperiod"|bc) T T T">>test_POSCAR_II
echo "   0.5 $(echo "scale=15;($bond_length*0.5+$(($i/4))*3*$bond_length)/$yperiod"|bc) -$(echo "scale=15;$d/$zperiod"|bc) T T T">>test_POSCAR_II
elif [ "$(echo "$i%4"|bc)" == 3 ]; then
echo "   0.0 $(echo "scale=15;($bond_length*2.0+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;$d/$zperiod"|bc) T T T">>test_POSCAR_II
echo "   0.0 $(echo "scale=15;($bond_length*2.0+$(($i/4))*3*$bond_length)/$yperiod"|bc) -$(echo "scale=15;$d/$zperiod"|bc) T T T">>test_POSCAR_II
fi
done

for (( i=$((($no_of_dimerlines1-$no_of_dimerlines2))); i<$((($no_of_dimerlines1+$no_of_dimerlines2))); i=i+1 ))
do
if [ "$(echo "$i%4"|bc)" == 0 ]; then
echo "   0.0 $(echo "scale=15;($bond_length*0.0+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;($layer_distance+$d)/$zperiod"|bc) T T T">>test_POSCAR_II
echo "   0.0 $(echo "scale=15;($bond_length*0.0+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;($layer_distance-$d)/$zperiod"|bc) T T T">>test_POSCAR_II
elif [ "$(echo "$i%4"|bc)" == 2 ]; then
echo "   0.5 $(echo "scale=15;($bond_length*1.5+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;($layer_distance+$d)/$zperiod"|bc) T T T">>test_POSCAR_II
echo "   0.5 $(echo "scale=15;($bond_length*1.5+$(($i/4))*3*$bond_length)/$yperiod"|bc) $(echo "scale=15;($layer_distance-$d)/$zperiod"|bc) T T T">>test_POSCAR_II
fi
done
