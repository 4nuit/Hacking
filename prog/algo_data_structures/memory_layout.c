#include <stdlib.h>

// The memory layout of the program is as follows:
// 1. Text segment: contains the executable code
// 2. Data - Initialized data segment: contains the global variables that are
//    initialized by the programmer
// 3. BSS - Uninitialized data segment: contains the global variables that are
//    not initialized by the programmer
// 4. Stack: contains the local variables and function calls
// 5. Heap: contains the dynamically allocated memory

int global;                 // uninitialized global variable --> bss
int initialized_global = 1; // initialized global variable --> data

int main(void)
{
    int local;                 // uninitialized local variable --> stack
    int initialized_local = 2; // initialized local variable --> stack

    char *uninit_pointer; // uninitialized pointer --> stack

    uninit_pointer = (char *)malloc(10); // dynamically allocated memory --> heap

    return 0;
}

/*
 night@me:~/Hacking/pro*g/algo_data_structures$ gdb -q ./memory_layout
 GEF for linux ready, type `gef' to start, `gef config' to configure
 93 commands loaded and 5 functions added for GDB 16.3 in 0.00ms using Python engine 3.13
 Reading symbols from ./memory_layout...

 This GDB supports auto-downloading debuginfo from the following URLs:
 <https://debuginfod.archlinux.org>
 Debuginfod has been disabled.
 To make this setting permanent, add 'set debuginfod enabled off' to .gdbinit.
 (No debugging symbols found in ./memory_layout)
 gef➤  info func
 All defined functions:

 Non-debugging symbols:
 0x0000000000001000  _init
 0x0000000000001030  malloc@plt
 0x0000000000001040  _start
 0x0000000000001139  main
 0x0000000000001160  _fini
 gef➤  disass main
 Dump of assembler code for function main:
 0x0000000000001139 <+0>:     push   rbp
 0x000000000000113a <+1>:     mov    rbp,rsp
 0x000000000000113d <+4>:     sub    rsp,0x10
 0x0000000000001141 <+8>:     mov    DWORD PTR [rbp-0xc],0x2
 0x0000000000001148 <+15>:    mov    edi,0xa
 0x000000000000114d <+20>:    call   0x1030 <malloc@plt>
 0x0000000000001152 <+25>:    mov    QWORD PTR [rbp-0x8],rax
 0x0000000000001156 <+29>:    mov    eax,0x0
 0x000000000000115b <+34>:    leave
 0x000000000000115c <+35>:    ret
 End of assembler dump.
 gef➤  b *main+20
 Breakpoint 1 at 0x114d

 [ Legend: Modified register | Code | Heap | Stack | String ]
 ───────────────────────────────────────────────────────────────────────────────── registers ────
 $rax   : 0x00007ffff7e0fe28  →  0x00007fffffffdef8  →  0x00007fffffffe36f  →  "SHELL=/usr/bin/bash"
 $rbx   : 0x0
 $rcx   : 0x0000555555557dd8  →  0x00005555555550e0  →   endbr64
 $rdx   : 0x00007fffffffdef8  →  0x00007fffffffe36f  →  "SHELL=/usr/bin/bash"
 $rsp   : 0x00007fffffffddb0  →  0x0000000200000000
 $rbp   : 0x00007fffffffddc0  →  0x00007fffffffde60  →  0x00007fffffffdec0  →  0x0000000000000000
 $rsi   : 0x00007fffffffdee8  →  0x00007fffffffe333  →  "/home/night/Hacking/prog/algo_data_structures/memo[...]"
 $rdi   : 0xa
 $rip   : 0x000055555555514d  →  <main+0014> call 0x555555555030 <malloc@plt>
 $r8    : 0x00007ffff7e08680  →  0x00007ffff7e09fe0  →  0x0000000000000000
 $r9    : 0x00007ffff7e09fe0  →  0x0000000000000000
 $r10   : 0x00007fffffffdb00  →  0x0000000000000000
 $r11   : 0x203
 $r12   : 0x00007fffffffdee8  →  0x00007fffffffe333  →  "/home/night/Hacking/prog/algo_data_structures/memo[...]"
 $r13   : 0x1
 $r14   : 0x00007ffff7ffd000  →  0x00007ffff7ffe2f0  →  0x0000555555554000  →   jg 0x555555554047
 $r15   : 0x0000555555557dd8  →  0x00005555555550e0  →   endbr64
 $eflags: [zero carry parity adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
 $cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00
 ───────────────────────────────────────────────────────────────────────────────────── stack ────
 0x00007fffffffddb0│+0x0000: 0x0000000200000000   ← $rsp
 0x00007fffffffddb8│+0x0008: 0x00007ffff7fe1e90  →   endbr64
 0x00007fffffffddc0│+0x0010: 0x00007fffffffde60  →  0x00007fffffffdec0  →  0x0000000000000000    ← $rbp
 0x00007fffffffddc8│+0x0018: 0x00007ffff7c27635  →   mov edi, eax
 0x00007fffffffddd0│+0x0020: 0x00007ffff7fc2000  →  0x03010102464c457f
 0x00007fffffffddd8│+0x0028: 0x00007fffffffdee8  →  0x00007fffffffe333  →  "/home/night/Hacking/prog/algo_data_structures/memo[...]"
 0x00007fffffffdde0│+0x0030: 0x00000001ffffde20
 0x00007fffffffdde8│+0x0038: 0x0000555555555139  →  <main+0000> push rbp
 ─────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
 0x55555555513d <main+0004>      sub    rsp, 0x10
 0x555555555141 <main+0008>      mov    DWORD PTR [rbp-0xc], 0x2
 0x555555555148 <main+000f>      mov    edi, 0xa
 ●→ 0x55555555514d <main+0014>      call   0x555555555030 <malloc@plt>
 ↳  0x555555555030 <malloc@plt+0000> jmp    QWORD PTR [rip+0x2fca]        # 0x555555558000 <malloc@got.plt>
 0x555555555036 <malloc@plt+0006> push   0x0
 0x55555555503b <malloc@plt+000b> jmp    0x555555555020
 0x555555555040 <_start+0000>    endbr64
 0x555555555044 <_start+0004>    xor    ebp, ebp
 0x555555555046 <_start+0006>    mov    r9, rdx
 ─────────────────────────────────────────────────────────────────────── arguments (guessed) ────
 malloc@plt (
     $rdi = 0x000000000000000a,
$rsi = 0x00007fffffffdee8 → 0x00007fffffffe333 → "/home/night/Hacking/prog/algo_data_structures/memo[...]",
$rdx = 0x00007fffffffdef8 → 0x00007fffffffe36f → "SHELL=/usr/bin/bash"
)
─────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "memory_layout", stopped 0x55555555514d in main (), reason: BREAKPOINT
───────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x55555555514d → main()
─────────────
*/
