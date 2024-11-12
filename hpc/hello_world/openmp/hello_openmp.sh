#!/bin/bash -l
#SBATCH --time=1
#SBATCH --account=lxp
#SBATCH --partition=cpu
#SBATCH --qos=default
#SBATCH --nodes=4

module load foss
g++ hello_openmp.cpp -o hello_openmp -fopenmp
export OMP_NUM_THREADS=10
./hello_openmp
