## Setup

### GDB

```bash
alias pwndbg='gdb -x ~/pwndbg/gdbinit.py -q '
alias gef='gdb -x ~/.gdbinit-gef.py -q '
alias gdb-peda='gdb -x ~/peda/peda.py'
```

```bash
gef➤  info functions
All defined functions:

Non-debugging symbols:
...
0x0000000000400520  strcmp@plt
...
gef➤  b *0x0000000000400520
Breakpoint 1 at 0x400520
gef➤  r toto
```

#### Quick wins

```bash
starti
jump *0x... #addresse print_flag()
```

```bash
b *main
r
p *(char) printFlag()
```

#### Control flow

```bash
tui enable
up
down
backtrace

#restart
start
target record-full
next
reverse-next
```

#### Memory

```bash
x/256xb $rsp #dump 256 bytes from the stack in hexadecimal format
x/60xw $rsp  #dump 60 32-bit words from the stack
x/30xg $rsp  #dump 30 64-bit words from the stack
x/42i main   #show the 42 first asm instructions of function main

ptype object
```

#### Basic strcmp

```bash
x/16x $esp+4
x/4s <1st address>
x/4s <2nd address>
```

### Radare2

```bash
r2 -d -A crackme

# seek function
s @sym.compare_pwd
s @sym.main

# disass main
pdf main
VV

# basic blocks
afbj
pdj
pif | grep -B2 mov,
```
