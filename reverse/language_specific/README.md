## Language Specific Reverse Engineering

### Entry Points by Language

| Language | Entry Point | Runtime Init | Notes |
|----------|-------------|--------------|-------|
| **C** | `main` | `__libc_start_main` | Standard |
| **C++** | `main` | `__libc_start_main` + constructors | Mangled: `_Z*` |
| **Rust** | `<crate>::main` → `entrypoint` | `std::rt::lang_start` | Module prefix |
| **Go** | `main.main` | `runtime·rt0_go` | `main_*` symbols |
| **Java** | `Class.main()` | `JNI_CreateJavaVM` | Bytecode |
| **.NET** | `Namespace.Class.Main` | `_CorExeMain` | IL metadata |
| **Python** | `<module>` | `Py_Main` | Bytecode/.pyc |
| **Swift** | `<Module>.main` | `swift_main` | Mangled: `_$s*` |

---

### C/C++

```
_start → __libc_start_main → main
```

**Finding user code:**
```bash
nm binary | grep " T main"
strings binary | grep -iE "error|usage|help"
```

**C++ specific:**
```bash
nm binary | c++filt | grep "main"
# Constructors run before main: .init_array
```

**References:**
- https://ptr-yudai.hatenablog.com/entry/2021/11/30/235732 # C++ smart pointers

#### Debugging

- [gdb-gef](https://github.com/bata24/gef)

---

### Rust

```
_start → std::rt::lang_start → <crate>::main → <crate>::entrypoint
```

**Finding user code:**
```bash
nm binary | grep "<crate>::"
grep -n "::entrypoint\|::main" binary.c
```

**Key locations in decompiled code:**
- `<crate>::main` (line ~4750) - wrapper
- `<crate>::entrypoint` (line ~5122) - actual logic

**Patterns:**
- Module naming: `<crate>::<function>`
- Strings: `qmemcpy(v, "string", len)`
- Crypto: `md5::compress::compress()`

**References:**
- https://www.eventhelix.com/rust/
- https://lockpin010.medium.com/comparative-analysis-reversing-rust-and-c-binaries-aa9e4b472539
- https://github.com/DMaroo/GhidRust # Ghidra plugin

#### Debugging 

- [rust-gdb tuto](https://michaelwoerister.github.io/2015/03/27/rust-xxdb.html)
- https://rustc-dev-guide.rust-lang.org/debugging-support-in-rustc.html

---

### Go

```
_start → runtime·rt0_go → runtime·main → main.main
```

**Finding user code:**
```bash
nm binary | grep " T main\."
# Symbols: main_main, main_Handler, main_init
```

**Go-specific:**
- Rich symbol tables
- Goroutines: `runtime·goroutine`
- Strings: length prefix in `.rodata`

**References:**
- [GoLang RE Resources/Links](https://gist.github.com/alexander-hanel/59af86b0154df44a2c9cebfba4996073)

---

### Python

**Finding user code:**
```bash
# Frozen executables (PyInstaller)
pyinstxtractor.py frozen_app.exe

# Decompile .pyc
uncompyle6 script.pyc
~/pycdc/build/pycdc chall.pyc

# Bytecode disassembly
~/pycdc/build/pycdas chall.pyc
```

**References:**
- https://github.com/Svenskithesource/awesome-python-re
- https://github.com/SuperStormer/pyasm
- [pycdc](https://github.com/zrax/pycdc)
- [pyinstxtractor](https://github.com/extremecoders-re/pyinstxtractor)
- https://github.com/KhanhNguyen9872/deobf_pyobfuscate.com
- https://www.bravegnu.org/blog/python-byte-code-hacks.html
- https://reverseengineering.stackexchange.com/questions/1999/what-are-the-tools-to-analyze-python-obfuscated-bytecode

#### Debugging

- [Pdb](https://docs.python.org/3/library/pdb.html)
- [Pdb++](https://github.com/pdbpp/pdbpp)

---

### Java

**Tools:** `jadx`, `javap`, `jd-gui`

**Finding user code:**
```bash
# Find main class
unzip -p app.jar META-INF/MANIFEST.MF | grep Main-Class
javap -c ClassName.class
```

---

### .NET

**Tools:** `dnSpy`, `ILSpy`, `dotPeek`, `ildasm`

**Finding user code:**
```bash
ildasm /text app.exe
```

**References:**
- https://fr.wikipedia.org/wiki/Common_Intermediate_Language

---

### Swift

```
_start → swift_main → <Module>.main
```

**Finding user code:**
```bash
swift-demangle <mangled_name>
nm binary | grep "_\$s"  # Swift mangling prefix
```

---

### Android

**Tools:** `jadx`, `apktool`, `adb`

---

### Bytecode & Obfuscation

**Python:**
```bash
# Pseudo code (may not work)
~/pycdc/build/pycdc chall.pyc

# Bytecode
~/pycdc/build/pycdas chall.pyc
```

**References:**
- https://github.com/h311d1n3r/Cerberus # Rust obfuscation
- https://github.com/apoirrier/CTFs-writeups/?tab=readme-ov-file#games

---

### General Language Resources

- https://github.com/apoirrier/CTFs-writeups/?tab=readme-ov-file#games
