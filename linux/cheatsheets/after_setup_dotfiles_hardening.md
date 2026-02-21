## Setup, Dotfiles & co

- https://www.linuxtricks.fr/wiki/personnaliser-son-shell-alias-couleurs-bashrc-cshrc
- https://scriptim.github.io/bash-prompt-generator/
- https://wiki.archlinux.org/title/User:Grufo/Color_System%27s_Bash_Prompt#A_well-established_Bash_color_prompt
- https://github.com/FredBezies/arch-tuto-installation/blob/master/install.md
- https://wiki.archlinux.org/title/Microsoft_fonts#Using_fonts_from_a_Windows_partition
- https://github.com/mgottschlag/kwin-tiling

```bash
cd /etc/xdg/autostart; sudo rm *kdeconnect* *kalendar* *geoclue* *discover*; cd
```

## Optimisation

- https://github.com/AdnanHodzic/auto-cpufreq

## Security - Hardening

- https://wiki.archlinux.org/title/Security
- https://wiki.archlinux.org/title/Data-at-rest_encryption
- https://wiki.archlinux.org/title/Security#Kernel_lockdown_mode
- https://wiki.archlinux.org/title/AppArmor
- https://theprivacyguide1.github.io/linux_hardening_guide/
- https://wonderfall.space/linux-bricoles/
- https://chrisdown.name/2018/01/02/in-defence-of-swap.html

```bash
#sudo nano /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
#GRUB_DISABLE_OS_PROBER=false
#GRUB_DISTRIBUTOR="Arch"
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash lsm=lockdown,yama lockdown=integrity intel_iommu=on amd_iommu=on efi=disable_early_pci_dma"

# Create /boot/efi/EFI/Arch/grubx64.efi
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --modules="tpm" --disable-shim-lock
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

```bash
#/etc/systemd/system/fwupdst.service

[Unit]
Description=Fwupd Daemon Service
DefaultDependencies=no
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/night
ExecStart=/usr/lib/fwupd/fwupd -vv
TimeoutstartSec=0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
^X

sudo systemctl daemon-reload && systemctl enable fwupdst
```

```bash
sudo sysctl -p sysctl_list.txt
sudo lynis audit system
```
