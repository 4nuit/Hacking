## Documentation

- https://ctf-wiki.mahaloz.re/misc/traffic/introduction/
- https://cheatsheet.haax.fr/shells-methods/reverse/
- https://github.com/sergiomarotco/Network-segmentation-cheat-sheet
- https://www.orangecyberdefense.com/fr/insights/blog/ethical-hacking/etat-de-lart-du-pivoting-reseau-en-2019
- https://heystacks.com/doc/401/attacking-secondary-contexts-in-web-applications
- https://github.com/V0lk3n/WirelessPentesting-CheatSheet

## Tools

- [Bettercap](https://www.bettercap.org/installation/)
- [Eaphammer](https://github.com/s0lst1c3/eaphammer)
- [Hex Packet Decoder](https://www.gasmi.net/hpd/)
- [Ngrok](https://ngrok.com/)
- [Revshells](https://revshells.com)
- [Tshark](https://tshark.dev/) , https://wiki.wireshark.org/SampleCaptures

### Challenges

https://wifichallengelab.com/

### Subnetting

`Memo: masque=subnet+host`

https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/veuillez-vous-identifier-pour-communiquer/le-subnetting-en-pratique/

https://youtu.be/B1vqKQIPxr0

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

### ARP

```bash
arp-scan
```

### DNS

- https://web-check.as93.net/

- https://www.duckdns.org/

```bash
whois google.com
```

*Zone transfer*

```bash
dig axfr @IP guess_domain_name
```

### Reverse lookup

```bash
nslookup flaws.cloud
nslookup 52.92.249.179
```

### HTTP

[Curl Options & POST](https://gist.github.com/subfuzion/08c5d85437d5d4f00e58)

### LDAP

https://serverfault.com/questions/1083914/replace-anonymous-ldapsearch-command-with-curl-command

### MAIL

https://elsicarius.fr/les-adresses-email-vous-connaissez

### QUIC

https://github.com/francoismichel/ssh3

### SIP

![sip](./maps-sip-web-architecture.jpg)

- https://www.commentcamarche.net/telecharger/communication/24399-x-lite/

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



## Wifi - Arp Spoofing

https://security.stackexchange.com/questions/225985/is-there-any-point-of-arp-spoofing-on-a-wifi-network

```bash
sudo ip l set wlanx down
sudo iw wlanx set monitor none
sudo ip l set wlanx up
sudo iw wlanx info
sudo wireshark&
```

https://dl.aircrack-ng.org/breakingwepandwpa.pdf

## WPA - PSK

```bash
sudo docker run -it --privileged --rm --net=host bettercap/bettercap -iface wlanx
#wifi.recon help

wpapcap2john bettercap-wifi-handshakes.pcap
```

https://www.evilsocket.net/2019/02/13/Pwning-WiFi-networks-with-bettercap-and-the-PMKID-client-less-attack/

*avec aircrack*

https://www.aircrack-ng.org/doku.php?id=cracking_wpa

```bash
sudo su
airmon-ng start wlan0 #set monitor & rename wlan0 (wlan0mon)
airodump-ng wlan0mon #scan network
airodump-ng --bssid 68:A3:78:01:C9:EF -w psk wlan0mon #find bssid (last command)
airodump-ng stop wlan0mon #set back monitor->managed

#offline
aircrack-ng -w rockyou.txt -b 68:A3:78:01:C9:EF psk-01.*cap
```

## WPA - EAP

```bash
sudo python3 ./eaphammer –cert-wizard
sudo python3 ./eaphammer -i wlan6 --creds -e "xxx" -b xx:xx:xx:xx:xx:xx #BSSID /MAC
```


