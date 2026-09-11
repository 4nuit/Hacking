#!/bin/bash -l
#SBATCH --time=0:30:00
#SBATCH --account=lxp
#SBATCH --partition=gpu
#SBATCH --qos=default
#SBATCH --nodes=1

module load env/staging/2023.1
module load intel-oneapi

icpx -fsycl -fsycl-targets=nvptx64-nvidia-cuda hello_buffer_gpu.cpp -o  hello_buffer_gpu
srun ./hello_buffer_gpu
