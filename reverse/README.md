# Doc reverse:

- https://reverse.zip/posts/introduction_au_reverse_partie_16/
- https://www.begin.re
- https://www.stashofcode.fr/developper-sur-android-sans-ide/
- https://bbinfosec.medium.com/reverse-engineering-resources-beginners-to-intermediate-guide-links-f64c207505ed
- https://www.slideshare.net/AmandaRousseau1/what-can-reverse-engineering-do-for-you
- https://forum.tuts4you.com/files/file/1307-lenas-reversing-for-newbies/
- https://tmpout.sh
- https://red-team-sncf.github.io/complete-process-hollowing.html

- [Plateforme Crackme.one](https://crackmes.one)
- `Awesome Reversing +`:  https://github.com/wtsxDev/reverse-engineering

## Références

- https://syscall.sh/

- https://blog.quarkslab.com/

- https://www.youtube.com/@StephenChapman

- https://m.youtube.com/c/oalabs

## Quelques outils (outils généraux d'analyse statique, décompilateurs):

À posséder:

- En ligne:
	- `Dogbolt (decompiler explorer)`: compare le pseudo code source de différents outils (Ghidra, Hex Rays, Ida, Binary Ninja) rapidement
	- `Disassembler.io`
	- `Mobsf.live`
	- `Virustotal`

- `Detect it Easy`: https://github.com/horsicq/Detect-It-Easy

- `Ghidra` : https://ghidra-sre.org/

- `Lief`: https://lief-project.github.io

- `UPX unpacker` : https://github.com/NozomiNetworks/upx-recovery-tool

- `z3`: https://theory.stanford.edu/~nikolaj/programmingz3.html

- `QEMU`

## Linux

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

- sélectionner l'asm
- puis appuyer sur `D` ou `CTRL-D`

-> savoir corriger les types (char), logique du code (boucles,tableaux), regarder l'asm (strings ascii)

- `ILSpy (.NET)`: https://github.com/icsharpcode/AvaloniaILSpy

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

### Asm

- https://aur.archlinux.org/packages/riscv64-unknown-elf-gcc
- https://zestedesavoir.com/articles/130/programmez-en-langage-dassemblage-sous-linux/

### Memo -Comparison between some ASM lang

- https://www.cs.uaf.edu/2011/spring/cs641/lecture/02_10_assembly.html

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

```bash
#symbols
#info functions
info file
x/15i <addresse_main>
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

- https://shoxxdj.fr/angr-basics/
- Challenges: https://github.com/jakespringer/angr_ctf

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
- Unity: https://github.com/imadr/Unity-game-hacking#unity-game-folder-structure

### Packer (upx ici)

- https://reverseengineering.stackexchange.com/questions/3184/packers-protectors-for-linux

- https://mkaring.github.io/ConfuserEx/

### QEMU - Debug foreign arch on x86

- https://ariadne.space/2021/05/05/using-qemu-user-emulation-to-reverse-engineer-binaries/
- https://www.mathyvanhoef.com/2013/12/reversing-and-exploiting-arm-binaries.html

`Arm_Now (ARM (32 bits + aarch/64 bits),MIPS)`

- https://github.com/nongiach/arm_now/wiki

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

## Android

### Outils

- `Android Studio`: - https://developer.android.com/studio

- `Frida`: https://github.com/frida/frida/releases/tag/16.1.8

- https://www.virustotal.com/gui/home/upload

- https://mobsf.live/

### Exercices & Corrections

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
<?xml version="1.0" encoding="utf-8"?>
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

- `DotNet` : https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

```powershell
Set-ExecutionPolicy unrestricted
#powershell -NoProfile -ExecutionPolicy unrestricted -Command ...
.\dotnet-install.ps1
```

- `DotPeek` : https://www.jetbrains.com/fr-fr/decompiler/ -> parfait pour du `.NET`
- `DnSpy` : https://github.com/dnSpy/dnSpy -> plus maintenu

## Game Hacking

- https://www.docdroid.net/rtoAc2n/game-hacking-pdf#page=87
- https://www.kodeco.com/36285673-how-to-reverse-engineer-a-unity-game
- https://0x64marsh.com/?p=689


