# Prérequis

Voir [Reverse](../reverse)

## Doc :

- Vidéos/Plateformes/Docs: https://mksec.fr/tricks/pwn_ressources/
- https://www.mycybersharing.com/cybersecu/app_sys_start_gradually/

- Overview du pwn en fr: https://own2pwn.fr 
- https://hackcess.org/pdf/Pwn_like_its_2007.pdf

- https://ir0nstone.gitbook.io/notes/
- https://github.com/guyinatuxedo/remenissions/blob/master/docs/exploit-methods.md
- https://www.corelan-training.com/index.php/training/heap/

## Challenges

- https://exploit.education #à faire
- https://pwn.college # à faire

## Cheatsheet

- [pwntools tuto](https://gist.github.com/anvbis/64907e4f90974c4bdd930baeb705dedf)

- https://github.com/Gallopsled/pwntools-tutorial
- https://github.com/Naetw/CTF-pwn-tips
- https://chovid99.github.io/posts/tcp1p-ctf-2023/#pwn
- http://dbp-consulting.com/tutorials/debugging/
- https://libc.blukat.me

![](./history_overview.png)

## Tools

- https://github.com/nobodyisnobody/tools/tree/main/pwn2204
- https://github.com/ptr-yudai/ptrlib (windows)

## Permissions

- https://en.wikipedia.org/wiki/Setuid
- https://stackoverflow.com/questions/21337923/why-ptrace-doesnt-attach-to-process-after-setuid
- https://unix.stackexchange.com/questions/451048/from-which-version-does-bash-drop-privileges
- https://linux.die.net/man/1/bash

```txt
 Si l’interpréteur est lancé avec un identifiant (de groupe) d’utilisateur effectif différent de l’identifiant (de groupe) d’utilisateur réel et si l’option -p n’est pas fournie [...] l’identifiant de l’utilisateur effectif est configuré à celui de l’utilisateur réel. Si l’option -p est fournie à l’appel, le comportement au démarrage est le même mais l’identifiant d’utilisateur effectif n’est pas modifié.
```

### Shellcode modifiant uid/gid voulu

- https://www.exploit-db.com/exploits/13338 # Linux x86 setreuid(geteuid,geteuid) + execve(/bin/sh) - 39 bytes

### Shellcode passant '-p' pour le pas changer eUID (effectif)

- https://shell-storm.org/shellcode/files/shellcode-606.html # Linux x86 - execve("/bin/bash", ["/bin/bash", "-p"], NULL) - 33 bytes

### Shellcode pointant vers un wrapper qui utilise setreuid() puis system()

```c
#include <stdlib.h>
#include <unistd.h>

int main(void)
{
   setreuid(0, 0); // 0 correspond à root, peut être amené à changer suivant votre utilisation
   system("/bin/bash");

   return 0;
}
```

## Stack

### Alignement

- https://stackoverflow.com/questions/1061818/stack-allocation-padding-and-alignment

![](./align.png)

```txt
It's a gcc feature controlled by -mpreferred-stack-boundary=n where the compiler tries to keep items on the stack aligned to 2^n. If you changed n to 2, it would only allocate 8 bytes on the stack. The default value for n is 4 i.e. it will try to align to 16-byte boundaries.
```

### Arguments et payload

- Si en argv[1]: ./vuln $(payload) 
- Sinon : python -c "print 'AAAA\n..'" | ./vuln
- https://reverseengineering.stackexchange.com/questions/13928/managing-inputs-for-payload-injection

- Voir `./asm`
- https://0xninja.fr/xchg-rax-rax/

### Assembleur et registres

[Section memo asm](./asm)

### Mémoire virtuelle, Segmentation et Ordonnancement

- https://www.root-me.org/fr/Documentation/Applicatif/Memoire-segmentation
- https://stackoverflow.com/questions/30542428/does-malloc-use-brk-or-mmap

`If you use malloc in your code, it will call brk() at the beginning, allocated 0x21000 bytes from the heap, that's the address you printed, so the Question 1: the following mallocs requirements can be meet from the pre-allocated space, so these mallocs actually didn't call brk, it is a optimization in malloc. If next time you want to malloc size beyond that boundary, a new brk will be called (if not large than the mmap threshold).`

- https://drive.google.com/drive/folders/16FnbMmbfreb2SJX0px-5ce5KFq0Pjd1M
- https://github.com/4nuit/Systeme_Exploitation/blob/master/TP1/TP1_ARSE.pdf

```bash
readelf -l /bin/ls
```

1 segment = plusieurs sections

![](./segments_colored.png)

![](./segmentation.gif)

Source: https://reverse.zip/posts/introduction_au_reverse_partie_3/

### 32 vs 64 bits

En 32 bits, tous les paramètres sont poussés vers la pile avant que la fonction ne soit appelée (STDCALL).
En 64 bits, cependant, les 6 premiers sont stockés dans les registres RDI, RSI, RDX, RCX, R8 et R9 respectivement selon la convention d'appel (FASTCALL, dépend de l'OS).

