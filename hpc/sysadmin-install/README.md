## Install and configuration

- https://slurm.schedmd.com/quickstart_admin.html
- https://sssd.io/docs/quick-start.html#quick-start-ldap
- https://osc.github.io/ood-documentation/latest/installation.html

```bash
apt install -y make gcc binutils build-essential zlibg1-dev ldap-utils libbz2-dev libssl-dev pkgconf

## Front/Mgmt node
### Munge
adduser --system --group --no-create-home --home /dev/null --shell /usr/sbin/nologin munge
chown -R munge:munge /etc/munge /var/lib/munge/ /var/log/munge /run/munge
systemd-tmpfiles --create /etc/tmpfiles.d/munge.conf
munge | unmunge
scp /etc/munge.key root@compute_node:/etc/munge/munge.key # + other nodes

### Slurm
### Config
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --runstatedir=/run
echo 'export SLURM_CONF=/etc/slurm/slurm.conf' >> ~/.bashrc # + other nodes

#### Slurmdbd: --with-mysql_config=/usr/bin
firewall-cmd --add-port=6817/tcp --permanent
firewall-cmd --add-port=6819/tcp --permanent
firewall-cmd --add-port=50000-50100/tcp --permanent
#### /etc/slurmdb.conf
#### AuthTyp=auth/munge
#### DbdPort = 6819
#### PidFile=/run/slurm/slurmdb.pid

#### /etc/slurm/slurm.conf
#### SrunPortRange = 50000-50100
scp /etc/slurm/slurm.conf root@compute_node:/etc/slurm/slurm.conf # + other nodes

## Compute node
### Slurmd: --with-bpf ()
firewall-cmd --add-port=6818/tcp --permanent


## Front/User node (Open On Demand)

#### /etc/ood/config/clusters.d/cluster.yml
#### /etc/ood/config/ood_portal.yml
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=5554/tcp --permanent

### SSSD config
#### /etc/sssd/sssd.conf
getent passwd user
sssctl config-check
sssctl domain-status <site.tld>
sssctl user-show <LDAP REMOTE USER>
```
