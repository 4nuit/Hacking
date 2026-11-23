# Arch Linux Install

## Pré-Installation

lister les claviers: `ls /usr/share/kbd/keymaps/**/*.map.gz`

charger la config clavier fr: `loadkeys fr` (ou) `loadkeys fr-latin1`

verifier la co: `ping -c 1 archlinux.org` 

actualiser l'orloge system: `timedatectl set-ntp true`

set default editor: `export EDITOR=vim` ou `export EDITOR=nano` (si vous etes un newbie)

## Pour les flèmards

script pour une installation automatique: `curl -L matmoul.github.io/archfi > archfi` et `./archfi`

## Insallation

### Creation et montage des partitions

System de partition: **GPT**

lister les partitions: `fdisk -l`

outil de partition: `cfdisk`

pour éditer le premier disk `cfdisk /dev/sda` ou `cfdisk /dev/nvme0n1`

partitions:

- efi (50Mo a 500Mo)
- boot (512Mo/1Go) (optionnel si pas chiffrées)
- root (120/160Go)
- home (tous l'espace restant)

Ajouter le tag EFI system pour la partition `efi` ou `boot` (oui le tag peut s'appeler 'boot' meme si il n'y a rien a voir avec la partition de boot)

#### Partitions Chiffrées

cf [Partitions Chiffrées](./partition_chiffree.md)

```bash
cryptsetup luksFormat -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 /dev/vda3
```

#### LVM

cf [lvm.md](./lvm.md) 

(`lvmdiskscan`)

```bash
# physical volume
pvcreate /dev/mapper/luks_root
# volumes group
vgcreate vg0 /dev/sda1
# logical volumes
lvcreate -L 4G vg0 -n swap
lvcreate -l +100%FREE vg0 -n root
```

#### Formater les partitions

partition vfat pour l'efi: `mkfs -t fat -n "efi" /dev/sdXn`

partition etx4 pour le boot: `mkfs -t ext4 -L boot /dev/sdXn`

partition btrfs/ext4 pour le root: `mkfs -t btrfs -L root /dev/sdXn` ou `mkfs -t btrfs -L root /dev/mapper/luks_root` ou `mkfs -t btrfs -L root /dev/vg0/root`

partition btrfs pour le home: `mkfs -t btrfs -L home /dev/sdXn` ou `mkfs -t btrfs -L home /dev/mapper/tvrypt_home`

* `-L` presise le nom de la partition (sauf pour les partition vfat: `-n`)

See partition:

```bash
lsblk -f
```

#### Monter les partitions

racine:

```bash
mount /dev/mapper/luks_root    /mnt    # si chiffrer
mount /dev/sdXn                /mnt    # si non chiffrer
mount /dev/mapper/luks_root    /mnt    -o compress-force=zstd:3 # compressions btrfs
mount /dev/vg0/root            /mnt    -o compress-force=zstd:3 # compressions btrfs
```

boot:

```bash
mkdir /mnt/boot                
mount /dev/sdXn /mnt/boot
```

efi: (si system efi)

```bash
mkdir /mnt/boot/efi
mount /dev/sdXn /mnt/boot/efi
```

home:

```bash
mkdir /mnt/home
mount /dev/sdXn                  /mnt/home    # si chiffrer
mount /dev/mapper/tcrypt_home    /mnt/home    # si non chiffrer
mount /dev/mapper/luks_root      /mnt/home    -o subvol=home,compress-force=zstd:3
mount /dev/vg0/root              /mnt/home    -o compress-force=zstd:3,subvol=/home # compressions btrfss
```

#### Swap

crée un swap dans une partition LVM:

```bash
dd if=/dev/zero of=/dev/vg0/swap bs=1M status=progress
mkswap /dev/vg0/swap
swapon /dev/vg0/swap
```

créer un swap dans un fichier sur la partition system:

```bash
btrfs subvolume create /mnt/swap
chattr +C /mnt/swap
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=4096 # for non trunc swap file
# truncate -s 4G /mnt/swapfile # will make uncontinious swap file (DON'T)
chattr +C /mnt/swap/swapfile # needed to disable copy on write
chmod 0600 /mnt/swap/swapfile
btrfs property set /mnt/swap/swapfile compression none
mkswap /mnt/swap/swapfile
swapon /mnt/swap/swapfile
```

(pour un swap de 1G: `count=1024` pour 8G: `count=8192`)

### Instalation du core du system

```bash
pacstrap -i /mnt linux linux-headers linux-firmware base base-devel grub efibootmgr btrfs-progs lvm2 pacman-contrib
```

```bash
pacstrap -i /mnt linux-zen linux-zen-headers # use zen kernel for evry day uses
```

```bash
pacstrap -i /mnt dhcpcd vim os-prober
```

```pacman
pacstrap -i /mnt mkinitcpio-netconf mkinitcpio-tinyssh mkinitcpio-utils
```

*vim may be optionnal here (depends if you are an alien or a human)*

verrify that btrfs compressions is working:

```bash
df -h /mnt # show partition usage size
du -hs /mnt # show size of file on disque
```

### Montage automatique des partitions

#### fstab

```bash
genfstab -U -p /mnt > /mnt/etc/fstab
```

- `-U` utiliser les UUID des partitions comme identifiant (important)
- `-p` exclu les system de fichiers temporaires (comportement par default)

##### Mapper partitions

(cryptsetup et truecrypt/veracrypt)

Les UUIDs ne peuvent pas etre utiliser avec les partitions virtuelles (mapper des partitions chiffrées), il faut donc les ajouter manuellement a `/etc/fstab`

root:

```bash
/dev/vg0/root    /    btrfs    defaults,compress-force=zstd:3    0    0
```

home:

```bash
/dev/mapper/tcrypt_home    /home    btrfs    defaults,rw    0    2
```

swap:

(LVM partition)

```bash
/dev/vg0/swap    none    swap    defaults,noatime    0    0
```

(btrfs swapfile)

```bash
/dev/mapper/luks_root    /swap    btrfs    defaults,noatime,subvol=swap    0    0
/swap/swapfile           none     swap     defaults,noatime                0    0
```

tmpfs: # if modify (already manage by default, without fstab entry, with half of the memory)

```bash
tmpfs    /tmp    tmpfs    rw,size=8G    0    0
```

`noatime`: do not upodate acess time (so no write on read)

see: `man mount` mfor more infos

#### Monter les partitions chiffrees au boot

editer: `/etc/crypttab`

```bash
luks_home      /dev/sdXn    /root/root.key    default                                              # partitions LUKS
tcrypt_home    UUID=b8ad5c18-f445-495d-9095-c9ec4f9d2f37    /root/passwd    tcrypt-veracrypt
```

La partition root ne peut pas etre ajouter au `crypttab` car, il contient le crypttab, il faut donc l'ajouter a GRUB. (cf. secction d'installation de GRUB)

