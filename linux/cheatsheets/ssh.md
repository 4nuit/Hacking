# SSH

## SSH usage

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

## SSH key generation

```bash
ssh-keygen -t rsa -b 16384
```

- `-t` `rsa`|`ed25519` type de clef

- `-b` `16384` taille de la clef

- `-f` path

## SSH tunneling

```bash
ssh -gN -L 8000:127.0.0.1:8000 nicolas@192.168.122.42 -p 222
```

- `-g` Allow remote connection to connect to the local forwarded port

- `-N` do not open a prompt

- `-L` Forwarding port
  
  - `local_port:ip:distant_port`
