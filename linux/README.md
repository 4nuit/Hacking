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

### Docker

- https://www.cybereason.com/blog/container-escape-all-you-need-is-cap-capabilities
- https://viktorbarzin.me/blog/16-ssh-forwarding-quirks/
- https://0xn3va.gitbook.io/cheat-sheets/container/escaping/exposed-docker-socket

### Disque

```bash
fdisk -l
mount challenge.ntfs -o ro,offset=$((64*512)) /mnt/test
```

```bash
sudo mount -o ro,loop challenge.ntfs /mnt/test
```

**Supprimer réellement un fichier** 

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

### Port Forwarding

- https://ittavern.com/visual-guide-to-ssh-tunneling-and-port-forwarding/

- https://iximiuz.com/en/posts/ssh-tunnels/

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
