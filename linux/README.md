## Documentation

- https://notes.shichao.io/
- https://diveintosystems.org/book/
- https://debian-handbook.info/browse/fr-FR/stable/
- [Modern Operating Systems - A. Tanenbaum](https://csc-knu.github.io/sys-prog/books/Andrew%20S.%20Tanenbaum%20-%20Modern%20Operating%20Systems.pdf)
- https://popovicu.com/posts/linux-vm-without-vm-software-user-mode/
- https://madaidans-insecurities.github.io/guides/linux-hardening.html
- https://cyber.gouv.fr/publications/recommandations-de-securite-relatives-un-systeme-gnulinux

## Challenges

- https://tryhackme.com/module/linux-fundamentals
- https://overthewire.org/wargames/

## Tools

- https://apparmor.net
- https://github.com/pyenv/pyenv-installer/
- https://wiki.archlinux.org/title/VeraCrypt/
- https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-endpoint-linux

### Change password (Unlocked bios)

- https://libreboot.org/
- https://kleman.pw/posts/2022-08-18-modifier-initramfs-afin-de-r%C3%A9cup%C3%A9rer-la-passphrase-luks/

```bash
# e <edit> in Grub
# linux /boot/vmlinuz ... change `rw` -> `ro` and add `init=/bin/bash`

adduser new_user		# useradd on Arch
usermod -aG sudo new_user
deluser new_user		# userdel on Arch
```

THC : add space before each command (no logs)


### Commands 

#### Package managers

- https://wiki.archlinux.org/title/Pacman/Rosetta

#### MV/CP in bash scripts

- https://unix.stackexchange.com/questions/277412/cp-vs-mv-which-operation-is-more-efficient

```bash
# touch cur_script.sh new_script.sh && ls -i
# cp new_script.sh cur_script.sh && ls -i # INODE UNCHANGED
# prefer mv of cp
cp --remove-destination

# Treat unset variables as an error when substituting
bash -u
```

#### Su/Sudo

- https://www.sudo.ws/security/advisories/
- https://www.redhat.com/fr/blog/difference-between-sudo-su

### Disks

```bash
fdisk -l
mount challenge.ntfs -o ro,offset=$((64*512)) /mnt/test
```

```bash
sudo mount -o ro,loop challenge.ntfs /mnt/test
```

### SUID bash scripts

- https://tbhaxor.com/demystifying-suid-and-sgid-bits/
- https://security.stackexchange.com/questions/194166/why-is-suid-disabled-for-shell-scripts-but-not-for-binaries
- https://www.zerodayinitiative.com/blog/2023/4/5/bash-privileged-mode-vulnerabilities-in-parallels-desktop-and-cdpath-handling-in-macos

### Capabilities

- https://debian-facile.org/doc:systeme:chroot
- https://www.cybereason.com/blog/container-escape-all-you-eed-is-cap-capabilities
- https://stackoverflow.com/questions/3737008/how-to-run-a-command-in-a-chroot-jail-not-as-root-and-without-sudo

### Docker

- https://github.com/cdk-team/CDK
- https://github.com/docker/docker-bench-security
- https://viktorbarzin.me/blog/16-ssh-forwarding-quirks/
- https://0xn3va.gitbook.io/cheat-sheets/container/escaping/exposed-docker-socket
- https://tbhaxor.com/container-breakout-part-2/

#### Change storage

- https://www.ibm.com/docs/en/z-logdata-analytics/5.1.0?topic=compose-relocating-docker-root-directory

```bash
sudo systemctl stop docker
sudo systemctl stop docker.socket
sudo systemctl stop containerd

sudo mkdir -p ~/docker && sudo mv /var/lib/docker ~/docker

sudo vim /etc/docker/daemon.json
#{
#  "data-root": "/home/user/docker"
#}
sudo systemctl start docker
```

### Iptables

- https://netfilter.org/documentation/
- https://docs.docker.com/engine/network/
- https://linux.developpez.com/iptables/?page=correspondances

### Libvirt

#### Change storage

- https://nicolargo.developpez.com/tutoriels/virtualisation/apprentissage-qemu-libvirt-exemple/
- https://serverfault.com/questions/840519/how-to-change-the-default-storage-pool-from-libvirt

```bash
# Run libvirt : specify arch, new disk storage in the iso pool
# OR

virsh pool-edit default
```

#### Network issues

**Dnsmasq**

```bash
sudo systemctl stop dnsmasq
sudo systemctl disable dnsmasq
sudo virsh net-start default
```

**Nftables**

- https://superuser.com/questions/1776277/no-internet-connection-in-vm-with-libvirt-nat

```
sudo vim /etc/libvirt/network.conf
#firewall_backend = "iptables" => add/uncomment to replace nftables

sudo net-destroy default && sudo net-start default
sudo systemctl restart libvirtd
```


## SUID: Path & Shared Objects Hijacking

- https://stackoverflow.com/questions/32455684/difference-between-real-user-id-effective-user-id-and-saved-user-id
- https://book.hacktricks.xyz/linux-hardening/privilege-escalation/euid-ruid-suid

```bash
find / -perm -4000 2>/dev/null
strace ./vulnerable_suid_program
```

### Path Hijacking

- https://attack.mitre.org/techniques/T1574/007/

```bash
ln -s /bin/xxxx /bin/yyyy
env PATH=/tmp ./vulnerable_suid_program
```

### Shared Objects Hijacking

- https://howtech.substack.com/p/shared-library-interposition-how
- https://github.com/HackTricks-wiki/hacktricks/blob/master/linux-hardening/privilege-escalation/README.md

```bash
ldconfig -p
ldd ./vuln
readelf -d ./vuln | grep "PATH"
readelf -d ./vuln | egrep "NEEDED|PATH"
```

## SSH

- https://grahamhelton.com/blog/ssh-cheatsheet/
- https://viktorbarzin.me/blog/16-ssh-forwarding-quirks/

### Agent Hijacking

- https://www.clockwork.com/insights/ssh-agent-hijacking/

### Port Forwarding

- https://ittavern.com/visual-guide-to-ssh-tunneling-and-port-forwarding/
- https://iximiuz.com/en/posts/ssh-tunnels/

```bash
ssh -gN -L 8000:127.0.0.1:8000 nicolas@192.168.122.42 -p 222
```

- `-g` Allow remote connection to connect to the local forwarded port
- `-N` do not open a prompt
- `-L` Forwarding port
- `local_port:ip:distant_port`
