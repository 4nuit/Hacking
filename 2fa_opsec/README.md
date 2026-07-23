## Doc 2FA

- https://www.microsoft.com/en-us/security/business/security-101/what-is-two-factor-authentication-2fa

### MFASweep

- https://kb.offsec.nl/tools/m365/mfasweep/
- https://www.blackhillsinfosec.com/exploiting-mfa-inconsistencies-on-microsoft-services/
- https://notes.incendium.rocks/pentesting-notes/cloud/azure/authenticated-enumeration

### Local 2FA (Linux)

#### FIDO with PAM

- https://docs.nitrokey.com/fr/nitrokey3/linux/desktop-login
- https://pychao.com/2020/06/10/update-on-using-protonmail-bridge-on-headless-wordpress-linux-servers/

#### OTP

- https://www.passwordstore.org/
- https://github.com/tadfisher/pass-otp

```bash
# init
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG # sec   ed25519/<ID> 2026-06-16 [SC]
pass init <ID>

# pass
pass generate github/git@github.com
pass github/git@github.com -c
pass rm -rf github

# otp
zbarimg -q --raw qrcode.png | pass otp insert -e acc
pass otp acc -c
```

### Password reset (online)

- https://github.com/KathanP19/HowToHunt/blob/master/Password_Reset_Functionality/Password_Reset_Flaws_by_Sm4rty.md
- https://www.shielder.com/blog/2022/09/how-to-decrypt-manage-engine-pmp-passwords-for-fun-and-domain-admin-a-red-teaming-tale/


## Doc Opsec

- https://ssd.eff.org/
- https://xn--gckvb8fzb.com/ # Infrastructure, Phone

### Guides

- https://thenewoil.org/en/
- https://wiki.nothing2hide.org/
- https://anonymousplanet.org/guide
- https://www.privacyguides.org/en/basics/threat-modeling/

### Software

- https://switching.software/
- https://prism-break.org/fr/
- https://justdeleteme.xyz/
- https://eylenburg.github.io/index.html

```bash
# https://archive.is/0OLMG#selection-377.0-377.51
# sudo crontab -e
*/1 * * * * sudo rm /etc/machine-id && sudo systemd-machine-id-setup
```

## Cheatsheets

- https://github.com/pluja/awesome-privacy
- https://github.com/Lissy93/awesome-privacy
- https://github.com/StellarSand/privacy-settings
- https://github.com/mendel5/alternative-front-ends
- https://osint-opsec.fr/opsec-egosrufing-infostealer/


## Tools

- https://tools.techlore.tech/#filter-archetype-WP
- https://search.disroot.org/ # private bin, nextcloud, filesharing
- https://searchengine.party/ # compare search engines
- https://filigrane.beta.gouv.fr/
- https://www.freetsa.org/index_en.php

### Network

#### DNS

- https://pranavk-official.gitlab.io/posts/post-2/
- https://security.stackexchange.com/questions/122547/is-there-a-point-to-dnscrypt-when-using-vpn

*Hosts (static)*

- https://privacy.sexy/
- https://github.com/StevenBlack/hosts/blob/master/hosts

*Dnscrypt*

- https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-linux (quad9)

*Dns0/Cloudfare -> logs!!*

- https://www.dns0.eu/
- https://pranavk-official.gitlab.io/posts/post-2/
- https://www.cloudflare.com/ssl/encrypted-sni/#results
- https://blog.powerdns.com/2019/09/25/centralised-doh-is-bad-for-privacy-in-2019-and-beyond

#### Monitoring

- https://github.com/safing/portmaster
- https://obdev.at/products/littlesnitch/index.html # MacOS

### TOR

```bash
sudo pacman -S tor proxychains-ng
sudo systemctl start tor.service
```

- https://archive.org (deleted and protected articles)
- https://www.gsocket.io/
- https://github.com/schollz/croc
- https://github.com/haad/proxychains

```bash
# All CLI-traffic through tor
proxychains bash

# Browser only
proxychains4 firefox
chromium --proxy-server="socks://localhost:9050"

proxychains ssh -D 127.0.0.1:9050 user@remote_server
```

#### VPN

- https://njal.la/resources/
- https://mullvad.net/en
- https://wiki.archlinux.org/title/VPN_over_SSH

### Selfhosted apps

- [Personal setup of containers (llama-server, stirling-pdf, nexcloud)](../devops-selfhost/containers)
- https://github.com/awesome-selfhosted/awesome-selfhosted

#### Docs

- https://docs.la-suite.eu/
- https://www.canarytokens.org/nest/

#### Filesharing

- https://github.com/schollz/croc#usage
- https://github.com/schollz/croc#self-host-relay

**Peer to peer networks**

- https://nicotine-plus.org/ # soulseek client
- https://deluge-torrent.org/ # bittorent client

```bash
# using ~/.config/mpv/mpv.conf for tiny bandwith
# encoding bitrate : -b  / resolution : -s 16:9  / video format : --vf
mpv https://<deluge server>/<downloads>/<film>
```

#### LLMs

