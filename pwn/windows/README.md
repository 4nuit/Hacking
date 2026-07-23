## Mitigations

Windows equivalents of the Linux protections table in [../README](../README.md) - check what's enabled with [winchecksec](https://github.com/trailofbits/winchecksec) (`PEChecksec`/CFF Explorer's "Load Config" also show this):

| **Mitigation** | **What it does** | **Bypass angle** |
|---|---|---|
| **CFG** (Control Flow Guard) | Validates indirect call targets against a compiler-generated bitmap of valid function entry points. | Any valid function entry point is still a legal target (coarse-grained) - JOP/data-only attacks, or call a CFG-suspended/unprotected module. [Microsoft docs](https://learn.microsoft.com/en-us/windows/win32/secbp/control-flow-guard) |
| **XFG** (eXtended Flow Guard, Win11) | CFG plus a type-hash check (arg count/types/return type) before the indirect call, narrowing valid targets. | Any function sharing the same signature hash is still callable - narrower than CFG, not eliminated. [Offensive Security - XFG Under The Microscope](https://www.offsec.com/blog/extended-flow-guard/) |
| **ACG** (Arbitrary Code Guard) | Makes code pages immutable at the OS level - `VirtualProtect`/`VirtualAlloc` with `PAGE_EXECUTE_READWRITE` fail, no JIT-spray/shellcode-write-then-exec. | Reuse existing code (ROP/JOP) instead of writing new code; abuse a process exempted from ACG (e.g. a JIT broker). [ired.team - ACG](https://www.ired.team/offensive-security/defense-evasion/acg-arbitrary-code-guard-processdynamiccodepolicy) |
| **CET Shadow Stack** (Win11, needs compatible CPU) | Hardware-enforced shadow copy of return addresses; `ret` faults if it doesn't match. | Doesn't protect indirect calls/jumps (pairs with CFG/XFG for that) or non-CET-compiled modules loaded into the process. |
| **SafeSEH / SEHOP** | SafeSEH: validates the exception handler is in a known table at compile time. SEHOP: validates the exception handler chain isn't corrupted at runtime, regardless of compile-time flags. | Modules compiled without `/SAFESEH`, or a handler outside the protected chain. |
| **/GS (stack cookie)** | Compiler-inserted canary in front of the saved return address, checked on function exit. | Overwrite past the cookie without touching it (e.g. via a pointer/vtable also on the stack), or leak the cookie. |
| **ASLR / PIE** (Win: `/DYNAMICBASE`) | Randomizes module/heap/stack base addresses. | Info leak, or a module compiled without `/DYNAMICBASE`. |
| **DEP** (Win's NX) | Non-executable stack/heap. | ROP/JOP (code-reuse, no injected shellcode needed). |

## Doc

- https://github.com/nop-tech/OSED/
- https://0xrick.github.io/win-internals/pe6/ # IAT
- https://j00ru.vexillium.org/syscalls/nt/64/
- https://github.com/7etsuo/windows-api-function-cheatsheets
- https://web.archive.org/web/20120720135045/http://www.ghostsinthestack.org/article-24-buffer-overflows-sous-xp-sp2.html

## Tools (Debug)

- https://github.com/leesh3288/WinPwn
- https://github.com/ptr-yudai/ptrlib
- https://doar-e.github.io/blog/2017/12/01/debugger-data-model/
- https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/getting-started-with-windbg

## Debuggers:

- `x32/64dbg`: https://x64dbg.com/

- `ollydbg`: https://www.ollydbg.de/

- `Windbg (GUI) / cdb (CLI)`
	- [WinDBG cheatsheet - Reversing bits](https://github.com/mohitmishra786/reversingBits/blob/main/src/windbg.md)
	- [cdb32/cdb64](https://www.codeproject.com/Articles/6469/Debug-Tutorial-Part-1-Beginning-Debugging-Using-CD)
	- `cdb32 prog.exe`: debug prog.exe
	- `u` : display functions
	- `g`: run the program
	- `bp 0x1`: set a breakpoint at 0x1
	- `p` : display registers
	- `d % 0x1`: display content at 0x1

- `cutter` : https://cutter.re/docs/index.html

- `edb` : https://github.com/eteran/edb-debugger

- `radare2` : https://book.rada.re/debugger/intro.html

### Using winedbg

```bash
$ winedbg --gdb --no-start cmd.exe
0022:0023: create process 'C:\windows\system32\cmd.exe'/0x110760 @0x7ece8b70 (0<0>)
0022:0023: create thread I @0x7ece8b70
target remote localhost:12345

$ gdb -quiet
(gdb) target remote localhost:12345
Remote debugging using localhost:47152
0x7b85d4b0 in ?? ()
(gdb) c
Continuing.
```

