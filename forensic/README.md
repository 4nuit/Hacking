## Docs

- https://www.dfir.training/downloads/cheats-infographics?category[0]=9&category_children=1

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

### Profils Linux (Vol2)

- https://github.com/Abyss-W4tcher/volatility2-profiles

```bash
python2 ~/volatility/vol.py -f dump --profile=Win7SP1x86 filescan | grep .exe
python2 ~/volatility/vol.py -f dump --profile=Win7SP1x86 dumpfiles -D files/ > dump_files_found
python2 ~/volatility/vol.py -f dump --profile=Win7SP1x86 dumpfiles -D output -Q 0x....
```

### Symboles Linux (Vol3)

- https://github.com/Abyss-W4tcher/volatility3-symbols

```bash
python ~/volatility3/vol.py -f memory.dmp banners.Banners
# Linux 5.x-y
```

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
