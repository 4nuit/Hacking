#!/bin/bash -l
#SBATCH --time=1
#SBATCH --account=lxp
#SBATCH --partition=gpu
#SBATCH --qos=default
#SBATCH --nodes=4

module load NVHPC
nvcc hello.cu -o hello_cu
srun -n 10 ./hello_cu