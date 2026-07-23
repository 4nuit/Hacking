## Documentation

### PE Format

- https://0xrick.github.io/win-internals/pe1/ #6 parts
- https://github.com/0xZ0F/Z0FCourse_ReverseEngineering/
- https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/pe-file-header-parser-in-c++/

### Loader

- https://learn.microsoft.com/windows/win32/debug/pe-format
- https://v1k1ngfr.github.io/loading-windows-unsigned-driver/

## Tools

- https://www.winehq.org/
- https://learn.microsoft.com/en-us/sysinternals/downloads

### Static Analysis

- [ListDlls](https://learn.microsoft.com/en-us/sysinternals/downloads/listdlls)


### Dynamic Analysis

#### Debuggers

- [x64dbg](https://x64dbg.com/)
- [WinDbg](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/)
- https://github.com/microsoft/Detours # IAT Patching

#### Tracers

- [ProcessExplorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer)
- [ProcMon](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon)
- [ProcDump](https://learn.microsoft.com/en-us/sysinternals/downloads/procdump)
- [SysMon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)

## Anti Debug

- https://ctf-wiki.mahaloz.re/reverse/windows/anti-debug/example/
- https://anti-reversing.com/Downloads/Anti-Reversing/The_Ultimate_Anti-Reversing_Reference.pdf
- https://web.archive.org/web/20250505203828/https://www.codeproject.com/articles/30815/an-anti-reverse-engineering-guide

### IAT 

- https://trikkss.github.io/posts/hiding_windows_api_calls_part1/
- https://trikkss.github.io/posts/iat_hooking/
- https://gitlab.winehq.org/wine/wine/-/blob/master/dlls/ntdll/loader.c

### SEH

- https://revers.engineering/applied-re-exceptions/
- https://github.com/nop-tech/OSED/tree/main/03)%20SEH
- https://www.defcon.org/images/defcon-16/dc16-presentations/newger/defcon-16-newger-wp.pdf
- https://web.archive.org/web/20120720135045/http://www.ghostsinthestack.org/article-24-buffer-overflows-sous-xp-sp2.html#p3
- https://web.archive.org/web/20210702054833/https://bytepointer.com/resources/pietrek_crash_course_depths_of_win32_seh.htm
- https://learn.microsoft.com/en-us/archive/msdn-magazine/2001/september/under-the-hood-new-vectored-exception-handling-in-windows-xp

### RunPE / Process Hollowing

- https://0xpat.github.io/ #9 parts
- https://www.aldeid.com/wiki/PEB-Process-Environment-Block
- https://red-team-sncf.github.io/complete-process-hollowing.html
- https://intezer.com/blog/malware-analysis/malware-reverse-engineering-beginners/


## Game Hacking

- https://gamehacking.academy
- https://www.docdroid.net/rtoAc2n/game-hacking-pdf#page=87
- https://connorjaydunn.github.io/blog/posts/denuvo-analysis/

### .NET

- https://fr.wikipedia.org/wiki/Common_Intermediate_Language
- [.NET install script](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script)

```powershell
Set-ExecutionPolicy unrestricted
#or
powershell -NoProfile -ExecutionPolicy unrestricted -Command ...
.\dotnet-install.ps1
```

- [DotPeek](https://www.jetbrains.com/en-us/decompiler/)
- [DnSpyEx](https://github.com/dnSpyEx/dnSpy)

### Unity

- [Game Hacks - Among US : IL2CPP Walkthrough](https://0x64marsh.com/?p=689)
- https://github.com/imadr/Unity-game-hacking
- https://www.kodeco.com/36285673-how-to-reverse-engineer-a-unity-game
