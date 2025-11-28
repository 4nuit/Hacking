## Cheatsheets

- https://ysap.sh/
- https://cheat.sh/
- https://explainshell.com/explain
- https://mywiki.wooledge.org/BashFAQ


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
