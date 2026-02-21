# ZFS

1) Storage provider => disques

2) Vdevs (grouping of storages)

3) Zpools (Agregation of storage into a Pool (ex: tank + ZIL + ARC + L2ARC))
   
   (default ARC = 1/32 of RAM)

4) File System (gzip compression)

## AutoStart

```bash
systemctl enable zfs.service
systemctl enable zfs-import-cache.service
systemctl enable zfs-import.service # auto import zfs file systems at boot
```

## Zpool

create a pool from theses 3 drives

```bash
zpool create NAS /dev/sda /dev/sdb /dev/sdc
```

(RAID-Z1 version)

```bash
zpool create NAS raidz1 /dev/sda /dev/sdb /dev/sdc
```

add a drive to a pool

```bash
zpool attach NAS /dev/sdd
```

remove a drive from a pool

```bash
zpool detach NAS /dev/sdd
```

get info of pools

```bash
zpool status
```

### ZIL

Add Write Caches

```bash
zpool add NAS log /dev/sde
```

### L2ARC

Add Read Caches

```bash
zpool add NAS cache /dev/sdf
```

## File Systemes

Create a file system in the pool

```bash
zfs create NAS/data
```

list files systemes

```bash
zfs list
```

### Compression

```bash
zfs set compression=gzip NAS
```

```bash
zfs get compression
```

### ACL

```bash
zfs set acltype=posix NAS
# zfs set aclinherit=passthrough NAS
```

```bash
chown root:nasuser /NAS/public
chmod g+s /NAS/public

sudo setfacl -d -m g::rwx /NAS/public/
```

```bash
sudo getfacl /NAS/public/
```
