#!/bin/bash

for a in `awk '{print $1}' lattice`
do
cd $a
cat>sub.sh<<!
#!/bin/bash
#PBS -N $a-Si-lda
#PBS -o out 
#PBS -e err 
#PBS -q ibm2
#PBS -l nodes=1:ppn=8 
cd \$PBS_O_WORKDIR
echo '=======================================================' 
echo Working directory is \$PBS_O_WORKDIR 
echo "Starting on \`hostname\` at \`date\`" 
if [ -n "\$PBS_NODEFILE" ]; then
if [ -f \$PBS_NODEFILE ]; then
echo "Nodes used for this job:" 
cat \${PBS_NODEFILE}
NPROCS=\`wc -l < \$PBS_NODEFILE\`
fi
fi
mpirun -hostfile \$PBS_NODEFILE -n \$NPROCS /opt/software/vasp/vasp.5.3.3.2-normal > log
echo "Job Ended at \`date\`" 
echo '======================================================='
!
cd ..
done
