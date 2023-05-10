## Doc :

- Vidéos/Plateformes/Docs: https://mksec.fr/tricks/pwn_ressources/

- https://ir0nstone.gitbook.io/notes/

- [Kernelmap interactive](https://makelinux.github.io/kernel/map/)

## Débuggers (pour binaires ELF (Linux), plus courants en pwn)

voir `../tutos` (cours/prog C)

- [gdb pour pwn](https://tc.gts3.org/cs6265/2019/tut/tut01-warmup1.html) , [gdb-gef](https://github.com/hugsy/gef)
- `r2`: https://github.com/radareorg/radare2

*Note*: gdb modifie l'environement en ajoutant $LINES $COLUMNS et le nom du prog avec un path absolu, le décalage n'est que dans la stack, pour corriger:

```bash
unset env LINES
unset env COLUMNS
```

voir aussi les outils sous `./windows`

## Stack et registres:

![](./pile.png)
![](./addresses.png)

## 32 vs 64 bits

En 32 bits, tous les paramètres sont poussés vers la pile avant que la fonction ne soit appelée.
En 64 bits, cependant, les 6 premiers sont stockés dans les registres RDI, RSI, RDX, RCX, R8 et R9 respectivement selon la convention d'appel (dépend de l'OS).
