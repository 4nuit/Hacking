# Prérequis

Voir [Reverse](../reverse)

## Doc :

- Vidéos/Plateformes/Docs: https://mksec.fr/tricks/pwn_ressources/

- https://www.mycybersharing.com/cybersecu/app_sys_start_gradually/

- Overview du pwn en fr: https://own2pwn.fr 

- https://ir0nstone.gitbook.io/notes/

- https://github.com/guyinatuxedo/remenissions/blob/master/docs/exploit-methods.md

## Cheatsheet

[Pwntools](https://gist.github.com/anvbis/64907e4f90974c4bdd930baeb705dedf)

- https://github.com/Naetw/CTF-pwn-tips

- https://chovid99.github.io/posts/tcp1p-ctf-2023/#pwn

- http://dbp-consulting.com/tutorials/debugging/

- https://libc.blukat.me

![](./history_overview.png)

## Tools

- https://github.com/nobodyisnobody/tools/tree/main/pwn2204

## Stack

### Arguments et payload

- Si en argv[1]: ./vuln $(payload) 
- Sinon : python -c "print 'AAAA\n..'" | ./vuln
- https://reverseengineering.stackexchange.com/questions/13928/managing-inputs-for-payload-injection


- Voir `./asm`
- https://0xninja.fr/xchg-rax-rax/

### Assembleur et registres

[Section asm](./asm)

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

- https://chromium.googlesource.com/chromiumos/docs/+/HEAD/constants/syscalls.md

### Débuggers

### Find offset / 'A' padding

- https://hugsy.github.io/gef/commands/pattern/
- https://hugsy.github.io/gef/commands/search-pattern/

### Quick (shell|op)code with asm

```bash
#obtenir le shell code en arm, 64 bits
rasm2 -aarm -b64 -C 'nop'
```

### Memo

*Note*: gdb modifie l'environement en ajoutant $LINES $COLUMNS et le nom du prog avec un path absolu, le décalage n'est que dans la stack, pour corriger:

```bash
unset env LINES
unset env COLUMNS
```
- https://security.stackexchange.com/questions/51375/why-stack-is-not-at-the-same-address-when-exec-running-in-gdb

voir aussi les outils sous `./windows`

### Shellcodes

- https://hugsy.github.io/gef/commands/shellcode/
- https://shell-storm.org/shellcode/index.html

```bash
nasm -f elf32 shellcode.s
objcopy -O binary -K shellcode shellcode.o shellcode.bin
```

[ret2shellcode](./shellcode)


![](./stack.png)

## Format Strings (leaks/read + write)

[./format_string.md](./format_string.md)

- https://axcheron.github.io/exploit-101-format-strings/
- https://docs.pwntools.com/en/stable/fmtstr.html
- [Patriot CTF - GOT Overwrite](https://github.com/4nuit/Writeup/tree/master/2023/Patriot/pwn/printshop)

## Stack Protections

-  https://blog.siphos.be/2011/07/high-level-explanation-on-some-binary-executable-security/

- **RELRO**: rend les headers (GOT,PLT) rx
- **NX**: rend la pile nx -> bypass avec ret2libc
- **ASLR** : randomise base address 
- **PIE** : same, randomise offset -> bypass avec un leak ou rop

![](./pile.png)
![](./addresses.png)

- **SSP/Canary**: stack cookie (gcc feature) -> bypass avec un leak

    - https://vozec.fr/writeups/tweetybirb-killerqueenctf-2021/
    - https://learn-cyber.net/article/Understanding-and-Defeating-the-Canary
    - https://j00ru.vexillium.org/slides/2015/insomnihack.pdf


![](./leak_and_bf.png)

## Heap

### Mémoire virtuelle et ordonnancement

- https://drive.google.com/drive/folders/16FnbMmbfreb2SJX0px-5ce5KFq0Pjd1M
- https://hugsy.github.io/gef/commands/vmmap/

[Section heap](./heap)

![heap](./heap.png)

## Kernel

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
