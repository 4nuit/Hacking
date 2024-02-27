## Documentation

- mes notes `arch.md`

- autres `*.md` @Xarus

- [Modern Operating Systems - A. Tanenbaum](https://csc-knu.github.io/sys-prog/books/Andrew%20S.%20Tanenbaum%20-%20Modern%20Operating%20Systems.pdf)

### Outils

- https://www.commandlinefu.com/commands/browse

- https://github.com/ThePorgs/Exegol

### Arch setup

- https://www.linuxtricks.fr/wiki/personnaliser-son-shell-alias-couleurs-bashrc-cshrc
- https://scriptim.github.io/bash-prompt-generator/
- https://wiki.archlinux.org/title/User:Grufo/Color_System%27s_Bash_Prompt#A_well-established_Bash_color_prompt

- https://github.com/FredBezies/arch-tuto-installation/blob/master/install.md
- https://wiki.archlinux.org/title/Microsoft_fonts#Using_fonts_from_a_Windows_partition
- https://github.com/mgottschlag/kwin-tiling

### Cryptsetup

- https://cheatsheet.haax.fr/cryptography/aes/

#### LUKS partitions

```bash
cryptsetup open /dev/sdXn luks_partition
cryptsetup --key-file /root/home.key open /dev/sdXn luks_partition
mount /dev/mapper/luks_partition

cryptsetup close /dev/sdXn luks_partition
umount /dev/mapper/luks_partition
```

#### Veracrypt partitions

```bash
cryptsetup open --type=tcrypt --veracrypt --key-file=/mnt/test /dev/sda4 tcrypt_home
mount /dev/mapper/tcrypt_home /mnt/home
```

### Docker

- https://www.cybereason.com/blog/container-escape-all-you-need-is-cap-capabilities
- https://viktorbarzin.me/blog/16-ssh-forwarding-quirks/
- https://0xn3va.gitbook.io/cheat-sheets/container/escaping/exposed-docker-socket

### Disque

#### Physical

```bash
fdisk -l
mount challenge.ntfs -o ro,offset=$((64*512)) /mnt/test
```

```bash
sudo mount -o ro,loop challenge.ntfs /mnt/test
```

#### Virtual

```bash
sudo modprobe nbd
sudo qemu-nbd -c /dev/nbd0 /media/data/virtruals_machines/Marionnet-Debian8.qcow2 #mount
sudo qemu-nbd -d /dev/nbd0 #unmount
```

```bash
qemu-img convert -f vdi -O qcow2 test.vdi test.qcow2
```

#### Delete file

`Réecriture de zéros`

```bash
shred -uvz file.txt
```

### Ecran

```bash
xrandr #corriger résolution
xrandr --output eDPA --mode 1600x900
sudo nano /etc/default/grub
#GRUB_CMDLINE_LINUX="video=VGA-1:1920x1080"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Python

#### Pyenv

```bash
curl https://pyenv.run | bash #https://github.com/pyenv/pyenv
pyenv install 3.9
pyenv global 3.9.18
pyenv virtualenv test
pyenv versions #3.9, test
```
ou
```bash
pip install pipx
pipx install virtualenv
virtualenv test
source test/bin/activate
```

#### Broken Dependencies

```bash
sudo rm -rf /usr/lib/python3*/site-packages
python -m ensurepip
pip install --upgrade pip
```

#### Externally Managed Env.

- https://bbs.archlinux.org/viewtopic.php?id=286788

### Rsync

```bash
rsync --sparse=always -a --delete <src> <target>
```

The first 3 options allow to make a perfect clone.

* `--sparse=always` : copy file with they correct size

* `--delete` : delete extraneous files from dest dirs

* `-a`: `-rlptgoD`

```bash
alias clone="rsync -a --delete --sparse=always -u -i -v -h --info=progress2"
```

### SSH

```bash
ssh-keygen -t rsa -b 16384
```

#### Port Forwarding

- https://ittavern.com/visual-guide-to-ssh-tunneling-and-port-forwarding/

- https://iximiuz.com/en/posts/ssh-tunnels/

```bash
ssh -gN -L 8000:127.0.0.1:8000 nicolas@192.168.122.42 -p 222
```

- `-g` Allow remote connection to connect to the local forwarded port
- `-N` do not open a prompt
- `-L` Forwarding port
- `local_port:ip:distant_port`

### USB

- https://www.sstic.org/2022/presentation/sasusb_presentation_dun_protocole_sanitaire_pour_lusb/


`Exemple d'injection`

```bash
import os

commands = ['hostname', 'uname -a', 'cat /proc/cpuinfo', 'lscpu', 'free -h', 'cat /proc/meminfo', 'df -h', 'lsblk', 'ifconfig', 'ip a', 'netstat -tuln', 'top', 'htop', 'uptime', 'who', 'w', 'uname -r', 'dmesg | grep Linux']
for c in commands:
    try:
        os.system(c)
    except:
        print("Error: " + c)
```
