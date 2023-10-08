# Doc reverse:

https://www.youtube.com/@StephenChapman

https://m.youtube.com/c/oalabs

- https://www.begin.re
- https://bbinfosec.medium.com/reverse-engineering-resources-beginners-to-intermediate-guide-links-f64c207505ed
- https://www.slideshare.net/AmandaRousseau1/what-can-reverse-engineering-do-for-you
- https://forum.tuts4you.com/files/file/1307-lenas-reversing-for-newbies/
- https://tmpout.sh

- [Plateforme Crackme.one](https://crackmes.one)
- `Awesome Reversing +`:  https://github.com/wtsxDev/reverse-engineering

# Quelques outils:

À posséder:

- En ligne:
	- `Dogbolt (decompiler explorer)`: compare le pseudo code source de différents outils (Ghidra, Hex Rays, Ida, Binary Ninja) rapidement
	- `Disassembler.io`

- `Ghidra` : https://ghidra-sre.org/ (clone d'après les sources du git)

- `UPX unpacker` : https://github.com/NozomiNetworks/upx-recovery-tool

- https://www.decompiler.com/

## Windows

Reverse: décompilos:

- `DotPeek` : https://www.jetbrains.com/fr-fr/decompiler/ -> parfait pour du `.NET`
- `DnSpy` : https://github.com/dnSpy/dnSpy -> plus maintenu

## Linux

Outils classiques:

- `objdump`:
	`-t` : afficher la table des symboles -> si rien : voir ../../pwn/asm
	`-h`: afficher les sections

- `ltrace`: voir les fonctions de la libc appelées

- `strace`: voir les syscalls

- `ldd`: voir les bibliothèques/libc utilisées (Hijacking, [ret2libc](../pwn/stack/ret2libc)

Débuggers:

- `gdb`: [gef](https://github.com/hugsy/gef)
- `r2`: https://github.com/radareorg/radare2
- `x64dbg` (windows)

```bash
alias pwndbg='gdb -x ~/pwndbg/gdbinit.py -q '
alias gef='gdb -x ~/.gdbinit-gef.py -q '
alias gdb-peda='gdb -x ~/peda/peda.py'
```

Exemple avec gdb-gef:

```bash
gef➤  info functions
All defined functions:

Non-debugging symbols:
0x00000000004004b0  _init
0x00000000004004e0  puts@plt
0x00000000004004f0  __stack_chk_fail@plt
0x0000000000400500  printf@plt
0x0000000000400510  __libc_start_main@plt
0x0000000000400520  strcmp@plt
0x0000000000400530  __gmon_start__@plt
0x0000000000400540  _start
0x0000000000400570  deregister_tm_clones
0x00000000004005a0  register_tm_clones
0x00000000004005e0  __do_global_dtors_aux
0x0000000000400600  frame_dummy
0x000000000040062d  get_pwd
0x000000000040067a  compare_pwd
0x0000000000400716  main
0x0000000000400760  __libc_csu_init
0x00000000004007d0  __libc_csu_fini
0x00000000004007d4  _fini
gef➤  b *0x0000000000400520
Breakpoint 1 at 0x400520
gef➤  r toto
```

*call function*

```bash
starti
jump *0x... #addresse print_flag()
```

*basic strcmp*

```bash
x/16x $esp+4
x/4s <premiere addresse>
x/4s <seconde addresse>
```

Accélérer l'analyse avec r2:

```bash
r2 -d -A crackme
....
s @sym.compare_pwd

```

### Compilation (sans protections,32bits)

```c
gcc -m32 -fno-stack-protector -no-pie -o test test.c
```

## Debug foreign arch on x86

### ARM

https://www.acmesystems.it/arm9_toolchain
https://0x90909090.blogspot.com/2014/01/how-to-debug-arm-binary-under-x86-linux.html

Compiler : 

```bash
arm-linux-gnueabihf-gcc -fno-pie -ggdb3 -no-pie -o hello_world hello_world.c
```

Exécuter : 

```bash 
qemu-arm -L /usr/arm-linux-gnueabihf -g 1234 ./hello_world
```

Reverser : 

```bash
gdb-multiarch -q --nh \
  -ex 'set architecture arm' \
  -ex 'set sysroot /usr/arm-linux-gnueabihf' \
  -ex 'file hello_world' \
  -ex 'target remote localhost:1234' \
  -ex 'break main' \
  -ex continue \
  -ex 'layout split'
```

### MIPS

https://pr0cf5.github.io/ctf/2019/07/16/mips-userspace-debugging.html

### RiscV

https://danielmangum.com/posts/risc-v-bytes-qemu-gdb/#installing-tools

## Stack x86

- https://n-pn.fr/t/2431-la-pile-en-assembleur-x86

## Cmp bypass

- https://github.com/ariary/Hack-weak-strcmp-code

## Ptrace bypass

- https://nuculabs.dev/p/bypassing-ptrace-ld-preload
- https://github.com/ariary/simple_anti-debug_and_simple_bypasss
- https://ctf-wiki.mahaloz.re/reverse/linux/ld_preload/

## Breakpoints bypass

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-bp/

## Packer (upx ici)

- https://reverseengineering.stackexchange.com/questions/3184/packers-protectors-for-linux

## Bytecode :

- Python: `uncompyle`
- Java: `jadx`
- Android: `jadx`, `apktool`, `adb`
- Rust: https://github.com/h311d1n3r/Cerberus
- Unity: https://github.com/imadr/Unity-game-hacking#unity-game-folder-structure

## Angr

(exec symbolique, s'appuie sur z3)

- https://theory.stanford.edu/~nikolaj/programmingz3.html
- https://shoxxdj.fr/angr-basics/

## Game Hacking

- https://www.docdroid.net/rtoAc2n/game-hacking-pdf#page=87
- https://www.kodeco.com/36285673-how-to-reverse-engineer-a-unity-game
- https://0x64marsh.com/?p=689


