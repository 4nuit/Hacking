# Prerequisites

- [Prog - asm](../prog/asm_emulation)
- [Linux](../linux)

## Doc

- https://tmpout.sh
- https://doar-e.github.io/
- https://blog.quarkslab.com/
- https://github.com/michalmalik/
- https://practicalbinaryanalysis.com/
- https://github.com/antire-book/antire_book/
- https://github.com/wtsxDev/reverse-engineering
- https://github.com/mohitmishra786/underTheHoodOfExecutables/
- https://github.com/yellowbyte/reverse-engineering-reference-manual
- https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
- https://bbinfosec.medium.com/reverse-engineering-resources-beginners-to-intermediate-guide-links-f64c207505ed
- https://m.youtube.com/c/oalabs
- https://www.youtube.com/@StephenChapman


## Courses

- https://p.ost2.fyi/
- https://class.malware.re/
- https://0xinfection.xyz/reversing/
- https://ligerlabs.org/lectures.html
- https://malwareunicorn.org/workshops/re101.html
- https://en.wikibooks.org/wiki/Subject:Assembly_languages

### Tutorials

- https://reverse.zip/
- https://how2rev.github.io/
- https://reverseengineering.stackexchange.com/
- https://forum.tuts4you.com/files/file/1307-lenas-reversing-for-newbies/
- https://www.slideshare.net/AmandaRousseau1/what-can-reverse-engineering-do-for-you
- https://zestedesavoir.com/articles/97/introduction-a-la-retroingenierie-de-binaires/


## Cheatsheets

