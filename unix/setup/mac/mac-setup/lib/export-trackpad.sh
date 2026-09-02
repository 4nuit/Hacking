#!/usr/bin/env bash
#
# export-trackpad.sh — read this Mac's trackpad, mouse and click
# settings, print them, and write them out so install.sh can replay
# them on another Mac.
#
#   ./lib/export-trackpad.sh            print the settings only
#   ./lib/export-trackpad.sh --write    print them and write config/trackpad/
#
# Run this on the Mac whose settings you want to keep. It reads only.
# Nothing is changed on the machine you run it on.
#
# Two kinds of setting come out, because macOS stores them two ways.
#
#   Whole domains. Everything the Trackpad settings pane writes lives in
#   its own preference domain. Those are copied out complete, as plist
#   files, and copied back the same way. This is exact.
#
#   Single keys in the global domain. Tracking speed, natural scrolling
#   and tap to click live in NSGlobalDomain, next to several hundred
#   unrelated settings. Copying that domain whole would carry your
#   entire system configuration with it, so these are written one key at
#   a time.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$HERE/../config/trackpad"
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

# Whole domains, copied exactly.
#
#   AppleMultitouchTrackpad                    the built-in trackpad
#   driver.AppleBluetoothMultitouch.trackpad   an external Magic Trackpad
#   AppleMultitouchMouse                       a Magic Mouse
#   driver.AppleBluetoothMultitouch.mouse      the same, over Bluetooth
#
# Each of these also has a per-machine copy, which macOS calls the
# current host. Some keys live in one, some in the other, so both are
# read.
DOMAINS="
com.apple.AppleMultitouchTrackpad
com.apple.driver.AppleBluetoothMultitouch.trackpad
com.apple.AppleMultitouchMouse
com.apple.driver.AppleBluetoothMultitouch.mouse
"

# Single keys in the global domain.
GLOBAL_KEYS="
com.apple.swipescrolldirection
com.apple.trackpad.scaling
com.apple.mouse.scaling
com.apple.scrollwheel.scaling
com.apple.trackpad.forceClick
com.apple.trackpad.enableSecondaryClick
com.apple.springing.enabled
com.apple.springing.delay
com.apple.mouse.doubleClickThreshold
com.apple.mouse.linear
AppleEnableSwipeNavigateWithScrolls
AppleEnableMouseSwipeNavigateWithScrolls
"

# The same, but stored per machine. Tap to click is the important one.
GLOBAL_HOST_KEYS="
com.apple.mouse.tapBehavior
com.apple.trackpad.enableSecondaryClick
"

# Gesture switches that omacosy also sets. Read and shown, but written
# into a separate file that is not replayed by default. See the note at
# the end.
DOCK_KEYS="
showMissionControlGestureEnabled
showAppExposeGestureEnabled
showDesktopGestureEnabled
showLaunchpadGestureEnabled
"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# defaults write needs to be told the type. defaults read-type says what
# it is, in a sentence, so take the last word and translate it.
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

printf '\n%sTrackpad and click settings on this Mac%s\n\n' "$BD" "$O"

printf '%sGlobal%s\n' "$BD" "$O"
for k in $GLOBAL_KEYS; do
  v="$(read_key read -g "$k")"
  printf '  %-45s %s\n' "$k" "${v:-(not set)}"
done

printf '\n%sGlobal, per machine%s\n' "$BD" "$O"
for k in $GLOBAL_HOST_KEYS; do
  v="$(read_key -currentHost read -g "$k")"
  printf '  %-45s %s\n' "$k" "${v:-(not set)}"
done

for d in $DOMAINS; do
  n="$(read_key read "$d" 2>/dev/null | grep -c '=' || true)"
  h="$(read_key -currentHost read "$d" 2>/dev/null | grep -c '=' || true)"
  printf '\n%s%s%s\n' "$BD" "$d" "$O"
  printf '  %s key(s), and %s more per machine\n' "${n:-0}" "${h:-0}"
  read_key read "$d" 2>/dev/null | grep '=' | sed 's/^ */    /'
  read_key -currentHost read "$d" 2>/dev/null | grep '=' | sed 's/^ */    [host] /'
