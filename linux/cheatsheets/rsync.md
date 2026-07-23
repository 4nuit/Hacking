# rsync

## Explications

```bash
rsync --sparse=always -a --delete <src> <target>
```

The first 3 options allow to make a perfect clone.

* `--sparse=always` : copy file with they correct size

* `--delete` : delete extraneous files from dest dirs

* `-a`: `-rlptgoD`
  
  - `-r`: recursive
  
  - `-l`: copy symlink as symlink
  
  - `-p`: preserve permissions
  
  - `-t`: preserve modification times
  
  - `-g`: preserve group
  
  - `-o`: preserve owner
  
  - `-D`: equivalent to `--devices` `--specials`
    
    - `--devices`: superuser recreate character and block file devices
    
    - `--specials`: superuser transfer special files like named sockets and fifos
  
  - `-P`: equivalent to `--partial` `--progress`
    
    - `--partial`: keep partialy transferd files ()to continue transfer them later)
    
    - `--progresss`: show progress of current file

* `-h`: human readable

* `-n`: dry-run

* `-i`: print summury of what happend

* `-v`: similare to -i but more info about dry-run

* `-u`: ignore file that are more recent on target (not a perfect clone)

* `-e`: use ssh

* `--info=progress2`: show global progress

## Exemples

safley clone a directory:

```bash
rsync --sparse=always -a -P --delete -u -h -i -v
```

make a dry run of the same commande:

```bash
rsync --sparse=always -a -P --delete -u -h -i -v -n
```

complete exemple:

```bash
rsync --sparse=always -a -P --delete -u -i -v -h -n /media/data/ /media/nicolas/save_data/data/
```

exemple using ssh:

```bash
rsync -e "ssh -p 222" nicofolxarus@192.168.122.42:"$SRC" "$DST"
```

## Aliases

making an alias of a clone commande can make it easier to use:

```bash
alias clone="rsync -a --delete --sparse=always -u -i -v -h --info=progress2"
```

```bash
alias suclone="sudo rsync -a --delete --sparse=always -u -i -v -h --info=progress2"
```