- [All tools - Reversing bits](https://github.com/mohitmishra786/reversingBits/tree/main/src)
- [ELF Format Cheatsheet](https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779)
- https://github.com/tmpout/awesome-elf
- https://github.com/jakespringer/angr_ctf
- https://github.com/aemmitt-ns/radius2-examples

### Specific reversing

- [Language specific RE](./language_specific/) - Entry points, bytecode, obfuscation by language
- [Operating specific RE (ELF/PE/Mach-O)](./os_specific) - Techniques & tools specific to OS.
  - [Emulation notes (ELF/Linux) for architecture dependant binaries](../linux/emulation)


## Challenges

- http://3564020356.org/
- https://crackmes.one/
- http://reversing.kr/
- https://www.root-me.org/fr/Challenges/Cracking/
- https://pwn.college/intro-to-cybersecurity/reverse-engineering/


## Tools

### IDA/Ghidra plugins

- https://decompilation.wiki/
- https://github.com/bootleg/ret-sync
- https://github.com/nccgroup/Cartographer
- https://vmallet.github.io/ida-plugins/
- https://github.com/polymorf/findcrypt-yara
- https://github.com/AllsafeCyberSecurity/awesome-ghidra
- https://github.com/fr0gger/awesome-ida-x64-olly-plugin
- https://blog.trailofbits.com/2024/02/07/binary-type-inference-in-ghidra/

### Malware VM

- https://docs.remnux.org/
- https://cloud.google.com/blog/topics/threat-intelligence/flare-vm-the-windows-malware?hl=en

### General tools

- [Angr](https://github.com/angr/angr)
- [Bap](https://github.com/BinaryAnalysisPlatform)
- [Binary Ninja ](https://binary.ninja/) (**x86/64 asm**, **armv7**) 
- [Binsec](https://github.com/binsec/binsec)
- [Capstone](https://github.com/capstone-engine/capstone)
- [Detect it Easy](https://github.com/horsicq/Detect-It-Easy)
- [Ghidra - latest release](https://github.com/NationalSecurityAgency/ghidra/releases) (**x86/64 C**, **arm32**, **mips** -> other arch)
- [Hexedit](https://hexed.it/)
- [IDA](https://my.hex-rays.com/download-center)
- [Lief](https://lief-project.github.io)
- [Manticore](https://github.com/trailofbits/manticore)
- [Mobsf](https://mobsf.live/)
- [OFRAK](https://ofrak.com/)
- [Pintool2](https://www.aldeid.com/wiki/Pintool2)
- [QEMU](https://www.qemu.org/docs/master/about/index.html)
- [R2 - radius2](https://github.com/aemmitt-ns/radius2)
- [Radare2 dbg](https://github.com/radareorg/radare2)
- [UPX Unpacker](https://github.com/NozomiNetworks/upx-recovery-tool)
- [Z3](https://theory.stanford.edu/~nikolaj/programmingz3.html)


## Compilation

### General references

- https://craftinginterpreters.com/
- https://godbolt.org/ (Compiler Explorer)
- https://gcc.gnu.org/onlinedocs/
- https://llvm.org/docs/
- https://wiki.osdev.org/
- https://en.wikipedia.org/wiki/Compiler

### Parsing AST

- [ast_parsing](../prog/ast_parsing)
- https://craftinginterpreters.com/
- https://en.wikipedia.org/wiki/Abstract_syntax_tree

### Intermediate Representation

- https://llvm.org/docs/LangRef.html
- https://bernsteinbear.com/assets/img/ssa-book.pdf
- https://en.wikipedia.org/wiki/Static_single-assignment_form
- https://en.wikipedia.org/wiki/Constant_folding
- https://en.wikipedia.org/wiki/Compiler_optimization

### Assembling 
  
- [helloworld_x86_64.s](../prog/asm_emulation/helloworld_x86_64.s)
- https://godbolt.org/ # compiler explorer
- https://en.wikibooks.org/wiki/X86_Disassembly

```bash
# syntax analysis
gcc test.c -fsyntax-only

# preprocesser and assembler (gcc)
cpp hello.c > hello_preprocessed.c
gcc -S -masm=intel hello_preprocessed.c
```

### Object files

- https://wiki.osdev.org/ELF
- https://learn.microsoft.com/windows/win32/debug/pe-format

```bash
# compiling into ELF and removing symbols (data)
gcc -o hello hello_preprocessed.s
strip hello
```

### Linker

- https://en.wikipedia.org/wiki/Linker_(computing)
- https://www.geeksforgeeks.org/operating-systems/difference-between-linker-and-loader/


```bash
# assembler and linker
nasm -f elf32 -o helloworld_x86.o helloworld_x86.s
ld -m elf_i386 -o helloworld_x86 helloworld_x86.o
```

### Loaders

- https://en.wikipedia.org/wiki/Loader_(computing)
- https://freecomputerbooks.com/Linkers-and-Loaders.html


## Data types , Endianness & Padding

- https://en.wikipedia.org/wiki/C_data_types
- https://docs.python.org/3/library/struct.html
- https://en.wikipedia.org/wiki/Word_(computer_architecture)
- https://en.wikipedia.org/wiki/ANSI_escape_code

```py
a, b, c, d = 1, 2, 4, 8

# int.to_bytes(length, byteorder) - length is the byte-count, not the value being packed
a.to_bytes(1,"little") # b'\x01'                                = 1 byte (8 bits) (register bl)
b.to_bytes(2,"little") # b'\x02\x00'                            = 2 bytes = 1 word (register bx)
c.to_bytes(4,"little") # b'\x04\x00\x00\x00'                    = 4 bytes = 1 dword (register ebx)
d.to_bytes(8,"little") # b'\x08\x00\x00\x00\x00\x00\x00\x00'    = 8 bytes = 1 qword (register rbx)
```

```py
import struct

struct.pack("<bhiq",1,2,4,8) #b'\x01\x02\x00\x04\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00' (little endian)
struct.pack(">bhiq",1,2,4,8) #b'\x01\x00\x02\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x08' (big endian)

struct.calcsize('>bhl') # 7
```

```py
import struct

packed = []
for i in range(0, len(codes), 8):
  chunk = codes[i:i+8]
  val = struct.unpack('<H', bytes([chunk[0], chunk[1]]))[0]
  packed.append(val)
  
#codes =  [codes[i] | (codes[i+1] << 8) for i in range(0, len(codes), 8)]
```

### Using bits

- [bit_utilities](./bit_utilities.py)
- [bitwise operations & optimizations](../prog/regexp_and_bits)

| Pattern(s)                               | Meaning / Reverse Insight                                                          |
| ---------------------------------------- | ---------------------------------------------------------------------------------- |
| `b0 \| (b1<<8)` ≡ `b0 + (b1<<8)`         | byte packing (little-endian); `\|` and `+` are equivalent when bytes don’t overlap |
| `b0 \| (b1<<8) \| (b2<<16) \| (b3<<24)`  | reconstruct 32-bit little-endian value                                             |
| `x & 0xff` ≡ `(byte)x` ≡ `LOBYTE(x)`     | truncate/extract low byte                                                          |
| `x & 0xffff` ≡ `(ushort)x` ≡ `LOWORD(x)` | truncate/extract low 16 bits                                                       |
| `(x>>8)&0xff` ≡ `HIBYTE(x)`              | extract middle byte                                                                |
| `(x>>16)&0xffff` ≡ `HIWORD(x)`           | extract upper word                                                                 |
| `~x`                                     | bitwise NOT; useful identity: `~x = -x-1`                                          |
| `x ^ k = y`                              | XOR is self-reversible → `x = y ^ k`                                               |
| `x & 0x7fffffff`                         | clear sign bit / signedness cleanup                                                |
| `~(a + (b<<8))`                          | invert packed little-endian word                                                   |


## Asm , Segmentation, Offset , Addressing Modes & Calling Convention (Saved Registers)

- https://www.developpez.net/forums/d1497/autres-langages/assembleur/qu-qu-offset/
- https://beuss.developpez.com/tutoriels/pcasm/
- https://zestedesavoir.com/articles/130/programmez-en-langage-dassemblage-sous-linux/
- https://drive.google.com/drive/folders/16FnbMmbfreb2SJX0px-5ce5KFq0Pjd1M
- https://beta.hackndo.com/assembly-basics/
- https://beta.hackndo.com/conventions-d-appel/

```
--------------------------------------------------------
|            |  x86  | amd64 | arm    | aarch64 | mips |
--------------------------------------------------------
|syscall num |  eax  | rax   | r7     |   x8   |  v0   |
--------------------------------------------------------
|   1st arg  |[eax+4]| rdi   | r0     |   x0   |  a0   |
--------------------------------------------------------
|   2nd arg  |[eax+8]| rsi   | r1     |   x1   |  a1   |
--------------------------------------------------------
|    call    |int0x80| call  | lr(r14)|   lr   |syscall|
--------------------------------------------------------
|  func ret  |  eax  | rax   | r0     |   x0   | v0,v1 |
--------------------------------------------------------
|instruct pt |  eip  | rip   | pc(r15)|   pc   |pc*(ra)|
--------------------------------------------------------
|  stack pt  |  esp  | rsp   | sp(r13)|   sp   |  sp   |
--------------------------------------------------------
|  frame pt  |  ebp  | rbp   | fp(r11)|   fp   |  fp   |
--------------------------------------------------------
|  mem load  |  mov  | mov   | ldr    |   ldr  | li,lw |
--------------------------------------------------------
|  mem store |  mov  | mov   | str    |  str |sb,sh,sw |
--------------------------------------------------------
```

`*` unlike the other columns, MIPS's PC is **not** a general-purpose register: it can't be named as an instruction operand or read/written directly from user mode. GDB exposes a synthesized "pc" pseudo-register for convenience, but there's no `$pc` in the real 32-entry GPR file - the actual mechanism to get an instruction's own address is `bal`/`jal` (which write the *next* instruction's address into `$ra` (saved program counter inside a call)), not a readable PC register.
 
 - **Cheatsheets**:
	- [Felix Cloutier - Intel x86](https://www.felixcloutier.com/x86/)
	- [ARM - Azeria](https://azeria-labs.com/writing-arm-assembly-part-1/)
	- [MIPS](https://www.kth.se/social/files/54948c82f276540590491ed4/mips-ref-cheat-sheet.pdf)

### Memory course - x86

- [Comparing Modern x86 and ARM Assembly Language](https://www.cs.uaf.edu/2011/spring/cs641/lecture/02_10_assembly.html)
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html
- https://stackoverflow.com/questions/9268586/what-are-callee-and-caller-saved-registers

#### 32 vs 64 bits calling conventions

- https://syscall.sh
- https://syscalls.mebeim.net/
- https://beta.hackndo.com/conventions-d-appel/
- https://n-pn.fr/t/2431-la-pile-en-assembleur-x86

#### Disassembling (x86/x86_64

- [UD2 bug / false disassembling](https://github.com/NationalSecurityAgency/ghidra/issues/4113)
- https://en.wikibooks.org/wiki/X86_Disassembly

**Xor**

```asm
;mov r1, r2
xor r1, r1
xor r1, r2
```

**Rep**

```asm
;rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
memcpy(*edi, *esi, sizeof(*esi))
```


## Decompilation

- https://github.com/icsharpcode/AvaloniaILSpy # .NET decompiler for linux
- https://blog.ret2.io/2017/11/16/dangers-of-the-decompiler/

### Ghidra 

- https://www.ghidrabook.com/
- https://scrapco.de/ghidra-cheat-sheet/
- https://www.retroreversing.com/intro-decompiling-with-ghidra
- force decompilation using `CTRL-A` on ASM code -> click `D` or `CTRL-D`. clear code bytes: `CTRL-C`.
- search **namespaces** in `Symbol Tree` -> `Filter`
- use `Window` for strings, graphs etc
- push `G` to **seek code on given address** (IDA , Ghidra) 

**Auto Create struct**

- `SHIFT+[`

**Copy Data to Python List**

- `CTRL-A|C` on DATA, Right click -> `Copy Special` -> `Python List`

**Patch**

- `CTRL+SHIFT+G` / Right click -> Patch

**Scripts**

- https://github.com/mandiant/Ghidrathon                                              # Add Python3 scripting to Ghidra (Extension for scripts, deprecated)
- https://github.com/HackOvert/GhidraSnippets
- https://www.ghidradocs.com/12.0.4_PUBLIC/Ghidra/Features/PyGhidra/pypkg/README.html # Python library that provides direct access to the Ghidra API  (locally)
- Set the JVM if using Java scripts (`archlinux-java status`). Check for the latest release, then check for issues
- Click `Script Manager`(green arrow) -> `New Script` -> Java (stored in `~/ghidra_scripts`), then use it with `Scripts`

run in `~/ghidra_12.0.4_PUBLIC/support`:
  - `pyghidraRun` (**enables Python support with PyGhidra inside of Ghidra**) using `~/.config/ghidra/ghidra_12.0.4_PUBLIC/venv/bin/python3` interpreter (`-m install capstone unicorn`)
  - `analyzeHeadless` & others

in `~/ghidra_12.0.4_PUBLIC/support/launch.properties` (optional):

```bash
# Use Java 21 specifically for scripts (example)
JAVA_HOME_OVERRIDE=/usr/lib/jvm/java-21-openjdk
```

**Plugins**

- `File` -> `Install Extension` -> `+`
- Check it is enabled with `File` -> `Configure` -> `Miscellaneous|Developer` -> Configure box (Codebrowser)

### IDA

- https://hexrays.su/   # Pro, cracked, always check for malware & dont promote it
- https://rutracker.org/forum/viewtopic.php?t=6742225 # Windows
- [IDA Pro Book](https://ia601005.us.archive.org/35/items/allitebooks-01/The%20IDA%20Pro%20Book%2C%202nd%20edition.pdf)
- https://malwareunicorn.org/workshops/idacheatsheet.html
- https://docs.hex-rays.com/developer-guide/idc/core-concepts
- force decompilation using `F5` (in a function), `CTRL+F5` (create a pseudo code of the whole, without XREF)
- `tab` to switch between pseudo code and CFG
- push `G` to **seek code on given address** (IDA , Ghidra) 

**Scripts**

- `File` -> `Script File`
- [IDA - Parsing CTF example](https://www.aperikube.fr/docs/breizhctf_2018/multiplat/)
- https://sark.readthedocs.io/en/latest/api/tutorial-conventions.html

**Plugins**

- `Edit` -> `Plugins`
- loaders are located in `~/idapro-*/loaders/` (install dir) and `~/.idapro/loaders` (user dir)
- plugins are located in `~/idapro-*/plugins` (install dir) and `~/.idapro/plugins` (user dir)
- https://python.docs.hex-rays.com/namespaceida__loader.html
- https://github.com/HexRaysSA/ida-sdk/blob/main/src/plugins/idapython/BUILDING.md

```bash
# update python interpreter

### build a venv / must be compatible with idapro version
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.11.9
ls ~/.pyenv/versions/3.11.9/lib/libpython3.11.so* 

### or reuse another
cat ~/.pyenv/versions/<venv-name>/pyvenv.cfg 

## point IDA's registry at the shared library backing the interpreter
~/idapro-9.0/idapyswitch -v -s /path/to/libpythonX.Y.so

## tell IDA to detect the venv
### in ~/.bashrc
export PYTHONEXECUTABLE=~/.pyenv/versions/<venv-name>/bin/python3
### in ~/.local/share/applications/IDA.desktop (GUI)
Exec=env PYTHONEXECUTABLE=... ~/idapro-9.0/ida64

## pin the venv and check headless
cd ~/idapro-9.0; pyenv local <venv-name>
TVHEADLESS=1 ./idat64 -A -S/path/to/check.py /path/to/some/binary

## install packages
~/.pyenv/versions/<version-or-venv-name>/bin/pip install <package>

# pip install angr yara-python git+https://github.com/mrexodia/ida-pro-mcp
```

```python
# inside of IDAPython
Python>import sys
print(sys.executable)
/home/user/.pyenv/shims/python3
```

[see reversing crypto using IDA](./reversing_crypto)


### Anti Debug

#### Linux

- https://github.com/ariary/Hack-weak-strcmp-code
- https://github.com/ariary/simple_anti-debug_and_simple_bypasss
- https://t-a-w.blogspot.com/2007/03/how-to-code-debuggers.html

#### Windows

- https://revers.engineering/applied-re-exceptions/
- https://fr.wikipedia.org/wiki/Interrupt_Descriptor_Table
- https://anti-reversing.com/Downloads/Anti-Reversing/The_Ultimate_Anti-Reversing_Reference.pdf


### Automation: Disassembling, Parsing, General Frameworks

- https://www.capstone-engine.org/lang_python.html
- https://www.0ffset.net/reverse-engineering/capstone-resolving-stack-strings/
- [Pintol - Instrumentation CTF example](https://github.com/mattfeng/hsf/tree/master/2016/isengard_fixed)
- https://github.com/JonathanSalwan/Triton
- https://github.com/cea-sec/miasm  # General

#### Equations / Keygen solver - z3

- `z3`: https://theory.stanford.edu/~nikolaj/programmingz3.html
- https://github.com/SuperStormer/pyasm
- https://github.com/TCP1P/TCP1P-CTF-2023-Challenges/blob/main/Reverse%20Engineering/Take%20some%20Byte/writeup/solver.py

modele:

```python
import z3

s = z3.Solver()
input_vec = [z3.BitVec(f'input{i}',8) for i in range(LEN_FLAG)]

for i in range(len(SYSTEM_COEFFS)):
  s.add(CONSTRAINT(input_vec,SYSTEM_COEFFS))

print(sat = s.check())
if sat == z3.sat:
  m = s.model()
  print(''.join([chr(m[input_vec[i]].as_long()) for i in range(LEN_FLAG)]))
```

#### Angr (cf z3)

Typical example: solving a crackme given 2 addresses (**find**, **avoid**)
(by exploring each CFG and solving a system of constraints)

![angr](./angr_basique.py)

- https://shoxxdj.fr/angr-basics/
- https://github.com/jakespringer/angr_ctf
- https://github.com/angr/angr-doc/blob/master/CHEATSHEET.md


### Obfuscation

#### Movfuscator

- https://github.com/xoreaxeaxeax/movfuscator
- https://github.com/xoreaxeaxeax/movfuscator

#### Mixed Boolean Arithmetic

- [mba with binsec](./automated_black_box_analysis_binsec/)
- https://blog.trailofbits.com/2026/04/03/simplifying-mba-obfuscation-with-cobra/

#### CFG Obfuscation

- https://tigress.wtf/introduction.html
- https://blog.es3n1n.eu/posts/obfuscator-pt-1/
- https://nicolo.dev/en/blog/role-control-flow-graph-static-analysis/
- https://polarply.medium.com/build-your-first-llvm-obfuscator-80d16583392b


### Packers

- https://vmpsoft.com/
- https://www.oreans.com/Themida.php
- https://tigress.wtf/introduction.html
- https://mkaring.github.io/ConfuserEx/
- https://reverseengineering.stackexchange.com/questions/72/unpacking-binaries-in-a-generic-way
- https://reverseengineering.stackexchange.com/questions/3184/packers-protectors-for-linux
