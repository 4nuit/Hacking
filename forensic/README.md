## Docs

- https://thedfirreport.com/
- https://www.dfir.training/downloads/cheats-infographics?category[0]=9&category_children=1
- https://www.hackthebox.com/blog/memory-forensics-volatility-write-up
- https://book.hacktricks.xyz/generic-methodologies-and-resources/basic-forensic-methodology/memory-dump-analysis/volatility-cheatsheet

## Challenges

- https://www.hackthebox.com/blog/Sherlock-Submission-Process
- https://tryhackme.com/module/investigations

## Tools:

- [Aes|Rsakeyfind](https://directory.fsf.org/wiki/Aeskeyfind)
- [Autopsy](https://www.sleuthkit.org/), [Fls](https://sleuthkit.org/sleuthkit/man/fls.html)
- [Binwalk](https://github.com/ReFirmLabs/binwalk)
- [Bulk Extractor](https://github.com/simsong/bulk_extractor)
- [Chainbreaker](https://github.com/n0fate/chainbreaker)
- [Cryptsetup](https://wiki.archlinux.org/title/Dm-crypt)
- [Dive (docker)](https://github.com/wagoodman/dive)
- [Photorec](https://www.cgsecurity.org/wiki/PhotoRec)
- [TCHunt-ng](https://github.com/antagon/TCHunt-ng)
- [Volatility](https://volatility3.readthedocs.io/en/latest/)
- https://start.me/p/19wjGD/forensics # toolbox
- https://github.com/meirwah/awesome-incident-response


## Disk (SSD)

### Anti forensic

- https://github.com/anvilsecure/ulexecve
- https://github.com/sundowndev/covermyass
- https://www.hackthebox.com/blog/anti-forensics-techniques

### Exfiltration

- https://tshark.dev/
- https://wiki.wireshark.org/SampleCaptures

```bash
tshark -2 -r chall.pcap -T fields -e data
# add -R "ip.addr == 127.0.0.1 && icmp.type==8"
```

### Logs analysis

- https://ericzimmerman.github.io/
- https://github.com/4nuit/Writeup/tree/master/2023/FCSC/forensic/weird_shell
- https://discuss.vlug.narkive.com/gHWmeiHQ/how-to-interpret-dev-input-event0

### Macros - PDF 

- https://github.com/jesparza/peepdf
- https://blog.didierstevens.com/programs/pdf-tools/
- https://stackoverflow.com/questions/10220497/extract-javascript-from-malicious-pdf

```bash
pip install oletools
```

## Os Specific (RAM)

### Create Dump

- https://andreafortuna.org/2019/04/03/how-to-analyze-a-vmware-memory-image-with-volatility/
- https://andreafortuna.org/2017/06/23/how-to-extract-a-ram-dump-from-a-running-virtualbox-machine/
- https://www.virtualbox.org/ticket/10222

```
VirtualBox --dbg --startvm <VM name>
```

- Mac: `osxpmem`
- Windows : `ftk imager/ winpmem / DumpIt`
- Linux: `avml`

### MacOS Forensics

- https://github.com/libyal/libfvde/wiki/
- https://web.archive.org/web/20190226133521/https://www.ma.rhul.ac.uk/static/techrep/2015/RHUL-MA-2015-8.pdf
- https://github.com/volatilityfoundation/profiles/tree/master/Mac
- https://github.com/volatilityfoundation/volatility/wiki/Mac
- https://github.com/tribalchicken/volatility-filevault2

### Windows Forensics

- https://andreafortuna.org/2017/10/20/windows-event-logs-in-forensic-analysis/
- https://andreafortuna.org/2017/06/25/volatility-my-own-cheatsheet-part-1-image-identification/
- https://github.com/superponible/volatility-plugins
- https://github.com/libyal/libbde/wiki/
- https://github.com/elceef/bitlocker

```
python3 ~/volatility3/vol.py -f dump windows.cmdline.CmdLine
python3 ~/volatility3/vol.py -f dump windows.filescan.FileScan
python3 ~/volatility3/vol.py -f dump windows.pslist.PsList
```

**Dump Volatility**:

```bash
# Dump l'éxécutable lié au processus de pid <PID>
python3 ~/volatility3/vol.py -f memory.dmp windows.pslist.PsList --pid <PID> --dump

# Dump tous les éxécutables + DLLs liés au pid <PID>
python3 ~/volatility3/vol.py -f memory.dmp windows.dumpfiles.DumpFiles --pid <PID>

# Dumps toute la mémoire liée au pid <PID>
python3 ~/volatility3/vol.py -f dump windows.memmap.Memmap --pid <PID> --dump
```

```bash
#Scan for files inside the dump
python3 ~/volatility3/vol.py -f file.dmp windows.filescan.FileScan
python3 ~/volatility3/vol.py -f file.dmp windows.dumpfiles.DumpFiles --physaddr <0xAAAAA> 
```

### Linux Forensics

- https://heisenberk.github.io/Profile-Memory-Dump/
- https://github.com/volatilityfoundation/volatility/wiki/Linux
- https://andreafortuna.org/2019/08/22/how-to-generate-a-volatility-profile-for-a-linux-system/
- https://github.com/glv2/bruteforce-luks

**Identifier kernel & OS**

```bash
python3 ~/volatility3/vol.py -f memory.dmp banners.Banners
```

**Find the kernel using GCC & /etc/apt/sources.list**

- https://www.pkusinski.com/sekai-ctf-2022-writeup-symbolicneeds/
- https://github.com/Abyss-W4tcher/volatility2-profiles
- https://github.com/volatilityfoundation/volatility/issues/807


#### Linux Profiles (VM mandatory for vol2)

```bash
# module.c (volatility/tools/linux)
MODULE_LICENSE("GPL");
```

```bash
git clone https://github.com/volatilityfoundation/volatility
cd volatility/volatility/tools/linux
make
cd
zip $(lsb_release -i -s)_$(uname -r)_profile.zip volatility/tools/linux/module.dwarf /usr/lib/debug/boot/System.map-4.19.0-26-amd64

cp Debian_4.19.0-26-amd64_profile.zip volatility/volatility/plugins/overlays/linux
```

### Linux Symbols (Vol3)

- https://github.com/Abyss-W4tcher/volatility3-symbols

```bash
dwarf2json linux --system-map /path/to/System.map-4.19.0-26-amd64 --elf /path/to/vmlinux-4.19.0-26-amd64 > debian.json
vol3 -s ./symbols -f hsr2024.dmp linux.bash
```

#### Handmade

`https://packages.debian.org/<version debian>/<architecture>/<nom du packet>/download`

```txt
linux-image-<version>-<architecture>-dbg
linux-image-<version>-<architecture>
linux-headers-<version>-<architecture>
```

*1/° System.map*

```bash
mkdir linux-image; cd linux-image
wget http://security.debian.org/debian-security/pool/updates/main/l/linux-signed-amd64/linux-image-4.19.0-26-amd64_4.19.304-1_amd64.deb
7z x linux-image-4.19.0-26-amd64_4.19.304-1_amd64.deb
tar -xf data.tar
find . | grep -i System.map
```

*2/° vmlinux*

```bash
mkdir linux-image-dbg; cd linux-image-dbg
wget http://security.debian.org/debian-security/pool/updates/main/l/linux/linux-image-4.19.0-26-amd64-dbg_4.19.304-1_amd64.deb
7z x linux-image-4.19.0-26-amd64-dbg_4.19.304-1_amd64.deb
tar -xf data.tar
find . | grep -i vmlinux
```

*3/° dwarf2json*

```bash
dwarf2json linux --system-map /path/to/System.map-4.19.0-26-amd64 --elf /path/to/vmlinux-4.19.0-26-amd64 > debian.json
vol3 -s ./symbols -f hsr2024.dmp linux.bash
```

#### Symbols using Docker

- [volatility-docker](../Dockerfile)
- https://openclassrooms.com/fr/courses/2035766-optimisez-votre-deploiement-en-creant-des-conteneurs-avec-docker/6211517-creez-votre-premier-dockerfile)

```bash
docker build -t dwarf2json .

CONTAINER_ID=$(docker run -ti --rm -d dwarf2json)
docker cp $CONTAINER_ID:/dwarf2json/linux-image-5.10.0-21-amd64.json volatility3/volatility3/symbols

docker rm -f $CONTAINER_ID
```

```bash
python volatility3/vol.py -f memory.dmp linux.bash
```

### Android

- https://forensics.spreitzenbarth.de/2012/02/28/cracking-pin-and-password-locks-on-android/
- https://android.googlesource.com/platform/system/tools/mkbootimg/+/refs/heads/master/unpack_bootimg.py
- https://github.com/504ensicsLabs/LiME
- https://github.com/volatilityfoundation/volatility/wiki/Android
- https://github.com/SorCelien/CTF-WRITEUPS/blob/main/FCSC-2021/forensics/ordiphone-1.md
