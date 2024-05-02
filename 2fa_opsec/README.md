## Doc 2FA

- https://www.shielder.com/blog/2022/09/how-to-decrypt-manage-engine-pmp-passwords-for-fun-and-domain-admin-a-red-teaming-tale/
- https://mshelton.medium.com/two-factor-authentication-for-beginners-b29b0eec07d7

## Doc Opsec

- https://anonymousplanet.org/guide.html

- [extensions](../web/)
- https://shutuptrackers.com/
- https://forum.level1techs.com/t/how-to-obscure-your-web-browser-and-keep-a-comfy-experience/103588
- https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Installation-linux
- https://pranavk-official.gitlab.io/posts/post-2/
- https://security.stackexchange.com/questions/122547/is-there-a-point-to-dnscrypt-when-using-vpn

**1.1.1.1**

- https://www.cloudflare.com/ssl/encrypted-sni/#results
- https://support.nordvpn.com/hc/en-us/articles/19919186892305-How-to-disable-IPv6-on-Windows
- https://www.reddit.com/r/CloudFlare/comments/15inies/difference_between_1111_and_warp/

```bash
# Linux
yay -S cloudfare-warp-bin
sudo systemctl start warp-svc
warp-cli register
warp-cli connect
sudo systemctl enable warp-svc
```

## Empreinte

- https://searchengine.party/
- https://www.avoidthehack.com/manually-install-extensions-ungoogled-chromium
- https://jshelter.org
- https://browserleaks.com/
- https://webbrowsertools.com/privacy-test/

### Firefox

- https://shutuptrackers.com/browser/tweaks.php
- https://addons.mozilla.org/en-US/firefox/addon/chameleon-ext/
- https://addons.mozilla.org/en-US/firefox/addon/canvasblocker/
- https://gs.statcounter.com/screen-resolution-stats
- https://support.mozilla.org/bm/questions/1043508

```bash
about:config
# privacy.resistFingerprinting -> set all to true
# dom.webaudio.enabled = false
# dom.disable_beforeunload = false
```

### Ungoogled Chromium

- https://chromium.woolyss.com/#privacy
- https://github.com/ungoogled-software/ungoogled-chromium
- https://github.com/ghostwords/chameleon

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
```

## RGPD

- https://www.datarequests.org/blog/sample-letter-gdpr-erasure-request/
- https://www.cnil.fr/fr/le-dereferencement-dun-contenu-dans-un-moteur-de-recherche

## Proxychains with Tor over Chromium

```bash
sudo systemctl start tor.service
```

- https://phackt.com/tor-proxychains
- https://archive.org (deleted and protected articles)

