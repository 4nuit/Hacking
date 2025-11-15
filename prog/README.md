## Doc

- https://blog.quentinra.dev
- https://github.com/keon/awesome-bits
- https://graphics.stanford.edu/~seander/bithacks.html
- [What every programmer should know about memory - lwn.net](https://lwn.net/Articles/250967/)
- https://training.zeropointsecurity.co.uk/collections?page=1 (rust,c# free)
- https://github.com/codecrafters-io/build-your-own-x/

### Livres

- https://goalkicker.com
- http://programming-motherfucker.com/become.html
- https://github.com/EbookFoundation/free-programming-books
- https://pdos.csail.mit.edu/6.828/2014/readings/pointers.pdf

### Cheatsheets

- https://github.com/dwmkerr/hacker-laws
- https://github.com/hemanth/functional-programming-jargon
- https://github.com/kamranahmedse/design-patterns-for-humans
- https://github.com/arialdomartini/Back-End-Developer-Interview-Questions

## Challenges

- https://projecteuler.net/
- https://www.france-ioi.org/
- https://www.codewars.com/
- https://leetcode.com/
- https://www.codingame.com/start/

## Data Structures & Algorithms

[algo_data_structures](./algo_data_structures)

## Design Patterns

[design_patterns](./design_patterns)

## Outils

- https://grep.app/
- https://github.com/jdx/mise/
- https://codesandbox.io/embed/new?codemirror=1/

**Challenges**

- https://www.codewars.com/
- https://leetcode.com/
- https://www.codingame.com/start/

## Cheatsheets

### Languages

- https://quickref.me/
- https://devhints.io/
- https://learnxinyminutes.com/

### Regexp

- https://ihateregex.io
- https://regex101.com

### Memos

[C common pitfalls (pointers,alignement,value & references passing)](./c_memo)

- https://ss64.com/
- https://wordsandbuttons.online/so_you_think_you_know_c.html
- https://wordsandbuttons.online/static_typing_isnt_free.html
- https://paragonie.com/blog/2016/02/how-safely-store-password-in-2016
- https://stackoverflow.com/questions/36347/what-are-the-differences-between-generic-types-in-c-and-java

`A reference works as a pointer. A reference is declared as an alias of a variable. It stores the address of the variable`

![](https://maxnilz.com/images/lang/moderncpp/reference-layout.png)

```
Reference can be treated as a const pointer. It has to be initialized during declaration, and its content cannot be changed
A reference allows you to manipulate an object using pointer, but without the pointer syntax of referencing and dereferencing.
```

Function call => copy of the argument on the stack

- Passed by value : dont modify the argument (treated like a value) after ret  
- Passed by address/ptr or reference: modify the argument (treated like a reference) after ret

```
Object references are passed by value.
Java works exactly like C. You can assign a pointer, pass the pointer to a method, follow the pointer in the method and change the data that was pointed to. However, you cannot change where that pointer points.
```

### Shell, C, Multiprocesseurs, Ordonnancement, Mémoire virtuelle, Fichiers - Kernel

- https://sites.uclouvain.be/SystInfo/notes/Theorie/html/index.html
- https://539kernel.com/book/index.html


### Equations

- https://stackoverflow.com/questions/62599169/solving-systems-of-equations-modulo-a-certain-number-with-or-without-numpy
- https://docs.sympy.org/latest/guides/solving/solve-matrix-equation.html
- https://speakerdeck.com/milkmix/using-z3-to-solve-crackme

## Compilation

- https://andreil26.github.io/me/uniprojects/2019/06/21/lexer_parser.html

### ASM (2 méthodes:libc ou syscalls -> cette dernière est retenue)

- https://youtu.be/uDkW8bQt1Rc
- https://zestedesavoir.com/articles/130/programmez-en-langage-dassemblage-sous-linux/
- https://stackoverflow.com/questions/30036738/assembly-set-directive-gives-error-invalid-operands-data-and-und-sections
- https://asmtutor.com
- https://flint.cs.yale.edu/cs421/papers/x86-asm/asm.html

#### Nasm elf32/64

- https://en.wikibooks.org/wiki/X86_Assembly/Data_Transfer#Operands
- https://en.wikibooks.org/wiki/X86_Assembly/NASM_Syntax
- https://sonictk.github.io/asm_tutorial

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

### Syscall - All Asm

- https://syscalls.mebeim.net/?table=x86/64/x64/v6.6

### Android

- https://www.stashofcode.fr/developper-sur-android-sans-ide/

### Bash

- https://explainshell.com/explain
- https://mywiki.wooledge.org/BashFAQ
- https://en.wikibooks.org/wiki/Bash_Shell_Scripting
- https://blog.robertelder.org/bash-one-liner-compose-music/

```bash
# basic loop
for e in $(seq 1 $(cat attack.txt |wc -l)); do echo $(sed -n $e"p" attack.txt) | base64 -d; done

# timestamp
date -d "$(stat --printf=%y file.txt | cut -d. -f1)" +"%s"
```

### C

- https://c-faq.com/
- https://en.wikipedia.org/wiki/C_data_types
- https://beej.us/guide/bgc/html/split/index.html
- [What every programmer should know about C - LLVM](https://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html)
- https://github.com/codr7/hacktical-c
- https://brennan.io/2015/01/16/write-a-shell-in-c/
- https://blog.abhi.host/blog/2010/04/15/very-simple-http-server-writen-in-c/

### C++

- https://eel.is/c++draft/
- https://cours-cpp.gitbook.io/resources
- https://maxnilz.com/docs/005-lang/moderncpp/
- https://dubrayn.github.io/IPS-DEV/cppfiles.html#5
- https://github.com/federico-busato/Modern-CPP-Programming
- https://zestedesavoir.com/tutoriels/822/la-programmation-en-c-moderne/

#### Templates, Lambdas (functionnal modern cpp)

- https://en.cppreference.com/w/cpp/language/templates
- https://en.cppreference.com/w/cpp/language/lambda
- https://openclassrooms.com/fr/courses/7137751-programmez-en-oriente-objet-avec-c/7533236-creez-des-templates

### C#

- https://perso.esiee.fr/~perretb/I3FM/POO1/classeobj/index.html

### Go

- https://gobuffalo.io/

### Java

- https://stackoverflow.com/questions/40480/is-java-pass-by-reference-or-pass-by-value

`The use of the term "reference" in Java is very misleading and is what causes most of the confusion here. What they call "references" act/feel more like what we'd call "pointers" in most other languages.`

- https://www.w3schools.com/java/default.asp
- https://github.com/kittylyst/javanut8
- https://abrillant.developpez.com/tutoriel/java/design/pattern/introduction/
- https://www.baeldung.com/java-dto-pattern
- https://docs.oracle.com/javase/tutorial/collections/streams/parallelism.html
- [Head First Java](https://docs.google.com/file/d/0BwxUBHTpU9kCU0xubVhyYlp0bWc/view?resourcekey=0-sk68B4dt12P8MPoLieNBBA)
- https://gokan-ekinci.developpez.com/tutoriels/java/introduction-bien-debuter-avec-maven/#LI

### Node

- https://pptr.dev/

### Python

- https://django-ninja.dev/
- https://gto76.github.io/python-cheatsheet/
- https://zestedesavoir.com/tutoriels/954/notions-de-python-avancees/
- https://www.stashofcode.fr/comment-marche-fonction-super-de-python/
- https://mariadb.com/resources/blog/how-to-connect-python-programs-to-mariadb/
- https://gonzalo123.com/2021/10/25/listen-to-postgresql-events-with-pg_notify-and-python/

#### Discord Bot

- https://discord.com/developers/docs/intro
- https://discord.com/developers/applications
- https://discordapp.com/oauth2/authorize?client_id=<BOT CLIENT ID>&scope=bot

### Rust

- https://cheats.rs/
- https://learning-rust.github.io/

