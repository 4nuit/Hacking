#!/usr/bin/env bash
#
# removed-casks.sh — check which of the unsigned casks still work, and
# print where to get each one by hand.
#
#   ./lib/removed-casks.sh
#
# Reads only. Installs nothing, changes nothing.
#
# WHY THIS EXISTS
#
# Homebrew audits every cask for Apple code signing and notarisation.
# Casks that fail are deprecated, then removed from the official tap.
# Removal began on 2026-09-01. The apps in the list below all failed
# that audit.
#
# A removed cask cannot be installed by any means, with any flag. The
# app itself usually still exists; only the Homebrew route closes.
#
# The homepage for each one comes from `brew info`, which is Homebrew's
# own record, so it stays right without anyone editing this file. When
# a cask is gone from Homebrew entirely there is no record left, and
# this falls back to a note written by hand.

set -uo pipefail

if [ -t 1 ]; then
  G=$'\033[0;32m'; Y=$'\033[0;33m'; R=$'\033[0;31m'; BD=$'\033[1m'; O=$'\033[0m'
else
  G=""; Y=""; R=""; BD=""; O=""
fi

# The casks this package knows are affected. Each line is:
#   cask name <TAB> what it is <TAB> fallback note if brew has no record
CASKS="$(cat <<'EOF'
freetube	YouTube client, open source	freetubeapp.io, or the FreeTubeApp/FreeTube releases on GitHub
imhex	Hex editor for reverse engineering	the WerWolv/ImHex releases on GitHub
makemkv	Blu-ray and DVD ripper	makemkv.com, which is where the official builds have always been
metasploit	Penetration testing framework	the Rapid7 nightly installer: docs.metasploit.com getting-started, or https://osx.metasploit.com/
qbittorrent	BitTorrent client	qbittorrent.org
whisky	Windows app runner, discontinued upstream	the Whisky-App/Whisky releases on GitHub. No further version is coming.
xld	X Lossless Decoder, audio converter	search for X Lossless Decoder; the author distributes it himself
zenmap	Graphical front end for Nmap	nmap.org, in the macOS download, which includes Zenmap
xact	Audio compression front end	already removed from Homebrew before this package was written
EOF
)"

command -v brew >/dev/null 2>&1 || { printf '%serror%s brew is not on PATH\n' "$R" "$O" >&2; exit 1; }

printf '\n%sUnsigned casks: current status%s\n\n' "$BD" "$O"

STILL=0
GONE=0

printf '%s\n' "$CASKS" | while IFS="$(printf '\t')" read -r name what fallback; do
  [ -n "$name" ] || continue

  INFO="$(brew info --cask "$name" 2>&1)"

  if printf '%s' "$INFO" | grep -qiE 'no available cask|does not exist|no formulae or casks'; then
    STATUS="${R}GONE${O}"
    HOME_URL=""
  # Match the state, not the warning. A deprecated cask says "will be
  # disabled on <date>", which contains the word disabled and would
  # otherwise be misread as already gone.
  elif printf '%s' "$INFO" | grep -qiE 'has been disabled|\(disabled!?\)'; then
    STATUS="${R}DISABLED${O}"
    HOME_URL="$(printf '%s' "$INFO" | grep -oE 'https?://[^ ]+' | head -1)"
  elif printf '%s' "$INFO" | grep -qi 'deprecated'; then
    STATUS="${Y}deprecated${O}"
    HOME_URL="$(printf '%s' "$INFO" | grep -oE 'https?://[^ ]+' | head -1)"
  else
    STATUS="${G}fine${O}"
    HOME_URL="$(printf '%s' "$INFO" | grep -oE 'https?://[^ ]+' | head -1)"
  fi

  printf '%s%-13s%s %b\n' "$BD" "$name" "$O" "$STATUS"
  printf '  %s\n' "$what"
  if [ -n "$HOME_URL" ]; then
    printf '  %s\n' "$HOME_URL"
  else
    printf '  %s\n' "$fallback"
  fi
  # Show the disable date when brew states one.
  printf '%s' "$INFO" | grep -oiE 'will be disabled on [0-9-]+' | head -1 | sed 's/^/  /'
  echo
done

cat <<EOF
${BD}What to do with each status${O}

  fine         Nothing to do. The Homebrew route still works.
  deprecated   Installs today, will stop. Download a copy of the
               installer now, while it is still fetchable.
  disabled     Homebrew will not install it. Use the link above.
  GONE         No record left in Homebrew. Use the note above.

${BD}Installing one${O}

  ./lib/install-dropped.sh <name>

fetches the latest release from the project's own repository, shows you
the file name, size and URL, and waits for you to say yes. It handles
freetube, imhex, whisky, qbittorrent and metasploit. The other four have
no release feed a script can read, so they go by hand.

${BD}Installing one by hand${O}

Download the .dmg or .pkg, open it, drag the app to Applications. macOS
will refuse the first launch, because these apps are unsigned and that
is why they left Homebrew in the first place. Then:

  ./lib/unquarantine.sh <AppName>

or right-click the app and choose Open, then Open Anyway.

${BD}Building from source${O}

Only two of these are practical to build on a Mac, and only one is
worth it.

  imhex        cmake based. \`brew install cmake ninja\` first, then
               follow the build instructions in the repository. It has
               many dependencies and takes a while.
  metasploit   Do not build it. Rapid7 ships an official nightly
               installer for macOS that brings its own Ruby and
               PostgreSQL. Run: ./lib/install-dropped.sh metasploit
               The git clone route is for editing the framework itself.

The rest are either closed source (makemkv, xld), Swift apps that need
Xcode and a developer certificate to be worth signing (whisky), or come
bundled with something else (zenmap, inside nmap). For those, download
the build.

${BD}A note on effort${O}

Do this for the apps you actually use. Reinstalling all nine by hand on
a machine your brother has not started using yet is work spent on
software he may never open. The Homebrew route still covers ninety-eight
other applications.
EOF
