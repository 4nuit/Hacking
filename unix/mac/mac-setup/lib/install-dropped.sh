#!/usr/bin/env bash
#
# install-dropped.sh — install the apps Homebrew dropped, from their own
# releases or repositories.
#
#   ./lib/install-dropped.sh              what it can and cannot do
#   ./lib/install-dropped.sh freetube     one app
#   ./lib/install-dropped.sh --all        each one in turn, asking first
#
# This is NOT run by install.sh. You run it yourself, on purpose.
#
# WHY IT ASKS BEFORE EVERY DOWNLOAD
#
# These apps left Homebrew because they are not signed or notarised.
# Installing one means downloading a binary from the internet and then
# clearing the quarantine tag so macOS will run it. Homebrew used to do
# the checking for you. Now nobody does.
#
# So the script shows you the release name, the file name, the size and
# the full URL, and waits. Read the URL. It should be the project's own
# repository or site. If it is not what you expect, answer no.
#
# WHAT IT WILL NOT DO
#
# It does not verify signatures, because there are none. It does not
# check hashes against a known list, because no such list exists once a
# project is outside Homebrew. It cannot tell you the download is safe.
# It can only show you where it came from.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if [ -t 1 ]; then
  B=$'\033[0;34m'; G=$'\033[0;32m'; Y=$'\033[0;33m'; R=$'\033[0;31m'; BD=$'\033[1m'; O=$'\033[0m'
else
  B=""; G=""; Y=""; R=""; BD=""; O=""
fi
info() { printf '%s==>%s %s\n' "$B" "$O" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$G" "$O" "$*"; }
warn() { printf '%s  !!%s %s\n' "$Y" "$O" "$*" >&2; }
die()  { printf '%serror%s %s\n' "$R" "$O" "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "This installs macOS apps. It only runs on a Mac."

# ---------------------------------------------------------------------------
# What each app needs
# ---------------------------------------------------------------------------
#
# name | method | source | asset pattern | resulting app
#
#   github   latest release from that repository, pick the asset whose
#            name matches the pattern
#   git      clone and run from the checkout, no .app involved
#   manual   cannot be automated, and the reason is given
#
# The repository names and asset patterns below were written from
# knowledge, not tested against the live GitHub API. The script prints
# what it resolved before downloading anything, so a wrong guess shows
# up as an odd URL at the prompt rather than as a silent bad install.

APPS="$(cat <<'EOF'
freetube|github|FreeTubeApp/FreeTube|\.dmg$|FreeTube
imhex|github|WerWolv/ImHex|macOS.*\.dmg$|ImHex
whisky|github|Whisky-App/Whisky|\.dmg$|Whisky
qbittorrent|github|qbittorrent/qBittorrent|\.dmg$|qbittorrent
metasploit|omnibus|https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb||
metasploit-src|git|https://github.com/rapid7/metasploit-framework.git||
makemkv|manual|https://www.makemkv.com/|closed source, and the download URL carries a version number that changes with each release|
xld|manual|the author's own site|closed source, distributed outside any release feed|
zenmap|manual|https://nmap.org/download.html|not a separate download; it comes inside the nmap installer for macOS|
xact|manual|already gone|no longer distributed anywhere this script can reach|
EOF
)"

lookup() { printf '%s\n' "$APPS" | grep "^$1|" | head -1; }

# ---------------------------------------------------------------------------
# Listing
# ---------------------------------------------------------------------------

usage() {
  printf '\n%sInstalling the apps Homebrew dropped%s\n\n' "$BD" "$O"
  printf '%sCan be automated%s\n' "$BD" "$O"
  printf '%s\n' "$APPS" | while IFS='|' read -r name method src pat app; do
    case "$method" in
      github)  printf '  %-14s latest release from %s\n' "$name" "$src" ;;
      omnibus) printf '  %-14s the official Rapid7 nightly installer\n' "$name" ;;
      git)     printf '  %-14s git clone, for working on the code itself\n' "$name" ;;
    esac
  done
  printf '\n%sHas to be done by hand%s\n' "$BD" "$O"
  printf '%s\n' "$APPS" | while IFS='|' read -r name method src pat app; do
    [ "$method" = "manual" ] || continue
    printf '  %-12s %s\n' "$name" "$pat"
    printf '  %-12s %s\n' "" "$src"
  done
  cat <<EOF

Usage:
  $0 <name>
  $0 --all

Every download is shown to you and confirmed before it happens.
Check the current status of each cask first with:

  ./lib/removed-casks.sh
EOF
}

# ---------------------------------------------------------------------------
# GitHub release
# ---------------------------------------------------------------------------

resolve_asset() {
  # repo, pattern -> prints "tag<TAB>name<TAB>size<TAB>url"
  repo="$1"; pattern="$2"
  command -v python3 >/dev/null 2>&1 || die "python3 is needed to read the GitHub API. It comes with the command line developer tools."

  curl -fsSL "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null \
    | python3 -c '
import json, re, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(1)
pat = re.compile(sys.argv[1], re.I)
for a in d.get("assets", []):
    if pat.search(a["name"]):
        print("\t".join([d.get("tag_name",""), a["name"], str(a["size"]), a["browser_download_url"]]))
        break
' "$pattern"
}

