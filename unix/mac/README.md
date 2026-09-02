# Documentation

- https://developer.apple.com/documentation/os/

```txt
# commands
option + n = ~
option + shift + l = |

ctrl + _ = same for other unix*
command + q = quit app

# hyperland
super + enter = new tiled terminal
command +w = close window
```


## Guides

- https://media.agentless.io/Searxng-Deploy-Guide.md
- https://media.agentless.io/websearch-deepseek-mcp-install.md
- https://media.agentless.io/Installing-LanguageTool-on-macOS-in-a-Docker-Container.md
- https://media.agentless.io/hermes-desktop-workspace-containment-macos.md

```bash
# start a service
vim ~/Library/LaunchAgents/jellyfinrpc.local.plist
plutil -lint ~/Library/LaunchAgents/jellyfinrpc.local.plist

launchctl bootout gui/$(id -u)/Jellyfin-RPC 2>/dev/null
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/jellyfinrpc.local.plist

launchtl list | grep -i jellyfin
```
