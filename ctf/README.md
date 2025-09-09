## Doc

- https://wiki.bi0s.in/
- https://primer.picoctf.org/
- https://blog.reinom.com/securitymethods/
- https://github.com/OpenToAllCTF/Tips

## Travailler dans /tmp

```bash
cd $(mktemp -d)
```

## Scraper les challenges à la fin:

- https://github.com/p0dalirius/ctfd-parser

## Partager des fichiers (réseau privé)

```python
ip -br a ; mkdir secret && cd secret ; python3 -m http.server 8000

#accéder à l'ip de l'interface http://192.168.xx.xx:8000/
```

## Parefeu

```bash
#!/bin/bash

# Set default chain policies
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F

# Allow established sessions to receive traffic
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Accept on localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
```

```bash
sudo iptables-save -f /etc/iptables/iptables.rules #sudo ip6tables-save -f /etc/iptables/ip6tables.rules
sudo iptables-restore -f /etc/iptables/iptables.rules  #sudo ip6tables-restore -f /etc/iptables/ip6tables.rules
```

![](./images/fw.png)
