#!/usr/bin/env bash
#
# apply-zen-profile.sh
#
# Copies userChrome.css and user.js into the Zen Browser profile.
#
# The main install.sh calls this. You can also run it alone, which is
# what you do if Zen had no profile yet when you ran install.sh:
#
#   ./lib/apply-zen-profile.sh
#
# Zen makes a profile the first time you start it. Start Zen, close it
# with Cmd-Q, then run this.
#
# The script is safe to run again. It backs up any file it replaces.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/../config/zen"
ZEN_ROOT="$HOME/Library/Application Support/zen"
DRY_RUN="${DRY_RUN:-0}"

info()  { printf '\033[0;34m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[0;32m  ok\033[0m %s\n' "$*"; }
warn()  { printf '\033[0;33m  !!\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[0;31merror\033[0m %s\n' "$*" >&2; exit 1; }

[ -d "$SRC" ] || die "Cannot find $SRC"

# ---------------------------------------------------------------------------
# Find the profile Zen actually uses
# ---------------------------------------------------------------------------
# Zen ships several channels and each one has its own profile. A file in
# the wrong profile does nothing, and looks exactly like broken CSS. So
# read profiles.ini instead of guessing.
#
# profiles.ini holds two kinds of section:
#   [InstallXXXX]  Default=<relative path>   the profile of one install
#   [ProfileN]     Path=<relative path> + Default=1
#
# The Install section is the better answer, because it names the profile
# of the copy of Zen that ran last.

find_profile() {
  local ini="$ZEN_ROOT/profiles.ini"
  [ -f "$ini" ] || return 1

  local rel
  rel="$(awk '
    /^\[Install/       { in_install = 1; next }
    /^\[/              { in_install = 0 }
    in_install && /^Default=/ { sub(/^Default=/, ""); print; exit }
  ' "$ini")"

  if [ -z "$rel" ]; then
    rel="$(awk '
      /^\[Profile/ { path = ""; is_default = 0; next }
      /^Path=/     { sub(/^Path=/, ""); path = $0 }
      /^Default=1/ { is_default = 1 }
      /^$/         { if (is_default && path != "") { print path; found = 1; exit } }
      END          { if (!found && is_default && path != "") print path }
    ' "$ini")"
  fi

  [ -n "$rel" ] || return 1

  # IsRelative=0 means the path is already absolute.
  case "$rel" in
    /*) printf '%s\n' "$rel" ;;
    *)  printf '%s/%s\n' "$ZEN_ROOT" "$rel" ;;
  esac
}

PROFILE=""
if PROFILE="$(find_profile)" && [ -d "$PROFILE" ]; then
  ok "profile: $PROFILE"
else
  # Fall back to a single profile directory, if there is exactly one.
  # macOS ships bash 3.2, so this stays free of bash 4 features.
  # The `|| true` matters: set -e plus pipefail would end the script
  # here when the Profiles directory does not exist at all.
  count="$( { find "$ZEN_ROOT/Profiles" -maxdepth 1 -mindepth 1 -type d 2>/dev/null || true; } | wc -l | tr -d ' ')"
  if [ "$count" = "1" ]; then
    PROFILE="$(find "$ZEN_ROOT/Profiles" -maxdepth 1 -mindepth 1 -type d)"
    warn "profiles.ini gave no answer, using the only profile found"
    ok "profile: $PROFILE"
  else
    warn "No Zen profile found under $ZEN_ROOT"
    warn "Start Zen once, quit it with Cmd-Q, then run this script again:"
    warn "  $HERE/apply-zen-profile.sh"
    exit 3
  fi
fi

# ---------------------------------------------------------------------------
# Install the two files
# ---------------------------------------------------------------------------

STAMP="$(date +%Y%m%d-%H%M%S)"

install_one() {
  local src="$1" dst="$2"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would write %s\n' "$dst"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
    cp "$dst" "${dst}.bak-${STAMP}"
    ok "backed up $(basename "$dst")"
  fi
  cp "$src" "$dst"
  ok "wrote $dst"
}

info "Installing userChrome.css"
# Do not write zen-themes.css or anything in zen-themes/. ZenMods
# generates both and overwrites them whenever a mod changes. Nothing
# regenerates userChrome.css.
install_one "$SRC/userChrome.css" "$PROFILE/chrome/userChrome.css"

info "Installing user.js"
# user.js also sets toolkit.legacyUserProfileCustomizations.stylesheets
# to true, which is what makes Zen read userChrome.css at all.
install_one "$SRC/user.js" "$PROFILE/user.js"

cat <<EOF

Done.

Quit Zen fully with Cmd-Q and start it again. Closing the window is not
enough. Zen reads both files only at startup.

To undo:
  rm "$PROFILE/chrome/userChrome.css"
  rm "$PROFILE/user.js"
EOF
