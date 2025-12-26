## Memo

- IDA: 
	- IDA Offset: **Options -> General -> Line prefixes : get offsets**
	- IDA Assembly: **use TAB to see assembly (functions offsets) from pseudo-code** => could help for debugging with gef
    - GDB Debugging with IDA Offsets: `vmmap`, `b *<addr binary> + <offset_ida>`
	- `.rodata` : data initialised :copy/paste
	- `.data` : non initialised -> reverse
	- https://malwareunicorn.org/workshops/idacheatsheet.html


- GTK code: callbacks (functions as handlers)
- Openssl/Routines: 
	- https://linux.die.net/man/3/evp_encryptinit 
	- `int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, ENGINE *impl, unsigned char *key, unsigned char *iv);` => key/iv 
	- `int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl, unsigned char *in, int inl);` => buffer out
	- https://docs.openssl.org/3.0/man3/OPENSSL_init_crypto/

### Example

```bash
gef➤  vmmap
[ Legend:  Code | Stack | Heap ]
Start              End                Offset             Perm Path
0x0000555555554000 0x0000555555556000 0x0000000000000000 r-- /home/night/Downloads/listviewer
0x0000555555556000 0x0000555555558000 0x0000000000002000 r-x /home/night/Downloads/listviewer
0x0000555555558000 0x0000555555559000 0x0000000000004000 r-- /home/night/Downloads/listviewer
0x0000555555559000 0x000055555555a000 0x0000000000004000 r-- /home/night/Downloads/listviewer
0x000055555555a000 0x000055555555b000 0x0000000000005000 rw- /home/night/Downloads/listviewer
0x000055555555b000 0x0000555555958000 0x0000000000000000 rw- [heap]
0x00007fffb4000000 0x00007fffb4021000 0x0000000000000000 rw- 

...

b *0x0000555555554000+0x3903
continue

[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x00007fffffffc270  →  0x0000ea9d00024c9d
$rbx   : 0x000055555588df20  →  0x00005550006c6f6c ("lol"?)
$rcx   : 0x00007fffffffc290  →  0x46addbbf2dd4e8f0
$rdx   : 0x00007fffffffc280  →  0x00024c9d00000000
$rsp   : 0x00007fffffffc220  →  0x00007fffffffc2b0  →  0x0000000000000020 (" "?)
$rbp   : 0x00005555558acf80  →  0x00005550006c6f6c ("lol"?)
$rsi   : 0x00007fffffffc270  →  0x0000ea9d00024c9d
$rdi   : 0x00007fffdc0211c0  →  0x0000555555904cc0  →  0x000000010000037f
$rip   : 0x0000555555557903  →   call 0x555555556380 <EVP_DecryptUpdate@plt>
$r8    : 0x10              
$r9    : 0x0               
$r10   : 0x0               
$r11   : 0x10              
$r12   : 0xe               
$r13   : 0x0000555555891550  →  0x0000000200000020 (" "?)
$r14   : 0x00007fffffffc290  →  0x46addbbf2dd4e8f0
$r15   : 0x00007fffdc0211c0  →  0x0000555555904cc0  →  0x000000010000037f
$eflags: [ZERO carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── stack ────
0x00007fffffffc220│+0x0000: 0x00007fffffffc2b0  →  0x0000000000000020 (" "?)     ← $rsp
0x00007fffffffc228│+0x0008: 0x000000010000e839
0x00007fffffffc230│+0x0010: 0x00007fffffffc280  →  0x00024c9d00000000
0x00007fffffffc238│+0x0018: 0x00007fffffffc270  →  0x0000ea9d00024c9d
0x00007fffffffc240│+0x0020: 0x0000e91c0000e839
0x00007fffffffc248│+0x0028: 0x0000555555891550  →  0x0000000200000020 (" "?)
0x00007fffffffc250│+0x0030: 0x6569567473694c1c
0x00007fffffffc258│+0x0038: "wer v1.010253"
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
   0x5555555578f6                  mov    rsi, rax
   0x5555555578f9                  mov    QWORD PTR [rsp+0x10], rdx
   0x5555555578fe                  mov    QWORD PTR [rsp+0x18], rax
●→ 0x555555557903                  call   0x555555556380 <EVP_DecryptUpdate@plt>
   ↳  0x555555556380 <EVP_DecryptUpdate@plt+0000> jmp    QWORD PTR [rip+0x3e22]        # 0x55555555a1a8 <EVP_DecryptUpdate@got.plt>
      0x555555556386 <EVP_DecryptUpdate@plt+0006> push   0x35
      0x55555555638b <EVP_DecryptUpdate@plt+000b> jmp    0x555555556020
      0x555555556390 <gtk_entry_set_text@plt+0000> jmp    QWORD PTR [rip+0x3e1a]        # 0x55555555a1b0 <gtk_entry_set_text@got.plt>
      0x555555556396 <gtk_entry_set_text@plt+0006> push   0x36
      0x55555555639b <gtk_entry_set_text@plt+000b> jmp    0x555555556020
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── arguments (guessed) ────
EVP_DecryptUpdate@plt (
   $rdi = 0x00007fffdc0211c0 → 0x0000555555904cc0 → 0x000000010000037f,
   $rsi = 0x00007fffffffc270 → 0x0000ea9d00024c9d,
   $rdx = 0x00007fffffffc280 → 0x00024c9d00000000,
   $rcx = 0x00007fffffffc290 → 0x46addbbf2dd4e8f0
)
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 3, Name: "pool-spawner", stopped 0x7ffff6d1872d in syscall (), reason: BREAKPOINT
[#1] Id 9, Name: "async-io", stopped 0x7ffff5b78bb3 in ?? (), reason: BREAKPOINT
[#2] Id 8, Name: "gly-global-exec", stopped 0x7ffff6d1872d in syscall (), reason: BREAKPOINT
[#3] Id 7, Name: "dconf worker", stopped 0x7ffff6c9f002 in ?? (), reason: BREAKPOINT
[#4] Id 1, Name: "listviewer", stopped 0x555555557903 in ?? (), reason: BREAKPOINT
[#5] Id 4, Name: "gmain", stopped 0x7ffff6c9f002 in ?? (), reason: BREAKPOINT
[#6] Id 2, Name: "[pango] fontcon", stopped 0x7ffff6d1872d in syscall (), reason: BREAKPOINT
[#7] Id 6, Name: "gdbus", stopped 0x7ffff6c9f002 in ?? (), reason: BREAKPOINT
[#8] Id 90, Name: "gly-hdl-loader", stopped 0x7ffff6c9f002 in ?? (), reason: BREAKPOINT
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x555555557903 → call 0x555555556380 <EVP_DecryptUpdate@plt>
[#1] 0x7ffff7f58c77 → test BYTE PTR [r12+0x2], 0x1
[#2] 0x7ffff7f58d89 → g_signal_emit_valist()
[#3] 0x7ffff7f58e44 → g_signal_emit()
[#4] 0x7ffff7a3ba66 → mov rax, QWORD PTR [rbp-0x28]
[#5] 0x7ffff7f58c77 → test BYTE PTR [r12+0x2], 0x1
[#6] 0x7ffff7f58d89 → g_signal_emit_valist()
[#7] 0x7ffff7f58e44 → g_signal_emit()
[#8] 0x7ffff7a3b8ae → mov rdi, r13
[#9] 0x7ffff79f6518 → mov rax, QWORD PTR [rbp-0x8]
───────────────────────────────────────────────────────

# RSI 2nd arg => out
# RDX 3d arg => outl
# NOTE THESE BEFORE DOING next instruction => caller save
```
