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
