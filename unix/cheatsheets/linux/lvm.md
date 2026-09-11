# LVM

## LVM Layer 1 – Hard Drives, Partitions, and Physical Volumes

`lvmdiskscan` – system readout of volumes and partitions

`pvdisplay` – display detailed info on physical volumes

`pvscan` – display disks with physical volumes

`pvcreate /dev/sda1` – create a physical volume from sda1

`pvchange -x n /dev/sda1` – Disallow using a disk partition

`pvresize /dev/sda1` – resize sda1 PV to use all of the partition

`pvresize --setphysicalvolumesize 140G /dev/sda1` – resize sda1 to 140g

`pvmove /dev/sda1` – can move data out of sda1 to other PVs in VG. Note: Free disk space equivalent to data moved is needed elsewhere.

`pvremove /dev/sda1` – delete Physical volume

## LVM Layer 2 – Volume Groups

`vgcreate vg1 /dev/sda1 /dev/sdb1` – create a volume group from two drives

`vgextend vg1 /dev/sdb1` – add PV to the volume group

`vgdisplay vg1` – Display details on a volume group

`vgscan` – list volume groups

`vgreduce vg1 /dev/sda1` – Removes the drive from vg1

*Note: use pvmove /dev/sda1 before removing the drive from vg1*

`vgchange` – you can activate/deactive and change perameteres

`vgremove vg1` – Remove volume group vg1

`vgsplit` and `vgmerge` can split and merge volume groups

`vgrename`– renames a volume group

## LVM Layer 3 – Logical Volumes and File Systems

`lvcreate -L 10G vg1 -n test` – create a 10 GB logical volume on volume group vg1 (with name test)

`lvcreate -l +100%FREE vg1 -n test`

`lvchange` and `lvreduce` are commands that typically aren’t used

`lvrename`– rename logical volume

`lvremove` – removes a logical volume

`lvscan` – shows logical volumes

`lvdisplay` – shows details on logical volumes

`lvextend -l +100%FREE /dev/vg1/lv1`– One of the most common
commands used to extend logical volume lv1 that takes up ALL of the
remaining free space on the volume group vg1.

`resize2fs /dev/vg1/lv1` – resize the file system to the size of the logical volume lv1.

(cf. `https://christitus.com/lvm-guide/`)