### Configuration du reste du System

Enter chroot

```bash
arch-chroot /mnt
```

#### Set Computer Name (hostname)

`/etc/hostname`

```bash
nicofolxarus
```

`/etc/hosts`

```
127.0.0.1    localhost nicofolxarus
::1          localhost nicofolxarus
```

`/etc/sysctl.d/sysctl.conf`

```bash
net.ipv4.ip_forward=1
vm.swappiness=10
```

#### Set Keyboard Layout

```bash
localectl set-keymap fr
localectl set-x11-keymap fr
localectl status # verify set
```

`/etc/vconsole.conf`

```bash
KEYMAP=fr # très important si disque chiffré (keymap par default du HOOKS keymap use by ENCRYPT)
```

#### Set Locale

`/etc/locale.conf`

```bash
LANG="en_US.UTF-8"
```

```bash
LC_CTYPE="fr_FR.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_TIME="fr_FR.UTF-8"
LC_NUMERIC="fr_FR.UTF-8"
LC_MONETARY="fr_FR.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_RESPONSE="en_US.UTF-8"
LC_PAPER="fr_FR.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="fr_FR.UTF-8"
LC_TELEPHONE="fr_FR.UTF-8"
LC_MEASUREMENT="fr_FR.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
```

`curl 192.168.122.1/nmarie/locale.conf > /etc/locale.conf`

`/etc/locale.gen`

```bash
en_US.UTF-8
fr_FR.UTF-8
```

Confirme local:

```bash
locale-gen
```

#### Set Time

```bash
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
```

Confirme Time in chroot:

```bash
hwclock --systohc --utc
```

#### Set root pawsword

```bash
passwd root
```

#### Bootloader

```bash
grub-install --recheck /dev/snvme0n1 --target=x86_64-efi --boot-directory=/boot --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
```

pour les partitions crypters:

`/etc/default/grub` *DEFAULT tag may be remove*

```bash
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=/dev/sdXn:luks_root resume=swap_device resume_offset=swap_file_offset"
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash cryptdevice=UUID=<uuid>:luks_lvm root=/dev/vg0/root resume=swap_device resume_offset=swap_file_offset"
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 cryptdevice=UUID=<uuid>:luks_lvm root=/dev/vg0/root ip=:::::eth0:dhcp"
```

`blkid` (may help) (5b1e300d-8389-46ef-aa06-6b0c59b869f7)

Add public key in `/etc/tinyssh/root_key` for remote encrypted root.

(use `ed25519`, (RSA not supported))

#### InitCPIO

`vim /etc/mkinitcpio.conf`

change: `HOOKS=(base udev autodetect keyboard modconf block filesystems fsck)`

to: `HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems fsck)`

or: `HOOKS=(base udev autodetect keyboard keymap modconf block encrypt lvm2 filesystems resume fsck)`

or to`HOOKS=(base udev plymouth autodetect keyboard keymap consolefont modconf block plymouth-encrypt lvm2 filesystems resume fsck)`

remote unlock `HOOKS=(base udev autodetect keyboard keymap consolefont modconf block netconf tinyssh encryptssh lvm2 filesystems fsck)`

(`lvm2` must be between block and filesystems)

```bash
mkinitcpio -p linux # linux-zen
```

#### repo and keyring

sort repos and initialize keyring:

```bash
systemctl enable dhcpcd

pacman -S reflector
reflector --verbose --protocol https --latest 70 --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose --protocol https --latest 50 --sort rate --country France,Germany --age 12 --save /etc/pacman.d/mirrorlist
pacman -S archlinux-keyring
pacman-key --init
pacman-key --populate archlinux
#pacman-key --refresh-keys
```

#### reboot

`reboot`
