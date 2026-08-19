# Prerequisites

- [Linux](../linux)
- [Devops](../devops)
- [Network](../network)
- [Hardware](../hardware)

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
- https://raspberrytips.com/raspberry-pi-file-server/

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
sudo mkfs.ext4 /dev/sda

# reserve 100% of the SSD
sudo tune2fs -m 0 /dev/sda

# mount it automatically
blkid
sudo nano /etc/fstab
# UUID=<UUID> /mnt/SSD  ext4  defaults,noatime,nofail,x-systemd.device-timeout=60,x-systemd.automount  0  2
sudo systemctl daemon-reload
sudo mount -a

sudo mkdir -p /mnt/SSD/media/{books,movies,music,tvshows}

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
- https://wiki.servarr.com/
- https://trash-guides.info/ 
- https://locatarr.github.io/
- https://github.com/calibrain/shelfmark/ # Serr equivalent for books
- https://github.com/crocodilestick/Calibre-Web-Automated # Readarr alternative
- https://theinit01.github.io/posts/media-stack/
- https://protonvpn.com/support/wireguard-linux

```bash
# Use media-stack containers
sudo mkdir -p /mnt/SSD/{appdata,torrents,usenet}
sudo mkdir -p /mnt/SSD/torrents/{books,movies,music,tvshows,cross-seed}
sudo mkdir -p /mnt/SSD/appdata/{qbittorrent,cross-seed,lidarr,radarr,sonarr,prowlarr,seerr,jellyfin,calibre-web-automated/ingest,shelfmark}
sudo chown -R 1000:1000 /mnt/SSD/{appdata,media,torrents,usenet}
#sudo chown -R 1000:1000 /mnt/SSD/media/books

# Add directories
# sudo install -d -o 1000 -g 1000 /mnt/SSD/torrents/stuff

# Copy docker-compose.yml and .env
mkdir media-stack && cd media-stack

# Configure ROUTER and VPN
mv .env.sample .env
chmod 600 ~/media-stack/.env

#docker compose config --quiet
#docker compose pull <missing container>
docker compose up -d --force-recreate --remove-orphans

# Configure client
## cross-seed: /mnt/SSD/appdata/cross-seed/config.js
##  torrentClients: ["qbittorrent:http://<admin>:<password>@gluetun:5080"],
##  linkDirs: ["/data/torrents/cross-seed"],

## Client hostname configuration (docker)
## radarr: http://radarr:7878
## lidarr: http://radarr:8686
## sonarr: http://sonarr:8989
## prowlarr: http://gluetun:9696
## qbittorrent: http://gluetun:5080

# Configure root folders
## /data/torrents/{books,movies,music,tvshows} for torrenting
## /data/media/{books,movies,music,tvshows} for *arr and media apps, /books for shelfmark
```

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

#### Jellyfin

- https://devoldemar.github.io/hevc/
- https://raspberrytips.fr/jellyfin-raspberry-pi/
- https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/#raspberry-pi-hardware-acceleration-support-deprecation
- https://github.com/JustRadical/jellyfin-rpc/

```bash
install -Dm644 jellyfin-rpc_main.json ~/.config/jellyfin-rpc/main.json
# edit the file
yay -S jellyfin-rpc-bin
systemctl --user start jellyfin-rpc
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
