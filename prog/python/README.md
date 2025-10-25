## Cheatsheets

- https://gto76.github.io/python-cheatsheet/
- https://github.com/crazyguitar/pysheeet
- https://github.com/satwikkansal/wtfpython

## Reminders

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
