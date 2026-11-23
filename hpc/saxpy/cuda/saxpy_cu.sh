#!/bin/bash -l
#SBATCH --time=1:00:00
#SBATCH --account=lxp
#SBATCH --partition=gpu
#SBATCH --qos=default

# 4GPU / noeud
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --gpus-per-task=1

module load NVHPC
# compile with -g -G to debug with cuda-gdb
nvcc saxpy.cu -o saxpy_cu
srun ./saxpy_cu