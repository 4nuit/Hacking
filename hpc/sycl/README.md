## Simplidied definition of the main classes

(From DPC++ book)
See [../../prog/c++](../../prog/c++/) for modern cpp memos.

### Queue

```c
class queue{
    public:
    //Create a queue associated with a default (implementation chosen) device
    queue(const property_list & = {});
    queue(const async_handler &, const property_list & = {});

    //Create a queue using a DeviceSelector (cpu_selector_v,gpu_selector_v,other ranked devices)
    template <typename DeviceSelector>
    explicit queue(const DeviceSelector &deviceSelector, const property_list &proplist = {});

    //Create a queue associated with and explicit device
    queue(const device &, const property_list & = {});

    //Create a queue associated with a device in a specific SYCL context. Selector could replace device.
    queue(const context &, const device &, const property_list & = {});
};
```

### Handlers

```c
// Access modes

queue q;
buffer a_device{a};
buffer b_device{b};

q.submit([&](handler &h){
    accessor a(a_device, h, read_only);
    accessor b(b_device, h, write_only);
    h.parallel_for(NumWork, KernelFunc);
});

/* a and b can be reused in other kernels */
host_accessor host_acc_a(a_device, read_only);
host_accessor host_acc_b(b_device, write_only);
```

```c
class handler{
    // Accessors members
    //Specifies events that must be complete before action.
    //Src: accessor,    Dest: shared_ptr
    //Src: accessor,    Dest: pointer
    //Src: shared_ptr   Dest: accessor
    //Src: pointer      Dest: accessor
    //Src accessor      Dest: accessor

    template <typename T_Src, typename T_Dst, int Dims, access::mode AccessMode, access::target AccessTarget, access::placeholder IsPlaceholder = access::placeholder::false_t>
    void copy(accessor<T_Src, Dims, AccessMode, AccessTarget, IsPLaceholder> Src, shared_ptr_class<T_Dst> Dst);
    //other overloaded equivalents

    // guarantees that the object refered by accessor is updated on the host after action
    template <typename T, int Dims, access::mode AccessMode, access::target AccessTarget, access::placeholder IsPlaceholder = access::placeholder::false_t>
    void update_host(accessor<T, Dims, AccessMode, AccessTarget, IsPlaceholder> Acc);

    // Non-accessors members
    void depends_on({event &});
    
    // Memory Commands
    void memcpy(void* Dest, const void* Src, size_t Count);
    //Enqueue a memcpy
    template <typename T>
    void copy(const T* Src, T* Dest, size_t Count);
    
    void memset(void* Ptr, int Value, size_t Count);
    //Enqueue a memset
    template <typename T>
    void fill(void* Ptr, const T& Pattern, size_t Count);

    // Kernel Commands
    template <typename KernelName, typename KernelType>
    void single_task(KernelType KernelFunc);

    template <typename KernelName, typename KernelType, int Dims>
    void parallel_for(range<Dims> NumWork, KernelType KernelFunc);
    // Exemple (1D, 2D kernels (up to 3D))
    // NumWork      =   sycl::range<1>(N),                          sycl::range<2>(N, N)
    // KernelFunc   =   [=](sycl::id<1> i){ device_acc[i]++; },     [=](sycl::id<2> idx){ int j,i = idx[0],idx[1]; for(int k=0; k<N; ++k){ c[j][i] += a[j][k]*b[k][i] }; }
    
    //nd_range overloaded
    void parallel_for(nd_range<Dims> ExecutionRange, KernelType KernelFunc);
}
```
