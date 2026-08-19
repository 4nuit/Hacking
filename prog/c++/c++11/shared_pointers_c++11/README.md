## Smart pointers

- https://cours-cpp.gitbook.io/resources/abstractions/les-move-semantics

| **Aspect**          | **Raw Pointer (`T*`)**      | **Shared Pointer (`std::shared_ptr`)** | **Weak Pointer (`std::weak_ptr`)** | **Unique Pointer (`std::unique_ptr`)** |
|---------------------|-----------------------------|----------------------------------------|------------------------------------|----------------------------------------|
| **Memory Management** | Manual (use `delete`)       | Automatic (via reference counting)    | Does not manage memory (no ownership) | Automatic (exclusive ownership)        |
| **Ownership**        | Single ownership by default | Shared ownership                       | No ownership, non-owning reference to `std::shared_ptr` | Exclusive ownership, no sharing allowed |
| **Safety**           | Prone to memory leaks       | Prevents *simple* memory leaks (not cycles - two `shared_ptr`s referencing each other still leak, see "Common pitfalls" below) | Breaks the cycle: replace one side of a circular reference with `weak_ptr` to fix it | Prevents dangling pointers, automatically deletes when out of scope |
| **Usage**            | Direct access to an object  | Manages the object's lifetime and ownership | Observes an object managed by `std::shared_ptr` without affecting its lifetime | Manages ownership of an object exclusively |
| **Lifetime**         | Object must be manually deleted | Object is deleted when reference count drops to 0 | Can check if the object still exists using `lock()` | Object is deleted automatically when `unique_ptr` goes out of scope |
| **Reference Counting** | None                      | Increases reference count when copied | Does not affect reference count, only observes | Does not use reference counting, exclusive ownership means no sharing |
| **Usage Difference** | Direct pointer manipulation | Multiple references to the same object | Observing `std::shared_ptr` without owning the object | Object is owned by one `unique_ptr`, cannot be shared or copied |


```c
//raw pointer ~ C pointer
int* ptr = new int(42)
```

Prefer `std::make_shared<T>(args...)` over `std::shared_ptr<T>(new T(args...))` (used below): one allocation instead of two (object + control block combined) and exception-safe (no leak if construction throws between `new` and the `shared_ptr` constructor). See [cppreference - make_shared](https://en.cppreference.com/w/cpp/memory/shared_ptr/make_shared.html).

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
