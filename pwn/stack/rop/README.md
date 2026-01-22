# Doc

- https://pop.rdi.sh/rop-exploits/
- https://hackcess.org/pdf/Pwn_like_its_2007.pdf/
- https://beta.hackndo.com/return-oriented-programming/
- https://zestedesavoir.com/articles/1424/decouvrez-lattaque-return-oriented-programming/
- https://www.lazenca.net/pages/viewpage.action?pageId=16810141


## Outils

- https://github.com/uZetta27/EasyROP
- https://github.com/inaz2/roputils


## Function ROP: calling conventions x86

- https://beta.hackndo.com/conventions-d-appel/
- https://dp12.github.io/posts/calling-conventions-for-pwn-and-profit/

```bash
payload = b"\x90" * offset
payload += p32(win)
# fake return address for win
payload += p32(0x12345678)
payload += p32(arg2)
payload += p32(arg1)
```

## Alignement & x64 MOVABS Issue

- https://ropemporium.com/guide.html => **common pitfalls**
- https://www.felixcloutier.com/x86/movaps
- https://stackoverflow.com/questions/1061818/stack-allocation-padding-and-alignment
- https://gist.githubusercontent.com/dmur1/9bf25015f731f99f94ab5882e48de66d/raw/b78c267f9234dbe57c197dab0c51c508384f0be9/5202c515_go.py

### Static (userland)

- http://wiki.bi0s.in/pwning/rop/static/
- https://www.re-xe.com/return-oriented-programming/

#### Stack Pivot

- https://www.lazenca.net/display/TEC/16.Stack+pivot
- https://nickgregory.me/post/2019/04/06/pivoting-around-memory/
- https://ir0nstone.gitbook.io/notes/binexp/stack/stack-pivoting/exploitation/leave
- https://book.hacktricks.xyz/fr/reversing-and-exploiting/linux-exploiting-basic-esp/stack-overflow/stack-pivoting-ebp2ret-ebp-chaining

### Dynamic (userland)

- http://wiki.bi0s.in/pwning/rop/dynamic/
- https://nuts7.fr/return-oriented-programming/
- https://www.dailysecurity.fr/return_oriented_programming/

#### ARM ROP

- https://ctf-wiki.mahaloz.re/pwn/linux/arm/arm_rop/


### Kernel

- https://lkmidas.github.io/posts/20210123-linux-kernel-pwn-part-3/
