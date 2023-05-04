# Notions

Utilités:

- être plus à l'aise en pwn et surtout reverse pour comprendre les instructions désassembIées (ghidra, cutter etc) -> **débugger des binaires sans symboles**
- faire ses propres shellcodes

https://beta.hackndo.com/assembly-basics/

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

# Programmation asm

[FCSC - VM](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/intro/comparaison)
