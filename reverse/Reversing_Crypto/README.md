## Memo

- IDA:  
	- IDA Offset: **Options -> General -> Line prefixes : get offsets** (**Faire par view (CFG, Code ETC)**)
	- IDA Assembly: **use TAB to see assembly (functions offsets) from pseudo-code** => could help for debugging with gef
	- IDA Strings :  **View -> Open Sub views -> Strings (Shift+F12)**
	- IDA Cross References: **Right click => Jump to XREF (X)**
	- IDA Renaming: **Right click => Renaming lvar (N)**

    - GDB Debugging with IDA Offsets: `vmmap`, `b *<addr binary> + <offset_ida>`
	- `.rodata` : data initialised :copy/paste
	- `.data` : non initialised -> reverse
	- https://malwareunicorn.org/workshops/idacheatsheet.html

- GTK code: callbacks (functions as handlers):
    - `v9 = gtk_button_new_with_label("Connect");`
    - `g_signal_connect_data(v9, "clicked", sub_3500, 0LL, 0LL, 0LL);` => `void sub_3500()` is the **sender**

- Openssl/Routines: 
	- https://linux.die.net/man/3/evp_encryptinit 
	- `int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, ENGINE *impl, unsigned char *key, unsigned char *iv);` => key/iv 
	- `int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl, unsigned char *in, int inl);` => buffer out
	- https://wiki.openssl.org/index.php/EVP_Authenticated_Encryption_and_Decryption

### Example

#### Socket 


The sender opens a socket in order to connect to the server. The first **15 bytes** are the header `Listviewer v1.0`:

```c
  if ( connect(v10, v9->ai_addr, v9->ai_addrlen) )
  {
    perror("connect");
    close(v11);
    goto LABEL_21;
  }
  
  for ( i = 0LL; i <= 0xE; i += v13 )
  {
    v13 = recv(v11, &v27[i], 15 - i, 0);
    if ( v13 <= 0 )
      goto LABEL_20;
  }
  if ( *(_QWORD *)v27 != 'weiVtsiL' || (v16 = 0LL, *(_QWORD *)&v27[7] != '0.1v rew') )
  {
    fwrite("Unexpected handshake header\n", 1uLL, 0x1CuLL, _bss_start);
LABEL_20:
    v14 = gtk_message_dialog_new(qword_62F0, 3LL, 3LL, 1LL, "%s", "Handshake with server failed.");
    gtk_dialog_run(v14);
    gtk_widget_destroy(v14);
    close(v11);
    goto LABEL_21;
  }
```

The **next 32 bytes** contain the decrypted packet:

```c
 do
  {
    v17 = recv(v11, (char *)ptr + v16, 32 - v16, 0);
    if ( v17 <= 0 )
      goto LABEL_20;
    v16 += v17;
  }
  while ( v16 <= 31 );
  v32.m128i_i32[0] = 0;
  v18 = ((__int64 (*)(void))EVP_CIPHER_CTX_new)();
```

#### Key & IV (GCM)

```c
  v20 = EVP_aes_128_gcm();
  if ( (unsigned int)EVP_DecryptInit_ex(v19, v20, 0LL, 0LL, 0LL) != 1
    || (unsigned int)EVP_CIPHER_CTX_ctrl(v19, 9LL, 12LL, 0LL) != 1
    || (unsigned int)EVP_DecryptInit_ex(v19, 0LL, 0LL, &unk_4330, &unk_4320) != 1           // Offset 38D6. &unk_4330 = key, &unk_4320 = iv
    || (unsigned int)EVP_DecryptUpdate(v19, &v30, &v33, ptr, 16LL) != 1                     // Offset 3903, &v30 = encrypted buffer, &v33 = sizeof buffer
    || (v25 = v33.m128i_i32[0], (unsigned int)EVP_CIPHER_CTX_ctrl(v19, 17LL, 16LL, v35) != 1)
    || (int)EVP_DecryptFinal_ex(v19, (char *)&v30 + v33.m128i_i32[0], &v33) <= 0 )
  {
    EVP_CIPHER_CTX_free(v19);
    goto LABEL_35;
  }
```

**Renaming**:

```c
  if ( (unsigned int)EVP_DecryptInit_ex(ctx, v20, 0LL, 0LL, 0LL) != 1
    || (unsigned int)EVP_CIPHER_CTX_ctrl(ctx, 9LL, 12LL, 0LL) != 1
    || (unsigned int)EVP_DecryptInit_ex(ctx, 0LL, 0LL, &key_gcm, &iv_gcm) != 1
    || (unsigned int)EVP_DecryptUpdate(ctx, &output_buffer_plain, &len, ptr, 16LL) != 1
    || (v25 = len.m128i_i32[0], (unsigned int)EVP_CIPHER_CTX_ctrl(ctx, 17LL, 16LL, v35) != 1)
    || (int)EVP_DecryptFinal_ex(ctx, (char *)&output_buffer_plain + len.m128i_i32[0], &len) <= 0 )
```

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

