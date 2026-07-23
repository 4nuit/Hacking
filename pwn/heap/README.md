## Documentation 


- https://explorar.dev/bminor/glibc
- https://samwho.dev/memory-allocation/
- https://en.wikipedia.org/wiki/Doubly_linked_list
- https://www.deep-kondah.com/glibc-heap-internals/
- https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/
- https://azeria-labs.com/heap-exploitation-part-1-understanding-the-glibc-heap-implementation/
- https://azeria-labs.com/heap-exploitation-part-2-glibc-heap-free-bins/
- [Modern Heap Exploitation](https://www.youtube.com/watch?v=69rAAqtDoSI)

### Courses

- https://heap-exploitation.dhavalkapil.com/heap_memory
- https://reverse.zip/categories/exploitation-de-la-heap/
- https://www.udemy.com/course/linux-heap-exploitation-part-1
- https://www.udemy.com/course/linux-heap-exploitation-part-2

![](../images/heap.png)

### Challenges

- https://reverse.zip/categories/exploitation-de-la-heap/
- https://www.corelan-training.com/index.php/training/heap/
- https://blog.quarkslab.com/heap-exploitation-glibc-internals-and-nifty-tricks.html

### Cheatsheets

- https://github.com/shellphish/how2heap/
- https://0x434b.dev/overview-of-glibc-heap-exploitation-techniques/
- https://www.ambionics.io/blog/iconv-cve-2024-2961-p1

`Protection`: No`free/delete/delete[]`, otherwise `ptr = NULL;` / `ptr = nullptr;`

### Tools

- https://github.com/wapiflapi/villoc

## Heap overflow

- https://www.bencode.net/posts/2019-10-19-heap-overflow/

## Use After Free
	
- https://beta.hackndo.com/use-after-free/
- https://youtu.be/o-nRssrHNMw
- https://github.com/LMS57/TempleOfPwn/blob/main/uaf/exploit.py

## Double Free

- https://youtu.be/NTSiUtzbWQs

Since glibc 2.29, tcache chunks carry a `key` field set to the tcache-perthread-struct address on `free()`; a second `free()` of the same still-cached chunk is caught by comparing `key` against it (`malloc.c`, `tcache_put`/`_int_free`). This blocks the naive double-free-into-tcache PoC — see [House of Botcake](#tcache-exploitation--safe-linking) below for the standard bypass (double-free via the unsorted bin instead of the tcache directly).

- [glibc source - malloc.c](https://sourceware.org/git/?p=glibc.git;a=blob;f=malloc/malloc.c)

## Heap Spray

- https://www.lazenca.net/display/TEC/11.Heap+Spray

## Tcache exploitation & Safe-Linking

Since glibc 2.32, `fd` pointers in tcache/fastbin free-list entries are mangled with `PROTECT_PTR`: `mangled = (L >> 12) ^ P`, where `L` is the chunk's own storage address and `P` is the pointer being stored. Without a heap-address leak, a naive `fd` overwrite (tcache poisoning) now produces a garbage pointer instead of a controlled one.

- [Check Point Research - Safe-Linking](https://research.checkpoint.com/2020/safe-linking-eliminating-a-20-year-old-malloc-exploit-primitive/)
- [Safe-Linking - ir0nstone notes](https://ir0nstone.gitbook.io/notes/binexp/heap/safe-linking)
- https://hackmd.io/@5Mo2wp7RQdCOYcqKeHl2mw/ByTHN47jf

## Houses

- https://github.com/shellphish/how2heap/
- https://www.lazenca.net/display/TEC/06.Heap+exploitation+techniques

### House of Force

Top-chunk primitive, not a double-free technique: an overflow that overwrites the top chunk's `size` field (usually to a huge value) lets a subsequent `malloc()` request of an attacker-chosen size return a pointer anywhere in memory, since the allocator trusts the top chunk to always be "big enough."

- [House of Force](https://mohamed-fakroud.gitbook.io/red-teamings-dojo/binary-exploitation/heap-house-of-force)

### House of Botcake

Bypasses the tcache `key` double-free check (see Double Free above) by freeing the chunk into the *unsorted bin* a second time (after tcache-consolidation with a neighbor) rather than the tcache directly - the unsorted bin has no such check. Also the standard target when Safe-Linking is in play, since the technique still ends with a controllable `fd`/`bk` write. Works from glibc 2.26 (tcache introduction) onward, accounting for Safe-Linking from 2.32 on.

- [how2heap - house_of_botcake.c](https://github.com/shellphish/how2heap/blob/master/glibc_2.31/house_of_botcake.c)

### House of apple 

- https://blog.kylebot.net/2022/10/22/angry-FSROP/
