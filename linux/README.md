## Documentation

- https://notes.shichao.io/
- https://www.0x0ff.info/2013/bash-share/
- https://debian-facile.org/doc:systeme:chroot
- https://debian-handbook.info/browse/fr-FR/stable/
- https://cyber.gouv.fr/publications/recommandations-de-securite-relatives-un-systeme-gnulinux
- [Modern Operating Systems - A. Tanenbaum](https://csc-knu.github.io/sys-prog/books/Andrew%20S.%20Tanenbaum%20-%20Modern%20Operating%20Systems.pdf)
- https://0xax.gitbooks.io/linux-insides/content/
- https://libc.rip/ # doc libc

## Outils

- https://apparmor.net
- https://github.com/pyenv/pyenv-installer/
- https://wiki.archlinux.org/title/VeraCrypt/
- https://github.com/AdnanHodzic/auto-cpufreq/
- https://www.commandlinefu.com/commands/browse/


- https://gtfobins.github.io/
- https://github.com/peass-ng/PEASS-ng/blob/master/linPEAS/README.md/
- https://github.com/PercussiveElbow/docker-escape-tool/
- https://github.com/cdk-team/CDK/ # Docker linPEAS
- https://github.com/docker/docker-bench-security
- https://github.com/ThePorgs/Exegol/

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

### Crack /etc/shadow (persistence)

```
unshadow /etc/passwd /etc/shadow > unshadowed.txt
john --wordlist=/usr/share/wordlists/rockyou.txt unshadowed.txt
```

### Crack SSH key passphrase

```bash
ssh2john private.pem > hash
john hash --wordlist=/usr/share/wordlists/rockyou.txt
```

### Disques

```bash
fdisk -l
mount challenge.ntfs -o ro,offset=$((64*512)) /mnt/test
```

```bash
sudo mount -o ro,loop challenge.ntfs /mnt/test
```

### Docker

- https://github.com/docker/docker-bench-security
- https://viktorbarzin.me/blog/16-ssh-forwarding-quirks/
- https://0xn3va.gitbook.io/cheat-sheets/container/escaping/exposed-docker-socket
- https://www.cybereason.com/blog/container-escape-all-you-need-is-cap-capabilities

### Jails

- https://shirajuki.js.org/blog/pyjail-cheatsheet

### SUID

- https://stackoverflow.com/questions/32455684/difference-between-real-user-id-effective-user-id-and-saved-user-id
- https://book.hacktricks.xyz/linux-hardening/privilege-escalation/euid-ruid-suid

### Shared Objects

- https://github.com/HackTricks-wiki/hacktricks/blob/master/linux-hardening/privilege-escalation/README.md

```bash
ldconfig -p
ldd ./vuln
readelf -d ./vuln | grep "PATH"
readelf -d ./vuln | egrep "NEEDED|PATH"
```

### SSH

- https://grahamhelton.com/blog/ssh-cheatsheet/
- https://viktorbarzin.me/blog/16-ssh-forwarding-quirks/

#### RSA Auth on distant server

```bash
ssh server@ip	# upgrade, install sshd
mkdir ~/.ssh && chmod 700 ~/.ssh
```

```bash
# Our machine
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519_account -C "account"
nano ~/.ssh/config
```

```txt
Host SERVER
	Hostname NAME
	User USER
	Port PORT
	IdentityFile ~/.ssh/id_ed25519_account
	IdentitiesOnly yes
	ForwardAgent no
```

```bash
# Distant server
scp ~/.ssh/id_ed25519_account.pub server@ip:~/.ssh/authorized_keys
sudo nano /etc/ssh/sshd_config
```

```txt
Port 717
AddressFamily inet
PermitRootLogin no
PasswordAuthentication no
```

```bash
sudo systemctl restart sshd
```

`ssh server@ip -p 717`

```bash
sudo ufw allow 717
sudo ufw enable
sudo ufw allow 8000/tcp
```

```bash
# sudo nano /etc/ufw/before.rules -> then sudo ufw reload
# ok icmp for INPUT
-A ufw-before-input -p icmp --icmp-type echo-request -j DROP
```

#### Agent Hijacking

- https://www.clockwork.com/insights/ssh-agent-hijacking/

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
