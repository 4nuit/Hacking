## Gotchas

- https://wordsandbuttons.online/so_you_think_you_know_c.html

- https://www.stashofcode.fr/comment-marche-fonction-super-de-python/

## Android

- https://www.stashofcode.fr/developper-sur-android-sans-ide/

## Bash

### Loop

```bash
for e in $(seq 1 $(cat attack.txt |wc -l)); do echo $(sed -n $e"p" attack.txt) | base64 -d; done
```

### Timestamp

```bash
date -d "$(stat --printf=%y file.txt | cut -d. -f1)" +"%s"
```

## BDD, TDD, (DDD)

 - https://blog.ouidou.fr/d%C3%A9veloppement-pilot%C3%A9-par-les-tests-et-comportement-bdd-et-tdd-dbb5f332a463

## Challenges

[Discord Oauth2 (Nishacid)](https://nishacid.guru/fr/writeups/cheshire_cat/)

## Cours

- https://info-llg.fr

- https://training.zeropointsecurity.co.uk/collections?page=1 (rust,c# free)

### C++

- https://imagecomputing.net/damien.rohmer/teaching/inf443/practice/content/extra_c++/content/013_elements_de_langages/index.html

## Liens

[Bash,C,C++,Electronique,Git,Java,Json,Latex,Unix,MCU,OO,Outils,Python,Reseau,Web](https://gradot.wordpress.com/liens/)

- https://quickref.me/

- https://devhints.io/bash

## Livres

- https://pdos.csail.mit.edu/6.828/2014/readings/pointers.pdf

- https://goalkicker.com

- http://programming-motherfucker.com/become.html


### Shell, C, Multiprocesseurs, Ordonnancement, Mémoire virtuelle, Fichiers - Kernel

- https://sites.uclouvain.be/SystInfo/notes/Theorie/html/index.html

- https://539kernel.com/book/index.html

