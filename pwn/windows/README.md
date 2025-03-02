## Doc

- https://quasarpwn.github.io/blog/windows%20exploitation%20introduction/
- [WinDBG cheatsheet - Reversing bits](https://github.com/mohitmishra786/reversingBits/blob/main/src/windbg.md)

## Outils (Debug)

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

## Débug sans symboles:

Voir **../asm**

