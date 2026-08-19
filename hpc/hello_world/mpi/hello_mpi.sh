#!/bin/bash -l
#SBATCH --time=1
#SBATCH --account=lxp
#SBATCH --partition=cpu
#SBATCH --qos=default
#SBATCH --nodes=4

module load foss
mpic++ hello_mpi.cpp -o hello_mpi
srun -n 10 ./hello_mpi