## Algorithms

- https://www.youtube.com/@abdul_bari
- https://www.youtube.com/@informatiquetheorique9146
- https://github.com/sslotin/amh-code
- https://github.com/lucasaugustus/labmath3
- https://github.com/keon/algorithms
- https://github.com/gkonovalov/algorithms
- https://github.com/cp-algorithms/cp-algorithms
- https://rosettacode.org/wiki/Category:Classic_CS_problems_and_programs

### Graphs

- Djikstra
- A*


## Data Structures

- https://rosettacode.org/wiki/Category:Data_Structures
- https://en.cppreference.com/w/cpp/container
- https://docs.python.org/3/tutorial/datastructures.html
- https://www.geeksforgeeks.org/dsa/dsa-tutorial-learn-data-structures-and-algorithms/
- https://dev.to/khaledhosseini/data-structures-and-algorithms-for-multi-language-programmers-c-swift-python-java-c-javascript-alp

### Arrays

**Contiguous memory + O(1) access**

- https://www.geeksforgeeks.org/c/pass-2d-array-parameter-c/

#### Static arrays

**Stack-Located, immutable**

- https://man.archlinux.org/man/alloca.3.en
- https://en.wikipedia.org/wiki/Stack-based_memory_allocation#System_interface

```c
T Array[n];
```

`C++: std::array<type,size>`

#### Dynamic array

**Heap-Located, mutable**

- https://man.archlinux.org/man/malloc.3.en
- https://en.wikipedia.org/wiki/Dynamic_array
- https://www.delftstack.com/howto/cpp/cpp-vector-implementation/
- https://www.laurentluce.com/posts/python-list-implementation/
- https://dev.to/adwaitthattey/optimizing-c-vector-for-2x-performance--1691

```c
struct Vector{
	T* Array;	// Vector of pointers to list elements (contiguous, pointer arithmetic)
	int current;
	int capacity;	// Intial allocation + realloc if overflow
}
```

`C++: std::vector<type>, std::string string`

```python
from array import array

# Arrays represent basic values and behave very much like lists, except the type of objects stored in them is constrained.
arr = array('i', [1,2,3,4])
```

**Pre allocating memory**

```c++
std::vector<int> vec;
vec.reserve(1000);
```

```java
ArrayList<Integer> list = new ArrayList<>();
list.ensureCapacity(1000);
```

| **Operation**        | **C++ (std::vector)**                                      | **Python (array or list)**         | **Java (ArrayList)**      |
|----------------------|-----------------------------------------------------------|---------------------------|---------------------------|
| **Type Definition**   | `std::vector<int>`                                        | `list = []`               | `ArrayList<Integer>`       |
| **Append**            | `emplace_back(element)` (O(1) amortized, use `reserve()` to pre-allocate) | `append(element)` (O(1))  | `add(element)` (O(1))     |
| **Access**            | `vec[i]` (O(1))                                          | `list[i]` (O(1))          | `get(i)` (O(1))           |
| **Delete (end)**      | `pop_back()` (O(1))                                      | `pop()` (O(1))            | `remove(index)` (O(n))    |
| **Resize**            | Automatic, O(n) when resizing                            | Automatic, O(n)           | Automatic, O(n)           |
| **Insertion (end)**   | O(1) amortized (use `reserve()` to pre-allocate)          | O(1) amortized            | O(1) amortized            |
| **Deletion (shift)**  | O(n) (use `erase` for non-contiguous deletes)            | O(n)                      | O(n)                      |
| **Pointer (begin)**   | `vec.begin()`                                            | `iter(list)`              | `list.listIterator()`     |
| **Pointer (end)**     | `vec.end()`                                              | `next(it)` (end range)    | `next(it)` (rend range) |



### Linked Lists

**(Heap) Non contiguous memory + O(1) insertion**

- https://en.wikipedia.org/wiki/Linked_list
- https://www.geeksforgeeks.org/c/linked-list-in-c/
- https://www.geeksforgeeks.org/python-linked-list/
- https://www.cs.princeton.edu/courses/archive/spr11/cos217/lectures/08DsAlg.pdf

```c
struct Node{
	T data
	struct Node *next;	// Node which follows (non contiguous)
};
typedef struct Node Node;

Node* new_node(T data) {
        Node* node = (Node *)malloc(sizeof(Node));
        if (node != NULL) {
                node->data = data;
                node->next = NULL;
        }
        return node;
}
```

`C++ (std::forward_list) only`


#### Double LinkedList

- https://explorar.dev/bminor/glibc
- https://azeria-labs.com/heap-exploitation-part-1-understanding-the-glibc-heap-implementation/


```c
struct Node{
	T data
	struct Node *next;
	struct Node *prev;
};
typedef struct Node Node;
```

| Operation | Python (Custom) | C++ (std::list) | Java (LinkedList) |
|----------|---------------|----------------|------------------|
| Create List | `list = LinkedList()` | `std::list<T> list` | `LinkedList<T> list` |
| Add First | `insert_at_begin(data)` | `emplace_front(element)` | `addFirst(element)` |
| Add Last | `insert_at_end(data)` | `emplace_back(element)` | `addLast(element)` |
| Remove First | `remove_first()` | `pop_front()` | `removeFirst()` |
| Remove Last | `remove_last()` | `pop_back()` | `removeLast()` |
| Get First | `head.data` | `front()` | `getFirst()` |
| Get Last | `tail.data` | `back()` | `getLast()` |
| Insert At Pos | `insert_at_index(data,pos)` | `iterator-based` | `iterator-based` |
| Remove At Pos | `remove_at_index(pos)` | `iterator-based` | `iterator-based` |
| Check Empty | `is_empty()` | `empty()` | `isEmpty()` |
| Get Size | `size()` | `size()` | `size()` |
| Clear List | `clear()` | `clear()` | `clear()` |
| Insert/Delete Head | O(1) | O(1) | O(1) |
| Insert/Delete Tail | O(1) | O(1) | O(1) |
| Insert/Delete Middle | O(n) | O(n) | O(n) |
| Access Element | O(n) | O(n) | O(n) |
| Search Element | O(n) | O(n) | O(n) |

### Stack

**Push/Pop O(1), unused memory allocation**

Stacks can be implemented with

- Dynamic Arrays (`C++: stack`, `Java: stack`)
- Linked Lists (`C++: queue`, `Java: LinkedList`)
- Double-Ended Queues (`C++: deque`, `Python: deque`, `Java: ArrayDeque`)

```c
// Array version
struct Stack{
	int Stack[N];
	int top;
};

typedef struct stack stack;

Stack new_s() { 
	Stack s;
	s.top = -1;
	return s;
}
```

```c++
// C++ stack data structure, using deque as default container
template <class T, class Container = deque<T> > class stack;
```

### HashTables

**Search O(1), key/value, no order/random access**

- `C++: Unordered map`
- `Python: Dict`
- `Java: HashTable`

### Set

#### Unordered set

**Search O(1), no random access**

- `C++: Unordered_set`
- `Python: Set`
- `Java: HashSet`

#### Ordered set (Red Back Tree)

**Search O(log(n)), random access > O(1)**

- `C++: set`
- `Java: TreeSet`

### Tree & Graphs

- https://maxnilz.com/docs/001-ds/tree/
- https://maxnilz.com/docs/001-ds/graph/
