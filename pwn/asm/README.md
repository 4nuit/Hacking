# Notions

- [Nasm elf64 - Regitres + Helloworld + Debug (Opcode)](https://youtu.be/uDkW8bQt1Rc)

Utilités:

- être plus à l'aise en pwn et surtout reverse pour comprendre les instructions désassembIées (ghidra, cutter etc) -> **débugger des binaires sans symboles**
- faire ses propres shellcodes

- https://beta.hackndo.com/assembly-basics/

## Programmation asm - ARM like

[FCSC - VM](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/intro/comparaison)

## Memo

- https://www.developpez.net/forums/d1497/autres-langages/assembleur/qu-qu-offset/
- https://stackoverflow.com/questions/9268586/what-are-callee-and-caller-saved-registers
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

## Prologue fonction (intel x86, 32bits)

```asm
push ebp		; Décrémenter ESP de 4 octets et empiler le pointeur de base de la pile du programme appelant
mov esp, ebp		; Faire de ESP le nouveau pointeur de base de la pile
sub esp, N		; Réserver de l'espace dans la pile pour les variables locales
```

Vision équivalente de la pile:

```
0        +-----------+
        |           |
        ...
        +-----------+ <- ESP
        | Locales   |
        +-----------+ <- EBP
        | EBP       |
        +-----------+
        | EIP       |
        +-----------+
        | Arguments |
N        +-----------+
```

## Épilogue

```asm
mov esp, ebp		; Faire de ESP le nouveau pointeur de base de la pile
pop ebp			; Retire l’élément au sommet de la pile, et l’assigne à la valeur passée en argument
			; En fait on fait une **sauvegarde eip**
ret			; Retour de la fonction
```

