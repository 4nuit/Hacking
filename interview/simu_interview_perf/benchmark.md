# HPC/AI Benchmark Engineer Interview Preparation Guide

---

# 1. Theoretical Peak Performance and HPL

## Problem Statement

Cluster:

* 128 nodes
* 2 × AMD EPYC 9654 CPUs per node
* 512 GB DDR5 RAM
* HDR InfiniBand (200 Gb/s)

The customer reports only **40% efficiency on HPL**.

---

## Expected Reasoning

### Compute Peak Formula

The theoretical peak performance is:

$$
R_{peak}=Nodes \times CPUs \times Cores \times Frequency \times FLOPs/Cycle
$$

For a CPU:


Peak_{CPU}=Cores \times Frequency \times FLOPs/Cycle
$$

Cluster peak:

$$
Peak_{Cluster}=Nodes \times CPUs \times Peak_{CPU}
$$

---

## What To Investigate

### CPU

* CPU frequency scaling
* Turbo mode
* Power limits
* SMT / Hyperthreading

### Memory

* NUMA locality
* Memory bandwidth
* Memory population

### MPI

* Rank placement
* Process binding
* Communication overhead

### Network

* InfiniBand link speed
* Fabric configuration

### HPL Parameters

* Matrix size (N)
* Block size (NB)
* Process grid

---

## Typical HPL Efficiency

| Efficiency | Interpretation       |
| ---------- | -------------------- |
| 90-95%     | Excellent            |
| 80-90%     | Good                 |
| 70-80%     | Acceptable           |
| <70%       | Investigation needed |
| ~40%       | Serious issue        |

---

## Official References

### HPL

Official project:

https://www.netlib.org/benchmark/hpl/

### TOP500

TOP500 methodology:

https://www.top500.org

### AMD EPYC Performance

https://www.amd.com/en/processors/epyc-server-cpu

---

# 2. Roofline Model

## What Is It?

The Roofline Model helps determine whether an application is limited by:

* Compute capability
* Memory bandwidth

- https://en.wikipedia.org/wiki/Roofline_model

---

## Arithmetic Intensity

$$
AI=\frac{Operations}{Bytes\ transferred}
$$

---

## Interpretation

If:

$$
AI < Ridge\ Point
$$

The application is:

**Memory-bound**

If:

$$
AI > Ridge\ Point
$$

The application is:

**Compute-bound**

---

## What Interviewers Want To Hear

* Arithmetic intensity
* Memory bandwidth
* FLOPS peak
* Bottleneck identification

---

## Official References

### Berkeley Roofline

https://crd.lbl.gov/divisions/amcr/computer-science-amcr/par/research/roofline/

### NERSC Roofline Tutorial

https://docs.nersc.gov/tools/performance/roofline/

### Intel Advisor Roofline

https://www.intel.com/content/www/us/en/docs/advisor/user-guide

---

# 3. NUMA (Non-Uniform Memory Access)

## What Is NUMA?

Modern multi-socket servers are NUMA systems.

Each CPU socket owns:

* Local memory
* Memory controller

Accessing local memory is faster than remote memory.

---

## Typical Problem

Performance decreases when moving from:

* 1 socket
* to 2 sockets

because remote memory accesses increase.

---

## Tools

### Hardware Topology

```bash
lstopo
```

### NUMA Layout

```bash
numactl --hardware
```

### NUMA Statistics

```bash
numastat
```

### CPU Counters

```bash
perf stat
```

### Advanced Profiling

* Intel VTune
* ARM MAP
* Arm Performance Reports

---

## Official References

### Linux NUMA

https://www.kernel.org/doc/html/latest/admin-guide/mm/numa_memory_policy.html

### numactl

https://github.com/numactl/numactl

### hwloc

https://www.open-mpi.org/projects/hwloc/

---

# 4. HPC Networking

## Ethernet

General-purpose network technology.

Advantages:

* Cheap
* Ubiquitous

Disadvantages:

* Higher latency
* More CPU overhead

---

## InfiniBand

Designed for HPC.

Features:

* RDMA
* Low latency
* High throughput
* Kernel bypass

---

## HDR vs NDR

| Generation | Speed    |
| ---------- | -------- |
| HDR        | 200 Gb/s |
| NDR        | 400 Gb/s |

---

## Why Scaling Breaks

A CFD or AI application may scale well initially.

Eventually:

$$
Communication > Computation
$$

Performance plateaus or decreases.

---

## Common Network Benchmarks

### OSU Micro Benchmarks

```bash
osu_latency
```

```bash
osu_bw
```

### InfiniBand Perftest

```bash
ib_write_bw
```

```bash
ib_send_bw
```

---

## Official References

### NVIDIA Networking

https://www.nvidia.com/en-us/networking/

### Open MPI

https://www.open-mpi.org

### OSU Benchmarks

https://mvapich.cse.ohio-state.edu/benchmarks/

### Perftest

