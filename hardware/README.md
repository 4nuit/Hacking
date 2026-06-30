## Doc


- http://virtualabs.fr/
- https://mobilespecs.net/hardware/
- https://connectorbook.com/identification.html
- https://voidstarsec.com/hw-hacking-lab/vss-lab-guide
- https://github.com/biero-el-corridor/OT_ICS_ressource_list
- https://cyber.gouv.fr/publications/exigences-de-securite-materielles

### Courses / Resources

- [Cours electronique - CNAM](https://web.archive.org/web/20181030211958/https://taz.newffr.com/TAZ/Miscellanous/Cours_Electronique_Base.pdf)
- https://www.lions-wing.net/lessons/hardware/hard.html
- https://github.com/m3y54m/Embedded-Engineering-Roadmap/
- https://swisskyrepo.github.io/HardwareAllTheThings/
- https://github.com/V33RU/awesome-connected-things-sec
- https://github.com/IamAlch3mist/Awesome-Embedded-Systems-Vulnerability-Research


### Low cost - Purchases

- https://atvido.com/
- https://kiisu.io/         # Flipper 0 alternative
- https://kubii.com/        # Arduino, Raspberry Pi, Micro::Bit, Nvidia GPUs + accessories
- https://freenove.com/about# Kits compatible with Arduino IDE, Raspberry Pi, micro:bit, ESP32, ESP8266, etc
- https://servethehome.com/ # Servers, storage, networking gear
- https://deals.bleepingcomputer.com/ # US
- https://www.tomsguide.fr/meilleur-forfait-mobile-notre-comparatif/
- https://www.bargainhardware.co.uk/components/enterprise-hdds-sdds-storage
- https://blog.quentinra.dev/tools-and-frameworks/random/unsorted/purchases.md

### Articles

- http://files.righto.com/calculator/sinclair_scientific_simulator.html
- https://elrindel.github.io/
- https://www.reddit.com/r/beneater/


## Challenges

- https://www.nand2tetris.org/
- https://hackropole.fr/en/hardware/
- https://github.com/iamABH/awesome-hardware-ctf


## Computer

### EEPROM

- https://davidzou.com/articles/bios-password-bypass
- https://blog.quarkslab.com/eeprom-when-tearing-off-becomes-a-security-issue.html


### Micro Controllers

- https://www.saleae.com/downloads
- https://github.com/logisim-evolution/logisim-evolution
- https://rdomanski.github.io/Reverse-engineering-of-ARM-Microcontrollers/
- https://fr.wikihow.com/casser-le-mot-de-passe-d'un-BIOS#Retirer-la-batterie-CMOS
- https://github.com/apoirrier/CTFs-writeups/?tab=readme-ov-file#micro-controllers-and-circuits

#### SIM

- https://github.com/mitshell/card
- https://srlabs.de/blog/new-sim-attacks


### Buses (attacks, firmware extraction)

- https://www.synacktiv.com/en/publications/i-hack-u-boot

#### PCI

- https://en.wikipedia.org/wiki/Peripheral_Component_Interconnect
- https://github.com/ufrisk/pcileech # Dump DMA

#### SPI

- https://www.circuitbasics.com/basics-of-the-spi-communication-protocol/
- https://en.wikipedia.org/wiki/Serial_Peripheral_Interface
- https://en.wikipedia.org/wiki/Low_Pin_Count
- https://blog.quarkslab.com/flash-dumping-part-i.html
- https://pulsesecurity.co.nz/articles/TPM-sniffing

#### UART

- https://youtu.be/01mw0oTHwxg
- https://www.circuitbasics.com/basics-uart-communication/
- https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter
- https://github.com/apoirrier/CTFs-writeups/blob/master/BrigitteFriang/ASCII_UART.md
- https://faire-ca-soi-meme.fr/domotique/2021/03/22/hack-detournement-de-la-passerelle-lidl-silvercrest
- https://medium.com/csg-govtech/hardware-implant-attacks-part-1-console-access-attacks-on-vulnerable-iot-devices-104662f472dc

#### USB

- https://ventoy.net/
- https://www.sstic.org/2022/presentation/sasusb_presentation_dun_protocole_sanitaire_pour_lusb/


### RFID / NFC

- https://resources.bishopfox.com/resources/tools/rfid-hacking/attack-tools/
- https://www.latelierdugeek.fr/2017/07/12/rfid-le-clone-parfait/
- https://github.com/ikarus23/MifareClassicTool # NFC / RFID reader for Android

### Attacks

- https://beta.hackndo.com/meltdown-spectre/

#### Fault injection & Side-Channel

- [../crypto](https://github.com/4nuit/Hacking/tree/master/crypto/sym#aes)
- [An-introduction-to-fault-injection-part-1-3](https://web.archive.org/web/20230804042320/https://research.nccgroup.com/2021/07/07/an-introduction-to-fault-injection-part-1-3/)
- https://chipwhisperer.readthedocs.io/
- https://coastalwhite.github.io/intro-power-analysis/intro.html
- https://crypto.stackexchange.com/questions/42571/why-are-side-channel-attacks-such-as-spa-dpa-cpa-based-on-the-aes-subbytes-rout


## Tools

### Raspberry

- https://kubii.com/
- https://www.framboise314.fr/articles/
- https://wiki.zenk-security.com/doku.php?id=raspberry_pi
- https://www.waveshare.com/wiki/RP2040-One
- https://www.electronique-mag.com/article20308.html    # Pico EDAC connectors
- https://github.com/thibmaek/awesome-raspberry-pi#readme
- https://www.waveshare.com/w/upload/3/30/Getting_started_with_pico.pdf
- https://fabacademy.org/2023/labs/riidl/students/jesal-mehta/weekly/week4D/

![](https://www.waveshare.com/w/upload/e/e2/RoArm-M1_Tutorial_II05.jpg)
![](https://www.waveshare.com/w/upload/a/ad/Pico_Get_Start_06.png)

- **boot** : accès à rpi-rp2 en tant que usb
- **reset** : lancer le programme uf2 (blink, circuitpython)

#### Pico Ducky

- https://github.com/dbisu/pico-ducky
- https://x.com/androidmalware2/status/1676884184424431616/
- https://github.com/hak5/usbrubberducky-payloads/tree/master/payloads/extensions
- https://null-byte.wonderhowto.com/how-to/make-your-own-bad-usb-0165419/

#### Router OpenWRT

- https://blog.cybiere.fr/post/implant-reseau-redteam-openwrt/

### Flipper Zero

- https://github.com/bigbrodude6119/flipper-zero-evil-portal?tab=readme-ov-file


![](./images/pico.jpg)