- https://www.canirun.ai/
- https://whatmodelscanirun.com/
- https://gpt4all.io/index.html
- https://ollama.com/library/codellama
- https://github.com/zylon-ai/private-gpt/
- https://github.com/SecureAI-Tools/SecureAI-Tools
- https://lucumr.pocoo.org/2026/5/8/local-models/

#### PDFs

- https://github.com/24eme/signaturepdf
- https://github.com/yunanwg/brilliant-CV
- https://github.com/Stirling-Tools/Stirling-PDF  # Add stamp (filigrane, timestamp), Compress, Sanitize, Signature. Use n to apply a stamp on all pages
- [Guide - How to sign PDFs with timestamp - freeTSA](https://www.freetsa.org/guide/)

### Bloated apps

- https://vencord.dev/
- https://vscodium.com/
- https://freetubeapp.io/
- https://github.com/SpotX-Official/SpotX-Bash

```bash
# flatpak command
run --branch=stable --arch=x86_64 --command=spotify --file-forwarding com.spotify.Client @@u %U @@ --audio-api=pulseaudio
```

### Online Temp Accounts

- https://librewolf.net/
- https://github.com/sebsauvage/ZeroBin
- https://github.com/gorhill/uBlock/wiki/Blocking-mode:-medium-mode

#### Bank / Virtual Cards

- https://wiki.zenk-security.com/doku.php?id=les_achats_en_chine
- https://www.comparateurbanque.com/les-cartes-virtuelles/
- https://www.revolut.com/blog/post/revolut-vs-wise/

#### RGPD Erasure requests

- https://www.datarequests.org/generator#!request_type=erasure
- https://www.datarequests.org/blog/sample-letter-gdpr-erasure-request/
- https://www.cnil.fr/fr/le-dereferencement-dun-contenu-dans-un-moteur-de-recherche

#### SMS (OTP)

- https://onlinesim.io/
- https://freephonenum.com/
- https://receive-smss.com/
- https://tempsmsonline.com/

#### Mail

- https://blog.slonser.info/posts/email-attacks/

```txt
<spoofed@gmail.com> "spoofed" <slonser.bugbounty@gmail.com>
```

- https://pissmail.com/
- https://temp-mail.org/en/
- https://tempmail.digital/


#### Reverse alias

- https://simplelogin.io/

![](./images/alias.png)


## Operating systems

### Android

- https://mvt.re/
- https://en.wikipedia.org/wiki/TWRP_(software)
- https://en.wikipedia.org/wiki/List_of_custom_Android_distributions
- https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/


#### Linux

- https://pureos.net/
- https://plasma-mobile.org/get/
- https://wiki.volla.online/index.php?title=English
- https://en.wikipedia.org/wiki/Linux_for_mobile_devices

#### Lineage / Graphene

- https://wiki.lineageos.org/
- https://github.com/microg/GmsCore/wiki # alt to google play, lineage based OS tutos
- https://grapheneos.org/
- https://xairy.io/articles/pixel-kgdb#-building-and-flashing-custom-kernel


```bash
adb shell pm list packages -f
adb shell pm uninstall --user 0 com.facebook.services
```

#### Alternative app stores

- https://f-droid.org/
- https://obtainium.page/
- https://accrescent.app/
- https://store.auroraoss.com/
- https://exodus-privacy.eu.org/

#### Apps

- Direct download:
    - https://aliucord.com/, https://rentry.co/mithiapa # plugins
    - https://blockada.org/ # prefer DNSNet
    - https://github.com/GrapheneOS/Camera/releases/
- Accrescent:
    - https://ironfoxoss.org/
    - https://organicmaps.app/
    - https://github.com/t895/DNSNet
- F-Droid:
    - https://termux.dev/
    - https://newpipe.net/
    - https://netguard.me/
    - https://saracroche.org/
    - https://transportr.app/
    - https://www.fossify.org/apps/
    - https://anysoftkeyboard.github.io/
    - https://codeberg.org/s1m/savertuner/releases
    - https://f-droid.org/packages/org.ligi.survivalmanual/
    - https://f-droid.org/en/packages/com.jmstudios.redmoon/
    - https://f-droid.org/packages/com.beemdevelopment.aegis/
    - https://f-droid.org/packages/com.github.howeyc.crocgui/
    - https://f-droid.org/packages/de.syss.MifareClassicTool/
    - https://f-droid.org/en/packages/net.yolosec.routerkeygen2/
    - https://f-droid.org/en/packages/com.artifex.mupdf.viewer.app/
    - https://f-droid.org/en/packages/de.markusfisch.android.binaryeye/
    - https://f-droid.org/en/packages/com.menny.android.anysoftkeyboard/
    - https://f-droid.org/en/packages/com.jarsilio.android.scrambledeggsif/
- https://wiki.volla.online/index.php?title=Messenger_Comparison

```bash
adb install app.apk

#remove metadata (i.e scrambledeggsif)
exiftool -all= image.png
```

### iOS

- https://thenewoil.org/en/guides/most-important/mobile-settings/

#### Alternative app stores

- https://altstore.io/
- https://cydia.saurik.com/ # jailbreak, not recommended

#### Apps

- https://blokada.org
- https://lockdownprivacy.com/


### Linux

[cryptsetup](https://gitlab.com/cryptsetup/cryptsetup) / [dm-crypt (LUKS) - Arch wiki](https://wiki.archlinux.org/title/Dm-crypt) (use distro's installer)

- https://entropyqueen.github.io/posts/Setting_up_2FA_on_Linux_with_PAM
- https://madaidans-insecurities.github.io/guides/linux-hardening.html

### Windows

[bitlocker](https://learn.microsoft.com/en-us/windows/security/operating-system-security/data-protection/bitlocker/) (not available in home/family edition - **see licenses /editions**)

- https://atlasos.net/ # An open and lightweight modification to Windows, designed to optimize performance, privacy and usabilit

#### Debloaters

- https://privacy.sexy/
- https://rentry.co/debloatguide#disabling-windows-telemetry
- https://github.com/Sycnex/Windows10Debloater
- https://github.com/Raphire/Win11Debloat


## Browser fingerprinting

- https://browsers.to/
- https://privacytests.org/
- https://browserleaks.com/
- https://webbrowsertools.com/privacy-test/
- https://www.avoidthehack.com/manually-install-extensions-ungoogled-chromium
- https://forum.level1techs.com/t/how-to-obscure-your-web-browser-and-keep-a-comfy-experience/103588


```txt
# Searx using gdorks
!g site:.com "chromium.woolys*"
```

### Firefox

- https://shutuptrackers.com/browser/tweaks.php
- https://wiki.archlinux.org/title/Firefox/Privacy
- https://brainfucksec.github.io/firefox-hardening-guide
- https://addons.mozilla.org/en-US/firefox/addon/chameleon-ext/
- https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/ (canvas + clientRects, audio)
- https://addons.mozilla.org/en-US/firefox/addon/font-fingerprint-defender/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search (fonts)
- https://support.mozilla.org/bm/questions/1043508

#### Hardened forks

- https://librewolf.net/ # no setup
- https://ironfoxoss.org/
- https://arkenfox.org/ # configuration


```bash
yay -S arkenfox-user.js
arkenfox-updater

#about:profiles (remove default) -> ~/.mozilla/firefox/string.default-release/user.js
#browser.search.separatePrivateDefault -> comment to keep searx

# privacy.resistFingerprinting -> set all to true
# privacy.firstparty.isolate -> false (modifier user.js)
# network.cookie.cookieBehavior = 1 // comment, default = 5
```

- Deactivate `safebrowsing/telemetry` (own risk)
- Delete `crashreporter, pingsender` (wiki firefox arch)


```bash
yay -S arkenfox-user.js
arkenfox-updater

#about:profiles (remove default) -> ~/.mozilla/firefox/string.default-release/user.js
#browser.search.separatePrivateDefault -> comment to keep searx
```

### Chrome

#### Brave

- https://community.brave.com/t/disable-webgl-web-tracking/189143/2

```bash
# sudo nano /usr/bin/brave
...
exec /opt/brave-bin/brave "${FLAG_LIST[@]}" "${@}" --incognito --disable-webgl
```

#### Chromium forks (Hardened)

- https://thorium.rocks/
- https://www.cromite.org/
- https://github.com/GrapheneOS/Vanadium

#### Ungoogled Chromium

- https://chromium.woolyss.com/#privacy
- https://github.com/ungoogled-software/ungoogled-chromium
- https://github.com/ghostwords/chameleon
- https://github.com/da2x/fluxfonts, https://medium.com/@Los-merengue/linux-daemon-configuration-c07e4eda3f37
- https://chromewebstore.google.com/detail/all-fingerprint-defender/meojnmfhjkahlfcecpdcdgjclcilmaij (fonts + audio)
- https://superuser.com/questions/1333563/disable-history-in-chromium
- https://vytal.io/ (chrome chameleon equivalent)
- https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome (extension UserAgent Switcher)
- https://www.thundercloud.net/infoave/new/how-to-turn-off-motion-sensors-in-chrome/
- https://www.reddit.com/r/linuxquestions/comments/sw4t5o/disable_pulseaudio_sinks/

```bash
pacmd list | grep chromium
pactl unload-module 9
```

**Violentmonkey: spoofing js scripts**

- https://greasyfork.org/en/scripts/29352-screen-resolution-spoof
- https://github.com/dillbyrne/random-agent-spoofer/issues/283

```bash
chrome://flags # disable canvas, video, webGL + webRTC, enable-generic-sensor-extra-classes; enable icognito, disable engine collection, disable referrers , get*ClientRects()/canvas::MeasureText deception...
chrome://settings/content/sensors # disable all (prevents sites from reading sensor data)


# ModHeader set

# Accept-Encoding: gzip, deflate, br
# Accept-Language: en-US,en;q=0.5
# X-Forwarded-For: 138.168.153.96 (chameleon firefox)
# User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36

# Tor like -> Vytal -> Custom + Win32
# User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/115.0
```
