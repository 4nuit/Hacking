## Data Structures

- https://en.cppreference.com/w/cpp/container
- https://docs.python.org/3/tutorial/datastructures.html

### Arrays

**Contiguous memory + O(1) access**.

```c
T Array[n];
```

#### Dynamic array

**Heap-Located (realloc)**

- https://en.wikipedia.org/wiki/Dynamic_array
- https://www.delftstack.com/howto/cpp/cpp-vector-implementation/
- https://www.laurentluce.com/posts/python-list-implementation/

```c
struct Vector{
	T* Array;	// Vector of pointers to list elements (contiguous, pointer arithmetic)
	int current;
	int capacity;	// Intial allocation + realloc if overflow
}
```


| Operation          | C++ (std::vector)           | Python (list)       | Java (ArrayList)        |
|--------------------|-----------------------------|---------------------|-------------------------|
| Type Definition    | `std::vector<int>`          | `list = []`         | `ArrayList<Integer>`    |
| Append             | `push_back(element)`        | `append(element)`   | `add(element)`          |
| Access             | `vec[i]`                    | `list[i]`           | `get(i)`                |
| Delete (end)       | `pop_back()`                | `pop()`             | `remove(index)`         |
| Resize             | Automatic (O(n))            | Automatic (O(n))    | Automatic (O(n))        |
| Insertion (at end) | O(1) amortized              | O(1) amortized      | O(1) amortized          |
| Deletion (shift)   | O(n)                        | O(n)                | O(n)                    |

## Linked Lists

**Non contiguous memory + O(1) insertion**

- https://en.wikipedia.org/wiki/Linked_list
- https://www.cs.princeton.edu/courses/archive/spr11/cos217/lectures/08DsAlg.pdf
- https://www.geeksforgeeks.org/python-linked-list/

```c
struct Node{
	T data
	struct Node *next;	// Node which follows (non contiguous)
};

struct Table{
	struct Node *first;
};
```

| Operation | Python (Custom) | C++ (std::list) | Java (LinkedList) |
|----------|---------------|----------------|------------------|
| Create List | `list = LinkedList()` | `std::list<T> list` | `LinkedList<T> list` |
| Add First | `insert_at_begin(data)` | `push_front(element)` | `addFirst(element)` |
| Add Last | `insert_at_end(data)` | `push_back(element)` | `addLast(element)` |
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

## Stack

```c
struct stack{
	int stack[N];
	int top;
};
```

## Algorithms

### Graphs

- Djikstra
- A*
