
## Cheatsheets

- https://ihateregex.io
- https://regex101.com

## Regexp

```py
import re

strings_to_match = [
    "toto",
    "foo",
    "bar",
    "pouet1",
    "pouet2",
    "root",
    "toor"
]

def regex_v1():
    reg = re.compile(r"pouet")
    for s in strings_to_match:
       if reg.match(s):
           print(f"Match: {s}")

def regex_v2():
    for s in strings_to_match:
       if re.match(r"pouet", s):
           print(f"Match: {s}")
```

## Compile: n operations vs 2n with match

First we need to find the difference between these 2 pieces of code: in one, we compile the regex at the start and then match using that compiled regex.
In the second, we match the pattern and string directly without compiling beforehand.

To really understand how it works, we can look at the code of the ``re`` library (https://github.com/blackberry/Python/blob/master/Python-3/Lib/re.py)

- here's the codeflow of ``re.match``:
```py
def match(pattern, string, flags=0):
    """Try to apply the pattern at the start of the string, returning
    a match object, or None if no match was found."""
    return _compile(pattern, flags).match(string)

# ...
def _compile(pattern, flags):
    return _compile_typed(type(pattern), pattern, flags)
# ...
def _compile_typed(text_bytes_type, pattern, flags):
    # about ten lines of code we don't care about
    return sre_compile.compile(pattern, flags) # The code of sre_compile.compile just parses the regex, so it's kind of useless to read

```
We can therefore conclude that ``_compile(pattern, flags)`` returns a compiled regex object (hence the fairly explicit name).
Basically, `re.match` generates a compiled regex object and then applies the match method on it.

**Important nuance**: `_compile()` is not a simple wrapper, it's a **cached** function (`_cache` dict, key = `(type, pattern, flags)`, see [`Lib/re/__init__.py`](https://github.com/python/cpython/blob/main/Lib/re/__init__.py)). So `re.match(pattern, s)` called `n` times with the **same pattern** does *not* recompile `n` times: only the 1st call actually compiles, the following ones hit the cache. The "n vs 2n operations" difference therefore only holds for a cache miss (1st call, or too many distinct patterns for the cache size) - not for a loop over the same pattern like in `regex_v2()` above. Explicit `re.compile()` remains preferable (avoids the cache lookup + handles the case where the pattern changes), but the real performance gap is much smaller than "compiling = n fewer operations".

- https://docs.python.org/3/library/re.html#re.compile
