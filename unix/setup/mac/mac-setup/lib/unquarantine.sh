#!/usr/bin/env bash
#
# unquarantine.sh — let one app open that macOS is refusing.
#
#   ./lib/unquarantine.sh FreeTube
#   ./lib/unquarantine.sh "Some App.app"
#   ./lib/unquarantine.sh /Applications/FreeTube.app
#
# Use this when an app installed fine but will not open, and macOS says
# the developer cannot be verified.
#
# It removes the com.apple.quarantine tag from the one app you name.
# Nothing else on the machine changes. Gatekeeper stays on for every
# other app. XProtect, which is the malware scanner, is untouched and
# still runs.
#
# There is a way to do this with no script at all: right-click the app
# in Applications, choose Open, then Open Anyway. That is the same
# result. This exists for when you would rather do it from the terminal,
# or for an app that ignores the right-click route.
#
# To stop it happening again for this app on the next machine, add the
# cask name to config/casks-unquarantine.txt.

set -uo pipefail

if [ -t 1 ]; then
  G=$'\033[0;32m'; Y=$'\033[0;33m'; R=$'\033[0;31m'; BD=$'\033[1m'; O=$'\033[0m'
else
  G=""; Y=""; R=""; BD=""; O=""
fi
ok()   { printf '%s  ok%s %s\n' "$G" "$O" "$*"; }
warn() { printf '%s  !!%s %s\n' "$Y" "$O" "$*" >&2; }
die()  { printf '%serror%s %s\n' "$R" "$O" "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "This only runs on a Mac."

NAME="${1:-}"
if [ -z "$NAME" ]; then
  cat <<EOF
Name one app.

  $0 FreeTube
  $0 /Applications/FreeTube.app

Apps currently carrying the quarantine tag:

EOF
  found=0
  for a in /Applications/*.app; do
    [ -d "$a" ] || continue
    if xattr -p com.apple.quarantine "$a" >/dev/null 2>&1; then
      printf '  %s\n' "$(basename "$a" .app)"
      found=1
    fi
  done
  [ "$found" = "0" ] && printf '  none\n'
  echo
  echo "A tag on its own is normal and harmless. It only matters when the"
  echo "app refuses to open."
  exit 1
fi

# Accept a bare name, a name with .app, or a full path.
case "$NAME" in
  /*)     APP="$NAME" ;;
  *.app)  APP="/Applications/$NAME" ;;
  *)      APP="/Applications/$NAME.app" ;;
esac

[ -d "$APP" ] || die "No app at $APP"

if ! xattr -p com.apple.quarantine "$APP" >/dev/null 2>&1; then
  ok "$(basename "$APP") is not quarantined. If it still will not open, the cause is something else."
  exit 0
fi

printf '\n%sApp:%s %s\n' "$BD" "$O" "$APP"
printf '%sTag:%s %s\n' "$BD" "$O" "$(xattr -p com.apple.quarantine "$APP" 2>/dev/null)"

# Ask Gatekeeper what it thinks, before changing anything. This only
# assesses. It writes nothing.
#
# Read the answer before you say yes:
#
#   "accepted, source=Notarized Developer ID"
#       Signed and notarised. Gatekeeper is not the problem, so removing
#       the tag will not help. Something else is wrong.
#
#   "rejected, source=no usable signature"
#   "rejected (the code is valid but does not seem to be an app)"
#       Unsigned. This is the case the tag removal is for, and it is
#       normal for open source apps whose maintainers do not pay Apple
#       $99 a year.
#
#   "rejected, source=Unnotarized Developer ID"
#       Signed by someone, but never submitted to Apple. Common with
#       smaller commercial apps and with older builds.
#
# None of these tells you the app is safe. They tell you who, if anyone,
# put their name to it.
printf '\n%sGatekeeper assessment:%s\n' "$BD" "$O"
if command -v spctl >/dev/null 2>&1; then
  spctl -a -vv "$APP" 2>&1 | sed 's/^/  /'
else
  printf '  spctl is not available\n'
fi

printf '\nRemove the quarantine tag from this one app? [y/N] '
IFS= read -r ANSWER
case "$ANSWER" in
  [Yy]*) ;;
  *) echo "Nothing changed."; exit 0 ;;
esac

# -r because an .app is a directory and the tag sits on files inside it
# as well as on the bundle.
if xattr -dr com.apple.quarantine "$APP"; then
  ok "tag removed from $(basename "$APP")"
  echo
  echo "Open it now. If macOS still refuses, the app is damaged or"
  echo "incompletely downloaded, which is a different message and a"
  echo "different problem. Reinstall it in that case."
else
  die "could not remove the tag. Try: sudo xattr -dr com.apple.quarantine \"$APP\""
fi
