#!/bin/bash -l
#SBATCH --time=8:00:00
#SBATCH --account=lxp
#SBATCH --partition=fpga
#SBATCH --qos=default
#SBATCH --nodes=1

module load env/staging/2023.1
module load intel-fpga
module load 520nmx/20.4

make
make early_image
make fast_compile
make full_compile
