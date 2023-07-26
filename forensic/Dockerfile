# Version souhaitée de l'OS
FROM debian:bullseye

# Update et installation des dépendances nécessaires à Dwarf2json

# /!\
# Il faut charger l'image `-dbg` avec la version trouvée pour avoir le fichier DWARF

RUN apt update
RUN apt install -y \
  linux-image-5.10.0-23-amd64-dbg \
  linux-headers-5.10.0-23-amd64 \
  golang-go git
# Récupération de Dwarf2json
RUN git clone https://github.com/volatilityfoundation/dwarf2json

WORKDIR dwarf2json

# On build puis on génère le fichier JSON depuis le fichier DWARF
RUN go mod download github.com/spf13/pflag
RUN go build
RUN ./dwarf2json linux --elf /usr/lib/debug/boot/vmlinux-5.10.0-23-amd64 > linux-image-5.10.0-23-amd64.json

CMD ["sleep", "3600"]
