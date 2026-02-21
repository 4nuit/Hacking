# CryptSetup

## Charcher les modules necessaires (iso arch linux uniquement):

```bash
modprobe dm-crypt
modprobe dm-mod
```

## Arguments Commande `cryptsetup`

- `-v` verbose mode
- `-c` `--cipher` cipher (`--cipher aes-xts-plain64`)
- `-s` `--key-size` taille de la clé (`--key-size 512`)
- `-h` `--hash` hash du passphrase (`--hash sha512`)
- `--type` type de partition (`--type=tcrypt`)
- `--veracrypt` specify veracrypt version of truecrypt
- `--key-file` file thet containe the key of the partition (`/root/data.key`)
- `/dev/sdXn` partition (`/dev/sda1`)
- `mapper` (`luks_root`, `tcrypt_home`)

## Chiffrer une partition avec LUKS

```bash
cryptsetup luksFormat -v --cipher aes-xts-plain64 --key-size 512 --hash sha512 /dev/sdXn
```

```bash
dd if=/dev/urandom of=/root/home.key bs=512 count=1
chmod 0400 /root/home.key
```

```bash
cryptsetup luksAddKey /root/home.key /dev/sdX
cryptsetup luksDump /dev/sdX
cryptsetup luksOpen --key-file /root/home.key --test-passphrase --key-slot 1 /dev/sdX
```

```bash
cryptsetup luksRemoveKey ?
```

## Ouvrir une partition chiffrée avec LUKS

### LUKS partitions

```bash
cryptsetup open /dev/sdXn luks_partition
cryptsetup --key-file /root/home.key open /dev/sdXn luks_partition
mount /dev/mapper/luks_partition

cryptsetup close /dev/sdXn luks_partition
umount /dev/mapper/luks_partition
```

### Veracrypt partitions

```bash
cryptsetup open --type=tcrypt --veracrypt --key-file=/mnt/test /dev/sda4 tcrypt_home
mount /dev/mapper/tcrypt_home /mnt/home
```

## fstab

```bash
/dev/mapper/tcrypt_home    /home            btrfs    rw,relatime    0    2
/dev/mapper/luks_data      /media/data      ext4     rw,relatime    0    2
```

not that UUID partition does not work with mapper, you must specify: `/dev/mapper/mapper_name`

## CrpytTab

### LUKS partitions

```bash
luks_data    UUID=b8ad5c18-f445-495d-9095-c9ec4f9d2f37    /root/data.key    luks
#or
luks_data    /dev/sdXn    /root/data.key    luks
```

ici, `/root/data.key` est une cle de la partition.

### Veracrypt partitions

```bash
tcrypt_home    UUID=b8ad5c18-f445-495d-9095-c9ec4f9d2f37    /dev/null    tcrypt-veracrypt,tcrypt-keyfile=/root/keyfile
# or
tcrypt_home    /dev/sdb1    /root/passwd    tcrypt-veracrypt,tcrypt-keyfile=/root/keyfile
```

ici:

- `tcrypt-keyfile=/root/keyfile` est la cle de la partition (block de données) 

- `/root/passwd` est un fichier text `UTF-8` qui contient le mot de passe de la partition

`tcrypt-system` peut etre ajouter pour si la partition veracrypt est une partition system.