https://github.com/linux-rdma/perftest

---

# 5. AI Benchmarking

## Training Benchmarks

### MLPerf Training

Industry standard.

Measures:

* Training throughput
* Time-to-train

---

## Inference Benchmarks

### MLPerf Inference

Measures:

* Throughput
* Latency

---

## LLM Benchmarks

Common frameworks:

* Megatron-LM
* DeepSpeed
* TensorRT-LLM
* vLLM

---

## GPU Communication

### NCCL Tests

```bash
all_reduce_perf
```

```bash
all_gather_perf
```

---

## Official References

### MLPerf

https://mlcommons.org

### NCCL

https://developer.nvidia.com/nccl

### DeepSpeed

https://www.deepspeed.ai

### Megatron-LM

https://github.com/NVIDIA/Megatron-LM

### TensorRT-LLM

https://developer.nvidia.com/tensorrt

### vLLM

https://github.com/vllm-project/vllm

---

# 6. GPU Performance Analysis

## Example

```text
GPU Utilization: 98%
SM Occupancy: 35%
Memory BW: 90%
```

---

## Interpretation

GPU appears busy.

However:

* Occupancy is low
* Memory bandwidth is nearly saturated

This usually indicates:

### Memory-bound kernel

Possible causes:

* Uncoalesced memory accesses
* Register pressure
* Shared memory limitations
* Small block size

---

## Tools

### NVIDIA Nsight Systems

System-wide analysis.

### NVIDIA Nsight Compute

Kernel-level analysis.

---

## Official References

### CUDA Best Practices

https://docs.nvidia.com/cuda/cuda-c-best-practices-guide/

### Nsight Systems

https://developer.nvidia.com/nsight-systems

### Nsight Compute

https://developer.nvidia.com/nsight-compute

---

# 7. Linux Performance Analysis

## Symptom

```text
CPU Idle = 40%
```

during a supposedly CPU-intensive benchmark.

---

## Possible Causes

### MPI Imbalance

Some ranks finish before others.

### I/O Wait

Storage bottleneck.

### Network Wait

MPI communication bottleneck.

### Poor CPU Affinity

Processes migrate across cores.

---

## Tools

### CPU Monitoring

```bash
mpstat
```

```bash
pidstat
```

### Performance Counters

```bash
perf
```

### Historical Statistics

```bash
sar
```

### Storage Analysis

```bash
iostat
```

---

## Official References

### Linux perf

https://perf.wiki.kernel.org

### sysstat

https://github.com/sysstat/sysstat

### Brendan Gregg Performance Analysis

https://www.brendangregg.com

---

# 8. Complete HPC Benchmarking Methodology

## Step 1 — Hardware Validation

CPU:

```bash
lscpu
```

Topology:

```bash
lstopo
```

GPU:

```bash
nvidia-smi
```

---

## Step 2 — Network Validation

InfiniBand:

```bash
ibstat
```

Bandwidth:

```bash
ib_write_bw
```

Latency:

```bash
osu_latency
```

---

## Step 3 — Storage Validation

### fio

```bash
fio
```

Metrics:

* IOPS
* Throughput
* Latency

---

## Step 4 — CPU Benchmarking

### HPL

Peak compute capability.

### HPCG

Realistic HPC workloads.

### STREAM

Memory bandwidth.

---

## Step 5 — GPU Benchmarking

### NCCL

GPU communication performance.

### CUDA Samples

* bandwidthTest
* deviceQuery

---

## Step 6 — AI Benchmarking

### MLPerf

Training and inference.

### LLM Benchmarks

* DeepSpeed
* Megatron-LM
* TensorRT-LLM
* vLLM

---

## Step 7 — Final Report

Include:

* Hardware inventory
* Software stack
* BIOS settings
* Benchmark results
* Expected performance
* Observed performance
* Bottleneck analysis
* Recommendations

---

# Concepts Frequently Asked in Interviews

## HPC Fundamentals

* FLOPS
* Vectorization
* SIMD
* AVX2
* AVX512

### References

https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html

---

## Parallel Programming

* MPI
* OpenMP
* Hybrid MPI/OpenMP

### References

https://www.mpi-forum.org

https://www.openmp.org

---

## Scaling

### Strong Scaling

Fixed problem size.

### Weak Scaling

Fixed workload per node.

### References

https://hpc-wiki.info/hpc/Scaling

---

## Memory

* NUMA
* Cache hierarchy
* STREAM benchmark

### References

https://www.cs.virginia.edu/stream/

---

## HPC Storage

* Lustre
* BeeGFS
* GPFS (IBM Storage Scale)

### References

https://www.lustre.org

https://www.beegfs.io

https://www.ibm.com/products/storage-scale

---

# Recommended Learning Path Before Interview

1. HPL
2. HPCG
3. STREAM
4. MPI basics
5. NUMA
6. InfiniBand
7. NCCL
8. MLPerf
9. Roofline Model
10. Linux perf
