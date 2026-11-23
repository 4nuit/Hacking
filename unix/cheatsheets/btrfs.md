# BTRFS

# NE PAS UTILISER BTRFS EN PROD, J'EN AI MARE D'ETRE APPEL A L'AIDE A CAUSE DE PARTITION BTRFS CORROMPUE

Partition btrfs corrompue fixe depuis janvier 2023: **5**.

## Usage

Display Spaces

```bash
btrfs filesystem usage /
btrfs filesystem df /
```

Defragmentation

```bash
btrfs filesystem defragment -r /
```

Balance

```bash
btrfs balance start --bg /
btrfs balance status /
```

(repaire broken RAID and resend all file throw the allocator)

## Snapshots

Nouvell SnapShote

```bash
btrfs subvolume snapshot source [dest/]name
```

Backup

```bash
btrfs send /root_backup | btrfs receive /backup
```

Incremental Backup

```bash
btrfs send -p /root_backup /root_backup_new | btrfs receive /backup
```

## Sub Voolumes

```bash
btrfs subvolume create /path/to/subvolume
```

```bash
btrfs subvolume list -p path
```

```bash
btrfs subvolume delete /path/to/subvolume
```

## Compression

```bash
compress=alg
compress-force=alg 
```

- `no` pas de compressions

- `lzo` vieux standard de comlpression, pas efficasse

- `zlib` (1-9)

- `zstd` (1-15)

Conseille: `compress-force=zstd:3`
