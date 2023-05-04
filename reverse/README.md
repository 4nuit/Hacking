# Quelques outils:

À posséder:

- En ligne:
	- `Dogbolt (decompiler explorer)`: compare le pseudo code source de différents outils (Ghidra, Hex Rays, Ida, Binary Ninja) rapidement
	- `Disassembler.io`

- `Ghidra` : https://ghidra-sre.org/ (clone d'après les sources du git)

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

Débuggers:

- `gdb`: [gef](https://github.com/hugsy/gef)
- `r2`: https://github.com/radareorg/radare2
- `x64dbg` (windows)

## Bytecode :

- Python: `uncompyle`
- Java: `jadx`
- Android: `jadx`, `apktool`, `adb`
