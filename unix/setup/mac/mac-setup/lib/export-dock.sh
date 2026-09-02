#!/usr/bin/env bash
#
# export-dock.sh — read this Mac's Dock and menu bar settings, print
# them, and write them out so install.sh can replay them elsewhere.
#
#   ./lib/export-dock.sh            print the settings only
#   ./lib/export-dock.sh --write    print them and write config/dock/
#
# Run this on the Mac whose settings you want to keep. It reads only.
# Nothing changes on the machine you run it on.
#
# Same two shapes as the trackpad export, for the same reason. Whole
# preference domains are copied exactly, as plists. Keys that live in
# NSGlobalDomain, next to several hundred unrelated settings, are copied
# one at a time.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$HERE/../config/dock"
WRITE=0
[ "${1:-}" = "--write" ] && WRITE=1

if [ -t 1 ]; then
  B=$'\033[0;34m'; G=$'\033[0;32m'; Y=$'\033[0;33m'; BD=$'\033[1m'; O=$'\033[0m'
else
  B=""; G=""; Y=""; BD=""; O=""
fi
info() { printf '%s==>%s %s\n' "$B" "$O" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$G" "$O" "$*"; }
warn() { printf '%s  !!%s %s\n' "$Y" "$O" "$*" >&2; }

[ "$(uname -s)" = "Darwin" ] || { warn "This reads macOS settings. It only runs on a Mac."; exit 1; }

# ---------------------------------------------------------------------------
# What to read
# ---------------------------------------------------------------------------

# Dock keys, read one at a time. The whole com.apple.dock domain is not
# copied by default because it holds persistent-apps and
# persistent-others, which are the actual contents of your Dock as a
# list of file paths. Those paths point at apps that may not exist on
# another Mac. There is a separate optional file for them below.
DOCK_KEYS="
orientation
autohide
autohide-delay
autohide-time-modifier
tilesize
largesize
magnification
show-recents
minimize-to-application
mineffect
launchanim
static-only
show-process-indicators
expose-group-apps
mru-spaces
size-immutable
position-immutable
"

# Hot corners. Each corner has an action number and a modifier key.
# tl, tr, bl, br are top left, top right, bottom left, bottom right.
CORNER_KEYS="
wvous-tl-corner
wvous-tl-modifier
wvous-tr-corner
wvous-tr-modifier
wvous-bl-corner
wvous-bl-modifier
wvous-br-corner
wvous-br-modifier
"

# Menu bar. These two live in the global domain.
#
#   _HIHideMenuBar                    hide the menu bar until you reach
#                                     the top of the screen
#   AppleMenuBarVisibleInFullscreen   show it in full screen apps
GLOBAL_KEYS="
_HIHideMenuBar
AppleMenuBarVisibleInFullscreen
"

# The clock domain is copied whole. Every key in it is a setting.
DOMAINS="
com.apple.menuextra.clock
"

# Control Centre is NOT copied whole, on purpose.
#
# That domain mixes real settings with things that belong to one machine
# and must not travel: LastSelectedDisplayUUID names a specific monitor,
# IRServiceToken is a token, and there are analytics timestamps and
# migration flags. Importing the domain would carry all of it.
#
# So only these keys are read. Items are matched by name.
CC_KEYS="
AutoHideMenuBarOption
"
CC_PREFIXES="
NSStatusItem Visible
NSStatusItem VisibleCC
"
CC_HOST_KEYS="
BatteryShowPercentage
Bluetooth
NowPlaying
VoiceControl
AirplayRecieverEnabled
ShowSuggestions
"

# com.apple.systemuiserver is not read at all. On this generation of
# macOS it holds nothing but an analytics timestamp and a window level
# flag.

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

write_flag() {
  case "$(defaults "$@" 2>/dev/null | awk '{print $NF}')" in
    boolean) printf -- '-bool'   ;;
    integer) printf -- '-int'    ;;
    float)   printf -- '-float'  ;;
    string)  printf -- '-string' ;;
    *)       printf -- ''        ;;
  esac
}
read_key() { defaults "$@" 2>/dev/null; }

# ---------------------------------------------------------------------------
# Print
# ---------------------------------------------------------------------------

printf '\n%sDock and menu bar settings on this Mac%s\n\n' "$BD" "$O"

printf '%sDock%s\n' "$BD" "$O"
for k in $DOCK_KEYS; do
  v="$(read_key read com.apple.dock "$k")"
  printf '  %-32s %s\n' "$k" "${v:-(not set)}"
done

printf '\n%sHot corners%s\n' "$BD" "$O"
for k in $CORNER_KEYS; do
  v="$(read_key read com.apple.dock "$k")"
  printf '  %-32s %s\n' "$k" "${v:-(not set)}"
done

printf '\n%sMenu bar, global domain%s\n' "$BD" "$O"
for k in $GLOBAL_KEYS; do
  v="$(read_key read -g "$k")"
  printf '  %-32s %s\n' "$k" "${v:-(not set)}"
done
# Some builds keep the menu bar setting per machine instead.
v="$(read_key -currentHost read -g _HIHideMenuBar)"
printf '  %-32s %s\n' "_HIHideMenuBar [per machine]" "${v:-(not set)}"

printf '\n%sControl Centre, the keys worth copying%s\n' "$BD" "$O"
for k in $CC_KEYS; do
  v="$(read_key read com.apple.controlcenter "$k")"
  printf '  %-40s %s\n' "$k" "${v:-(not set)}"
