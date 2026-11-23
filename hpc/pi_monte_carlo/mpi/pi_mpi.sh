#!/bin/bash -l
#SBATCH --time=1:00:00
#SBATCH --account=lxp

#2CPU /noeud
#SBATCH --partition=cpu
#SBATCH --qos=default
#SBATCH --nodes=10

module load foss
mpicc pi_mpi.c -o pi_mpi
srun -n 30 ./pi_mpi