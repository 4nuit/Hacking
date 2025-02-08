# Vulnérabilités sur la pile

- Voir `../asm`

On parle souvent de `ret` pour l'instruction asm de **retour** d'une fonction.
Contrôler vers quoi on retourne revient à contrôler `eip` (le pointeur d'instructions en x86 32bits):

Dans "l'ordre":

- ret2win (appeler une fonction qui pop un shell, cat un password etc)
- retlibc (utiliser la libc du programme pour appeler system())
- rop (return oriented programming)

Les démos sont faites d'après : https://ir0nstone.gitbook.io/notes/

## Alignement & x64 MOVABS Issue

- https://ropemporium.com/guide.html => **common pitfalls**
- https://www.felixcloutier.com/x86/movaps
- https://stackoverflow.com/questions/1061818/stack-allocation-padding-and-alignment
- https://gist.githubusercontent.com/dmur1/9bf25015f731f99f94ab5882e48de66d/raw/b78c267f9234dbe57c197dab0c51c508384f0be9/5202c515_go.py

## Pivot

![](../images/pivot.png)