install_from_github() {
  name="$1"; repo="$2"; pattern="$3"

  info "Asking GitHub for the latest $name release"
  LINE="$(resolve_asset "$repo" "$pattern" || true)"
  if [ -z "$LINE" ]; then
    warn "No macOS asset matched in the latest release of $repo."
    warn "The project may have stopped publishing Mac builds, or the file"
    warn "naming changed. Look at https://github.com/$repo/releases"
    return 1
  fi

  TAG="$(printf '%s' "$LINE" | cut -f1)"
  FILE="$(printf '%s' "$LINE" | cut -f2)"
  SIZE="$(printf '%s' "$LINE" | cut -f3)"
  URL="$(printf '%s' "$LINE" | cut -f4)"
  MB=$(( SIZE / 1048576 ))

  cat <<EOF

${BD}$name${O}
  release   $TAG
  file      $FILE
  size      ${MB} MB
  from      $URL

Read that URL. It should be github.com and the repository you expect.
This app is not signed, so nothing else will check it for you.

EOF
  printf 'Download and install it? [y/N] '
  IFS= read -r ANS
  case "$ANS" in [Yy]*) ;; *) echo "Skipped."; return 0 ;; esac

  info "Downloading"
  curl -fL --progress-bar -o "$WORK/$FILE" "$URL" || { warn "download failed"; return 1; }
  ok "got $FILE"

  case "$FILE" in
    *.dmg) install_dmg "$WORK/$FILE" ;;
    *.zip) install_zip "$WORK/$FILE" ;;
    *.pkg) install_pkg "$WORK/$FILE" ;;
    *) warn "do not know how to install a $FILE"; return 1 ;;
  esac
}

install_dmg() {
  dmg="$1"
  info "Mounting"
  MNT="$(hdiutil attach -nobrowse -readonly "$dmg" 2>/dev/null | grep -o '/Volumes/.*' | head -1)"
  [ -n "${MNT:-}" ] || { warn "could not mount $dmg"; return 1; }

  APPSRC="$(find "$MNT" -maxdepth 2 -name '*.app' -print -quit 2>/dev/null)"
  if [ -z "$APPSRC" ]; then
    hdiutil detach "$MNT" -quiet 2>/dev/null || true
    warn "no .app inside the disk image"
    return 1
  fi

  DEST="/Applications/$(basename "$APPSRC")"
  if [ -e "$DEST" ]; then
    printf 'Replace the existing %s? [y/N] ' "$(basename "$DEST")"
    IFS= read -r R
    case "$R" in [Yy]*) rm -rf "$DEST" ;; *) hdiutil detach "$MNT" -quiet; echo "Left alone."; return 0 ;; esac
  fi

  # ditto, not cp. It keeps extended attributes, code signatures and
  # resource forks intact, which cp -R does not.
  ditto "$APPSRC" "$DEST" || { hdiutil detach "$MNT" -quiet; warn "copy failed"; return 1; }
  hdiutil detach "$MNT" -quiet 2>/dev/null || true
  ok "installed $DEST"
  offer_unquarantine "$DEST"
}

install_zip() {
  info "Extracting"
  ditto -x -k "$1" "$WORK/unzipped" || { warn "extract failed"; return 1; }
  APPSRC="$(find "$WORK/unzipped" -maxdepth 3 -name '*.app' -print -quit)"
  [ -n "$APPSRC" ] || { warn "no .app inside the archive"; return 1; }
  DEST="/Applications/$(basename "$APPSRC")"
  [ -e "$DEST" ] && rm -rf "$DEST"
  ditto "$APPSRC" "$DEST" || { warn "copy failed"; return 1; }
  ok "installed $DEST"
  offer_unquarantine "$DEST"
}

install_pkg() {
  warn "This is a .pkg installer. It runs as root and can put files anywhere."
  printf 'Run it with sudo? [y/N] '
  IFS= read -r R
  case "$R" in [Yy]*) ;; *) echo "Skipped. The file is at $1"; return 0 ;; esac
  sudo installer -pkg "$1" -target / || { warn "installer failed"; return 1; }
  ok "installed"
}

offer_unquarantine() {
  app="$1"
  printf '\n'
  info "Gatekeeper assessment"
  spctl -a -vv "$app" 2>&1 | sed 's/^/  /' || true
  printf '\nmacOS will refuse to open this app while the quarantine tag is on it.\n'
  printf 'Remove the tag from %s? [y/N] ' "$(basename "$app")"
  IFS= read -r R
  case "$R" in
    [Yy]*) xattr -dr com.apple.quarantine "$app" && ok "tag removed" ;;
    *) printf 'Left in place. To do it later:\n  %s/unquarantine.sh "%s"\n' "$HERE" "$(basename "$app" .app)" ;;
  esac
}

# ---------------------------------------------------------------------------
# Rapid7 nightly installer
# ---------------------------------------------------------------------------

