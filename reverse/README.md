# Prérequis

- https://fr.wikibooks.org/wiki/Fonctionnement_d'un_ordinateur

## Doc

- https://reverse.zip/
- https://www.begin.re
- https://dmz.torontomu.ca/wp-content/uploads/2020/12/Reverse-Engineering-101.pdf

- https://bbinfosec.medium.com/reverse-engineering-resources-beginners-to-intermediate-guide-links-f64c207505ed
- https://www.slideshare.net/AmandaRousseau1/what-can-reverse-engineering-do-for-you
- https://forum.tuts4you.com/files/file/1307-lenas-reversing-for-newbies/
- https://tmpout.sh

- [Plateforme Crackme.one](https://crackmes.one)
- `Awesome Reversing +`:  https://github.com/wtsxDev/reverse-engineering

## Outils

- https://docs.remnux.org/
- https://cloud.google.com/blog/topics/threat-intelligence/flare-vm-the-windows-malware?hl=en

## Références

- https://syscall.sh/, https://syscalls.mebeim.net/?table=x86/64/x64/v6.6
- https://blog.quarkslab.com/
- https://www.youtube.com/@StephenChapman
- https://m.youtube.com/c/oalabs

## Quelques outils (outils généraux d'analyse statique, décompilateurs):

À posséder:

- En ligne:
	- https://dogbolt.org/      : compare le pseudo code source de différents outils (Ghidra, Hex Rays, Ida, Binary Ninja) rapidement
	- https://disassembler.io/
	- https://mobsf.live/
        - https://appetize.io/      : permet d'éxécuter une app android dans une sandbox rapidement
	- https://www.virustotal.com/gui/
       
- `Detect it Easy`: https://github.com/horsicq/Detect-It-Easy

- `Adb`
- `Binary Ninja`: https://binary.ninja/ (**x86/64 asm**, **armv7**) 
- `Ghidra` : https://ghidra-sre.org/ (**x86/64 C**, **arm32**, **mips** -> other arch), https://ghidra-sre.org/CheatSheet.html
- `Lief`: https://lief-project.github.io
- `UPX unpacker` : https://github.com/NozomiNetworks/upx-recovery-tool
- `z3`: https://theory.stanford.edu/~nikolaj/programmingz3.html

## Game Hacking

- https://gamehacking.academy
- https://lsdsecdaemon.com/game-hacking-links-repo/
- https://www.docdroid.net/rtoAc2n/game-hacking-pdf#page=87
- https://www.kodeco.com/36285673-how-to-reverse-engineer-a-unity-game
- https://0x64marsh.com/?p=689
- https://github.com/imadr/Unity-game-hacking

## Linux (point dentrée pour débuter)

- https://zestedesavoir.com/articles/97/introduction-a-la-retroingenierie-de-binaires/
- https://github.com/4nuit/Systeme_Exploitation/blob/master/TP5/Debugging_Kernel_TP_User.pdf

Outils classiques:

- `objdump`:
	`-t` : afficher la table des symboles -> si rien : voir ../../pwn/asm
	`-h`: afficher les sections

- `ltrace`: voir les fonctions de la libc appelées

```bash
#fin de chaine -> \0
ltrace -s 128 
```

- `strace`: voir les syscalls

- `ldd`: voir les bibliothèques/libc utilisées (Hijacking, [ret2libc](../pwn/stack/ret2libc)

- `Ghidra`

**Pseudo-code**:

```c
*(byte *)(local_a0 + uVar5) = *pbVar4 ^ *(byte *)(local_a0 + uVar3);
```

**Code pas décompilé**:

- https://blog.ret2.io/2017/11/16/dangers-of-the-decompiler/
- sélectionner l'asm
- puis appuyer sur `D` ou `CTRL-D`

-> savoir corriger les types (char), logique du code (boucles,tableaux), regarder l'asm (strings ascii)

- `ILSpy (.NET)`: https://github.com/icsharpcode/AvaloniaILSpy

**Chercher le code à une certaine addresse**:

- comme IDA, appuyer sur `G`

Débuggers:

- `gdb`: [gef](https://github.com/hugsy/gef)
- `r2`: https://github.com/radareorg/radare2

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

### Anti Debug

- https://www.codeproject.com/articles/30815/an-anti-reverse-engineering-guide

### Asm , Segmentation, Offset , Addressing Modes & Calling Convention (Saved Registers)

- https://www.developpez.net/forums/d1497/autres-langages/assembleur/qu-qu-offset/
- https://beuss.developpez.com/tutoriels/pcasm/
- https://zestedesavoir.com/articles/130/programmez-en-langage-dassemblage-sous-linux/
- https://drive.google.com/drive/folders/16FnbMmbfreb2SJX0px-5ce5KFq0Pjd1M
- https://beta.hackndo.com/assembly-basics/

#### Memo

- https://stackoverflow.com/questions/9268586/what-are-callee-and-caller-saved-registers
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

## Programmation asm - ARM like

[FCSC - VM](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/intro/comparaison)

## Hello world (x86,x64,arm32,aarch64)

Voir `../prog`:

[prog](../prog)

```asm
;https://x64.syscall.sh/

global _start:

section .rodata:
	helloworld db "Hello World", 10, 0	; declare bytes "Hello world\n\0"
	helloworld_len equ $-helloworld		; gets len with $-

section .text:

_start:						; ssize_t write(int fildes, const void *buf, size_t nbyte) (man 3 write)
	mov eax, 4				; syscall write
	mov ebx, 1				; arg0, stdout
	mov ecx, helloworld			; arg1, string
	mov edx, helloworld_len			; arg2, len
	int 0x80				; writes hellworld on stdout
	jmp _exit

_exit:
	mov eax, 1				; syscall exit
	mov ebx, 1				; arg0, error code (139 segfault if we did not exit
	int 0x80				; clean exit
```

```bash
nasm -f elf32 -o helloworld_x86.o helloworld_x86.s
ld -m elf_i386 -o helloworld_x86 helloworld_x86.o
```

### Memo -Comparison between some ASM lang

- https://www.cs.uaf.edu/2011/spring/cs641/lecture/02_10_assembly.html
- https://syscalls.mebeim.net/?table=x86/64/x64/v6.6

### 32 vs 64 bits calling conventions

- https://beta.hackndo.com/conventions-d-appel/

```
----------------------------------
|            |  x86  | x64 | arm |
----------------------------------
| ret val reg|  eax  | rax | r0  |
----------------------------------
|   1st arg  |[eax+4]| rsi | r0  |
----------------------------------
|   2nd arg  |[eax+8]| rdi | r1  |
----------------------------------
|    call    |int0x80| call| bl  |
----------------------------------
|  func ret  |  ret  | ret | bxlr|
----------------------------------
|  stack pt  |  esp  | rsp | sp  |
----------------------------------
|  mem load  |  mov  | mov | ldr |
----------------------------------
|  mem store |  mov  | mov | str |
----------------------------------
```

### C/C++

- https://en.wikipedia.org/wiki/Virtual_function
- https://en.wikipedia.org/wiki/Virtual_method_table
- https://alschwalm.com/blog/static/2016/12/17/reversing-c-virtual-functions/

### Start - x86

- [UD2 bug](https://github.com/NationalSecurityAgency/ghidra/issues/4113)

*call function*

```bash
starti
jump *0x... #addresse print_flag()
```

ou 

```bash
b *main
r
p *(char) printFlag()
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

- https://n-pn.fr/t/2431-la-pile-en-assembleur-x86

### Cmp bypass

- https://github.com/ariary/Hack-weak-strcmp-code

```bash
./chall `printf "non_ascii_password"`
./chall "`python2 -c 'print "non_ascii_password"'`"
```

### Ptrace bypass - (+Hook strcmp, func,..)

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-dbg/
- https://nuculabs.dev/p/bypassing-ptrace-ld-preload
- https://github.com/ariary/simple_anti-debug_and_simple_bypasss
- https://t-a-w.blogspot.com/2007/03/how-to-code-debuggers.html

`fake_lib.c` :(ptrace,strcmp, etc)

```c
#gcc -m32 fake_lib.c -o fake_lib.so -shared -fPIC
long ptrace(int request, int pid, void *addr, void *data) {
  return 0;
}

int strcmp(const char* s1, const char* s2, int i){
  //printf("%s\n",s1);
  //printf("%s\n",s2);
  return 0;
}
```

### Breakpoints bypass - 0xcc

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

### Equations / Keygen solver - z3

- Keygen: Coder un programme recréeant un clé, celle-ci étant utilisée par le crackme/keygen pour la résolution.

Rajouter sol CTF z3

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

## Angr (voir z3 plus haut)

Exemple typique: résoudre un crackme connaissant 2 addresses (**find**,avoid**)
(en explorant chaque CFG et résolvant un système)

![angr](./angr_basique.py)

- https://shoxxdj.fr/angr-basics/
- https://github.com/jakespringer/angr_ctf
- https://github.com/angr/angr-doc/blob/master/CHEATSHEET.md

## Bytecode :


- Python: `uncompyle6`, https://github.com/SuperStormer/pyasm
- [pycdc](https://github.com/zrax/pycdc], [pyinstxtractor](https://github.com/extremecoders-re/pyinstxtractor)

  - https://github.com/pyenv/pyenv
  - https://reverseengineering.stackexchange.com/questions/1999/what-are-the-tools-to-analyze-python-obfuscated-bytecode

```bash
#pseudo code (peut ne pas marcher)
~/pycdc/build/pycdc chall.pyc

#bytecode
~/pycdc/build/pycdas chall.pyc
```
- Java: `jadx`
- Android: `jadx`, `apktool`, `adb`
- Rust: https://github.com/h311d1n3r/Cerberus

## Obfuscation

- https://github.com/KhanhNguyen9872/deobf_pyobfuscate.com

### Packer (upx ici)

- https://reverseengineering.stackexchange.com/questions/72/unpacking-binaries-in-a-generic-way

- https://reverseengineering.stackexchange.com/questions/3184/packers-protectors-for-linux

- https://mkaring.github.io/ConfuserEx/

### QEMU - Debug foreign arch on x86

- https://azeria-labs.com/the-importance-of-deep-work-the-30-hour-method-for-learning-a-new-skill/
- https://ariadne.space/2021/05/05/using-qemu-user-emulation-to-reverse-engineer-binaries/
- https://www.mathyvanhoef.com/2013/12/reversing-and-exploiting-arm-binaries.html
- https://github.com/andrew-d/static-binaries


#### MultiArch

Une fois la vm QEMU/KVM **LibVirt** installée (voir plus loin):

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

![](./Libvirt.gif)

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

Compiler :

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
gdb-multiarch -q --nh \
  -ex 'set architecture arm' \
  -ex 'set sysroot /usr/arm-linux-gnueabihf' \
  -ex 'file hello_world' \
  -ex 'target remote localhost:1234' \
  -ex 'break main' \
  -ex continue \
  -ex 'layout split'
```

#### MIPS

https://pr0cf5.github.io/ctf/2019/07/16/mips-userspace-debugging.html

#### RiscV

https://danielmangum.com/posts/risc-v-bytes-qemu-gdb/#installing-tools


### Qiling - Alternative to Qemu-User

- https://github.com/qilingframework/qiling
- https://github.com/qilingframework/rootfs

### Miasm - Another RE framework

- https://github.com/cea-sec/miasm

## Android

### Doc

- https://medium.com/purplebox/step-by-step-guide-to-building-an-android-pentest-lab-853b4af6945e

### Outils

- `Android Studio`: - https://developer.android.com/studio

- `Frida`: https://github.com/frida/frida/releases/tag/16.1.8

- `Waydroid`: https://docs.waydro.id/usage/install-and-run-android-applications 

- `Corriger binder waydroid`: https://github.com/choff/anbox-modules

```bash
waydroid init
```

- https://www.virustotal.com/gui/home/upload

- https://mobsf.live/

### Exercices & Corrections

- https://mobisec.reyammer.io/slides

- https://www.ragingrock.com/AndroidAppRE/ -> **ThaiCamera,FotaProvider,Mediacode corrigés**

- https://www.evilsocket.net/2017/04/27/Android-Applications-Reversing-101/

**Corrections**

[ThaiCamera](./ragingrock/ThaiCamera/README.md)

[FotaProvider](./ragingrock/FotaProvider/README.md)

[MediaCode](./ragingrock/MediaCode/README.md)

### Structure (statique)

- `Manifest`

Exemple de permissions d'une application malveillante

```xml
<?<xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" android:versionCode="2" android:versionName="1.2" package="com.cp.camera" platformBuildVersionCode="23" platformBuildVersionName="6.0-2704002">
    <uses-sdk android:minSdkVersion="15" android:targetSdkVersion="23"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.CAMERA"/>
```

- `Code`

- `Ressources`


Point d'entrée:

- `Launcher Activity`

```java
android.intent.category.LAUNCHER
```

Une application malveillante peut accéder aux données de cette application et éxécuter du code:

```bash
- com.my.appstore.search
	com.app.myfolder.activity.FoldersSearchActivity

- android.intent.action.AdupsFota.WriteCommandReceiver
	com.adups.fota.sysoper.WriteCommandReceiver
```

### Android Studio (dynamique)

- https://developer.android.com/studio/command-line/adb?hl=fr

- https://braincoke.fr/blog/2021/03/android-reverse-engineering-for-beginners-frida/#static-analysis-reminder


```bash
# Si téléphone éteint - run Thaicamera échoue
rm ~/.android/avd/Pixel_5_API_31.avd/*.lock
```

![adb](./adb.png)

**Hook avec Frida**

Dans le répertoire d'un projet APK dans Android Studio:

```bash
wget https://github.com/frida/frida/releases/download/16.1.8/frida-inject-16.1.8-android-x86_64.xz #choisir l'architecture en fonction du tel émulé
xz -d *gz
```

Créer `exploit.js`:

```js
var a = MainActivity.a;
a.overload('java.lang.String').implementation = function() {
    code.
}
```

Exemple:

```js
Java.perform(function () {
        var main_activity = Java.use("com.example.<application/projet>.<Main (sans smali)>");
        main_activity.<main_method>.overload("java.lang.String").implementation = function(var0) {
        var decrypt = this.<main_method>(var0);
   console.log("FLAG: " + decrypt);
        }
});
```

Avec ADB:

```bash
adb devices
adb shell
adb shell pm list packages -f
adb shell pm uninstall --user 0 com.facebook.services
adb install tp.apk 
adb shell am start -n com.hack_apk.main/.MainActivity --em "key" "test"
```

```
adb push exploit.js /data/local/tmp
adb push frida-inject-16.1.8-android-x86_64 /data/local/tmp #depend de l'arch du tel choisi
```

```bash
adb shell "ps -A | grep <nom application/projet>"
adb shell "/data/local/tmp/frida-inject* -p <PID obtenu>   -s exploit.js"
```

## Macos

Outils

- https://github.com/darlinghq/darling
- https://github.com/kholia/OSX-KVM

## Windows

Outils classiques

- `Wine`
- `x64dbg` (windows)

https://learn.microsoft.com/fr-fr/sysinternals/downloads

- [ListDlls](https://learn.microsoft.com/fr-fr/sysinternals/downloads/listdlls)
- [ProcessExplorer](https://learn.microsoft.com/fr-fr/sysinternals/downloads/process-explorer)
- [ProcMon](https://learn.microsoft.com/fr-fr/sysinternals/downloads/procmon)
- [x64dbg](https://x64dbg.com/)

### .NET

- https://fr.wikipedia.org/wiki/Common_Intermediate_Language

- `DotNet` : https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

```powershell
Set-ExecutionPolicy unrestricted
#or
powershell -NoProfile -ExecutionPolicy unrestricted -Command ...
.\dotnet-install.ps1
```

- `DotPeek` : https://www.jetbrains.com/fr-fr/decompiler/ -> parfait pour du `.NET`
- `DnSpy` : https://github.com/dnSpy/dnSpy -> plus maintenu

## Malware development (windows)

- https://0xpat.github.io/ (9 parts)

## RunPE - Process Hollowing

- https://red-team-sncf.github.io/complete-process-hollowing.html

