## Docs

- https://www.dfir.training/downloads/cheats-infographics?category[0]=9&category_children=1
- https://andreafortuna.org/2017/06/23/how-to-extract-a-ram-dump-from-a-running-virtualbox-machine/
- https://andreafortuna.org/2019/08/22/how-to-generate-a-volatility-profile-for-a-linux-system/

## Tools:

- [Autopsy](https://www.sleuthkit.org/)
- `binwalk` (`binwalk -e <file>` , `binwalk -dd="*" <file>`)
- [Dive (docker)](https://github.com/wagoodman/dive)
- `photorec` (récupérer les fichiers supprimés (unlinkés)
-  https://github.com/corkami/docs/blob/master/PDF/PDF.md

- `volatility`:
        - profils linux avec [Vol2 (HackSecuReims)](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/HackSecuReims/forensic/memdump)

`Une fois setup ci dessous effectué`

https://volatility3.readthedocs.io/en/latest/getting-started-linux-tutorial.html#

## Analyse de logs

- https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/forensic/weird_shell
- https://discuss.vlug.narkive.com/gHWmeiHQ/how-to-interpret-dev-input-event0

## Anti forensic

- https://github.com/sundowndev/covermyass
- https://www.hackthebox.com/blog/anti-forensics-techniques

## Exfiltration

- https://tshark.dev/

- https://wiki.wireshark.org/SampleCaptures

```bash
tshark -2 -r chall.pcap -T fields -e data
# add -R "ip.addr == 127.0.0.1 && icmp.type==8"
```

## Macros - PDF 

- https://stackoverflow.com/questions/10220497/extract-javascript-from-malicious-pdf
- https://github.com/jesparza/peepdf
- https://blog.didierstevens.com/programs/pdf-tools/

```bash
pip install oletools
```

## Mount Bitlocker Disk Encryption

```bash
yay -S libbde
```

## Os Specific

### MacOS Forensics

- https://web.archive.org/web/20190226133521/https://www.ma.rhul.ac.uk/static/techrep/2015/RHUL-MA-2015-8.pdf

### Windows Forensics

- https://andreafortuna.org/2017/10/20/windows-event-logs-in-forensic-analysis/
- https://github.com/superponible/volatility-plugins

**Analyse Volatility**:

```
python ~/volatility3/vol.py -f dump windows.cmdline.CmdLine
python ~/volatility3/vol.py -f dump windows.filescan.FileScan
python ~/volatility3/vol.py -f dump windows.pslist.PsList
```

**Dump Volatility**:

```bash
# Dump l'éxécutable lié au processus de pid <PID>
python ~/volatility3/vol.py -f memory.dmp windows.pslist.PsList --pid <PID> --dump

# Dump tous les éxécutables + DLLs liés au pid <PID>
python ~/volatility3/vol.py -f memory.dmp windows.dumpfiles.DumpFiles --pid <PID>

# Dumps toute la mémoire liée au pid <PID>
python3 ~/volatility3/vol.py -f dump windows.memmap.Memmap --pid <PID> --dump
```

### Profils Linux (Vol2)

**Identifier kernel & OS**

```bash
python ~/volatility3/vol.py -f memory.dmp banners.Banners
```

- https://github.com/Abyss-W4tcher/volatility2-profiles
- https://github.com/volatilityfoundation/volatility/issues/807

```bash
# module.c (volatility/tools/linux)
MODULE_LICENSE("GPL");
```

**Trouver le bon kernel à partir de GCC + /etc/apt/sources.list general**

- https://www.pkusinski.com/sekai-ctf-2022-writeup-symbolicneeds/
- https://www.andynoel.xyz?p=494

### Symboles Linux (Vol3)

- https://github.com/Abyss-W4tcher/volatility3-symbols

```bash
dwarf2json linux --system-map /path/to/System.map-4.19.0-26-amd64 --elf /path/to/vmlinux-4.19.0-26-amd64 > debian.json
vol3 -s ./symbols -f hsr2024.dmp linux.bash
```

#### Symboles - À la main

`https://packages.debian.org/<version debian>/<architecture>/<nom du packet>/download`

```txt
linux-image-<version>-<architecture>-dbg
linux-image-<version>-<architecture>
linux-headers-<version>-<architecture>
```

*1/° System.map*

```bash
mkdir linux-image; cd linux-image
wget https://packages.debian.org/buster/amd64/linux-image-4.19.0-26-amd64/download
7z x linux-image-4.19.0-26-amd64_4.19.304-1_amd64.deb
tar -xf data.tar
find . | grep -i System.map
```

*2/° vmlinux*

```bash
mkdir linux-image-dbg; cd linux-image-dbg
wget wget http://security.debian.org/debian-security/pool/updates/main/l/linux/linux-image-4.19.0-26-amd64-dbg_4.19.304-1_amd64.deb
7z x linux-image-4.19.0-26-amd64-dbg_4.19.304-1_amd64.deb
tar -xf data.tar
find . | grep -i vmlinux
```

*3/° dwarf2json*

```bash
dwarf2json linux --system-map /path/to/System.map-4.19.0-26-amd64 --elf /path/to/vmlinux-4.19.0-26-amd64 > debian.json
vol3 -s ./symbols -f hsr2024.dmp linux.bash
```

#### Symboles - Vm ou Docker

```Dockerfile
# Version souhaitée de l'OS
FROM debian:bullseye

ARG KERNEL_VERSION=5.10.0-21
ARG KERNEL_ARCH=amd64

# Update et installation des dépendances nécessaires à Dwarf2json

# /!\
# Il faut charger l'image `-dbg` avec la version trouvée pour avoir le fichier DWARF

RUN apt update
RUN apt install -y \
  linux-image-${KERNEL_VERSION}-${KERNEL_ARCH}-dbg \
  linux-headers-${KERNEL_VERSION}-${KERNEL_ARCH} \
  build-essential golang-go git make

# Volatility3
# Récupération de Dwarf2json
RUN git clone https://github.com/volatilityfoundation/dwarf2json

WORKDIR dwarf2json

# On build puis on génère le fichier JSON depuis le fichier DWARF
RUN go mod download github.com/spf13/pflag
RUN go build
RUN ./dwarf2json linux --elf /usr/lib/debug/boot/vmlinux-${KERNEL_VERSION}-${KERNEL_ARCH} > linux-image-${KERNEL_VERSION}-${KERNEL_ARCH}.json

CMD ["sleep", "3600"]
```

[Memo](https://openclassrooms.com/fr/courses/2035766-optimisez-votre-deploiement-en-creant-des-conteneurs-avec-docker/6211517-creez-votre-premier-dockerfile)

```bash
docker build -t dwarf2json .

CONTAINER_ID=$(docker run -ti --rm -d dwarf2json)
docker cp $CONTAINER_ID:/dwarf2json/linux-image-5.10.0-21-amd64.json volatility3/volatility3/symbols

docker rm -f $CONTAINER_ID
```

```bash
python volatility3/vol.py -f memory.dmp linux.bash
```

### Profils Android

- https://android.googlesource.com/platform/system/tools/mkbootimg/+/refs/heads/master/unpack_bootimg.py

- https://github.com/504ensicsLabs/LiME
