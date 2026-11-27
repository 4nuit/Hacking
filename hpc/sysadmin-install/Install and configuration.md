```bash
## Slurm
## Config
## ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --runstatedir=/run

### Front/Mgmt node
#### Slurmdbd: --with-mysql_config=/usr/bin
firewall-cmd --add-port=6817/tcp --permanent
firewall-cmd --add-port=6819/tcp --permanent
firewall-cmd --add-port=50000-50100/tcp --permanent
#### /etc/slurm/slurm.conf
#### SrunPortRange = 50000-50100

### Compute node
### Slurmd: --with-bpf ()
firewall-cmd --add-port=6818/tcp --permanent

## SSSD config
### Front/User node (Open On Demand)
getent passwd user
sssctl config-check
sssctl domain-status <site.tld>
sssctl user-show <LDAP REMOTE USER>
```