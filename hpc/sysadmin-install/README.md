## Install and configuration

- https://slurm.schedmd.com/quickstart_admin.html
- https://sssd.io/docs/quick-start.html#quick-start-ldap
- https://osc.github.io/ood-documentation/latest/installation.html

```bash
# base install
apt install -y make gcc binutils build-essential zlibg1-dev ldap-utils libbz2-dev libssl-dev pkgconf

## Front/Mgmt node
apt install -y libmariadb-dev libmariadb-dev-compat
### Maria
mariadb -u root
# CREATE DATABASE IF NOT EXISTS slurm_acct_db;
# CREATE DATABASE IF NOT EXISTS 'slurm'@localhost' IDENTIFIED BY '<PASS>;
# GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@localhost';
# FLUSH PRIVILEGES;
# EXIT;

### Munge
adduser --system --group --no-create-home --home /dev/null --shell /usr/sbin/nologin munge # + other nodes
useradd --system --uid 64030 --gid slurm --create-home --home-dir /var/lib/slurm --shell /usr/sbin/nologin slurn #+ other nodes

#chmod 600 for most of files
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
#### SlurmUser=slurm
#### StorageType=accounting_storage/mysql
#### StorageHost=localhost,StoragePort=3306,StoragePass=<PASS>,StorageLoc=slurm_acct_db
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
sudo openssl req -x509 -newkey rsa:2048 -nodes -days 365 -keyout /etc/ssl/ood/ood.key -out /etc/ssl/ood/ood.crt -subj "/CN=front_vm.site.tld" -addext "subjectAltName=DNS:front_vm.site.tld"

sudo cp /etc/ssl/ood/ood.crt /usr/local/share/ca-certificates/ood.crt
sudo scp /etc/ssl/certs/ca-certificates.crt root@node:/etc/ssl/certs/ca-certificates.crt # + other nodes
sudo update-ca-certificates # same

#### /etc/sssd/sssd.conf
sudo scp /etc/sssd/sssd.conf root@node:/etc/sssd/sssd.conf # + other nodes

getent passwd user
sssctl config-check
sssctl domain-status <site.tld>
sssctl user-show <LDAP REMOTE USER>
```
