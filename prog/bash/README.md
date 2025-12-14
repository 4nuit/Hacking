## Doc

- https://ysap.sh/v/1/
- https://effective-shell.com/
- https://blog.lecacheur.com/2016/02/16/jq-manipuler-du-json-en-shell/
- https://sap1ens.com/blog/2017/07/01/bash-scripting-best-practices/
- https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html


## Cheatsheets

- https://devhints.io/bash
- https://mywiki.wooledge.org/BashFAQ
- https://mywiki.wooledge.org/BashPitfalls
- https://onceupon.github.io/Bash-Oneliner/

## Tools

- https://www.shellcheck.net/
- https://www.commandlinefu.com/
- https://explainshell.com/explain


```bash
# basic loop
for e in $(seq 1 $(cat attack.txt |wc -l)); do echo $(sed -n $e"p" attack.txt) | base64 -d; done
```

```bash
# timestamp
date -d "$(stat --printf=%y file.txt | cut -d. -f1)" +"%s"
```

```bash
#cat file | grep
#grep item < file
< file grep item
```