done
# Named status items only. Entries called Item-0, Item-1 and so on are
# anonymous slots belonging to third-party apps, numbered in the order
# this machine installed them. On another Mac the same numbers point at
# different apps, so copying them hides the wrong things.
read_key read com.apple.controlcenter 2>/dev/null \
  | grep -E '"?NSStatusItem Visible' \
  | grep -vE 'Item-[0-9]' \
  | sed 's/^ */  /'
printf '  %s\n' "(NSStatusItem Preferred Position keys are skipped: pixel offsets that depend on screen width)"

printf '\n%sControl Centre, per machine%s\n' "$BD" "$O"
for k in $CC_HOST_KEYS; do
  v="$(read_key -currentHost read com.apple.controlcenter "$k")"
  printf '  %-40s %s\n' "$k" "${v:-(not set)}"
done

for d in $DOMAINS; do
  printf '\n%s%s%s\n' "$BD" "$d" "$O"
  read_key read "$d" 2>/dev/null | sed 's/^ */    /'
done

printf '\n%sDock contents, for information%s\n' "$BD" "$O"
printf '  persistent-apps entries:   %s\n' \
  "$(read_key read com.apple.dock persistent-apps 2>/dev/null | grep -c '_CFURLString' || echo 0)"
printf '  persistent-others entries: %s\n' \
  "$(read_key read com.apple.dock persistent-others 2>/dev/null | grep -c '_CFURLString' || echo 0)"

if [ "$WRITE" != "1" ]; then
  cat <<EOF

Nothing was written. To save these into the package, run:

  $0 --write

EOF
  exit 0
fi

# ---------------------------------------------------------------------------
# Write
# ---------------------------------------------------------------------------

echo
info "Writing $OUT"
mkdir -p "$OUT"

for d in $DOMAINS; do
  if defaults export "$d" "$OUT/$d.plist" 2>/dev/null && grep -q '<key>' "$OUT/$d.plist" 2>/dev/null; then
    ok "$d.plist"
  else
    rm -f "$OUT/$d.plist"
  fi
done

SETTINGS="$OUT/settings.sh"
{
  echo "#!/usr/bin/env bash"
  echo "#"
  echo "# config/dock/settings.sh"
  echo "#"
  echo "# Written by lib/export-dock.sh on $(date +%Y-%m-%d)."
  echo "# Run by the dock stage of install.sh."
  echo "#"
  echo "# Delete any line you do not want."
  echo ""
  echo "set -uo pipefail"
  echo ""
  echo "# --- Dock ---"
  for k in $DOCK_KEYS $CORNER_KEYS; do
    v="$(read_key read com.apple.dock "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag read-type com.apple.dock "$k")"
    if [ "$f" = "-string" ]; then
      printf 'defaults write com.apple.dock %s -string "%s"\n' "$k" "$v"
    else
      printf 'defaults write com.apple.dock %s %s %s\n' "$k" "$f" "$v"
    fi
  done
  echo ""
  echo "# --- Menu bar ---"
  for k in $GLOBAL_KEYS; do
    v="$(read_key read -g "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag read-type -g "$k")"
    printf 'defaults write -g %s %s %s\n' "$k" "$f" "$v"
  done
  v="$(read_key -currentHost read -g _HIHideMenuBar)"
  if [ -n "$v" ]; then
    f="$(write_flag -currentHost read-type -g _HIHideMenuBar)"
    printf 'defaults -currentHost write -g _HIHideMenuBar %s %s\n' "$f" "$v"
  fi
  echo ""
  echo "# --- Control Centre ---"
  echo "# Only named keys. The machine-specific ones in this domain"
  echo "# (display UUID, service token, analytics stamps) are left behind."
  for k in $CC_KEYS; do
    v="$(read_key read com.apple.controlcenter "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag read-type com.apple.controlcenter "$k")"
    printf 'defaults write com.apple.controlcenter %s %s %s\n' "$k" "$f" "$v"
  done
  read_key read com.apple.controlcenter 2>/dev/null \
    | grep -E '"NSStatusItem Visible' \
    | grep -vE 'Item-[0-9]' \
    | sed -E 's/^ *"([^"]+)" = ([0-9]+);/defaults write com.apple.controlcenter "\1" -int \2/'
  echo ""
  for k in $CC_HOST_KEYS; do
    v="$(read_key -currentHost read com.apple.controlcenter "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag -currentHost read-type com.apple.controlcenter "$k")"
    printf 'defaults -currentHost write com.apple.controlcenter %s %s %s\n' "$k" "$f" "$v"
  done
  echo ""
  echo "# --- Apply ---"
  echo "# The Dock re-reads its settings only when it restarts. That is"
  echo "# instant and safe; launchd starts it again straight away."
  echo "killall Dock 2>/dev/null || true"
  echo "killall SystemUIServer 2>/dev/null || true"
  echo "killall ControlCenter 2>/dev/null || true"
} > "$SETTINGS"
chmod +x "$SETTINGS"
ok "settings.sh"

# The Dock contents, kept apart because the paths inside point at apps
# that may not exist on another Mac. Rename to .plist to use it.
if defaults export com.apple.dock "$OUT/com.apple.dock.full.plist.optional" 2>/dev/null; then
  ok "com.apple.dock.full.plist.optional"
  ok "  the whole Dock domain, including which apps are in your Dock."
  ok "  Not replayed. It points at app paths that may not exist on the"
  ok "  other Mac, which shows as question mark icons. To use it anyway,"
  ok "  drop the .optional from the file name."
fi

cat <<EOF

Done. ${BD}$(find "$OUT" -type f | wc -l | tr -d ' ') file(s)${O} in config/dock/

The dock stage picks these up on its own. To apply them to a Mac that is
already set up:

  ./install.sh --only dock

The Dock changes at once. The menu bar may need a log out and back in.
EOF
