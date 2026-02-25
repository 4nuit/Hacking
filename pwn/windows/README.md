## Doc

- https://github.com/nop-tech/OSED/
- https://j00ru.vexillium.org/syscalls/nt/64/
- [WinDBG cheatsheet - Reversing bits](https://github.com/mohitmishra786/reversingBits/blob/main/src/windbg.md)
- https://web.archive.org/web/20120720135045/http://www.ghostsinthestack.org/article-24-buffer-overflows-sous-xp-sp2.html

## Tools (Debug)

- https://github.com/leesh3288/WinPwn
- https://github.com/ptr-yudai/ptrlib
- https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/getting-started-with-windbg

## Debuggers:

- `x32/64dbg`: https://x64dbg.com/

- `ollydbg`: https://www.ollydbg.de/

- `Windbg (GUI) / cdb (CLI)` : cdb32/cdb64 : https://www.codeproject.com/Articles/6469/Debug-Tutorial-Part-1-Beginning-Debugging-Using-CD
	- `cdb32 prog.exe`: débugger prog.exe
	- `u` : afficher fonctions
	- `g`: run programme
	- `bp 0x1`: mettre un point d'arrêt à 0x1
	- `p` : afficher registres
	- `d % 0x1`: afficher contenu 0x1

- `cutter` : https://cutter.re/docs/index.html

- `edb` : https://github.com/eteran/edb-debugger

- `radare2` : https://book.rada.re/debugger/intro.html

### Using winedbg

```bash
$ winedbg --gdb --no-start cmd.exe
0022:0023: create process 'C:\windows\system32\cmd.exe'/0x110760 @0x7ece8b70 (0<0>)
0022:0023: create thread I @0x7ece8b70
target remote localhost:12345

$ gdb -quiet
(gdb) target remote localhost:12345
Remote debugging using localhost:47152
0x7b85d4b0 in ?? ()
(gdb) c
Continuing.
```

