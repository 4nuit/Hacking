## Documentation

- https://mariushosting.com/ 
- https://www.servethehome.com/ 
- https://forums.unraid.net/ 
- https://forums.truenas.com/ 
- https://reddit.com/r/SelfHosting/ 
- https://reddit.com/r/selfhosted/ 
- https://reddit.com/r/homelab/ 
- https://media.agentless.io/Guide-Self-Hosting.html
- https://www.youtube.com/@ServeTheHomeVideo
- https://www.youtube.com/@nascompares

## NAS

- https://www.raid-calculator.com/
- https://www.synology.com/en-global/support/RAID_calculator
- https://en.wikipedia.org/wiki/RAID
- https://en.wikipedia.org/wiki/Non-RAID_drive_architectures
- https://en.wikipedia.org/wiki/Solid-state_drive
- https://en.wikipedia.org/wiki/Network-attached_storage
- https://www.raspberrypi.com/tutorials/nas-box-raspberry-pi-tutorial/

### Download

#### Manual

- https://open-slum.org/               # books
- https://www.qbittorrent.org/
- https://github.com/slskd/slskd/      # music
- https://github.com/spotbye/SpotiFLAC # music
- https://opentrackers.org/tracker-list/
- https://xff.cz/megatools/man/megatools.html
- https://www.easynews.com/usenet-black-friday/

```bash
sudo mkfs.ext4 /dev/sdb

# reserve 100% of the SSD
sudo tune2fs -m 0 /dev/sdb
sudo mount /dev/sdb /mnt/SSD

sudo chmod -R a+rX /mnt/SSD/media
sudo nano /etc/samba/smb.conf
sudo systemctl restart smbd
sudo smbpasswd -a pi-nas-user
sudo smbstatus --shares

megadl <url>
```

#### Automated (NAS)

- https://homarr.dev/
- https://seerr.dev/    # Media browser
- https://prowlarr.com/ # Indexer Manager
- https://radarr.video/ # Film Indexer
- https://sonarr.tv/    # Series Indexer
- https://lidarr.audio/ # Music Indexer
- https://soularr.net/  # Lidarr bridge for Soulseek
- https://trash-guides.info/ 
- https://theinit01.github.io/posts/media-stack/

### Selfhosted software

- https://jellyfin.org/
- https://immich.app/
- https://nextcloud.com/
- https://cal.com/
- https://jitsi.org/
- https://n8n.io/
- https://git.lolcat.ca/lolcat/4get
- https://www.home-assistant.io/
- https://frigate.video/
- https://element.io/en
- https://joinmastodon.org/
- https://github.com/pi-hole/pi-hole
- https://mariushosting.com/docker/
- https://github.com/lissy93/web-check
- [Personal setup of containers (llama-server, stirling-pdf, nexcloud)](../devops-selfhost/containers)
- https://github.com/awesome-selfhosted/awesome-selfhosted
- https://www.proxmox.com/en/products/proxmox-virtual-environment/overview

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
