## Documentation

- https://explorar.dev/python/cpython
- https://docs.python.org/3/using/cmdline.html#environment-variables
- https://docs.python.org/3/library/gc.html#gc.get_referrers
- https://zestedesavoir.com/tutoriels/954/notions-de-python-avancees/
- https://www.bravegnu.org/blog/python-byte-code-hacks.html


### List : Dynamic array implementation

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

### Decorators

- https://pythonbasics.org/decorators/

```py
def toto(self):
	print("toto")
	return self

@toto
def titi():
	print("titi")

if __name__ == '__main__':
    #print("toto\ntiti\n")
	titi()
```

```py
def hello(func):                                                                                            
    def inner():
        print("Hello ")
        func()
    return inner

@hello                                                                                                      
def name():
    """
    obj = hello(name)
    """
    print("Alice")

                                                                                                            
if __name__ == "__main__":
    #print("Hello\nAlice\n")
    name()
```

## Cheatsheets

- https://github.com/crazyguitar/pysheeet
- https://github.com/satwikkansal/wtfpython
- https://gto76.github.io/python-cheatsheet/


## Tools

- https://astral.sh/ruff
- https://docs.astral.sh/uv/

### Optimisations (Functions, Iterators, Numpy, Cython Bindings)

- https://docs.python.org/3/library/itertools.html
- https://blog.lightender.fr/articles/optimizePython
- https://realpython.com/introduction-to-python-generators/

### Numpy 

- https://github.com/darkhelmet/cheats
- https://www.geeksforgeeks.org/python/numpy-cheat-sheet/
- https://zestedesavoir.com/tutoriels/4139/les-bases-de-numpy-et-matplotlib/

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



