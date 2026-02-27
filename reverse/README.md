## Doc

- https://practicalbinaryanalysis.com/
- https://0xinfection.github.io/reversing/
- https://github.com/antire-book/antire_book/
- https://github.com/mohitmishra786/underTheHoodOfExecutables/
- https://github.com/yellowbyte/reverse-engineering-reference-manual

### Courses

- https://p.ost2.fyi/
- https://reverse.zip/
- https://how2rev.github.io/
- https://class.malware.re/
- https://ligerlabs.org/lectures.html

### Cheatsheets

- [All tools - Reversing bits](https://github.com/mohitmishra786/reversingBits/tree/main/src)
- [ELF Format Cheatsheet](https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779)
- https://github.com/tmpout/awesome-elf
- https://github.com/jakespringer/angr_ctf
- https://github.com/aemmitt-ns/radius2-examples

#### Language specific

- [Language specific RE](./language_specific/) - Entry points, bytecode, obfuscation by language

### Beginning & References

- https://tmpout.sh
- https://www.youtube.com/@StephenChapman
- https://m.youtube.com/c/oalabs
- https://blog.quarkslab.com/
- https://www.slideshare.net/AmandaRousseau1/what-can-reverse-engineering-do-for-you
- https://forum.tuts4you.com/files/file/1307-lenas-reversing-for-newbies/
- [Plateforme Crackme.one](https://crackmes.one)
- https://github.com/wtsxDev/reverse-engineering
- https://github.com/JonathanSalwan/Triton
- https://github.com/michalmalik/linux-re-101
- https://github.com/michalmalik/osx-re-101

## Challenges

- http://3564020356.org/
- https://crackmes.one/
- http://reversing.kr/
- https://www.root-me.org/fr/Challenges/Cracking/

## Tools

### IDA/Ghidra plugins

- https://decompilation.wiki/
- https://github.com/nccgroup/Cartographer
- https://github.com/fr0gger/awesome-ida-x64-olly-plugin
- https://blog.trailofbits.com/2024/02/07/binary-type-inference-in-ghidra/

### Malware VM

- https://docs.remnux.org/
- https://cloud.google.com/blog/topics/threat-intelligence/flare-vm-the-windows-malware?hl=en

### General stuff

- https://bbinfosec.medium.com/reverse-engineering-resources-beginners-to-intermediate-guide-links-f64c207505ed
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
- [UPX Unpacker](https://github.com/NozomiNetworks/upx-recovery-tool)
- [Z3](https://theory.stanford.edu/~nikolaj/programmingz3.html)


## Basics

- https://reverse.zip
- https://pwn.college/intro-to-cybersecurity/reverse-engineering/

### Compilation

```c
cpp hello.c > hello_preprocessed.c
gcc -S -masm=intel hello_preprocessed.c
gcc -o hello hello_preprocessed.s
strip hello
```

#### Hello world (x86,x64,arm32,aarch64)

Voir `../prog`:

[helloworld_x86_64.s](../prog/asm_emulation/helloworld_x86_64.s)

```bash
nasm -f elf32 -o helloworld_x86.o helloworld_x86.s
ld -m elf_i386 -o helloworld_x86 helloworld_x86.o
```

#### ARM like basic comparison

- https://github.com/4nuit/Writeup/tree/master/2023/FCSC/intro/comparaison


### Data types , Endianness & Padding

- https://en.wikipedia.org/wiki/C_data_types
- https://docs.python.org/3/library/struct.html
- https://en.wikipedia.org/wiki/Word_(computer_architecture)
- https://en.wikipedia.org/wiki/ANSI_escape_code

```py
a, b, c, d = 1, 2, 4, 8

a.to_bytes(1,"little") # b'\x01'                                = 1 byte (8 bits) (register bl)
b.to_bytes(b,"little") # b'\x02\x00'                            = 2 bytes = 1 word (register bx)
c.to_bytes(c,"little") # b'\x04\x00\x00\x00'                    = 4 bytes = 1 dword (register ebx)
d.to_bytes(d,"little") # b'\x08\x00\x00\x00\x00\x00\x00\x00'    = 8 bytes = 1 qword (register rbx)
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

### Asm , Segmentation, Offset , Addressing Modes & Calling Convention (Saved Registers)

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
| ret val reg|  eax  | rax   | r7     |   x8   |  ra   |
--------------------------------------------------------
|   1st arg  |[eax+4]| rdi   | r0     |   x0   |  a0   |
--------------------------------------------------------
|   2nd arg  |[eax+8]| rsi   | r1     |   x1   |  a1   |
--------------------------------------------------------
|    call    |int0x80| call  | lr(r14)|   lr   |syscall|
--------------------------------------------------------
|  func ret  |  eax  | rax   | r0     |   x0   | v0,v1 |
--------------------------------------------------------
|  IP / PC   |  eip  | rip   | pc(r15)|   pc   |  pc   |
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
 
 - **Cheatsheets**:
	- [Felix Cloutier - Intel x86](https://www.felixcloutier.com/x86/)
	- [ARM - Azeria](https://azeria-labs.com/writing-arm-assembly-part-1/)
	- [MIPS](https://www.kth.se/social/files/54948c82f276540590491ed4/mips-ref-cheat-sheet.pdf)

### ELF Format 

- [ELF Format Cheatsheet](https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779)
- https://github.com/michalmalik/linux-re-101
- https://reverse.zip/posts/introduction_au_reverse_partie_3/
- https://intezer.com/blog/executable-linkable-format-101-part-2-symbols/
- https://intezer.com/blog/executable-linkable-format-101-part-2-symbols/

#### ELF Magic numbers

- [How programs get run - lwn.net](https://lwn.net/Articles/631631/)
- https://docs.pwntools.com/en/stable/elf/elf.html
- https://eli.thegreenplace.net/2012/08/13/how-statically-linked-programs-run-on-linux

```txt
| Context                    | Magic Number Address |
| -------------------------- | -------------------- |
| File offset                | `0x00`               |
| In-memory (64-bit, no PIE) | `0x400000`           |
| In-memory (32-bit, no PIE) | `0x08048000`         |
```

- **Program Headers** = `INTERP`, `LOAD` (**PT_LOAD = mapping of the base address of the CODE**)
- **Section Headers** = `.text`, `.plt` & `.got`, `.data` & `.rodata`, `.bss`, `GNU_STACK`

![](./images/segmentation.gif)

```bash
readelf -l /bin/cat
readelf -a /bin/cat | grep interpret
```

### Memory course - x86

- [Comparing Modern x86 and ARM Assembly Language](https://www.cs.uaf.edu/2011/spring/cs641/lecture/02_10_assembly.html)
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html
- https://stackoverflow.com/questions/9268586/what-are-callee-and-caller-saved-registers

### 32 vs 64 bits calling conventions

- https://syscall.sh
- https://syscalls.mebeim.net/
- https://beta.hackndo.com/conventions-d-appel/


### Tips x86

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

## ELF / Linux (x86-amd64 examples)

- [Language specific RE](./language_specific/) - Entry points, bytecode, obfuscation by language
- https://en.wikipedia.org/wiki/Name_mangling   # compact args and signature for overloaded C++ methods
- https://www.man7.org/linux/man-pages/man1/c++filt.1.html
- https://en.wikipedia.org/wiki/Constant_folding
- https://m101.github.io/binholic/2017/05/20/notes-on-abusing-exit-handlers.html
- https://zestedesavoir.com/articles/97/introduction-a-la-retroingenierie-de-binaires/
- https://linux-audit.com/elf-binaries-on-linux-understanding-and-analysis/
- https://0xdarkvortex.dev/ground-zero-part-1-reverse-engineering-basics/
- https://blog.0x972.info/?d=2014/11/13/10/40/50-how-does-a-debugger-work

Tools classiques:

- `objdump -d <binary> -M intel`:
  - `-t` : afficher la table des symboles
  - `-h`: afficher les sections
  - `R` : la global offset table

- `ltrace -i --demangle`: voir les fonctions de la libc appelées

```bash
#fin de chaine -> \0
ltrace -s 128 
```

- `nm -D --demangle`: parse la table des symboles (dynamique)
- `ldd`: voir les bibliothèques/libc utilisées, `LD_SHOW_AUXV=1 ./bin`
- `lsof`: voir l'etat, sockets d'un processus en memoire
- `pidof`: voir pid binaire
- `strace`
	- `-fxi`
	- `-e trace=read,write`
	- `-E LD_PRELOAD=preload.so`
- `Ghidra`
- `ILSpy (.NET)`: https://github.com/icsharpcode/AvaloniaILSpy


### Decompilation

- https://blog.ret2.io/2017/11/16/dangers-of-the-decompiler/

#### Ghidra 

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

#### IDA

- https://hexrays.su/   # Pro, cracked, always check for malware & dont promote it
- https://rutracker.org/forum/viewtopic.php?t=6742225 # Windows
- [IDA Pro Book](https://ia601005.us.archive.org/35/items/allitebooks-01/The%20IDA%20Pro%20Book%2C%202nd%20edition.pdf)
- https://malwareunicorn.org/workshops/idacheatsheet.html
- https://docs.hex-rays.com/developer-guide/idc/core-concepts
- force decompilation using `F5` (in a function), `CTRL+F5` (create a pseudo code of the whole, without XREF)
- `tab` to switch between pseudo code and CFG
- push `G` to **seek code on given address** (IDA , Ghidra) 

[see reversing crypto using IDA](./reversing_crypto)

### Debuggers

- `gdb-gef`: [gef](https://github.com/hugsy/gef)  # Linux
- `r2`: https://github.com/radareorg/radare2

```bash
alias pwndbg='gdb -x ~/pwndbg/gdbinit.py -q '
alias gef='gdb -x ~/.gdbinit-gef.py -q '
alias gdb-peda='gdb -x ~/peda/peda.py'
```

```bash
gef➤  info functions
All defined functions:

Non-debugging symbols:
...
0x0000000000400520  strcmp@plt
...
gef➤  b *0x0000000000400520
Breakpoint 1 at 0x400520
gef➤  r toto
```

### Start - x86

- [UD2 bug](https://github.com/NationalSecurityAgency/ghidra/issues/4113)
- https://n-pn.fr/t/2431-la-pile-en-assembleur-x86

#### Function call

```bash
starti
jump *0x... #addresse print_flag()
```

or

```bash
b *main
r
p *(char) printFlag()
```

#### Memory

```bash
x/256xb $rsp #dump 256 bytes from the stack in hexadecimal format
x/60xw $rsp  #dump 60 32-bit words from the stack
x/30xg $rsp  #dump 30 64-bit words from the stack
x/42i main   #show the 42 first asm instructions of function main
```

#### Basic strcmp

```bash
x/16x $esp+4
x/4s <premiere addresse>
x/4s <seconde addresse>
```

#### R2 analysis

```bash
r2 -d -A crackme

# seek function
s @sym.compare_pwd
s @sym.main

# disass main
pdf main
VV

# basic blocks
afbj
pdj
pif | grep -B2 mov,
```

#### CFG Obfuscation

- https://tigress.wtf/introduction.html
- https://blog.es3n1n.eu/posts/obfuscator-pt-1/
- https://nicolo.dev/en/blog/role-control-flow-graph-static-analysis/
- https://polarply.medium.com/build-your-first-llvm-obfuscator-80d16583392b

### Anti Breakpoints

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-bp/
- https://jaybailey216.com/debugging-stripped-binaries/
- https://blog.0x972.info/?d=2014/11/13/10/40/50-how-does-a-debugger-work
- https://stackoverflow.com/questions/14016610/x86-instruction-help-mov-edx-eax
- https://stackoverflow.com/questions/8878716/what-is-the-difference-between-hardware-and-software-breakpoints

```bash
#symbols
#info functions
info file
starti
hb *<addr bp>
```

### Anti Debug

- https://github.com/ariary/Hack-weak-strcmp-code
- https://revers.engineering/applied-re-exceptions/
- https://fr.wikipedia.org/wiki/Interrupt_Descriptor_Table
- https://github.com/ariary/simple_anti-debug_and_simple_bypasss
- https://t-a-w.blogspot.com/2007/03/how-to-code-debuggers.html

#### Linux

- https://hexed.it/
- https://ctf-wiki.mahaloz.re/reverse/linux/detect-dbg/
- https://bases-hacking.org/ptrace.html
- https://codelucky.com/core-dump-linux/
- https://bases-hacking.org/faux-desassemblage.html   # patch fake opcodes (0xEB0108) by nops (0x90)
- https://bases-hacking.org/faux-breakpoint.html      # use hardware breakpoints (hb *) to avoid changing 0xCC interruptions
- https://bases-hacking.org/code-checksum.html        # 

```bash
# core dump
cat /proc/`pidof binary`/status
ps f
#  71554 pts/1    Ss     0:00 /usr/bin/bash
#  85717 pts/1    S+     0:00  \_ ./binary
sudo gcore 85717
strings -atx core.85717
gdb -c core.85717 -q

# OR attaching to process
./binary
sudo gdb -p `pidof binary`
```

**Avoiding SigTRAP (int 3)** 

`signal(int sig,__sighandler_t handler)`

```bash
# Find sig in signal
kill -l
```

```asm
# x86: 48 signal eax:30, ebx (arg0):sig, ecx(arg1):handler  
# mov $0x80480e2, %ecx
# int $0x80

set $eip=0x80480e2
```


### Automation: Disassembling, Parsing, General Framework

- https://www.capstone-engine.org/lang_python.html
- https://www.0ffset.net/reverse-engineering/capstone-resolving-stack-strings/
- [IDA - Parsing CTF example](https://www.aperikube.fr/docs/breizhctf_2018/multiplat/)
- [Pintol - Instrumentation CTF example](https://github.com/mattfeng/hsf/tree/master/2016/isengard_fixed)
- https://github.com/cea-sec/miasm  # General

### Equations / Keygen solver - z3

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

#### Angr (voir z3 plus haut)

Exemple typique: résoudre un crackme connaissant 2 addresses (**find**,avoid**)
(en explorant chaque CFG et résolvant un système)

![angr](./angr_basique.py)

- https://shoxxdj.fr/angr-basics/
- https://github.com/jakespringer/angr_ctf
- https://github.com/angr/angr-doc/blob/master/CHEATSHEET.md

### Packers

- https://vmpsoft.com/
- https://www.oreans.com/Themida.php
- https://tigress.wtf/introduction.html
- https://mkaring.github.io/ConfuserEx/
- https://reverseengineering.stackexchange.com/questions/72/unpacking-binaries-in-a-generic-way
- https://reverseengineering.stackexchange.com/questions/3184/packers-protectors-for-linux

### QEMU - Debug foreign arch on x86

- https://airbus-seclab.github.io/qemu_blog/
- https://azeria-labs.com/the-importance-of-deep-work-the-30-hour-method-for-learning-a-new-skill/
- https://ariadne.space/2021/05/05/using-qemu-user-emulation-to-reverse-engineer-binaries/
- https://www.mathyvanhoef.com/2013/12/reversing-and-exploiting-arm-binaries.html
- https://github.com/andrew-d/static-binaries

#### Qiling - Alternative to Qemu-User

- https://github.com/qilingframework/qiling
- https://github.com/qilingframework/rootfs

#### MultiArch

- https://www.debian.org/distrib/netinst
- https://wiki.debian.org/Multiarch/HOWTO
- https://packages.debian.org/
- https://unix.stackexchange.com/questions/582074/are-there-any-alternatives-to-ltrace-that-does-the-same-job#584911

```bash
dpkg --add-architecture armel
dpkg --add-architecture armhf
apt update && apt install libc6:armel libc6:armhf
```

#### Fix linker and shared libraries

- https://unix.stackexchange.com/questions/553743/correct-way-to-add-lib-ld-linux-so-3-in-debian
- https://stackoverflow.com/questions/59549978/how-to-use-patchelf-with-set-interpreter

```bash
root@debian:~# patchelf --print-needed ch23.bin 
libc.so.6
root@debian:~# file ch23.bin 
ch23.bin: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically li
nked, interpreter /lib/ld-linux.so.3, for GNU/Linux 2.6.26, BuildID[sha1]=e1b71a
8437277ebc3eb417be2bf877b5dfff85c8, stripped
root@debian:~# patchelf --set-interpreter /lib/arm-linux-gnueabi/ld-linux.so.3 ch23.bin 
root@debian:~# LD_LIBRARY_PATH=./lib/arm-linux-gnueabi ./ch23.bin 
Please input password
```

#### LibVirt (Qemu / KVM GUI)

- https://nicolargo.developpez.com/tutoriels/virtualisation/apprentissage-qemu-libvirt-exemple/
- https://serverfault.com/questions/840519/how-to-change-the-default-storage-pool-from-libvirt
- https://www.xmodulo.com/network-default-is-not-active.html

```bash
sudo virsh net-start default
```

![](./images/Libvirt.gif)

#### Libvirt - arm 32 bits

- https://superuser.com/questions/1009540/difference-between-arm64-armel-and-armhf#1259737
- https://marcin.juszkiewicz.com.pl/2016/01/17/running-32-bit-arm-virtual-machine-on-aarch64-hardware/
- https://people.debian.org/~aurel32/qemu/armel/

#### Libvirt - arm vs armv6l

- options architectures libvirt  **arm = iso armhf**
- activer **démarrage de noyau direct** dans édition de la vm pour armel

#### Quick script (mips|ppc|arm|x86|x64)

- https://people.debian.org/~aurel32/qemu/
- https://gist.github.com/cellularmitosis/54d3cc18e1b128b9286d7ceed3c5bdb7

```bash
remmina&
#127.0.0.1:5900
#attendre le boot
ssh -p 2222 root@<ip_wlan0>
```

#### Arm_Now (ARM (32 bits + aarch/64 bits),MIPS)

- https://github.com/nongiach/arm_now/wiki

**Avec l outil:**

```bash
arm_now list
arm_now offline
arm_now start armv5-eabi --sync
arm_now resize 2G
arm_now clean
```

**A la main**:

```bash
#host - chall_arm.bin
python -m http.server 8000
```

```bash
#root:root
arm_now start armv5-eabi
wget http://10.0.2.2:8000/chall_arm.bin
gdb -tui -ex "layout asm" -ex "layout regs" chall_arm.bin
```

```bash
#si souci au demarrage
#invalid card size:
qemu-img resize arm_now/rootfs.ext2 128M #1G
```

#### ARM

- https://www.acmesystems.it/arm9_toolchain
- https://0x90909090.blogspot.com/2014/01/how-to-debug-arm-binary-under-x86-linux.html
- https://salmanarif.bitbucket.io/visual/

```bash
arm-linux-gnueabihf-gcc -fno-pie -ggdb3 -no-pie -o hello_world hello_world.c
```

Exécuter :

```bash
qemu-arm -d strace ./hello_world
qemu-arm -L /usr/arm-linux-gnueabihf -g 1234 ./hello_world
```

Reverser :

```bash
gdb-multiarch -q \
  -ex 'source ~/.gdbinit' \
  -ex 'set architecture arm' \
  -ex 'set sysroot /usr/arm-linux-gnueabihf' \
  -ex 'file hello_world' \
  -ex 'target remote localhost:1234' \
  -ex 'break main' \
  -ex continue \
  -ex 'layout split'
```

#### MIPS

- https://pr0cf5.github.io/ctf/2019/07/16/mips-userspace-debugging.html

#### RiscV

- https://danielmangum.com/posts/risc-v-bytes-qemu-gdb/#installing-tools

### Nanomites / Multithreaded debugging

- https://linux.die.net/man/2/fork
- https://drdobbs.com/cpp/multithreaded-debugging-techniques/199200938?pgno=6
