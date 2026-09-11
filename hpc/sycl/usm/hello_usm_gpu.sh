#!/bin/bash -l
#SBATCH --time=0:30:00
#SBATCH --account=lxp
#SBATCH --partition=gpu
#SBATCH --qos=default
#SBATCH --nodes=1

module load env/staging/2023.1
module load intel-oneapi

icpx -fsycl -fsycl-targets=nvptx64-nvidia-cuda hello_usme_gpu.cpp -o  hello_usme_gpu
icpx -fsycl -fsycl-targets=nvptx64-nvidia-cuda hello_usmi_gpu.cpp -o  hello_usmi_gpu
srun ./hello_usme_gpu
srun ./hello_usmi_gpu