# Notions

- [Nasm elf64 - Regitres + Helloworld + Debug (Opcode)](https://youtu.be/uDkW8bQt1Rc)
- https://asmtutor.com

Utilités:

- être plus à l'aise en pwn et surtout reverse pour comprendre les instructions désassembIées (ghidra, cutter etc) -> **débugger des binaires sans symboles**
- faire ses propres shellcodes

## Memo

- https://www.developpez.net/forums/d1497/autres-langages/assembleur/qu-qu-offset/
- https://stackoverflow.com/questions/9268586/what-are-callee-and-caller-saved-registers
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

## Prologue fonction (intel x86, 32bits)

- https://beta.hackndo.com/assembly-basics/


## Programmation - ARM like comparison

[FCSC - VM](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/intro/comparaison)

## Programmation - Intel x64 helloworld

`helloworld.s`

```asm
;https://x64.syscall.sh/

global _start:

section .rodata
        helloworld db "Hello world", 10, 0      ; declare bytes "Hello world\n\0"
        helloworld_len equ $-helloworld         ; gets len with $-

section .text

_start:                                         ; ssize_t write(int fildes, const void *buf, size_t nbyte) (man 3 write)
        mov rax, 1                              ; syscall write
        mov rdi, 1                              ; arg0, stdout
        mov rsi, helloworld                     ; arg1, string
        mov rdx, helloworld_len                 ; arg2, len
        syscall                                 ; writes helloworld on stdout
        jmp _exit

_exit:
        mov rax, 60                             ; syscall exit
        mov rdi, 0                              ; arg0, error code if we stopped to the previous syscall (echo $?)
        syscall                                 ; clean exit
```

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

