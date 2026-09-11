# Documentation

- https://developer.apple.com/documentation/os/
- https://www.macports.org/install.php
- [Mac Keyboard shortcuts](https://support.apple.com/en-us/102650) 

## Guides

- https://media.agentless.io/mac-setup.zip
- https://media.agentless.io/Searxng-Deploy-Guide.md
- https://media.agentless.io/websearch-deepseek-mcp-install.md
- https://media.agentless.io/Installing-LanguageTool-on-macOS-in-a-Docker-Container.md
- https://media.agentless.io/hermes-desktop-workspace-containment-macos.md

```bash
sysctl -a
sysctl -n machdep.cpu.brand_string
```

```bash
# start a service
vim ~/Library/LaunchAgents/jellyfinrpc.local.plist
plutil -lint ~/Library/LaunchAgents/jellyfinrpc.local.plist

launchctl bootout gui/$(id -u)/Jellyfin-RPC 2>/dev/null
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/jellyfinrpc.local.plist

launchtl list | grep -i jellyfin

# see logs
tail -f /tmp/jellyfinrpc.local.stdout.txt
```
## Ext4 automount

```bash
# Mount ext4 external SSD (no kext, no FUSE — native FSKit)
# Install Ext4Kit once: https://github.com/rayhanadev/Ext4Kit/releases
#   → drag to /Applications, open once, enable in System Settings > General > Login Items & Extensions > File System Extensions

mountssd() {
  local dev mp="/Volumes/MySSD"
  dev=$(diskutil list external | awk '/^\/dev\/disk/ {print $1; exit}')
  if [ -z "$dev" ]; then
    echo "No external disk found." >&2
    return 1
  fi
  sudo mkdir -p "$mp"
  sudo mount -F -t ext4 "${dev#/dev/}" "$mp" && echo "Mounted ${dev#/dev/} at $mp"
}

# auto-mount at login (optional — requires scoped sudoers rule for NOPASSWD)
# sudo visudo -f /etc/sudoers.d/mount-myssds
#   night ALL=(root) NOPASSWD: /sbin/mount -F -t ext4 disk* /Volumes/MySSD
#
# LaunchAgent for auto-mount + hotplug: see media.agentless.io/ext4-auto-mount.md

brew install e2fsprogs
sudo umount /Volumes/MySSD
sudo /opt/homebrew/opt/e2fsprogs/sbin/e2fsck -f -y /dev/disk5
sudo /opt/homebrew/opt/e2fsprogs/sbin/tune2fs -U random /dev/disk5
sudo /opt/homebrew/opt/e2fsprogs/sbin/e2fsck -f -y /dev/disk5
mountssd
```

## Privacy & Optimisations
```bash
# Disable Siri stack
launchctl disable system/com.apple.siriactionsd
launchctl disable gui/$(id -u)/com.apple.assistantd

# Disable Apple Intelligence
launchctl disable gui/$(id -u)/com.apple.contextstored
launchctl disable gui/$(id -u)/com.apple.privatecloudcomputed

# Disable telemetry
launchctl disable gui/$(id -u)/com.apple.analyticsd
launchctl disable gui/$(id -u)/com.apple.osanalyticshelper

# Clear logs
sudo rm -rf ~/Library/Logs/*
```

```bash
# Disable unnecessary animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable Spotlight suggestions (keeps search working)
defaults write com.apple.Spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 1;"name" = "MENU_DEFINITION";}'

# Turn off Power Nap (battery + disk thrashing)
sudo pmset -a powernap 0
```

## Controls

```txt
# commands
option + n = ~
option + shift + l = |
option + shift + ( = [

ctrl + _ = same for other unix*
command + q = quit app
command + c / command + v = copy / paste

# hyperland
super + K = cheatsheet

super + enter = new tiled terminal
command +w = close window

# screenshot
command + shift + (

# lock & log out
ctrl + command + q
shift + command + q
``` 

### Keycaps replacement

- [![Video 1](https://img.youtube.com/vi/EHpb2UR5slk/hqdefault.jpg)](https://www.youtube.com/watch?v=EHpb2UR5slk)
- [![Video 2](https://img.youtube.com/vi/BLxcMIyXNLE/hqdefault.jpg)](https://www.youtube.com/watch?v=BLxcMIyXNLE)
- [![Video 3](https://img.youtube.com/vi/xc__-jWXInU/hqdefault.jpg)](https://www.youtube.com/watch?v=xc__-jWXInU)
- [![Video 4](https://img.youtube.com/vi/C6tk7NQnd9A/hqdefault.jpg)](https://www.youtube.com/watch?v=C6tk7NQnd9A)
- [Switching keycaps AZERTY to QWERTY (I did it)](https://www.reddit.com/r/macbook/comments/19fbs21/switching_keycaps_azerty_to_qwerty_i_did_it/)
