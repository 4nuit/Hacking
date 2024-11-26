## Reminders

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
