# HPC Interview Cheatsheet — Synchronization, Performance & Q&A

---

## 1. Mutex

```c
pthread_mutex_lock(&m);
// critical section
pthread_mutex_unlock(&m);
```

| Attribute   | Value        |
|-------------|--------------|
| **Owner**   | yes          |
| **Limitation** | contention |
| **Limitation** | low scalability |

**Resources:**
- https://man7.org/linux/man-pages/man3/pthread_mutex_lock.3.html
- https://hpc-tutorials.llnl.gov/posix/

**Interview Q&A:**

| Q | A |
|---|---|
| What is a mutex? | Ensures only one thread accesses a critical section at a time. |
| Why can mutexes hurt performance in HPC? | They serialize access, increasing contention and reducing parallel efficiency. |

---

## 2. Semaphore

```c
sem_wait(&s);
sem_post(&s);
```

| Attribute     | Value           |
|---------------|-----------------|
| **Owner**     | no              |
| **Type**      | counter-based   |

**Resources:**
- https://man7.org/linux/man-pages/man7/sem_overview.7.html

**Interview Q&A:**

| Q | A |
|---|---|
| How does a semaphore differ from a mutex? | A semaphore allows multiple threads (up to N) to access a resource; a mutex allows only one. |

---

## 3. Mutex vs Semaphore

| Criterion   | Mutex              | Semaphore          |
|-------------|--------------------|--------------------|
| **Access**  | 1                  | N                  |
| **Owner**   | Yes                | No                 |
| **Usage**   | critical section   | resource limit     |
| **HPC Notes** | avoid for high thread counts | can limit resources |

---

## 4. Contention

**Definition:** Concurrent access to a shared resource.

**Effects:**
- Waiting
- Slowdown
- Poor scalability

**Solutions:**
- Thread-local variables
- Data partitioning
- Reduction
- Lock-free approaches

**Resources:**
- https://hpc-wiki.info/hpc/Performance_optimisations

**Interview Q&A:**

| Q | A |
|---|---|
| What is contention in HPC? | When multiple threads compete for the same resource, reducing performance. |
| How can you reduce it? | Thread-local data, partitioning, reduction, lock-free algorithms. |

---

## 5. Atomic vs Reduction

### Atomic

```c
#pragma omp atomic
sum += A[i];
```

- Serialization
- Contention
- Cache ping-pong

### Reduction

```c
#pragma omp parallel for reduction(+:sum)
for (int i = 0; i < N; i++)
    sum += A[i];
```

- Thread-local → combined at the end
- Scalable

**Resources:**
- https://www.openmp.org/specifications/

**Interview Q&A:**

| Q | A |
|---|---|
| Why is atomic slower than reduction? | Atomic serializes access; reduction uses private variables per thread and combines at the end. |
| When would you use atomic instead of reduction? | Only when performing operations that cannot be expressed as a reduction. |

---

## 6. False Sharing

### Problem

```c
struct {
    int a;
    int b;
};
```

**Definition:** Different variables on the same cache line.

**Effects:** Cache invalidations, performance degradation.

### Fix

```c
struct {
    int a;
    char pad[60];
};
```

**Resources:**
- https://hpc-wiki.info/hpc/FalseSharing

**Interview Q&A:**

| Q | A |
|---|---|
| What is false sharing? | Occurs when multiple threads write to different variables on the same cache line, causing cache ping-pong. |
| How do you prevent it? | Padding, cache line alignment, or separating thread-local data. |

---

## 7. Summary Table of Key Points

| Concept        | Problem it solves           | HPC Note                        | Interview Tip                          |
|----------------|-----------------------------|---------------------------------|----------------------------------------|
| Mutex          | exclusive access            | avoid high thread counts        | explain serialization                  |
| Semaphore      | limited resource            | N threads allowed               | compare with mutex                     |
| Atomic         | safe single variable update | contention possible             | contrast with reduction                |
| Reduction      | parallel sum/combination    | scalable                        | always prefer over atomic for reductions |
| False Sharing  | cache invalidation          | severe perf hit                 | explain padding solution               |

---

## 8. HPC Best Practices

- Avoid mutexes when possible
- Prefer reductions for sums/aggregations
- Use thread-local data
- Avoid unnecessary shared memory
- Consider cache line alignment and padding
- Think in terms of scalability

---

## 9. Common Interview Questions

- Explain mutex vs semaphore
- Causes and solutions for contention
- Atomic vs reduction differences
- False sharing definition and mitigation
- Examples of improving parallel performance

---

## 10. Key Reminders

- `volatile` does not provide synchronization
- Algorithmic complexity does not always equal HPC performance
- Performance bottlenecks are often memory- or synchronization-bound

---

## 11. Further Reading

- Cache / MESI protocol: https://en.wikipedia.org/wiki/MESI_protocol
- OpenMP tutorials: https://www.openmp.org/resources/tutorials-articles/
- HPC optimization: https://hpc-wiki.info/hpc/Main_Page

---

## TL;DR

- **thread-local > shared**
- **reduction > atomic**
- **cache awareness > everything else**
