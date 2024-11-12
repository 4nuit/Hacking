## Doc

- https://docs.lxp.lu/
- https://hpc-tutorials.llnl.gov/
- https://diveintosystems.org/book/
- https://ulhpc-tutorials.readthedocs.io/en/latest/
- https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8me_CAP

![](https://diveintosystems.org/book/C15-Parallel/_images/NewHPCHDAFigure.png)

## HPC

### Cluster

- https://docs.easybuild.io/
- https://modules.sourceforge.net/
- https://slurm.schedmd.com/quickstart.html/
- https://wiki.lustre.org/images/6/64/LustreArchitecture-v4.pdf

### OS

- https://cpu.land/
- https://csc-knu.github.io/sys-prog/books/Andrew%20S.%20Tanenbaum%20-%20Modern%20Operating%20Systems.pdf
- https://openclassrooms.com/fr/courses/19980-apprenez-a-programmer-en-c/7673041-utilisez-les-directives-du-preprocesseur
- https://drive.google.com/drive/folders/16FnbMmbfreb2SJX0px-5ce5KFq0Pjd1M
- https://stackoverflow.com/questions/50560395/how-to-install-cuda-in-google-colab-gpus

### Prog

- https://en.algorithmica.org/hpc/
- https://rookiehpc.org/index.html/

### Prog SMP / Shared memory

*2 approches*:

- `Unified Shared Memory` (host/device => 1 pointer for all accesses)`
- `Local Memory` (DMA, SYCL Buffers => 2 accessors)

#### CPU (Pthread / OpenMP)

`1 CPU = sockets x cores` 

- Personal computer  ~ 1 x (2 or 4 cores) 
- HPC supercalulator ~ 2 x (32 or 64 cores) (per CPU/node)

ex with 200 nodes: 2CPU/node, with 2 sockets, 64 cores each => 400 CPU, 128 cores/node

![](https://diveintosystems.org/book/C5-Arch/_images/multicore.png)

- https://gitlab.com/perache.marc/pbt_mpp
- https://web.archive.org/web/20120120160334/http://www.ibm.com/developerworks/library/l-linux-smp/
- https://www.openmp.org/wp-content/uploads/SC19-Ruud-SpeedUp.pdf
- https://sites.cs.ucsb.edu/~tyang/class/240a16w/slides/lectureOpenMP.pdf

#### GPU (CUDA / OpenCL)

`1 GPU = sockets x SMs` 

- 1 GPC = 16 SMs (A100); 1 SM ~ 1 CPU core
- A kernel grid is split among a GPU:
	- 1 SM ~ 1 block. 4 TensorCore / SM
	- 1 CUDA Core = 1 thread = 1 register. 16 FP32 (+ 16INT32)/TensorCore => 64 FP32(+64INT32) CUDA CORE /SM; 32 FP64 CUDA Core/SM
	- 1 warp = smallest unit of // = 32 threads (+/- 2 blocks)

- See page 19: [A100 Official doc](https://images.nvidia.com/aem-dam/en-zz/Solutions/data-center/nvidia-ampere-architecture-whitepaper.pdf)

![](https://developer-blogs.nvidia.com/wp-content/uploads/2020/06/kernel-execution-on-gpu-1-625x438.png)

ex with 200 nodes: 4GPU /node, with 4 sockets, 128 SMs each => 800 GPU, 512 SMs/node

![](https://docs.lxp.lu/system/images/ga100-full-gpu-128-sms.png)
![](https://docs.lxp.lu/system/images/ga100-sm.png)

- https://own2pwn.fr/gpu-intro
- https://developer.nvidia.com/blog/cuda-refresher-cuda-programming-model/
- https://developer.nvidia.com/blog/easy-introduction-cuda-c-and-c/
- https://www.nvidia.com/docs/IO/116711/sc11-cuda-c-basics.pdf
- https://developer.download.nvidia.com/compute/cuda/2_1/cudagdb/CUDA_GDB_User_Manual.pdf
- https://engineering.purdue.edu/~smidkiff/ece563/NVidiaGPUTeachingToolkit/Mod20OpenCL/3rd-Edition-AppendixA-intro-to-OpenCL.pdf

#### FPGA

- https://www.intel.com/content/www/us/en/docs/programmable/683846/22-4/overview.html
- https://luxprovide.github.io/QuantumFPGA/
- https://docs.lxp.lu/fpga/opencl/pyopencl_ifpgasdk/

#### SYCL (Intel OneApi Spec)

- https://github.khronos.org/SYCL_Reference/
- https://oneapi-spec.uxlfoundation.org/specifications/oneapi/v1.3-rev-1/
- https://www.intel.com/content/www/us/en/developer/articles/technical/compiling-sycl-with-different-gpus.html
- https://www.intel.com/content/www/us/en/developer/articles/technical/learn-sycl-in-an-hour-maybe-less.html

### Prog Distribuee & Hybride

![](https://diveintosystems.org/book/C15-Parallel/_images/SharedNothing.png)

- https://researchcomputing.princeton.edu/sites/g/files/toruqf311/files/documents/MPI_tutorial_Fall_Break_2022.pdf
- https://www.cac.cornell.edu/education/training/ParallelMay2012/HybridProgMay2012.pdf

## HPDA

- https://docs.lxp.lu/software/module_example/HFInference/
- https://huggingface.co/docs/accelerate/usage_guides/distributed_inference/
- https://stackoverflow.com/questions/20327621/calling-ipython-from-a-virtualenv/
