// https://arm64.syscall.sh/
// https://peterdn.com/post/2020/08/22/hello-world-in-arm64-assembly/
.global _start

.data
	helloworld:	.ascii "Hello World\n"          // declare ascii string
	helloworld_len = . - helloworld // gets len with = .-

.text

_start:                                 // ssize_t write(int fildes, const void *buf, size_t nbyte)
	mov x8, #64                     // syscall write
	mov x0, #1                      // arg0, stdout
	ldr x1, =helloworld             // arg1, string
	ldr x2, =helloworld_len         // arg2, len
	svc #0                          // writes helloworld on stdout

_exit:
	mov x8, #93                     // syscall exit
	mov x0, #0                      // arg0, error code
	svc #0                          // clean exit
