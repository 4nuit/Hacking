global _start:

section .rodata

	helloworld db "Hello World", 10, 0
	helloworld_len equ $-helloworld

section .text

_start:
	mov eax, 4
	mov ebx, 1
	mov ecx, helloworld
	mov edx, helloworld_len
	int 0x80
	jmp _exit

_exit:
	mov eax, 1
	mov ebx, 1
	int 0x80	
