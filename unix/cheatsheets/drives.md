# Drives

## Mount Drives

mount:

```bash
sudo mount <file> <mount_directory>
```

exemple:

```bash
sudo mount /media/ext_data/test.img ./test/
```

mount without root:

```bash
udiskctl mount --block-device /dev/sddX
```

unmount:

```bash
sudo umount <mount_directory>
```

exemple:

```bash
sudo umount /media/test
```

unmount without root:

```bash
udiskctl unmount --block-device /dev/sddX
```

## Create Virtual Drives/Partitions

Create a raw image:

```bash
truncate -s <size> <file>
```

exemple:

```bash
truncate -s 64G test.img
```

Format a RAW images:

```bash
mkfs -t <type> <file>
```

exemple:

```bash
mkfs -t ext4 test.img
```

## Mount virtual Drives

### mount qcow2 images

```bash
sudo modprobe nbd
sudo qemu-nbd -c /dev/nbd0 /media/data/virtruals_machines/Marionnet-Debian8.qcow2
```

mount, use and **UNMOUNT** partitions: 
`/dev/nbd0n1`,
`/dev/nbd0n2`,
...

then **unmount** qcow2 images:

```bash
sudo qemu-nbd -d /dev/nbd0
```

### mount vhd immages

```bash
sudo guestmount --add <file.vhd> --inspector --ro <mount_point> -v
```

## qcow2 images

### convert/clone qcow2 images

```bash
qemu-img convert -f qcow2 -O qcow2 (-c) <input_img> <output_img>
```

* -f input images type
* -O output image type
* -c compress

exemples:

```bash
qemu-img convert -O qcow2 /media/data/virtruals_machines/Marionnet-Debian8.qcow2 /media/ext_data/data/save_vm/Marionnet-Debian8.qcow2
```

```bash
qemu-img convert -c -O qcow2 /media/data/virtruals_machines/Marionnet-Debian8.qcow2 /media/ext_data/data/save_vm/Marionnet-Debian8-compress.qcow2
```

### convert vdi to qcow2 images

```bash
qemu-img convert -f vdi -O qcow2 test.vdi test.qcow2
```

## reduce images sizes

Using virt-sparsify (this is the best option):

```bash
virt-sparsify in.qcow2 (--compress) out.qcow2
```

* --compress (compress l'image disk)

exemples:

```bash
virt-sparsify /media/data/virtruals_machines/Marionnet-Debian8.qcow2 /media/ext_data/data/save_vm/Marionnet-Debian8-sparsify.qcow2
```

```bash
virt-sparsify /media/data/virtruals_machines/Marionnet-Debian8.qcow2 --compress /media/ext_data/data/save_vm/Marionnet-Debian8-sparsify-compress.qcow2
```

qemu convertion can also be use for less better result if virt-sparsify is not installed:

```bash
qemu-img convert -O qcow2 <-c> <input_img> <output_img>
```

exemples:

```bash
qemu-img convert -O qcow2 /media/data/virtruals_machines/Marionnet-Debian8.qcow2 /media/ext_data/data/save_vm/Marionnet-Debian8.qcow2
```

```bash
qemu-img convert -c -O qcow2 /media/data/virtruals_machines/Marionnet-Debian8.qcow2 /media/ext_data/data/save_vm/Marionnet-Debian8-compress.qcow2
```

## Others

### Create RAM Disques on Linux

```bash
mount -t tmpfs -o size=1024m tmpfs /media/ramdisk
```

### zeros free space in windows to sparsify the drives

```batch
sdelete -Z C:
```
