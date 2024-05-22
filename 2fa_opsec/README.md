## Doc 2FA

- https://proton.me/pass/password-generator
- https://proton.me/mail/bridge
- https://pychao.com/2020/06/10/update-on-using-protonmail-bridge-on-headless-wordpress-linux-servers/

```bash
#PKGBUILD
makepkg -sri
```

- https://www.shielder.com/blog/2022/09/how-to-decrypt-manage-engine-pmp-passwords-for-fun-and-domain-admin-a-red-teaming-tale/
- https://mshelton.medium.com/two-factor-authentication-for-beginners-b29b0eec07d7

### Reverse Alias

- https://simplelogin.io/

![](./alias.png)

### Temp or Fake for deletion

- https://temp-mail.org/en/
- https://freephonenum.com/
- https://justdeleteme.xyz/

## Doc Opsec

- https://anonymousplanet.org/guide.html
- https://archive.is/0OLMG#selection-377.0-377.51

```bash
# sudo crontab -e
*/1 * * * * sudo rm /etc/machine-id && sudo systemd-machine-id-setup
```

- https://shutuptrackers.com/
- https://chromium.woolyss.com/#privacy
- https://forum.level1techs.com/t/how-to-obscure-your-web-browser-and-keep-a-comfy-experience/103588
- https://switching.software/
- https://restoreprivacy.com/privacy-tools/
- https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-linux
- https://pranavk-official.gitlab.io/posts/post-2/
- https://security.stackexchange.com/questions/122547/is-there-a-point-to-dnscrypt-when-using-vpn


**DNSproxy/1.1.1.1**

- https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-linux (quad9)

ou

- https://pranavk-official.gitlab.io/posts/post-2/
- https://www.cloudflare.com/ssl/encrypted-sni/#results
- https://support.nordvpn.com/hc/en-us/articles/19919186892305-How-to-disable-IPv6-on-Windows
- https://www.reddit.com/r/CloudFlare/comments/15inies/difference_between_1111_and_warp/
- https://blog.powerdns.com/2019/09/25/centralised-doh-is-bad-for-privacy-in-2019-and-beyond

## Empreinte

- https://searchengine.party/
- https://privacytests.org/
- https://www.avoidthehack.com/manually-install-extensions-ungoogled-chromium
- https://jshelter.org
- https://browserleaks.com/
- https://webbrowsertools.com/privacy-test/

```txt
# Searx using gdorks
!g site:.com "chromium.woolys*"
```

### Firefox

- https://shutuptrackers.com/browser/tweaks.php
- https://wiki.archlinux.org/title/Firefox/Privacy
- https://addons.mozilla.org/en-US/firefox/addon/chameleon-ext/
- https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/ (canvas + clientRects, audio)
- https://addons.mozilla.org/en-US/firefox/addon/font-fingerprint-defender/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search (fonts)
- https://gs.statcounter.com/screen-resolution-stats
- https://support.mozilla.org/bm/questions/1043508

#### Hardening `user.js`

```bash
yay -S arkenfox-user.js
arkenfox-updater 

#about:profiles (remove default) -> ~/.mozilla/firefox/string.default-release/user.js
#browser.search.separatePrivateDefault -> comment to keep searx

# privacy.resistFingerprinting -> set all to true
# privacy.firstparty.isolate -> false (modifier user.js)
# network.cookie.cookieBehavior = 1 // comment, default = 5
```

S assurer que safebrowsing/telemetry sont désactivés
Supprimer crashreporter, pingsender (cf wiki firefox arch)


```bash
yay -S arkenfox-user.js
arkenfox-updater 

#about:profiles (remove default) -> ~/.mozilla/firefox/string.default-release/user.js
#browser.search.separatePrivateDefault -> comment to keep searx
```

### Brave

```bash
# sudo -i; mv /usr/bin/brave /usr/bin/brave_old; nano /usr/bin/brave

#!/bin/bash
brave_old --incognito

# chmod +x brave
```

### Ungoogled Chromium

- https://github.com/ungoogled-software/ungoogled-chromium
- https://github.com/ghostwords/chameleon
- https://github.com/da2x/fluxfonts, https://medium.com/@Los-merengue/linux-daemon-configuration-c07e4eda3f37
- https://chromewebstore.google.com/detail/all-fingerprint-defender/meojnmfhjkahlfcecpdcdgjclcilmaij (fonts + audio)

```bash
#/etc/systemd/system/fluxfontd.service

[Unit]
Description=Fluxfont Daemon Service
DefaultDependencies=no
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/night
ExecStart=/usr/local/bin/fluxfontd
TimeoutstartSec=0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

#systemd daemon-reaload && systemctl enable fluxfontd
```

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
chrome://settings/content/sensors # disable all (laisser données des sites)


# ModHeader set

# Accept-Encoding: gzip, deflate, br
# Accept-Language: en-US,en;q=0.5
# X-Forwarded-For: 138.168.153.96 (chameleon firefox)
# User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36

# Tor like -> Vytal -> Custom + Win32
# User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:109.0) Gecko/20100101 Firefox/115.0
```

Reste à trouver: keyboard spoof, webgpu spoof, gyroscope block

## RGPD

- https://www.datarequests.org/blog/sample-letter-gdpr-erasure-request/
- https://www.cnil.fr/fr/le-dereferencement-dun-contenu-dans-un-moteur-de-recherche

## Proxychains with Tor over Chromium

```bash
sudo systemctl start tor.service
```

- https://phackt.com/tor-proxychains
- https://archive.org (deleted and protected articles)

