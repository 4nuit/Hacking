# SYCL Task Dependencies Demonstration

## Problem Overview

Matrix operations are common in HPC and often involve dependencies between tasks. For example:
- `B= tA`
- `C = B + k(1)`
- `D = C*C`

## Resolution Approaches

1. **USM with In-Order Queue (`usm_in_order_queue.cpp`)**  
   - Uses Unified Shared Memory (USM) with an *in-order queue*.  
   - Task dependencies are implicit due to the sequential execution of the queue.

2. **USM with Out-of-Order Queue and `depends_on` (`usm_depends_on.cpp`)**  
   - Uses USM with an *out-of-order queue*.  
   - Dependencies are explicitly managed using the `depends_on` mechanism for each task.

3. **Buffer Accessors with Read/Write Rights (`buffer_accessors.cpp`)**  
   - Uses SYCL buffers and accessors to define explicit read/write access.  
   - Task dependencies are implicitly managed by the SYCL runtime based on buffer usage.
