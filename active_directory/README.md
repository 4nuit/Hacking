## Bases LDAP

https://www-sop.inria.fr/members/Laurent.Mirtain/ldap-livre.html

## Doc AD:

- https://orange-cyberdefense.github.io/ocd-mindmaps/img/pentest_ad_dark_2023_02.svg

- https://zer1t0.gitlab.io/posts/attacking_ad/
- https://m0chan.github.io/2019/07/30/Windows-Notes-and-Cheatsheet.html
- https://tesserent.com/insights/blog/dumping-windows-credentials?utm_source=securusglobal.com&utm_medium=301

- https://attl4s.github.io/assets/pdf/You_do_(not)_Understand_Kerberos.pdf
- https://academy.hackthebox.com/course/preview/active-directory-bloodhound

`potato local privesc -> voir ../windows`

## Setup LAB AD

- `commencement_tp.docx`
- https://docs.contactit.fr/windows_server_ldap/active_directory/installation-active-directory/
- https://docs.contactit.fr/windows_server_ldap/active_directory/active-directory-tp-uo-ou-gg-gl-partages-et-droits-utilisateurs/

- https://github.com/WazeHell/vulnerable-AD
- https://github.com/Orange-Cyberdefense/GOAD

## Cheatsheet 

- [hashs types](https://hashcat.net/wiki/doku.php?id=example_hashes)

- [thehacker.recipes](https://www.thehacker.recipes/)
- [ad cheatsheet - tools](https://github.com/S1ckB0y1337/Active-Directory-Exploitation-Cheat-Sheet)

## NTLM

- https://beta.hackndo.com/pass-the-hash/#protocole-ntlm
- https://www.vaadata.com/blog/fr/authentification-ntlm-principes-fonctionnement-et-attaques-ntlm-relay/
- https://www.801labs.org/research-portal/post/cracking-an-ntlmv2-hash/

`Le client s’authentifie avec empreinte MD4 de son mot de passe (hash NT) pour chiffrer le challenge (NTLM)`

*Calcul du hash Net-NTLM v2*

```txt
SC = 8-byte server challenge, random
CC = 8-byte client challenge, random
CC* = (X, time, CC2, domain name)
v2-Hash = HMAC-MD5(NT-Hash, user name, domain name)
LMv2 = HMAC-MD5(v2-Hash, SC, CC)
NTv2 = HMAC-MD5(v2-Hash, SC, CC*)
response = LMv2 | CC | NTv2 | CC*
```

### Dumping 

SAM -> local
NTDS.DIT -> BDD des utilisateurs de l'AD

- https://www.thehacker.recipes/ad/movement/credentials/dumping/sam-and-lsa-secrets

**PTH -> possession du hash NT**

## Kerberos

### (Pre) Authentication

- https://beta.hackndo.com/kerberos/
- https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/plan-connect-userprincipalname#upn-format
- https://www.chudamax.com/posts/kerberos-102-overview/
- https://vbscrub.com/2020/02/27/getting-passwords-from-kerberos-pre-authentication-packets/


*Calcul du hash kerb5 pre-auth*

```txt
Krb5pa meaning kerberos 5 pre-auth, and 18 meaning kerberos encryption type 18 (AES-256) as discussed above.
It encrypts the current time and sends it to the server (as part of the initial kerberos AS-REQ packet) but it encrypts it using the user’s password as the encryption key.
```

- https://stackoverflow.com/questions/12260587/kerberos-fails-when-accessing-site-by-ip-address

```
/etc/hosts
ip DOMAIN
ip DC
```

### Memo : auth + ticket granting

![](./kerberos.gif)

### AsRepRoast

**User sans PreAuth**

- https://beta.hackndo.com/kerberos-asrep-roasting/
- https://www.login-securite.com/2022/11/03/analyse-et-poc-de-la-cve-2022-33679/
- ([UAC values](https://jackstromberg.com/2013/01/useraccountcontrol-attributeflag-values/))
- [GetNPUsers.py](https://github.com/fortra/impacket/blob/master/examples/GetNPUsers.py)

*Hash krb5asrep*

```
On parle d’utilisateur AS_REP Roastable lorsque la pré-authentification Kerberos n’est pas requise pour cette utilisateur. Nous pouvons alors demander un TGT (Ticket Granting Ticket) au KDC (Key Distribution Center) à son nom et cracker une partie de la réponse KRB_AS_REP, qui contient le TGT et une clé de session chiffrée avec son hash NT.
Un attaquant peut tenter de retrouver le password de ce compte de domaine via du bruteforce en offline.
```

### Kerberoast

**SPN non vide**

- https://beta.hackndo.com/kerberoasting/
- [GetUserSPNs.py](https://github.com/fortra/impacket/blob/master/examples/GetUserSPNs.py)

*Hash krb5tgs*

```
Un utilisateur authentifié sur un domaine AD peut demander un TGT (Ticket Granting Ticket) au KDC, (Key Distribution Center) via une requête KRB_AS_REQ, le KDC lui enverra alors un TGT au nom de l’utilisateur demandeur et une clé de session chiffré avec le hash NT de l’utilisateur, via une réponse KRB_AS_REP.
Ensuite, l’utilisateur peut faire une demande de ST (Service Ticket) au TGS (Ticket Granting Service) en fournissant son TGT et un SPN (Service Principal Name) valide, via une requête KRB_TGS_REQ, le KDC lui enverra alors un ST pour le service demandé via une réponse KRB_TGS_REP.

Ce ST est chiffré avec le hash NT du compte de service demandé. On dit alors que ce compte est Kerberoastable. Un attaquant peut tenter de retrouver le password du compte de service via du bruteforce en offline.
```

### SAM AccountName

- https://learn.microsoft.com/fr-fr/windows/win32/adschema/a-samaccountname
- [S4User2Self](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-sfu/02636893-7a1f-4357-af9a-b672e3e3de13)
- [S4User2Proxy](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-sfu/bde93b0e-f3c9-4ddf-9f44-e1453be7af5a)

![](./s4u.png)

### Silver/Golden Ticket

- https://beta.hackndo.com/kerberos-silver-golden-tickets/#pac
- https://learn.microsoft.com/en-us/answers/questions/87978/reset-krbtgt-password
- https://github.com/fortra/impacket/issues/1457

### Memo

[Box Active (HTB)](https://0xdf.gitlab.io/2018/12/08/htb-active.html)

Synchroniser l'horloge:

`sudo ntpdate <ip>`

**Crackmapexec** :
	- check GPPPassword ([share spidering](https://www.infosecmatter.com/crackmapexec-module-library/?cmem=smb-spider_plus): spider_plus): `cme smb <Domain> -u <user> -p <pass> -M gpp_password`
	- check SamAccountName: `crackmapexec smb <ip> -M nopac` & `crackmapexec ldap -d <Domain> -u <user> -p <pass> -M Maq` (max machines à créer)
	- Pass The Hash: `crackmapexec <ip> -u Administrator -H <lmhash:nthash> -x 'whoami'`


**WinRm shell**

`Domain.local/Administrator@127.0.0.1`

`psexec.py <Domain>/<user>:<pass>@<DC.local>`
`wmiexec.py <Domain>/<user>@<DC.local> -hashes ':<nthash>'`

```bash
#win-rm protocol
evil-winrm -i <ip> -u <account> -p <password>

#pass the hash
evil-winrm -i <ip> -u <account> -H <hash>
```

**FreeRDP2**

(TryHackMe AD Basics)

```bash
xfreerdp /v:10.10.222.63 /u:THM\Mark /p:M4rk3t1ng.21
```

![](./thm_rdp.png)

```bash
#remote desktop protocol
xfreerdp /v:<ip> /u:<account> /p:<password>

#pass the hash
xfreerdp /v:<ip> /u:<account> /pth:<hash>
```

