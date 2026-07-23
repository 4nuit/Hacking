## Documentation

### ELF format

- [ELF Format Cheatsheet](https://gist.github.com/x0nu11byt3/bcb35c3de461e5fb66173071a2379779)
- https://github.com/michalmalik/linux-re-101
- https://reverse.zip/posts/introduction_au_reverse_partie_3/
- https://intezer.com/blog/executable-linkable-format-101-part-2-symbols/
- https://intezer.com/blog/executable-linkable-format-101-part-2-symbols/
- https://linux-audit.com/elf-binaries-on-linux-understanding-and-analysis/
- https://0xdarkvortex.dev/ground-zero-part-1-reverse-engineering-basics/
- https://m101.github.io/binholic/2017/05/20/notes-on-abusing-exit-handlers.html


#### ELF Magic numbers

- https://docs.pwntools.com/en/stable/elf/elf.html
- https://eli.thegreenplace.net/2012/08/13/how-statically-linked-programs-run-on-linux

```txt
| Context                    | Magic Number Address |
| -------------------------- | -------------------- |
| File offset                | `0x00`               |
| In-memory (64-bit, no PIE) | `0x400000`           |
| In-memory (32-bit, no PIE) | `0x08048000`         |
```

- **Program Headers** = `INTERP`, `LOAD` (**PT_LOAD = mapping of the base address of the CODE**)
- **Section Headers** = `.text`, `.plt` & `.got`, `.data` & `.rodata`, `.bss`, `GNU_STACK`

![](../images/segmentation.gif)

```bash
readelf -l /bin/cat
readelf -a /bin/cat | grep interpret
```

#### Loader

- [How programs get run - lwn.net](https://lwn.net/Articles/631631/)
- https://eli.thegreenplace.net/tag/linkers-and-loaders
- [How does an executable get loaded to memory](https://web.archive.org/web/20230327081940/https://www.pwnthebox.net/reverse/engineering/and/binary/exploitation/series/2019/11/10/understanding-the-loader-part1-how-does-an-executable-get-loaded-to-memory.html)
- https://github.com/realcathode/elf-loader/

## Tools

### Static analysis

- https://www.gnu.org/software/binutils/
- `ltrace`: prints LIBC calls
  - `i --demangle`: print EIP and [demangle](https://github.com/4nuit/Hacking/tree/master/reverse/language_specific#c-mangling)
  - `-s 128`: specify maximum string to print (useful for bypassing`\0` in strings)
  - `-S`: prints also system calls
- `ldd`: see used libraries (user, libc), `LD_SHOW_AUXV=1 ./bin`

- `nm -D --demangle`: parse symbol table
- `objdump -d <binary> -M intel`:
  - `-t` : see symbols table
  - `-h`: see sections
  - `R` : see GOT

### Dynamic analysis

#### Debuggers

- [debugging notes](./debugging)
- `gdb-gef`: [gef](https://github.com/hugsy/gef)  # Linux
- `r2`: https://github.com/radareorg/radare2

#### Tracers

- `lsof`: see opened files (processes, sockets)
- `pidof`: see pid of running process
- `strace`: trace running process
	- `-fxi`
	- `-e trace=read,write`
	- `-E LD_PRELOAD=preload.so`


## Anti Debug

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-dbg/
- https://bases-hacking.org/ptrace.html
- https://blog.0x972.info/?d=2014/11/13/10/40/50-how-does-a-debugger-work
- https://codelucky.com/core-dump-linux/
- https://bases-hacking.org/faux-desassemblage.html   # patch fake opcodes (0xEB0108) by nops (0x90), https://hexed.it/
- https://bases-hacking.org/faux-breakpoint.html      # use hardware breakpoints (hb *) to avoid changing 0xCC interruptions
- https://bases-hacking.org/code-checksum.html        # 

```bash
# core dump
cat /proc/`pidof binary`/status
ps f
#  71554 pts/1    Ss     0:00 /usr/bin/bash
#  85717 pts/1    S+     0:00  \_ ./binary
sudo gcore 85717
strings -atx core.85717
gdb -c core.85717 -q

# OR attaching to process
./binary
sudo gdb -p `pidof binary`
```

#### Anti Breakpoints

- https://ctf-wiki.mahaloz.re/reverse/linux/detect-bp/
- https://jaybailey216.com/debugging-stripped-binaries/
- https://stackoverflow.com/questions/14016610/x86-instruction-help-mov-edx-eax
- https://stackoverflow.com/questions/8878716/what-is-the-difference-between-hardware-and-software-breakpoints

```bash
#symbols
#info functions
info file
starti
hb *<addr bp>
```

#### Avoiding SigTRAP (int 3)

`signal(int sig,__sighandler_t handler)`

```bash
# Find sig in signal
kill -l
```

```asm
# x86: 48 signal eax:30, ebx (arg0):sig, ecx(arg1):handler  
# mov $0x80480e2, %ecx
# int $0x80

set $eip=0x80480e2
```

#### Nanomites / Multithreaded debugging

- https://linux.die.net/man/2/fork
- https://drdobbs.com/cpp/multithreaded-debugging-techniques/199200938?pgno=6
- https://doar-e.github.io/blog/2014/10/11/taiming-a-wild-nanomite-protected-mips-binary-with-symbolic-execution-no-such-crackme/#nanomites-101
