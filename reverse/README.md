# Quelques outils:

- `Dogbolt`
- `Disassembler.io`

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

## Bytecode :

- Python: `uncompyle`
- Java: `jadx`
- Android: `jadx`, `apktool`, `adb`
