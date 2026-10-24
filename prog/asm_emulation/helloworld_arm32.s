@comment
//comment

.global _start

.data
	helloworld:	.asciz "Hello World\n"
	helloworld_len = .-helloworld

.text

_start:
	mov r0, #1
	ldr r1, =helloworld
	ldr r2, =helloworld_len
	mov r7, #4
	swi 0

_exit:
	mov r7, #1
	mov r0, #0
	swi 0