b *0x0000555555554000+0x386F
run
[ Legend: Modified register | Code | Heap | Stack | String ]
───────────────────────────────────────────────────────────────────────────────── registers ────
$rax   : 0x1               
$rbx   : 0x0000555555631fa0  →  0x00005550006c6f6c ("lol"?)
$rcx   : 0x0000555555558330  →   stc 
$rdx   : 0x0               
$rsp   : 0x00007fffffffc220  →  0x00007fffffffc2b0  →  0x0000000000000020 (" "?)
$rbp   : 0x00005555555aaf70  →  0x00005550006c6f6c ("lol"?)
$rsi   : 0x0               
$rdi   : 0x0000555555635010  →  0x000055555587b670  →  0x000000010000037f
$rip   : 0x00005555555578d6  →   call 0x555555556420 <EVP_DecryptInit_ex@plt>
$r8    : 0x0000555555558320  →   mov edx, 0x27063a0
$r9    : 0x00007fffffffc150  →  0x00007ffff73e80b6  →  0x6c74006e656c7669 ("ivlen"?)
$r10   : 0x000055555587b670  →  0x000000010000037f
$r11   : 0x0               
$r12   : 0xe               
$r13   : 0x00005555555c8940  →  0x0000000200000020 (" "?)
$r14   : 0x00007fffffffc290  →  0xed7b70e693d9a28b
$r15   : 0x0000555555635010  →  0x000055555587b670  →  0x000000010000037f
$eflags: [ZERO carry PARITY adjust sign trap INTERRUPT direction overflow resume virtualx86 identification]
$cs: 0x33 $ss: 0x2b $ds: 0x00 $es: 0x00 $fs: 0x00 $gs: 0x00 
───────────────────────────────────────────────────────────────────────────────────── stack ────
0x00007fffffffc220│+0x0000: 0x00007fffffffc2b0  →  0x0000000000000020 (" "?)     ← $rsp
0x00007fffffffc228│+0x0008: 0x000000010000e839
0x00007fffffffc230│+0x0010: 0x0000e83900024de7
0x00007fffffffc238│+0x0018: 0x0000e91c00024da0
0x00007fffffffc240│+0x0020: 0x0000e91c0000e839
0x00007fffffffc248│+0x0028: 0x00005555555c8940  →  0x0000000200000020 (" "?)
0x00007fffffffc250│+0x0030: 0x6569567473694c1c
0x00007fffffffc258│+0x0038: "wer v1.010707"
─────────────────────────────────────────────────────────────────────────────── code:x86:64 ────
   0x5555555578c5                  lea    r8, [rip+0xa54]        # 0x555555558320
   0x5555555578cc                  mov    rdi, r15
   0x5555555578cf                  lea    rcx, [rip+0xa5a]        # 0x555555558330
 → 0x5555555578d6                  call   0x555555556420 <EVP_DecryptInit_ex@plt>
   ↳  0x555555556420 <EVP_DecryptInit_ex@plt+0000> jmp    QWORD PTR [rip+0x3dd2]        # 0x55555555a1f8 <EVP_DecryptInit_ex@got.plt>
      0x555555556426 <EVP_DecryptInit_ex@plt+0006> push   0x3f
      0x55555555642b <EVP_DecryptInit_ex@plt+000b> jmp    0x555555556020
      0x555555556430 <gtk_text_view_set_editable@plt+0000> jmp    QWORD PTR [rip+0x3dca]        # 0x55555555a200 <gtk_text_view_set_editable@got.plt>
      0x555555556436 <gtk_text_view_set_editable@plt+0006> push   0x40
      0x55555555643b <gtk_text_view_set_editable@plt+000b> jmp    0x555555556020
