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
Host SERVER_NAME
	Hostname IP_OR_NAME
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

- [port knocking (on port 717 here)](https://github.com/4nuit/Hacking/tree/master/network#port-knocking)
- https://github.com/skeeto/endlessh
- https://github.com/fail2ban/fail2ban

## SSH key generation

```bash
ssh-keygen -t rsa -b 16384
```

- `-t` `rsa`|`ed25519` type de clef

- `-b` `16384` taille de la clef

- `-f` path

## SSH tunneling

### Local port forwarding

```bash
ssh -gN -L 8000:127.0.0.1:8000 nicolas@192.168.122.42 -p 222
```

- `-g` Allow remote connection to connect to the local forwarded port

- `-N` do not open a prompt

- `-L` Forwarding port
  
  - `local_port:ip:distant_port`

```bash
# same thing
## forward port 65537 from the gateway
ssh -L 65537:<cluster>:22 <gateway>

## connect to cluster
ssh -p 65537 127.0.0.1
```

```bash
## Using https (distant_port = 443)
ssh -Nf -L 8443:10.23.0.170:443 <cluster>

## Access with localhost:local_port
## Using http and following redirections
curl https://localhost:8443 -L -k
```

### Dynamic port forwarding

```bash
ssh -Nf -D 1080 <user>@<cluster>

# FoxyProxy (Browser)
## Name: IDRAC
## Type: SOCKS5
## Hostname: 127.0.0.1
## Port: 1080
# Then go to http://10.23.0.<node>
## Where 10.23.x.y is ib0 interface
```

```bash
# Curl with SOCKS proxy

curl --proxy socks5h://127.0.0.1:1080 http://10.23.0.170/restgui/start.html -L -k -i <user>:<pass>
```
