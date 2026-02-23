## Documentation

- https://syscall.sh/
- https://syscalls.mebeim.net/			# Linux
- https://j00ru.vexillium.org/syscalls/nt/64/	# Windows
- https://github.com/larsbrinkhoff/awesome-cpus	# All architectures specifications
- [Comparing Modern x86 and ARM Assembly Language](https://www.cs.uaf.edu/2011/spring/cs641/lecture/02_10_assembly.html)

### x86

#### NASM

- https://asmtutor.com
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html
- https://www.aldeid.com/wiki/Category:Architecture/x86-assembly
- https://sensepost.com/blogstatic/2014/01/SensePost_crash_course_in_x86_assembly-.pdf

#### MASM

- https://sonictk.github.io/asm_tutorial

### ARMv6

- https://armasm.com/docs/
- https://www.aldeid.com/wiki/Category:Architecture/ARM
- https://azeria-labs.com/writing-arm-assembly-part-1/

### Compilation

```bash
sudo pacman -S nasm arm-linux-gnueabi-binutils arm-linux-gnueabi-gcc aarch64-linux-gnu-gcc aarch64-linux-gnu-binutils aarch64-linux-gnu-gcc
make
./helloworld_x86 && ./helloworld_x86_64
qemu-arm ./hellworld_arm32
qemu-aarch64 ./helloworld_aarch64
```

### Disassembly

```bash
nasm -f elf64 helloworld.s -o hellworld.o
ld -o helloworld helloworld.o
objdump -d helloworld
```

```asm
Déassemblage de la section .text :

0000000000000000 <_start>:
   0:   b8 01 00 00 00          mov    $0x1,%eax
   5:   bf 01 00 00 00          mov    $0x1,%edi
   a:   48 be 00 00 00 00 00    movabs $0x0,%rsi
  11:   00 00 00 
  14:   ba 0d 00 00 00          mov    $0xd,%edx
  19:   0f 05                   syscall
  1b:   eb 00                   jmp    1d <_exit>

000000000000001d <_exit>:
  1d:   b8 3c 00 00 00          mov    $0x3c,%eax
  22:   bf 00 00 00 00          mov    $0x0,%ed
```

## Binary exploitation

- https://www.developpez.net/forums/d1497/autres-langages/assembleur/qu-qu-offset/
- https://stackoverflow.com/questions/9268586/what-are-callee-and-caller-saved-registers
- https://github.com/wirasecure/pentest-notes/blob/master/buffer_overflow/assembly/course_notes.md


### Questions/remarques ARM vs x86

- Pourquoi ne pas mettre de '#' (immediate) ne change rien
- Pourquoi mettre un mov ne fonctionne pas (`ldr`) alors qu'on pourrait loader avec `lea` en x86

```bash
[root@alarm ~]# as -o helloworld.o helloworld.s 
[root@alarm ~]# ld -o helloworld helloworld.o
[root@alarm ~]# ./helloworld 
Hello World
[root@alarm ~]# diff old_helloworld helloworld
```
