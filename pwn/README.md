## Petits programmes

Doc : https://ir0nstone.gitbook.io/notes/

GDB:

- voir ../tutos (cours/prog C)

- [gdb pour pwn](https://tc.gts3.org/cs6265/2019/tut/tut01-warmup1.html)

## Stack et registres:

![](./pile.png)
![](./addresses.png)

## 32 vs 64 bits

En 32 bits, tous les paramètres sont poussés vers la pile avant que la fonction ne soit appelée.
En 64 bits, cependant, les 6 premiers sont stockés dans les registres RDI, RSI, RDX, RCX, R8 et R9 respectivement selon la convention d'appel (dépend de l'OS).