install_omnibus() {
  name="$1"; url="$2"

  cat <<EOF

${BD}$name${O}
  The official Rapid7 installer, from the Nightly Installers page in
  the Metasploit documentation.

  It brings its own Ruby and PostgreSQL, so nothing here fights the
  system Ruby. It imports the Rapid7 signing key and sets up a package
  that your package manager can then update, or that you update with
  msfupdate.

  Installs to   /opt/metasploit-framework/bin/msfconsole
  Script from   $url

  On first run it asks whether to set up a database and whether to add
  itself to your PATH.

EOF
  printf 'Download the installer script? [y/N] '
  IFS= read -r ANS
  case "$ANS" in [Yy]*) ;; *) echo "Skipped."; return 0 ;; esac

  curl -fsSL "$url" -o "$WORK/msfinstall" || { warn "download failed"; return 1; }
  ok "downloaded, $(wc -l < "$WORK/msfinstall" | tr -d ' ') lines"

  # The documented instructions download this file and then run it. That
  # leaves a gap where you can read it first, so take it.
  printf '\nRead the script before running it? [y/N] '
  IFS= read -r R
  case "$R" in [Yy]*) ${PAGER:-less} "$WORK/msfinstall" ;; esac

  printf '\nRun it? It asks for your password and installs to /opt. [y/N] '
  IFS= read -r R
  case "$R" in [Yy]*) ;; *) printf 'Skipped. The script is at %s\n' "$WORK/msfinstall"; return 0 ;; esac

  chmod 755 "$WORK/msfinstall"
  ( cd "$WORK" && ./msfinstall ) || { warn "the installer did not finish"; return 1; }

  if [ -x /opt/metasploit-framework/bin/msfconsole ]; then
    ok "installed. Run: /opt/metasploit-framework/bin/msfconsole"
  else
    ok "installer finished. Look for msfconsole in /opt/metasploit-framework/bin"
  fi
  printf '  Update it later with: msfupdate\n'
  printf '  The .pkg is also at https://osx.metasploit.com/ if you prefer a normal installer.\n'
}

# ---------------------------------------------------------------------------
# git checkout
# ---------------------------------------------------------------------------

install_from_git() {
  name="$1"; url="$2"
  DEST="$HOME/src/$name"

  cat <<EOF

${BD}$name${O}
  This is the development route, and it is not what most people want.
  For simply using Metasploit, run:

    $0 metasploit

  which uses the official Rapid7 installer and brings its own Ruby and
  PostgreSQL. Use this git route when you intend to edit modules or
  work on the framework itself.

  It updates with git pull. Gatekeeper never applies, because there is
  no .app bundle.

  clone into   $DEST
  from         $url

  Afterwards it needs Ruby and bundler. The Ruby that ships with macOS
  will fight you, so use the Homebrew one:

    brew install ruby
    cd $DEST && bundle install
    ./msfconsole

EOF
  printf 'Clone it now? [y/N] '
  IFS= read -r ANS
  case "$ANS" in [Yy]*) ;; *) echo "Skipped."; return 0 ;; esac

  mkdir -p "$(dirname "$DEST")"
  if [ -d "$DEST/.git" ]; then
    ok "already cloned at $DEST, pulling instead"
    git -C "$DEST" pull --ff-only || warn "pull failed"
  else
    git clone --depth 1 "$url" "$DEST" || { warn "clone failed"; return 1; }
    ok "cloned to $DEST"
  fi
  warn "bundle install is not run for you. It compiles native gems and takes a while."
}

# ---------------------------------------------------------------------------
# One app
# ---------------------------------------------------------------------------

do_one() {
  ENTRY="$(lookup "$1")"
  [ -n "$ENTRY" ] || { warn "$1 is not in the list. Run $0 with no arguments."; return 1; }

  NAME="$(printf '%s' "$ENTRY" | cut -d'|' -f1)"
  METHOD="$(printf '%s' "$ENTRY" | cut -d'|' -f2)"
  SRC="$(printf '%s' "$ENTRY" | cut -d'|' -f3)"
  PAT="$(printf '%s' "$ENTRY" | cut -d'|' -f4)"

  case "$METHOD" in
    github)  install_from_github "$NAME" "$SRC" "$PAT" ;;
    omnibus) install_omnibus "$NAME" "$SRC" ;;
    git)     install_from_git "$NAME" "$SRC" ;;
    manual)
      printf '\n%s%s%s cannot be automated.\n' "$BD" "$NAME" "$O"
      printf '  %s\n' "$PAT"
      printf '  Get it from: %s\n' "$SRC"
      printf '  Then run: %s/unquarantine.sh <AppName>\n\n' "$HERE"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Arguments
# ---------------------------------------------------------------------------

case "${1:-}" in
  "")     usage ;;
  --all)
    # metasploit-src is left out. It is the developer alternative to
    # metasploit, not a tenth app, and installing both gives you two
    # copies.
    printf '%s\n' "$APPS" | cut -d'|' -f1 | grep -v '^metasploit-src$' | while IFS= read -r n; do
      [ -n "$n" ] && do_one "$n" </dev/tty
    done
    ;;
  -h|--help) usage ;;
  *)      do_one "$1" ;;
esac