─────────────────────────────────────────────────────────────────────── arguments (guessed) ────
EVP_DecryptInit_ex@plt (
   $rdi = 0x0000555555635010 → 0x000055555587b670 → 0x000000010000037f,
   $rsi = 0x0000000000000000,
   $rdx = 0x0000000000000000,
   $rcx = 0x0000555555558330 →  stc ,
   $r8 = 0x0000555555558320 →  mov edx, 0x27063a0
)
─────────────────────────────────────────────────────────────────────────────────── threads ────
[#0] Id 1, Name: "listviewer", stopped 0x5555555578d6 in ?? (), reason: SINGLE STEP
[#1] Id 2, Name: "[pango] fontcon", stopped 0x7ffff6d1872d in syscall (), reason: SINGLE STEP
[#2] Id 3, Name: "pool-spawner", stopped 0x7ffff6d1872d in syscall (), reason: SINGLE STEP
[#3] Id 4, Name: "gmain", stopped 0x7ffff6c9f002 in ?? (), reason: SINGLE STEP
[#4] Id 6, Name: "gdbus", stopped 0x7ffff6c9f002 in ?? (), reason: SINGLE STEP
[#5] Id 7, Name: "dconf worker", stopped 0x7ffff6c9f002 in ?? (), reason: SINGLE STEP
───────────────────────────────────────────────────────────────────────────────────── trace ────
[#0] 0x5555555578d6 → call 0x555555556420 <EVP_DecryptInit_ex@plt>
[#1] 0x7ffff7f58c77 → test BYTE PTR [r12+0x2], 0x1
[#2] 0x7ffff7f58d89 → g_signal_emit_valist()
[#3] 0x7ffff7f58e44 → g_signal_emit()
[#4] 0x7ffff7a3ba66 → mov rax, QWORD PTR [rbp-0x28]
[#5] 0x7ffff7f58c77 → test BYTE PTR [r12+0x2], 0x1
[#6] 0x7ffff7f58d89 → g_signal_emit_valist()
[#7] 0x7ffff7f58e44 → g_signal_emit()
[#8] 0x7ffff7a3b8ae → mov rdi, r13
[#9] 0x7ffff79f6518 → mov rax, QWORD PTR [rbp-0x8]
────────────────────────────────────────────────────────────────────────────────────────────────
# KEY
gef➤  x/4xw $rcx
0x555555558330: 0xd68119f9      0xf472b8bc      0x41983134      0x97211586
# IV
gef➤  x/4xw $r8
0x555555558320: 0x7063a0ba      0x4cc93102      0x6c8c61a1      0x00000000
gef➤  
```

#### Output Buffer

```bash
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

# RSI 2nd arg => unsigned char* out (encrypted buffer)
# RDX 3d arg => int outl (sizeof buffer)
# NOTE THESE BEFORE DOING next instruction => caller save

# &out = 0x00007fffffffc150
gef➤  ni

# value of output_buffer_plain (AFTER CALLING EVP_DecryptUpdate)
gef➤  x/2gx 0x00007fffffffc150
0x7fffffffc150: 0x627bf3875897f737      0x0752d66a44071985

```

```c
EVP_DecryptFinal_ex@plt (
   $rdi = 0x00005555555cf390 → 0x0000555555887080 → 0x000000010000037f,
   $rsi = 0x00007fffffffc160 → 0x00024c9d00000010,
   $rdx = 0x00007fffffffc160 → 0x00024c9d00000010
)
```


#### Key (ECB)

```c
// void sub_3500 AKA sender() (current function with socket & AES GCM operations)
  v26 = len.m128i_i32[0] + v25; // => BP on this : sub3500 + 0x45E
  EVP_CIPHER_CTX_free(ctx);
  if ( v26 != 16 )
    goto LABEL_35;
  fd = v11;
  dword_6294 = 1;
  len.m128i_i32[0] = v32;
  *(__int64 *)((char *)len.m128i_i64 + 4) = output_buffer_plain;
  len.m128i_i32[3] = v31;
  
  // XREF on xmmword_6284
  xmmword_6284 = (__int128)_mm_xor_si128(_mm_shuffle_epi32(_mm_cvtsi32_si128('\xFF\xFF\xFF\xFF\xAB\xAB\xAB\xAB'), 0),len);
```

```asm
; basic block for  v26 = len.m128i_i32[0] + v25
sub_3500+45E  mov     eax, [rsp+4C8h+var_4BC]
sub_3500+462  mov     rdi, r15
sub_3500+465  add     eax, dword ptr [rsp+4C8h+len]
sub_3500+469  mov     [rsp+4C8h+var_4BC], eax
sub_3500+46D  call    _EVP_CIPHER_CTX_free
sub_3500+472  cmp     [rsp+4C8h+var_4BC], 10h
sub_3500+477  jnz     loc_3881
```

```c
// void sub_2CA0 : FIND XREF to AES ECB
  v4 = EVP_aes_128_ecb();
  if ( (unsigned int)EVP_EncryptInit_ex(v3, v4, 0LL, &xmmword_6284, 0LL) != 1
    || (EVP_CIPHER_CTX_set_padding(v3, 1LL), (unsigned int)EVP_EncryptUpdate(v3, v40, v46, a1, v2) != 1)
    || (v8 = *(_DWORD *)v46, (unsigned int)EVP_EncryptFinal_ex(v3, &v40[*(int *)v46], v46) != 1) )
  {
    EVP_CIPHER_CTX_free(v3);
LABEL_6:
    v5 = "Data encryption failed.";
LABEL_7:
    v6 = gtk_message_dialog_new(qword_62F0, 3LL, 3LL, 1LL, "%s", v5);
    gtk_dialog_run(v6);
    gtk_widget_destroy(v6);
    return 0xFFFFFFFFLL;
  }
```
