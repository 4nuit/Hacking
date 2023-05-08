## Doc

https://zer1t0.gitlab.io/posts/attacking_ad/

## Tools:

- le carving type `photorec` (récupérer les fichiers supprimés (unlinkés) mais pas encore ré-écrit / dans le même grenre tu as binwalk qui te prend un gros fichier (un blob) et qui t'extrait tout ce qu'il arrive à extraire
- l'analyse d'une copie de la RAM avec `volatility`:
	- profils linux avec [vol2](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/HackSecuReims/forensic/memdump)

- `impacket` : GetUserSPNs.py pour Kerberoasting par ex.

## FreeRDP2

(TryHackMe AD Basics)

```bash
xfreerdp /v:10.10.222.63 /u:THM\Mark /p:M4rk3t1ng.21
```

![](./thm_rdp.png)