done

printf '\n%sGesture switches, which omacosy also sets%s\n' "$BD" "$O"
for k in $DOCK_KEYS; do
  v="$(read_key read com.apple.dock "$k")"
  printf '  %-45s %s\n' "$k" "${v:-(not set)}"
done

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

# --- whole domains, as plists ---------------------------------------
for d in $DOMAINS; do
  if defaults export "$d" "$OUT/$d.plist" 2>/dev/null; then
    if grep -q '<key>' "$OUT/$d.plist" 2>/dev/null; then
      ok "$d.plist"
    else
      rm -f "$OUT/$d.plist"   # the domain exists but is empty
    fi
  fi
  if defaults -currentHost export "$d" "$OUT/$d.currentHost.plist" 2>/dev/null; then
    if grep -q '<key>' "$OUT/$d.currentHost.plist" 2>/dev/null; then
      ok "$d.currentHost.plist"
    else
      rm -f "$OUT/$d.currentHost.plist"
    fi
  fi
done

# --- global keys, one defaults write per line ------------------------
GLOBALS="$OUT/globals.sh"
{
  echo "#!/usr/bin/env bash"
  echo "#"
  echo "# config/trackpad/globals.sh"
  echo "#"
  echo "# Written by lib/export-trackpad.sh on $(date +%Y-%m-%d)."
  echo "# Read by the trackpad stage of install.sh."
  echo "#"
  echo "# These keys live in NSGlobalDomain, next to several hundred"
  echo "# unrelated settings, so they are copied one at a time instead of"
  echo "# as a whole domain."
  echo "#"
  echo "# Delete any line you do not want."
  echo ""
  for k in $GLOBAL_KEYS; do
    v="$(read_key read -g "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag read-type -g "$k")"
    printf 'defaults write -g %s %s %s\n' "$k" "$f" "$v"
  done
  echo ""
  echo "# Per machine. Tap to click is here."
  for k in $GLOBAL_HOST_KEYS; do
    v="$(read_key -currentHost read -g "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag -currentHost read-type -g "$k")"
    printf 'defaults -currentHost write -g %s %s %s\n' "$k" "$f" "$v"
  done
} > "$GLOBALS"
chmod +x "$GLOBALS"
ok "globals.sh"

# --- gesture switches, kept apart ------------------------------------
GESTURES="$OUT/dock-gestures.sh.disabled"
{
  echo "#!/usr/bin/env bash"
  echo "#"
  echo "# config/trackpad/dock-gestures.sh.disabled"
  echo "#"
  echo "# NOT replayed. The file name ends in .disabled on purpose."
  echo "#"
  echo "# omacosy turns these four gestures off, so that macOS Mission"
  echo "# Control stops fighting its own swipe daemon for the same four"
  echo "# fingers. Turning them back on breaks workspace swiping."
  echo "#"
  echo "# omacosy's uninstall.sh restores them if you remove omacosy."
  echo "#"
  echo "# To replay them anyway, rename this file to dock-gestures.sh."
  echo ""
  for k in $DOCK_KEYS; do
    v="$(read_key read com.apple.dock "$k")"
    [ -n "$v" ] || continue
    f="$(write_flag read-type com.apple.dock "$k")"
    printf 'defaults write com.apple.dock %s %s %s\n' "$k" "$f" "$v"
  done
  echo "killall Dock"
} > "$GESTURES"
ok "dock-gestures.sh.disabled"

cat <<EOF

Done. ${BD}$(find "$OUT" -type f | wc -l | tr -d ' ') file(s)${O} in config/trackpad/

Copy the whole mac-setup folder to the new Mac. The trackpad stage
picks these up on its own. To apply them to a Mac that is already set
up:

  ./install.sh --only trackpad

Settings take effect after you log out and back in. A trackpad does not
re-read its configuration while it is in use.
EOF
