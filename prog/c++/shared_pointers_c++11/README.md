## Smart pointers

- https://cours-cpp.gitbook.io/resources/abstractions/les-move-semantics

| **Aspect**          | **Raw Pointer (`T*`)**      | **Shared Pointer (`std::shared_ptr`)** | **Weak Pointer (`std::weak_ptr`)** |
|---------------------|-----------------------------|----------------------------------------|------------------------------------|
| **Memory Management** | Manual (use `delete`)       | Automatic (via reference counting)    | Does not manage memory (no ownership) |
| **Ownership**        | Single ownership by default | Shared ownership                       | No ownership, non-owning reference to `std::shared_ptr` |
| **Safety**           | Prone to memory leaks       | Prevents memory leaks                  | Prevents memory leaks caused by circular references |
| **Usage**            | Direct access to an object  | Manages the object's lifetime and ownership | Observes an object managed by `std::shared_ptr` without affecting its lifetime |
| **Lifetime**         | Object must be manually deleted | Object is deleted when reference count drops to 0 | Can check if the object still exists using `lock()` |
| **Reference Counting** | None                      | Increases reference count when copied | Does not affect reference count, only observes |

```c
//raw pointer ~ C pointer
int* ptr = new int(42)
```

Rq: there is `std::unique_ptr` too

## Common pitfalls

- runtime overhead compared to raw pointers

- memory leak for circular references

```c
std::shared_ptr<A> a = std::make_shared<A>();
std::shared_ptr<B> b = std::make_shared<B>();
a->b = b; // A refers to B
b->a = a; // B refers to A
// Memory leak! Use std::weak_ptr to solve this.
```
