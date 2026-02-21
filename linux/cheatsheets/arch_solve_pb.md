## Wifi / Netork setup

- https://zestedesavoir.com/billets/3113/archlinux-et-installation-en-wifi/
- https://wiki.archlinux.org/title/iwd
- https://fr.linuxteaching.com/article/arch_linux_networkmanager
- https://aur.archlinux.org/packages/wpa_supplicant-wep

```bash
pacstrap /mnt linux-firmware iwlwifi
pacstrap /mnt linux-lts linux-lts-headers intel-ucode ntpd iwd dialog wpa_supplicant wifi_menu dhcpcd 
```
### Dhcp

- https://bbs.archlinux.org/viewtopic.php?id=212214
- https://forums.archlinux.fr/viewtopic.php?t=7597

```bash
systemctl enable dhcpcd.service
netctl
``` 
### Driver

- https://bbs.archlinux.org/viewtopic.php?id=257079

## Keys / Kernel parameters

### VMs / modules

**NB**: `lockdown` and `modules.sig_enforce=1` forbid to install non signed modules (e.g Virtualbox, VMWare)

- https://www.virtualbox.org/ticket/11577
- https://forums.virtualbox.org/viewtopic.php?t=112433 #disable EFI

### Grub

- https://forum.manjaro.org/t/grub-detecter-autres-disques-internes-et-usb/114756
- https://bbs.archlinux.org/viewtopic.php?id=252598

### Dual Boot

- https://forums.archlinux.fr/viewtopic.php?t=10701

## Keys

- https://forums.archlinux.fr/viewtopic.php?t=17836
- https://stackoverflow.com/questions/48117783/arch-linux-system-update-error-gpgme-error-no-data

```bash
sudo pacman-key --refresh-keys
```

## Audio

**NB**: `pipewire` and `pulseaudio` are incompatible. Use `pipewire-{pulse,alsa,jack}` instead of `pulseaudio pipewire-media-session` 

- https://wiki.archlinux.org/title/WirePlumber#Delete_corrupt_settings

## Python

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

### Broken Dependencies

```bash
sudo rm -rf /usr/lib/python3*/site-packages
python -m ensurepip
pip install --upgrade pip
```

### Externally Managed Env.

- https://bbs.archlinux.org/viewtopic.php?id=286788

```bash
sudo rm /usr/lib/python3.*/EXTERNALLY-MANAGED
```

