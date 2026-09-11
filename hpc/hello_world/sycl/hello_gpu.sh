#!/bin/bash -l
#SBATCH --time=0:30:00
#SBATCH --account=lxp
#SBATCH --partition=gpu
#SBATCH --qos=default
#SBATCH --nodes=1

module load env/staging/2023.1
module load intel-oneapi
module load 520nmx/20.4
# Check the available devices
sycl-ls
icpx -fsycl -fsycl-targets=nvptx64-nvidia-cuda hello_sycl.cpp -o  hello_sycl_gpu
srun ./hello_sycl_gpu