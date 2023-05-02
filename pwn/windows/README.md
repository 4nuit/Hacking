# Debug / Pwn windows

## Debuggers:

- `cdb` : cdb32/cdb64 : https://www.codeproject.com/Articles/6469/Debug-Tutorial-Part-1-Beginning-Debugging-Using-CD
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

