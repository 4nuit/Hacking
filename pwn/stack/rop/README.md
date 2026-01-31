# Doc

- https://pop.rdi.sh/rop-exploits/
- https://beta.hackndo.com/return-oriented-programming/
- https://zestedesavoir.com/articles/1424/decouvrez-lattaque-return-oriented-programming/
- https://www.lazenca.net/pages/viewpage.action?pageId=16810141
- https://web.archive.org/web/20250110120153/https://hackcess.org/pdf/Pwn_like_its_2007.pdf/



## Outils

- https://github.com/uZetta27/EasyROP
- https://github.com/inaz2/roputils
- https://github.com/sashs/Ropper


```bash
ROPGadget --binary vuln --ropchain
ROPGadget --binary vuln --multibr | grep "syscall" #syscall; ret
ROPGadget --binary vuln | grep "pop"		   #control registers (when *rsp = @ pop rdi)
# payload += POP_RDI		| @pop rdi;ret	   <- RSP
# payload += 0xdeadbeef		| 0xdeadbeef	   <- RBP

ROPgadget --binary vuln --string "/bin/sh"         #search string
```

```bash
(ropper)> file vuln
(vuln/ELF/x86_64)> semantic search rdx==1
[INFO] Searching for gadgets: search rdx==1

[INFO] File: vuln
0x0000000000404360: mov edx, 1; mov rax, r8; syscall; 
```

## Static (userland)

- https://pop.rdi.sh/rop-exploits/
- http://wiki.bi0s.in/pwning/rop/static/
- https://www.re-xe.com/return-oriented-programming/

```asm
pop rdi; ret
&addr_writeable				; using vmmap in gef

pop rax; ret
"/bin/sh\0"

mov qword ptr [rdi], rax	; *addr_writeable = "/bin/sh" , useful for execve("/bin/sh", NULL, NULL)
```

### Stack Pivot

- https://www.lazenca.net/display/TEC/16.Stack+pivot
- https://nickgregory.me/post/2019/04/06/pivoting-around-memory/
- https://ir0nstone.gitbook.io/notes/binexp/stack/stack-pivoting/exploitation/leave
- https://book.hacktricks.xyz/fr/reversing-and-exploiting/linux-exploiting-basic-esp/stack-overflow/stack-pivoting-ebp2ret-ebp-chaining


```asm
#SEIP = pivot1 + pivot2

MAIN:
	sEBP = fff
	EBP = 0xabcde
	RSP = 0xfghij
	PADDING - sEBP(.data) - SEIP(&leave_ret*2)

leave_ret1:
	(leave:)
	RSP = RBP
	POP RBP => RBP = &.data
	(ret:)
	POP EIP => &(leave_ret2)

leave_ret2:
	(leave:)
	RSP = RBP
	POP RBP
	(ret:)
	POP EIP => &buf

section .data
	buf [read(0,buffer,99999)			] PADDING

NVXbuffer[ROPChain]
```

![](../images/pivot.png)


## Dynamic (userland)

- http://wiki.bi0s.in/pwning/rop/dynamic/
- https://nuts7.fr/return-oriented-programming/
- https://www.dailysecurity.fr/return_oriented_programming/

### ARM ROP

- https://ctf-wiki.mahaloz.re/pwn/linux/arm/arm_rop/


## Advanced topics

### CET & Shadow stack

- https://book.hacktricks.xyz/binary-exploitation/common-binary-protections-and-bypasses/cet-and-shadow-stack
- https://gmo--cybersecurity-com.translate.goog/blog/intel-cet-bypass-on-linux-userland/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp

### JIT - ROP

- https://www.ieee-security.org/TC/SP2013/papers/4977a574.pdf
- https://www.usenix.org/conference/usenixsecurity16/technical-sessions/presentation/maisuradze


## Kernel

- https://lkmidas.github.io/posts/20210123-linux-kernel-pwn-part-3/
