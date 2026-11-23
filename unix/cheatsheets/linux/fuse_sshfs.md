# SSHFS

## Setup

Add  in `/etc/fuse.conf`

```bash
user_allow_other
```

run:

```bash
groups add fuse
usermod -a -G fuse user
```

Add in `/etc/fstab`

```bash
nasusers@192.168.2.12:/NAS/       /run/media/user/NAS        fuse.sshfs    allow_other,delay_connect,reconnect,ServerAliveInterval=15,ServerAliveCountMax=2,default_permissions,idmap=user,uid=1000,gid=1000,port=222,IdentityFile=/path/to/private/key    0    0
```

Source: `nasusers@192.168.2.12:/NAS/`

Destionation: `/run/media/user/NAS`

File SYstem Type: `fuse.sshfs`

Options: `allow_other,delay_connect,reconnect,ServerAliveInterval=15,ServerAliveCountMax=2,default_permissions,idmap=user,uid=1000,gid=1000,port=222,IdentityFile=/path/to/private/key`

- `allow_other`: let other  user than root acces the file system (the one in the fuse group and work only with `user_allow_other` in `/etc/fuse.conf`)
- `delay_connect`: wait for the network to be up before connecting
- `reconnect`: automaticly reconnect when disconnected from the server
- `ServerAliveInterval=15`: number of second between ping send to the server to verify it is still connected
- `ServerAliveCountMax=2`: number of ping wothout response to consider the server disconnected
- `default_permissions`: set the permission of files to refect the one on the server (still does not respect ACL, sshfs does not support ACL)
- `idmap=user`: map file owner of the user that connect to the file of the user & group specify by the option, `uid` & `gid`
- `uid=1000`: set the file owner to be the user `1000`
- `gid=1000`: set the file group owner to be the group of id `1000`
- `port=222`: set the port for the ssh connection
- `IdentityFile=/path/to/private/key`: set the private key file use to connect to the server (will not work in fstab if it had a password)
