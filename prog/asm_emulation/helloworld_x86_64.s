;https://x64.syscall.sh/

global _start:

section .rodata
	helloworld db "Hello world", 10, 0	; declare bytes "Hello world\n\0"
	helloworld_len equ $-helloworld		; gets len with equ $-

section .text

_start:						; ssize_t write(int fildes, const void *buf, size_t nbyte) (man 3 write)
	mov rax, 1				; syscall write
	mov rdi, 1				; arg0, stdout
	mov rsi, helloworld			; arg1, string
	mov rdx, helloworld_len			; arg2, len
	syscall					; writes helloworld on stdout
	jmp _exit

_exit:
	mov rax, 60				; syscall exit
	mov rdi, 0				; arg0, error code if we stopped to the previous syscall (echo $?)	
	syscall					; clean exit
