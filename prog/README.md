## BDD, TDD, (DDD)

 - https://blog.ouidou.fr/d%C3%A9veloppement-pilot%C3%A9-par-les-tests-et-comportement-bdd-et-tdd-dbb5f332a463

## Cours

- https://info-llg.fr

- https://training.zeropointsecurity.co.uk/collections?page=1 (rust,c# free)

## Liens

[Bash,C,C++,Java](https://gradot.wordpress.com/liens/)

- https://mksec.fr/tricks/c_pointeurs/

```c
int a = 2;
int *p;
p = &a;
```

eq

``
int *p = &a;
```

- https://quickref.me/

- https://devhints.io/

- https://learnxinyminutes.com/

### ASM (2 méthodes:libc ou syscalls -> cette dernière est retenue)

- https://youtu.be/uDkW8bQt1Rc
- https://zestedesavoir.com/articles/130/programmez-en-langage-dassemblage-sous-linux/
- https://stackoverflow.com/questions/30036738/assembly-set-directive-gives-error-invalid-operands-data-and-und-sections

#### Nasm elf32/64

- https://en.wikibooks.org/wiki/X86_Assembly/Data_Transfer#Operands
- https://en.wikibooks.org/wiki/X86_Assembly/NASM_Syntax

#### As arm32/aarch64

- https://armasm.com/docs/
- https://kerseykyle.com/articles/ARM-assembly-hello-world
- https://peterdn.com/post/2020/08/22/hello-world-in-arm64-assembly/

```bash
sudo pacman -S nasm arm-linux-gnueabi-binutils arm-linux-gnueabi-gcc aarch64-linux-gnu-gcc aarch64-linux-gnu-binutils aarch64-linux-gnu-gcc
make
./helloworld_x86 && ./helloworld_x86_64
qemu-arm ./hellworld_arm32
qemu-aarch64 ./helloworld_aarch64
```

### Questions/remarques ARM vs x86

- Pourquoi ne pas mettre de '#' (immediate) ne change rien

```bash
[root@alarm ~]# as -o helloworld.o helloworld.s 
[root@alarm ~]# ld -o helloworld helloworld.o
[root@alarm ~]# ./helloworld 
Hello World
[root@alarm ~]# diff old_helloworld helloworld
```

- Pourquoi mettre un mov ne fonctionne pas (`ldr`) alors qu'on pourrait loader avec `lea` en x86

### Android

- https://www.stashofcode.fr/developper-sur-android-sans-ide/

### Bash

- https://blog.robertelder.org/bash-one-liner-compose-music/

```bash
# basic loop
for e in $(seq 1 $(cat attack.txt |wc -l)); do echo $(sed -n $e"p" attack.txt) | base64 -d; done

# timestamp
date -d "$(stat --printf=%y file.txt | cut -d. -f1)" +"%s"
```
### C

- https://c-faq.com/
- https://drive.google.com/drive/folders/16FnbMmbfreb2SJX0px-5ce5KFq0Pjd1M

### C++

- https://eel.is/c++draft/
- https://caiorss.github.io/C-Cpp-Notes/WindowsAPI-cpp.html

### Rust

- https://cheats.rs/
- https://learning-rust.github.io/

## Livres

- https://pdos.csail.mit.edu/6.828/2014/readings/pointers.pdf

- https://goalkicker.com

- http://programming-motherfucker.com/become.html


## Memos - Quizz

- https://wordsandbuttons.online/so_you_think_you_know_c.html

- https://www.stashofcode.fr/comment-marche-fonction-super-de-python/

### Shell, C, Multiprocesseurs, Ordonnancement, Mémoire virtuelle, Fichiers - Kernel

- https://sites.uclouvain.be/SystInfo/notes/Theorie/html/index.html

- https://539kernel.com/book/index.html

