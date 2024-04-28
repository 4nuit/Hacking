## Doc 2FA

- https://www.shielder.com/blog/2022/09/how-to-decrypt-manage-engine-pmp-passwords-for-fun-and-domain-admin-a-red-teaming-tale/
- https://mshelton.medium.com/two-factor-authentication-for-beginners-b29b0eec07d7

## Doc Opsec

- [extensions](../web/)
- https://shutuptrackers.com/

## Empreinte

- https://searchengine.party/
- https://www.avoidthehack.com/manually-install-extensions-ungoogled-chromium
- https://jshelter.org
- https://browserleaks.com/

### Firefox

- https://shutuptrackers.com/browser/tweaks.php
- https://addons.mozilla.org/en-US/firefox/addon/chameleon-ext/
- https://gs.statcounter.com/screen-resolution-stats

```bash
about:config
# privacy.resistFingerprinting -> set all to true
```

### Ungoogled Chromium

- https://chromium.woolyss.com/#privacy
- https://github.com/ungoogled-software/ungoogled-chromium
- https://superuser.com/questions/1333563/disable-history-in-chromium
- https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome (extension UserAgent Switcher)
- https://askubuntu.com/questions/1300473/how-to-fake-locationlatitude-and-longitude-in-ubuntu-20-04
- https://stackoverflow.com/questions/18398022/disable-gzip-compression-in-chrome/19425303#19425303 (extension ModHeader)
- https://www.thundercloud.net/infoave/new/how-to-turn-off-motion-sensors-in-chrome/
- https://www.reddit.com/r/linuxquestions/comments/sw4t5o/disable_pulseaudio_sinks/

```bash
pacmd list | grep chromium
pactl unload-module 9
```

Clavier -> set en-US + fr et switch pour Chromium

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

- https://phackt.com/tor-proxychains
- https://archive.org (deleted and protected articles)