- https://beta.hackndo.com/conventions-d-appel/
- https://beta.hackndo.com/rappels-d-architecture/

### Endianness

- https://serverfault.com/questions/163487/how-to-tell-if-a-linux-system-is-big-endian-or-little-endian

### Memo

- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

### Syscalls

- https://syscalls.mebeim.net/?table=x86/64/x64/v6.6

### Débuggers

```bash
gdb -q ./exploit
list 1
break 3 # break at 3 line of source code
```

### Core files

- https://unix.stackexchange.com/questions/89933/how-to-view-core-files-for-debugging-purposes-in-linux

```bash
ulimit -c unlimited
echo 'core' | sudo tee /proc/sys/kernel/core_pattern
```

### Find offset / 'A' padding

- https://hugsy.github.io/gef/commands/pattern/
- https://hugsy.github.io/gef/commands/search-pattern/

### Quick (shell|op)code with asm

```bash
#obtenir le shell code en arm, 64 bits
rasm2 -aarm -b64 -C 'nop'
```

### Memo overflow

- https://zestedesavoir.com/articles/100/introduction-aux-buffer-overflows/

*Note*: gdb modifie l'environement en ajoutant $LINES $COLUMNS et le nom du prog avec un path absolu, le décalage n'est que dans la stack, pour corriger:

```bash
unset env LINES
unset env COLUMNS
```
- https://security.stackexchange.com/questions/51375/why-stack-is-not-at-the-same-address-when-exec-running-in-gdb

voir aussi les outils sous `./windows`

- https://www.root-me.org/fr/Documentation/Applicatif/Debordement-de-tampon-utiliser-l-environnement

### Shellcodes

#### Outils

- https://hugsy.github.io/gef/commands/shellcode/
- https://shell-storm.org/shellcode/index.html

#### Principe

- https://www.root-me.org/fr/Documentation/Applicatif/Shellcode-introduction
- https://www.root-me.org/fr/Documentation/Applicatif/Shellcode-ecrire-un-bytecode
- https://www.root-me.org/fr/Documentation/Applicatif/Shellcode-caracteres-interdits


```bash
nasm -f elf32 shellcode.s
objcopy -O binary -K shellcode shellcode.o shellcode.bin
```

[ret2shellcode](./shellcode)


![](./stack.png)

## Format Strings (leaks/read + write)

[format_string](./format_string)

- https://axcheron.github.io/exploit-101-format-strings/
- https://docs.pwntools.com/en/stable/fmtstr.html
- [Patriot CTF - GOT Overwrite](https://github.com/4nuit/Writeup/tree/master/2023/Patriot/pwn/printshop)

## Stack Protections

-  https://blog.siphos.be/2011/07/high-level-explanation-on-some-binary-executable-security/

- **RELRO**: rend les headers (GOT,PLT) rx
- **NX**: rend la pile nx -> bypass avec ret2libc
- **ASLR** : randomise base address 
- **PIE** : same, randomise offset -> bypass avec un leak ou rop
- [FORTIFY SOURCE](https://www.root-me.org/fr/Documentation/Applicatif/Memoire-protection-FORTIFY_SOURCE)

![](./pile.png)
![](./addresses.png)

- **SSP/Canary**: stack cookie (gcc feature) -> bypass avec un leak

    - https://vozec.fr/writeups/tweetybirb-killerqueenctf-2021/
    - https://learn-cyber.net/article/Understanding-and-Defeating-the-Canary
    - https://j00ru.vexillium.org/slides/2015/insomnihack.pdf


![](./leak_and_bf.png)

## Heap

HP-Allocateur: Pagination, interaction caches

- https://github.com/4nuit/Systeme_Exploitation/blob/master/TP2/TP2_ARSE-2.pdf

[Section heap](./heap)

![heap](./heap.png)

## Kernel

- https://github.com/4nuit/Systeme_Exploitation/blob/master/TP7/TP7.pdf
- https://github.com/4nuit/Systeme_Exploitation/blob/master/TP6/Debugging_Kernel_TP_Kernel.pdf

- https://lkmidas.github.io/posts/20210123-linux-kernel-pwn-part-1/

- Kernelmap interactive: https://makelinux.github.io/kernel/map/

- Kernel: https://0xax.gitbooks.io/linux-insides/content/

### ARM - Egghunter

```bash
arm-linux-gnueabihf-as -o hunter hunter.s
arm-linux-gnueabihf-ld -N hunter.o -o hunter
arm-linux-gnueabihf-objcopy -O binary hunter hunter.bin
hexdump -v -e '"\\""x" 1/1 "%02x" ""' hunter.bin
```

