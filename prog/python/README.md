## Documentation

- https://explorar.dev/python/cpython

## Cheatsheets

- https://docs.astral.sh/uv/
- https://github.com/crazyguitar/pysheeet
- https://github.com/satwikkansal/wtfpython
- https://gto76.github.io/python-cheatsheet/
- https://github.com/salvatore-abello/python-ctf-cheatsheet

## Optimisations (Functions, Iterators, Numpy, Cython Bindings)

- https://docs.python.org/3/library/itertools.html
- https://blog.lightender.fr/articles/optimizePython

### Numpy 

- https://github.com/darkhelmet/cheats
- https://www.geeksforgeeks.org/python/numpy-cheat-sheet/

#### Converting: Octave to Numpy

```bash
f=load(data.map)
C = [f.X, f.y]
csvwrite(data.csv,C)
```

```py
import numpy as np
data = np.genfromtxt('data.csv', delimiter=',')
np.save('data.npy', data)
```

### Multithreading for IO-bound tasks, Multiprocessing for CPU-bound tasks

- https://docs.python.org/3/library/concurrent.futures.html
- https://www.geeksforgeeks.org/python/multithreading-python-set-1/
- https://guif.re/python#Use%20Map%20reduce%20to%20divide%20CPU%20intensive%20tasks:
- https://www.geeksforgeeks.org/python/difference-between-multithreading-vs-multiprocessing-in-python/
- https://stackoverflow.com/questions/52507601/whats-the-point-of-multithreading-in-python-if-the-gil-exists

## Decorators

- https://pythonbasics.org/decorators/

```py
@hello                                                                                                      
def name():   
```

equals

```py
obj = hello(name)
```

## List

- https://www.laurentluce.com/posts/python-list-implementation/

```c
//Warning: ob_items are not a node byt PyObject vector (realloc if len=sizeof(list))

typedef struct {
    PyObject_HEAD
    Py_ssize_t ob_size;

    /* Vector of pointers to list elements.  list[0] is ob_item[0], etc. */
    PyObject **ob_item;

    /* ob_item contains space for 'allocated' elements.  The number
     * currently in use is ob_size.
     * Invariants:
     *     0 <= ob_size <= allocated
     *     len(list) == ob_size
     *     ob_item == NULL implies ob_size == allocated == 0
     */
    Py_ssize_t allocated;
} PyListObject;
```

```py
#help(list)

a = [1, 2, 3 ,4]
for e in a:
        print(hex(id(e)))

"""
List are tabs in practice: +0x20 (sizeof(int) = 4*8)) for each offset.
"""

#0x7e7c238df3d0
#0x7e7c238df3f0
#0x7e7c238df410
#0x7e7c238df430
```

**Python List = mutable sized tab (contiguous memory reallocation) => O(1) in access and append() (de-referencing + offset known), O(n) for write (pop,insert)**

| **Type**       | **Python**: Shallow Copy Issues | **C++**: Shallow Copy Issues                       |
|-----------------|----------------------------------|---------------------------------------------------|
| `int`          | No issues (immutable)           | No issues (copied by value)                       |
| `float`        | No issues (immutable)           | No issues (copied by value)                       |
| `complex`      | No issues (immutable)           | No issues (uses deep copy by default)             |
| `str`          | No issues (immutable)           | No issues (strings are deep copied or `std::move`)|
| `tuple`        | No issues (immutable)           | No direct equivalent, typically no issues         |
| `list`/`array` | Issues (mutable)                | Possible issues if shallow copy (`std::vector`)   |
| `dict`         | Issues (mutable)                | Custom object; depends on implementation          |
| `set`          | Issues (mutable)                | Similar to `std::set`; no shallow copy issues     |
| `bytearray`    | Issues (mutable)                | N/A (use `std::vector<uint8_t>` or similar)       |
