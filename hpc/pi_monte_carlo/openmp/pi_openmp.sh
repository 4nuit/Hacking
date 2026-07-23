#!/bin/bash -l
#SBATCH --time=1:00:00
#SBATCH --account=lxp
#SBATCH --partition=cpu
#SBATCH --qos=default

# 2 CPU/noeud
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

# equivalent to srun -c 30 -n 1 ./pi_openmp
# -n = --ntasks, -c = --cpu

module load foss
gcc -fopenmp pi_openmp.c -o pi_openmp
export OMP_NUM_THREADS=100
time srun ./pi_openmp
