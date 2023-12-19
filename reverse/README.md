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
	- `Mobsf.live`
	- `Virustotal`

- `Android Studio`: - https://developer.android.com/studio

- `Frida`: https://github.com/frida/frida/releases/tag/16.1.8

- `Ghidra` : https://ghidra-sre.org/ (clone d'après les sources du git)

- `UPX unpacker` : https://github.com/NozomiNetworks/upx-recovery-tool

- `Detect it Easy`: https://github.com/horsicq/Detect-It-Easy 

- https://www.decompiler.com/

- `DotNet` : https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

```powershell
Set-ExecutionPolicy unrestricted
.\dotnet-install.ps1
```

## Android 

### Outils

- https://www.virustotal.com/gui/home/upload

- https://mobsf.live/

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

## Windows

Reverse: décompilos:

- `DotPeek` : https://www.jetbrains.com/fr-fr/decompiler/ -> parfait pour du `.NET`
- `DnSpy` : https://github.com/dnSpy/dnSpy -> plus maintenu
- `ProcessExplorer` : https://learn.microsoft.com/fr-fr/sysinternals/downloads/process-explorer

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

- `ILSpy`: https://github.com/icsharpcode/AvaloniaILSpy

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

## Start - x86

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

## Debug foreign arch on x86

### Arm_Now (ARM,MIPS)

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

## Stack x86

- https://n-pn.fr/t/2431-la-pile-en-assembleur-x86

## Cmp bypass

- https://github.com/ariary/Hack-weak-strcmp-code

```bash
./chall `printf "non_ascii_password"`
```

## Ptrace bypass - (+Hook strcmp, func,..)

### Resume: catch syscall, set $(e)rax =0, ld_preload

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-dbg/
- https://nuculabs.dev/p/bypassing-ptrace-ld-preload
- https://github.com/ariary/simple_anti-debug_and_simple_bypasss

`fake_lib.c` :(ptrace,strcmp, etc)

```bash
# 32 bits
gcc -m32 fake_lib.c -o fake_lib.so -shared -fPIC
```

## Breakpoints bypass - 0xcc

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-bp/
- https://jaybailey216.com/debugging-stripped-binaries/

```bash
#symbols
#info functions
info file
x/15i <addresse_main>
```


## Packer (upx ici)

- https://reverseengineering.stackexchange.com/questions/3184/packers-protectors-for-linux

- https://mkaring.github.io/ConfuserEx/

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


