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

### Profils Linux (Vol3)

```bash
python ~/volatility3/vol.py -f memory.dmp banners.Banners
# Linux 5.x-y
```

```Dockerfile
# Version souhaitée de l'OS
FROM debian:bullseye

# Update et installation des dépendances nécessaires à Dwarf2json

# /!\
# Il faut charger l'image `-dbg` avec la version trouvée pour avoir le fichier DWARF

RUN apt update
RUN apt install -y \
  linux-image-5.10.0-21-amd64-dbg \
  linux-headers-5.10.0-21-amd64 \
  golang-go git
# Récupération de Dwarf2json
RUN git clone https://github.com/volatilityfoundation/dwarf2json

WORKDIR dwarf2json

# On build puis on génère le fichier JSON depuis le fichier DWARF
RUN go mod download github.com/spf13/pflag
RUN go build
RUN ./dwarf2json linux --elf /usr/lib/debug/boot/vmlinux-5.10.0-21-amd64 > linux-image-5.10.0-21-amd64.json

CMD ["sleep", "3600"]
```

[Memo](https://openclassrooms.com/fr/courses/2035766-optimisez-votre-deploiement-en-creant-des-conteneurs-avec-docker/6211517-creez-votre-premier-dockerfile)

```bash
docker build -t dwarf2json .
docker run -ti --rm -d dwarf2json
# Copier le profil vers l'hôte pour Volatility
docker ps -a --filter "ancestor=dwarf2json" --format "{{.ID}}"
docker cp $(!!):/dwarf2json/linux-image-5.10.0-21-amd64.json .
cp vmlinux-5.10.0-21-amd64.json volatility3/volatility3/symbols
```

```bash
python volatility3/vol.py -f memory.dmp linux.bash
```

### Profils Android

https://github.com/504ensicsLabs/LiME

## Exfiltration

https://tshark.dev/
https://wiki.wireshark.org/SampleCaptures

## Analyse de logs

https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/forensic/weird_shell
