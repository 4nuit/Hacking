## Courses & Tutos

- https://ysap.sh/v/1/
- https://effective-shell.com/
- https://blog.lecacheur.com/2016/02/16/jq-manipuler-du-json-en-shell/
- https://sap1ens.com/blog/2017/07/01/bash-scripting-best-practices/
- https://www.gnu.org/software/bash/manual/html_node/Quoting.html
- https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html


## Cheatsheets

- https://devhints.io/bash
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

```bash
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
# functions
? () { echo "$*" | bc -l; }

? 1+1
```

```bash
export var=1

# POSIX test
[ "$var" -eq 1 ] && echo true || echo false
[ 1 = 1 ] && echo true || echo false


# Bash test
[[ $var -eq 1 ]] && echo true || echo false
[[ 1 == 1 ]] && echo true || echo false
```

```bash
# ranaming
mv file.{bin,bak}

# bulk renaming
for e in ./*.bin; do mv -- "$e" "${e//bin/bak}"; done
```

```bash
# basic loop
for e in $(seq 1 $(cat attack.txt |wc -l)); do echo $(sed -n $e"p" attack.txt) | base64 -d; done
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

```bash
stty -echo; read -p "Password:" pass; stty echo; echo $pass
```
