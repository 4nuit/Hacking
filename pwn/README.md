# Prerequisites

- [Prog - C](../prog/c_memo/undefined_behaviours/)
- [Prog - Asm](../prog/asm_emulation/)
- [Linux](../linux)
- [Linux reverse](../reverse)
- https://github.com/hackclub/some-assembly-required
- https://beta.hackndo.com/rappels-d-architecture/
- https://github.com/wirasecure/pentest-notes/blob/master/buffer_overflow/assembly/course_notes.md


## Courses / Tutos

- https://github.com/RPISEC/MBE
- https://github.com/rosehgal/BinExp
- https://reverse.zip/categories/pwn/
- https://training.tosch.io/appsec101
- https://github.com/guyinatuxedo/nightmare
- https://bases-hacking.org/failles-applicatives.html
- https://wiki.zenk-security.com/doku.php?id=failles_app
- https://www.cgsecurity.org/Articles/SecProg/buffer.html
- https://web.archive.org/web/20241002005448/http://own2pwn.fr/
- https://cyber.gouv.fr/publications/regles-de-programmation-pour-le-developpement-securise-de-logiciels-en-langage-c


### Analysis

- [Audit code: Reversing Binaries](https://github.com/4nuit/Hacking/tree/master/audit_code#reversing-binaries-blackbox)
- https://codeql.github.com/
- https://github.com/NASA-SW-VnV/ikos
- https://github.com/weggli-rs/weggli
- https://github.com/0xdea/ghidra-scripts
- https://www.lazenca.net/display/TEC/03.Analysis
- https://www.lazenca.net/display/TEC/04.Fuzzing

```bash
#https://github.com/0xdea/weggli-patterns
weggli '{_ $buf[_]; $buf[_]=_;}' .

#https://github.com/synacktiv/Weggli_rules_SSTIC2023 
bash dangerous_functions.qry binary.c
bash malloc_overflow.qry  binary.c
bash stack.qry binary.c


#https://github.com/0xdea/semgrep-rules
#https://github.com/semgrep/semgrep-rules/
semgrep --config ~/semgrep-rules/rules/ --severity ERROR --severity WARNING --sarif --sarif-output=pwn.sarif .
```

```bash
#www.lazenca.net
scan-build gcc main.c
scan-build: Using '/usr/bin/clang-18' for static analysis

clang -Wall -Wextra -std=c99 -fsanitize=address -g -o main main.c && ./main

valgrind --tool=memcheck --leak-check=full ./main
```

### Beginning (Stack/Heap)

- https://www.youtube.com/c/PinkDraconian
- https://www.youtube.com/@paulviel5931
- https://www.youtube.com/@que20
- [CryptoCat](https://www.youtube.com/watch?v=wa3sMSdLyHw)

## Cheatsheets

- [ELF Format Cheatsheet](https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779)
- [Pwntools cheatsheet](https://gist.github.com/anvbis/64907e4f90974c4bdd930baeb705dedf)
- [Pwndbg cheatsheet](https://pwndbg.re/CheatSheet.pdf)
- https://ir0nstone.gitbook.io/notes/
- https://www.ctfrecipes.com/pwn/
- https://github.com/nobodyisnobody/docs
- https://ctf-wiki.mahaloz.re/pwn/readme/
- https://hackmd.io/@u1f383/pwn-cheatsheet
- https://github.com/xairy/linux-kernel-exploitation
- https://www.lazenca.net/display/TEC/05.Basic+exploitation+techniques


### Common Issues

- https://github.com/OpenToAllCTF/Tips
- https://github.com/Naetw/CTF-pwn-tips
- https://en.wikipedia.org/wiki/Time-of-check_to_time-of-use


| **Byte** (Hex Value) | **Problematic Methods** |
|----------------------|-------------------------|
| Null Byte \0 (0x00)  |         strcpy          |
|----------------------|-------------------------|
| Newline \n (0x0a)    | scanf gets getline fgets|
|----------------------|-------------------------|
| Return \r (0x0d)     | scanf                   |
|----------------------|-------------------------|
|     Space (0x20)     | scanf                   |
|----------------------|-------------------------|
|     Tab \t (0x09)    | scanf                   |
|----------------------|-------------------------|
|     Del (0x7f)       | protocols (telnet,VT100)|


### Protections

- https://www.ctfrecipes.com/pwn/protections/
- https://connect.ed-diamond.com/MISC/misc-062/la-securite-applicative-sous-linux
- https://wiki.zenk-security.com/doku.php?id=failles_app:aslr
- https://www.dailysecurity.fr/la-stack-smashing-protection/
- [https://ironhackers.es/en/tutoriales/pwn-rop-bypass-nx-aslr-pie-y-canary](https://web.archive.org/web/20240914140056/https://ironhackers.es/en/tutoriales/pwn-rop-bypass-nx-aslr-pie-y-canary/)
- https://blog.siphos.be/2011/07/high-level-explanation-on-some-binary-executable-security/
- https://media.blackhat.com/bh-us-10/whitepapers/Meer/BlackHat-USA-2010-Meer-History-of-Memory-Corruption-Attacks-wp.pdf


```bash
(hacking) night@me:~/towerctf$ checksec vuln
[*] '/home/night/towerctf/vuln'
    Arch:       amd64-64-little
    RELRO:      No RELRO
    Stack:      No canary found
    NX:         NX enabled
    PIE:        No PIE (0x400000)
    Stripped:   No
    Debuginfo:  Yes
```

Exploits often follows protections. See **Segmentation** section for further details.


| **Protection**               | **Description**                                                | **Bypass**                    | **Disable**                                               |
|------------------------------|----------------------------------------------------------------|-------------------------------|-----------------------------------------------------------|
| **RELRO**                     | Full RELRO makes GOT/PLT read-only *after* binding, to prevent GOT-overwrite. Governs GOT writability only. | N/A vs. ret2libc/ROP (they don't need to write the GOT); only blocks direct GOT-overwrite primitives. | `gcc -z norelro` |
| **NX** or **DEP**                  | Non-executable stack/heap to prevent shellcode execution.           | Ret2libc / ROP (code-reuse, no injected code needed). | **Linux**: `gcc -z execstack`<br>**Windows**: `bcdedit /set nx AlwaysOff` |
| **ASLR** (+PIE for Windows)   | Randomizes stack/heap/libs base addresses.                    | Leak address/Bf, Ret2plt.     | **Linux**: `echo "0" > /proc/sys/kernel/randomize_va_space`<br>**Windows**: `bcdedit /set noaslr` |
| **PIE**                       | Randomizes binary (text/data) section offsets.                | Leak base address, ROP.       | `gcc -no-pie`                                             |
| **SSP/Canary**                | Protects against stack overflows with a canary value.         | Leak canary value, overwrite return address. | `gcc -fno-stack-protector`                                 |
| **FORTIFY_SOURCE**            | Compiler hardening for buffer overflows.                      |                               | `gcc -D_FORTIFY_SOURCE=0`                                  |
| **KASLR**                     | Randomizes kernel memory addresses.                           | Leak kernel memory (via debug or vuln). | **Linux**: `echo 0 > /proc/sys/kernel/randomize_va_space`   |
| **SMEP**                      | Prevents CPU from *executing* user-mode pages while in kernel mode.             | ROP in kernel-mapped memory, or disable via CR4 write gadget.            |                                                           |
| **SMAP**                      | Prevents CPU from *accessing* (read/write) user-mode pages while in kernel mode, unless explicitly allowed (`stac`/`clac`). | Kernel ROP through `stac`/`clac`-bracketed gadgets, or disable via CR4 write gadget. |                                                           |
| **KPTI**                      | Isolates kernel and user-space memory to mitigate Spectre/Meltdown. | Kernel exploit.              |                                                           |
| **Secure Boot / Module Signing** | Only signed kernels/modules allowed.                          | Exploit misconfigurations or use custom signed modules. |                                                           |
| **Control Flow Integrity (CFI)** | Restricts indirect calls/jumps to a set of statically-valid targets. | JOP/COOP, or any target that's still "CFI-legal" (generic ROP alone is usually *not* enough once CFI is enforced). |                                                           |
| **UEFI Secure Boot**          | Ensures only trusted bootloaders/kernel images are loaded.    | Exploit firmware vuln to bypass. |                                                           |
| **PAC / BTI / MTE** (ARM64)   | Pointer Authentication signs return addresses/pointers; Branch Target Identification restricts valid indirect-branch landing pads; Memory Tagging Extension tags allocations to catch UAF/OOB. | PAC: signing-oracle leaks, un-signed-pointer gadgets. BTI: any call to a valid `bti` landing pad still works. MTE: only 4-bit tags, brute-forceable / async mode is best-effort. | [ARM: PAC](https://developer.arm.com/documentation/102433/latest/), [ARM: MTE](https://developer.arm.com/documentation/102925/latest/) |


![](./images/history_overview.png)


## Challenges

- https://pwnable.kr/ # recommended
- https://exploit.education #to do
- https://pwn.college # to do
- https://sourcery.pwnadventure.com/
- https://github.com/bkerler/exploit_me # ARM stack bof
- https://app.tower-ctf.fr/adventure/map/carte-des-aventuriers-du-pwn
- https://wiki.zenk-security.com/doku.php?id=exploit_exercises_protostar
- https://www.root-me.org/en/Challenges/App-System/

## Tools

- [GEF - Installer](./gef_bata24_install.sh)
- https://libc.rip/
- [reversing bits - cheatsheets](https://github.com/mohitmishra786/reversingBits/tree/main/src)
- [libvirt](https://libvirt.org/)
- [glibc matrix all in one](https://github.com/matrix1001/glibc-all-in-one)
- [One Gadget](https://github.com/david942j/one_gadget)
- [pwntools](https://docs.pwntools.com/en/stable/) or [ptrlib](https://github.com/ptr-yudai/ptrlib/) for windows
- [pwntools - patch elf](https://www.aldeid.com/wiki/Pwntools)
- [pwninit](https://github.com/io12/pwninit/)
- [ROPgadget](https://github.com/JonathanSalwan/ROPgadget)
- [Zeratool](https://github.com/ChrisTheCoolHut/Zeratool)   # Autopwner
- https://github.com/guyinatuxedo/remenissions              # Autopwner
- https://shell-storm.org/shellcode/index.html
- https://github.com/nobodyisnobody/tools/tree/main/pwn2204

### Setup notes

#### Pwntools notes

```python
p.send(payload)		# do a sendline() without "\n" (e.g without overflowing a following read()
p.clean(1)		# do a recvline() + clean buffer
pwn template -h		# alternative to gdbscript + generates boilerplate
pwn asm -h		# generates shellcode from any asm
pwn debug --exec ./ch10 # same as clean_exploit_testing.py but from the command line
```

See [full_exploit_testing.py](./full_exploit_testing.py) :

```bash
pwn template ./ch20 --quiet --host challenge05.root-me.org --port 50000
```

**Tmux, GDB & Qemu integration** (How to edit the generated template)

```python
# Tmux integration
# https://halb.it/posts/pwntools-gdb/
context.terminal = ['tmux', 'splitw', '-h']

# GDB integration without aslr

if args.GDB:
    return gdb.debug([exe.path] + argv, gdbscript=gdbscript, *a, **kw, aslr=False)
```

```python
# QEMU user integration (optional)
if args.GDB:
    io = process(["qemu-aarch64", "-g", "12345", elf.path])
elif args.LOCAL:
    io = process(["qemu-aarch64", elf.path])
```

```bash
tmux

# LOCAL DEBUGGING
python solve.py LOCAL GDB ./vuln

# REMOTE SOLVE
python solve.py 
```

#### Patchelf & Pwninit notes

Check also [../reverse](../reverse) with patchelf

```bash
#yay -S pwninit || cargo install pwninit 
$ file ch46
ch46: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/arm/2.27/lib/ld-linux.so.3, BuildID[sha1]=a9888dc2282c6a76631e4dda710d1251a5faaead, for GNU/Linux 3.2.0, not stripped
$ sudo dpkg --add-architecture armel
$ sudo apt update sudo apt install libc6:armel
$ pwninit --bin ch46 --ld /usr/arm-linux-gnueabi/lib/ld-linux.so.3
bin: ch46
ld: /usr/arm-linux-gnueabi/lib/ld-linux.so.3

copying ch46 to ch46_patched
running patchelf on ch46_patched
$ qemu-arm -d strace ./ch46_patched
Give me data to dump:
```

### Arguments & payload

- https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Process-Substitution
- https://reverseengineering.stackexchange.com/questions/13928/managing-inputs-for-payload-injection

```bash
# Payload in argv[1]
./vuln $(cat payload.txt)

# Payload in the buffer

## Python, encoding
python2 -c 'print "AAAA\n.."' | ./vuln
python3 -c 'import sys; sys.stdout.buffer.write(b"AAAA\n" + b"nope\n")'

## In GDB
## Does NOT filter out all NULL bytes 
run < <(python3 -c 'import sys; sys.stdout.buffer.write(b"AAAA\n" + b"nope\n")')

## Keep shell
(echo -ne <payload> ; cat) | ./vuln
(echo -ne <payload> ; cat) | qemu-mips -g 1234 ./vuln
```

### Debuggers

See [pwntools + gdb clean exploit testing](./clean_exploit_testing.py) for **pwntools**.

- https://github.com/bata24/gef (linux)
- https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/getting-started-with-windbg (windows)
- https://drdobbs.com/cpp/multithreaded-debugging-techniques/199200938?pgno=6

#### GDB vanilla (bad)

```bash 
break main+3
hbreak main+3
find <start>, +<length>, <data...>      // search string
info breakpoints                        // see breakpoints
info frame                              // see saved registers
info proc mappings                      // see memory = vmmap
next instruction                        // execute ni
step instruction                        // execute and steps into function
x/2xw 0xdeadbeef                        // prints out 2 addresses in x86
x/2xg 0xdeadbeef                        // prints out 2 addresses in x86_64
p/d (0xffc485bc-0xffc484ac)/4           // prints out offset between two addresses in x86
```

#### GEF

```bash
grep "/bin/sh"                          // search string
grep 0x181d5000                         // search value
search-pattern "/bin/sh"		// grep for bata24 gef fork
vmmap                                   // see virtual address segmentation  -> useful for getting writable address
hexdump dword --size 100 0xbffff404 	// get 100 addresses post offset 404 -> useful for nops/locating shellcode
telescope                               // expand stack 
canary                                  // get the SSP value if active
got                                     // prints the global offset table once the binary is run (starti). useful for GOT overwrite.
                                        // Name              | PLT            | GOT            | GOT value
                                        // exit              | 0x000000401160 | 0x000000404060 | 0x0000004010c0 <.plt+0xa0>
``` 

### Emulation

- https://people.debian.org/~aurel32/qemu/ # QEMU Images for all architectures
- https://unix.stackexchange.com/questions/499752/qemu-user-get-memory-maps-while-debugging-remotely
- https://nicolargo.developpez.com/tutoriels/virtualisation/apprentissage-qemu-libvirt-exemple/

#### QEMU + GDBServer notes

**Local setup** (e.g under x86/amd64 proc , using docker for debian (gdb-multiarch available))

```bash
#tmux
#1st term
qemu-arm -L /usr/arm-linux-gnueabihf -g 1234 ./arm_bin
#2nd term
gdb-multiarch -q \
  -ex 'source ~/.gdbinit' \
  -ex 'set architecture arm' \
  -ex 'set sysroot /usr/arm-linux-gnueabihf' \
  -ex 'file arm_bin' \
  -ex 'target remote localhost:1234' \
  -ex 'break main' \
  -ex 'continue' \
  -ex 'layout split'
```

**Remote setup (Libvirt VM)** (e.g under arm/aarch64 proc)

```bash
#see ../reverse for custom vms (LibVirt, arm_now -> opkg broken)
#fix missing libc/path (VM/emulated hardware)
dpkg --add-architecture armel armhf
apt update && apt install libc6:armel libc6:armhf
pwninit

tmux
#1st term
gdbserver localhost:1234 ./arm_bin
#2nd term
gef -ex "target remote localhost:1234"
```

## Basic stuff; common hints & pitfalls

### Bash environment/gdb tricks

**-i only sets the following variable on the stack**

Problem: environment offset shift

```bash
env -i pwn_string="cat /etc/passwd" gdb-gef ./ex3
# or in gdb
# unset env LINES
# unset env COLUMNS
```

```bash
b *main
r
x/s *(environ)
#entry to see other env. variables
```

```bash
env -i SHELLCODE=$(echo -ne "...") gdb -gef ./vuln
```

- https://security.stackexchange.com/questions/51375/why-stack-is-not-at-the-same-address-when-exec-running-in-gdb
- https://www.root-me.org/fr/Documentation/Applicatif/Debordement-de-tampon-utiliser-l-environnement

[Automating shellcode's creation](./shellcodes/doall.sh)
[Find an environment variable's address - getenv.c](./shellcodes/getenv.c)

### SUID - Permissions

- https://www.root-me.org/?page=forum&id_thread=12932
- https://stackoverflow.com/questions/32455684/difference-between-real-user-id-effective-user-id-and-saved-user-id
- https://tbhaxor.com/demystifying-suid-and-sgid-bits/
- https://book.hacktricks.xyz/linux-hardening/privilege-escalation/euid-ruid-suid/
- https://podalirius.net/fr/reverse-shells/unix-shells-dropping-suid-rights-in-shellcodes/

`int setuid(uid_t uid);`

```txt
Sets the euid (modifies the SUID binary's rights -> the only purpose is to drop privileges)
```

**system() calls bash, which drops privileges (euid<-rid)**

- bypass using a C wrapper
- bypass using `bash -p`
- bypass using `setreuid(geteuid(),geteuid())`

**Last method**:

`uid_t geteuid(void);`

```txt
Returns the SUID binary's effective uid -> as an attacker we want to set our rights, assigning: ruid <- euid
```

`int setreuid(uid_t ruid, uid_t euid);`
`int setresuid(uid_t ruid, uid_t euid, uid_t suid);`

```c
// use this
setreuid(geteuid(),geteuid())
setresuid(geteuid(),geteuid(),geteuid())
```

### Endianness

- https://pwnforfunandprofit.substack.com/p/the-single-byte-that-kills-your-exploit
- https://serverfault.com/questions/163487/how-to-tell-if-a-linux-system-is-big-endian-or-little-endian


## Segmentation & Architecture (MMU,TLB)

- https://www.root-me.org/fr/Documentation/Applicatif/Memoire-utilisation
- https://www.root-me.org/fr/Documentation/Applicatif/Memoire-segmentation
- https://beta.hackndo.com/rappels-d-architecture/
- https://www.0x0ff.info/2014/segmentation-memoire-buffer-overflow/

[Memory segmentation - memory_layout.c](memory_layout.c)

### ELF Format 

- [ELF Format Cheatsheet](https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779)

![](./images/segments_colored.png)
![](./images/elf_in_memory.png)

Source: https://reverse.zip/posts/introduction_au_reverse_partie_3/

#### ELF Magic numbers

- [How programs get run - lwn.net](https://lwn.net/Articles/631631/)
- https://docs.pwntools.com/en/stable/elf/elf.html
- https://eli.thegreenplace.net/2012/08/13/how-statically-linked-programs-run-on-linux


### Virtual vs Physical memory

- https://fr.wikipedia.org/wiki/Fragmentation_(informatique)
- https://fr.wikipedia.org/wiki/M%C3%A9moire_virtuelle
- https://fr.wikipedia.org/wiki/Gestionnaire_de_m%C3%A9moire_virtuelle


![](./images/Memoire_virtuelle.png)

- https://en.wikipedia.org/wiki/Memory_segmentation
- https://en.wikipedia.org/wiki/Memory_management_unit
- https://en.wikipedia.org/wiki/Page_table
- https://en.wikipedia.org/wiki/Translation_lookaside_buffer
- https://www.root-me.org/fr/Documentation/Applicatif/Memoire-segmentation
- https://stackoverflow.com/questions/41090469/linux-kernel-how-to-get-physical-address-memory-management

![](./images/virtual_memory.jpg)

#### Pages

```bash
cat /proc/<pid>/maps
cat /proc/self/maps
cat /proc/self/smaps
cat /proc/self/status
```

![](./images/pages.png)

#### Frames, Sections

**GEF/Pwndbg vmmap**

NB: `code(text)|bss|data|heap|stack|kernel(vvar,vdso,vsyscall)` (bss|data are not named like [stack]). Kernel land=50% of the program, accessible only in kernel mode, from 0xbfffffffff to 0xffffffffff.

![](./images/vmmap.png)
