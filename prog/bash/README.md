## Courses & Tutos

- https://ysap.sh/v/1/
- https://effective-shell.com/
- https://mywiki.wooledge.org/BashGuide
- https://en.wikibooks.org/wiki/Bash_Shell_Scripting
- https://blog.lecacheur.com/2016/02/16/jq-manipuler-du-json-en-shell/
- https://sap1ens.com/blog/2017/07/01/bash-scripting-best-practices/
- https://www.gnu.org/software/bash/manual/html_node/Quoting.html
- https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html


## Cheatsheets

- https://devhints.io/bash
- https://mywiki.wooledge.org/BashSheet
- https://mywiki.wooledge.org/BashFAQ
- https://mywiki.wooledge.org/Bashism # POSIX pitfalls
- https://mywiki.wooledge.org/BashPitfalls
- https://onceupon.github.io/Bash-Oneliner/

```txt
- beware of POSIX compatibility
- quote variables, not string literals
```

## Tools

- https://www.shellcheck.net/
- https://www.commandlinefu.com/
- https://www.epochconverter.com/
- https://explainshell.com/explain
- https://blog.robertelder.org/bash-one-liner-compose-music/

```bash
#!/usr/bin/env bash

set -o errexit
set -o pipefail

# using previous commands
id
sudo !!

# replacing
lscpu
^cpu^pci

# background bot
nohup python bot.py &
```

```bash
# arithmetic
echo $(( 5 + 5 ))

# functions
? () { echo "$*" | bc -l; }

? 1+1
```

```bash
# params
"$0" # argv[0], name
"$1" # first param
"$@" # list of individual params
$# # number of params
$? # exit code of previous command
$$ # PID of current shell

# arrays
array=(a b c)
echo ${#array[@]}
```

```bash
export var=1

# POSIX test
[ "$var" -eq 1 ] && echo true || echo false
[ 1 = 1 ] && echo true || echo false


# Bash test
[[ "$var" -eq 1 ]] && echo true || echo false
[[ 1 == 1 ]] && echo true || echo false
(( 5 > 0 )) && echo true || echo false

## Pattern matching
[[ $filename = *.png ]] && echo "$filename looks like a PNG file"
```

```bash
# Input redirection
stty -echo; read -p "Password:" pass; stty echo; echo $pass

# tubes
mkfifo myfifo

grep bea myfifo &
[1] 32635
$ echo "rat
> cow
> deer
> bear
> snake" > myfifo
bear
```

```bash
# Compound commands | Subshells
(cd /tmp || exit 1; date > timestamp) # ts in /tmp/timestamp if /tmp exists
bash -c "cd /tmp || exit 1; date > timestamp"
{ echo "Starting at $(date)"; rsync -av . /backup; echo "Finishing at $(date)"; } >backup.log 2>&1
```

### Useful commands

```bash
# basic loop
for e in $(seq 1 $(cat attack.txt |wc -l)); do echo $(sed -n $e"p" attack.txt) | base64 -d; done
```

```bash
# renaming
mv file.{bin,bak}

# bulk renaming
for e in ./*.bin; do mv -- "$e" "${e//bin/bak}"; done
```

```bash
# Date to timestamp
date -d "Thu Nov 6 01:14:35 AM CET 2025" +%s    #1762388075
date -d "$(stat --printf=%y file.txt | cut -d. -f1)" +"%s"

# Timestamp to date
date -d @1762388075                             #Thu Nov  6 01:14:35 AM CET 2025
date -d @1762388075 "+%Y-%m-%d %H:%M:%S"        #2025-11-06 01:14:35
```

```bash
#cat file | grep
#grep item < file
< file grep item
```

```bash
grep
	-o, --only-matching
		Print only the matched (non-empty) parts of a matching line, with each such part on a separate output line.
	-C-NUM, --context=NUM
		Print NUM lines of output context.  Places a line containing a group separator (--) between contiguous groups of matches.  With the -o or --only-matching option, this has no  effect
```

```bash
# extract column n°X
awk '{print $X}' file
```
