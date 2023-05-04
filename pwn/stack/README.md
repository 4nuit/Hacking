# Vulnérabilités sur la pile

- Voir `../asm`

On parle souvent de `ret` pour l'instruction asm de **retour** d'une fonction.
Contrôler vers quoi on retourne revient à contrôler `eip` (le pointeur d'instructions en x86 32bits):

Dans "l'ordre":

- ret2win (appeler une fonction qui pop un shell, cat un password etc)
- retlibc (utiliser la libc du programme pour appeler system())
- rop (return oriented programming)

Les démos sont faites d'après : https://ir0nstone.gitbook.io/notes/
