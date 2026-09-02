#!/usr/bin/env bash
#
# install.sh — set up a new Mac in one run.
#
#   ./install.sh --dry-run     print every action, change nothing
#   ./install.sh               do it
#   ./install.sh --help        all options
#
# The script is idempotent. Run it again after a failure, or after you
# change something. It skips what is already done.
#
# It works on bash 3.2, which is the bash macOS ships.

set -uo pipefail

# ===========================================================================
# Settings. Change these if you want a different machine.
# ===========================================================================

# Node versions to install, and the one new shells use.
NODE_VERSIONS="${NODE_VERSIONS:-22 24}"
DEFAULT_NODE_VERSION="${DEFAULT_NODE_VERSION:-24}"

# Python versions uv manages. The full set matches the source machine.
# --lean cuts this down. See --help.
UV_PYTHON_MINORS="${UV_PYTHON_MINORS:-3.8 3.9 3.10 3.11 3.12 3.13}"
UV_PYTHON_EXACT="${UV_PYTHON_EXACT:-3.9.22 3.10.17 3.11.12 3.12.10}"
BREW_PYTHONS="${BREW_PYTHONS:-python@3.12 python@3.13 python@3.14}"

# Python command line tools. Zed's settings.json expects ruff and
# pyrefly as its Python language servers.
UV_TOOLS="${UV_TOOLS:-ruff pyrefly git-filter-repo}"

# Homebrew formulae that are not in the Brewfile.
CORE_FORMULAE="git mas topgrade fnm pnpm uv go zsh-autosuggestions zsh-syntax-highlighting"

# Databases. SQLite needs no server. MySQL and PostgreSQL each install a
# server that you start yourself. See the databases stage.
DB_FORMULAE="${DB_FORMULAE:-mysql sqlite}"

# Which PostgreSQL. Empty means the script picks the newest one Homebrew
# offers. Set it to pin a version, for example POSTGRES_FORMULA=postgresql@17.
POSTGRES_FORMULA="${POSTGRES_FORMULA:-}"

# Start the MySQL and PostgreSQL servers at login. Off by default,
# because the Brewfile also installs DBngin, which runs its own copies
# of both on the same ports. Read the databases stage before you turn
# this on.
START_DB_SERVICES="${START_DB_SERVICES:-0}"

# Window corner radius. 0.1 is square. 4 is Catalina. 9 to 10 is
# Sequoia. Do not use plain 0, which behaves oddly in some apps.
CORNER_RADIUS="${CORNER_RADIUS:-0.1}"

# Focus ring radius for omacosy. The rule from borders.conf is
#   ring radius = window corner radius + gap + width/2
# and with omacosy's gap=-1 and width=3 that is window radius + 0.5.
RING_RADIUS="${RING_RADIUS:-0.6}"

OMACOSY_REPO="https://github.com/paulsp94/omacosy.git"
OMACOSY_DIR="$HOME/.local/share/omacosy"

# ===========================================================================
# Paths and state
# ===========================================================================

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="$HERE/config"
LIB="$HERE/lib"
BIN="$HERE/bin"

DRY_RUN=0
SKIP_OMACOSY=0
SKIP_APPS=0
SKIP_EXTRAS=0
SKIP_AGENTS=0
SKIP_NEOVIM=0
SKIP_GIT=0
SKIP_TRACKPAD=0
UPDATE_MACOS=0
SKIP_DOCK=0
ONLY=""
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_DIR="$HOME/.local/state/mac-setup"
LOG="$LOG_DIR/install-$STAMP.log"

FAILED=""        # stage names that failed
NOTES=""         # things the person still has to do by hand
CASK_FAILED=""   # casks that would not install
FAILED_AGENTS="" # agent harnesses that would not install

ALL_STAGES="macos-update xcode git-identity rosetta homebrew launchd-path macos-defaults trackpad brew-core databases apps extras neovim omacosy shell dock node python rust agents configs zed zen"

# ===========================================================================
# Helpers
# ===========================================================================

if [ -t 1 ]; then
  C_BLUE=$'\033[0;34m'; C_GREEN=$'\033[0;32m'; C_YELLOW=$'\033[0;33m'
  C_RED=$'\033[0;31m';  C_BOLD=$'\033[1m';     C_OFF=$'\033[0m'
else
  C_BLUE=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_BOLD=""; C_OFF=""
fi

info()  { printf '%s==>%s %s\n' "$C_BLUE" "$C_OFF" "$*"; }
ok()    { printf '%s  ok%s %s\n' "$C_GREEN" "$C_OFF" "$*"; }
warn()  { printf '%s  !!%s %s\n' "$C_YELLOW" "$C_OFF" "$*" >&2; }
err()   { printf '%serror%s %s\n' "$C_RED" "$C_OFF" "$*" >&2; }
die()   { err "$*"; exit 1; }

banner() {
  printf '\n%s%s %s%s\n' "$C_BOLD" "────" "$*" "$C_OFF"
}

note()  { NOTES="$NOTES
  - $*"; }

# Run a command, or print it in a dry run.
run() {
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: %s\n' "$*"
    return 0
  fi
  "$@"
}

# Copy a file, keeping a timestamped backup of anything it replaces.
install_file() {
  local src="$1" dst="$2"
  if [ ! -f "$src" ]; then
    warn "missing source file: $src"
    return 1
  fi
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would write: %s\n' "$dst"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && ! cmp -s "$src" "$dst"; then
    cp "$dst" "${dst}.bak-${STAMP}"
    ok "backed up $dst"
  fi
  cp "$src" "$dst"
  ok "wrote $dst"
}

have() { command -v "$1" >/dev/null 2>&1; }

stage_wanted() {
  [ -z "$ONLY" ] && return 0
  case ",$ONLY," in
    *",$1,"*) return 0 ;;
    *) return 1 ;;
  esac
}

# ===========================================================================
# Arguments
# ===========================================================================

usage() {
  cat <<EOF
${C_BOLD}install.sh${C_OFF} — set up a new Mac in one run.

  --dry-run          Print every action. Change nothing. Do this first.
  --skip-omacosy     Do not install or update the omacosy desktop.
  --skip-apps        Do not install the applications from config/Brewfile.
  --skip-extras      Do not install the extra command line tools from
                     config/Brewfile.extras.
  --skip-agents      Do not install the LLM agent harnesses from
                     config/agents.txt.
  --skip-neovim      Do not install Neovim and LazyVim.
  --skip-git         Do not ask for your git name, email and SSH key.
  --skip-trackpad    Do not replay the trackpad settings in
                     config/trackpad/.
  --skip-dock        Do not apply config/dock.sh.

  --update-macos     Install pending macOS updates in stage 1. This
                     restarts the Mac, which ends the run. You then
                     start install.sh again. Off by default, because a
                     restart in the middle of a 90 minute install is a
                     bad surprise.

  --part1            Everything except the omacosy desktop. This is the
                     safe half: if it goes wrong, nothing is broken and
                     you still have a working Mac.
  --part2            The omacosy desktop and the stages that depend on
                     it. Run this only after --part1 finished and
                     lib/verify.sh looked right.
  --lean             Install fewer Python versions: 3.12 and 3.13 only,
                     and one Homebrew Python. Saves about 15 minutes and
                     several GB. The full set is the default because it
                     matches the source machine.
  --start-databases  Start the MySQL and PostgreSQL servers at login.
                     Off by default. Read the databases stage first:
                     DBngin runs its own copies on the same ports.
  --only <stages>    Run only these stages. Comma separated, no spaces.
  -h, --help         This text.

Stages, in the order they run:
  $ALL_STAGES

Examples:
  ./install.sh --dry-run
  ./install.sh
  ./install.sh --lean --skip-apps
  ./install.sh --only zen
  ./install.sh --only configs,zed

Running it in two parts, which is safer when nobody experienced is
watching:

  ./install.sh --part1
  ./lib/verify.sh
  ./install.sh --part2
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)      DRY_RUN=1 ;;
    --skip-omacosy) SKIP_OMACOSY=1 ;;
    --skip-apps)    SKIP_APPS=1 ;;
    --skip-extras)  SKIP_EXTRAS=1 ;;
    --skip-agents)  SKIP_AGENTS=1 ;;
    --skip-neovim)  SKIP_NEOVIM=1 ;;
    --skip-git)     SKIP_GIT=1 ;;
    --skip-trackpad) SKIP_TRACKPAD=1 ;;
    --update-macos) UPDATE_MACOS=1 ;;
    --skip-dock)    SKIP_DOCK=1 ;;
    --part1)
      # Every stage except omacosy. The shell, configs and zed stages
      # are here because they work with or without the desktop.
      ONLY="macos-update,xcode,git-identity,rosetta,homebrew,launchd-path,macos-defaults,trackpad,brew-core,databases,apps,extras,neovim,shell,dock,node,python,rust,agents,configs,zed,zen"
      ;;
    --part2)
      # omacosy, then the two stages that have to run after it: shell
      # puts ~/.zshrc back to a real file, configs sets the ring radius
      # in the borders.conf that omacosy creates.
      ONLY="omacosy,shell,dock,configs"
      ;;
    --lean)
      UV_PYTHON_MINORS="3.12 3.13"
      UV_PYTHON_EXACT=""
      BREW_PYTHONS="python@3.13"
      ;;
    --start-databases) START_DB_SERVICES=1 ;;
    --only)         shift; ONLY="${1:-}" ;;
    --only=*)       ONLY="${1#--only=}" ;;
    -h|--help)      usage; exit 0 ;;
    *)              err "unknown option: $1"; echo; usage; exit 1 ;;
  esac
  shift
done

# ===========================================================================
# Preflight
# ===========================================================================

banner "Checks"

[ "$(uname -s)" = "Darwin" ] || die "This script runs on macOS only."
[ "$(id -u)" -ne 0 ] || die "Do not run this script with sudo. It asks for a password when it needs one."
[ -d "$CFG" ] || die "Cannot find $CFG. Run the script from inside the folder you unzipped."

ARCH="$(uname -m)"
MACOS_VERSION="$(sw_vers -productVersion)"
MACOS_MAJOR="${MACOS_VERSION%%.*}"
ok "macOS $MACOS_VERSION on $ARCH"

if [ "$DRY_RUN" = "1" ]; then
  warn "DRY RUN. Nothing on this machine changes."
else
  ok "log: $LOG"
fi

# Ask for the password once, then keep it fresh in the background, so
# no step stops halfway waiting for input.
if [ "$DRY_RUN" != "1" ]; then
  info "Some steps need your password. Asking once now."
  if sudo -v; then
    ( while true; do sudo -n true 2>/dev/null; sleep 50; kill -0 "$$" 2>/dev/null || exit; done ) &
    SUDO_KEEPALIVE_PID=$!
    trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT
    ok "password cached"
  else
    warn "No password. Steps that need one will ask again or be skipped."
  fi
fi

# ===========================================================================
# 1. macOS updates
# ===========================================================================

stage_macos_update() {
  banner "1. macOS updates"

  # This runs first so you can decide before spending an hour and a
  # half on the rest.
  #
  # It only looks, unless you pass --update-macos. Installing a macOS
  # update restarts the Mac. A restart in the middle of this run kills
  # it, and you would have to start again, so the choice is yours and
  # not the script's.

  info "Asking Apple what is available. This takes up to a minute."

  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: softwareupdate -l\n'
    return 0
  fi

  AVAIL="$(softwareupdate -l 2>&1)"

  if printf '%s' "$AVAIL" | grep -qi "No new software available"; then
    ok "macOS $MACOS_VERSION is up to date"
  else
    printf '%s\n' "$AVAIL" | sed 's/^/    /'

    if [ "$UPDATE_MACOS" = "1" ]; then
      warn "Installing updates. The Mac restarts when it finishes."
      warn "Start install.sh again after it comes back."
      # -r is recommended updates only. Major version upgrades need
      # --include-major-os-updates, which this deliberately leaves out.
      sudo softwareupdate -i -r --restart --agree-to-license || {
        err "softwareupdate failed."
        err "On Apple silicon an update that needs a restart also needs"
        err "the password of a volume owner, which softwareupdate cannot"
        err "always collect from a script. Use System Settings, General,"
        err "Software Update instead. It is more reliable."
        return 1
      }
    else
      note "macOS updates are available. Install them from System Settings, General, Software Update, then run this script again. Or pass --update-macos."
    fi
  fi

  # A major version upgrade is a separate question and this never does
  # it on its own.
  MAJOR="$(softwareupdate -l --include-major-os-updates 2>&1 | grep -i 'Label:' | grep -viF "$(printf '%s' "$AVAIL" | grep -i 'Label:' || echo 'zzzznomatch')" || true)"
  if [ -n "$MAJOR" ]; then
    printf '\n'
    warn "A major macOS upgrade is offered:"
    printf '%s\n' "$MAJOR" | sed 's/^/    /'
    warn "This script will not install it. Two reasons:"
    warn "  omacosy is built and tested on macOS 26. A newer major"
    warn "  version is untested with it."
    warn "  The square corners key is undocumented and Apple can remove"
    warn "  it in any build."
    note "A major macOS upgrade is available. Do it deliberately, from System Settings, not as part of this run."
  fi

  # The rest of the package assumes macOS 26 or later.
  if [ "$MACOS_MAJOR" -lt 26 ] 2>/dev/null; then
    warn "This is macOS $MACOS_VERSION. omacosy is built for macOS 26."
    warn "Everything else works. The square corners stage will skip itself."
  fi
}

# ===========================================================================
# 2. Xcode command line tools
# ===========================================================================

stage_xcode() {
  banner "2. Command line developer tools"

  if xcode-select -p >/dev/null 2>&1; then
    ok "already installed at $(xcode-select -p)"
    return 0
  fi

  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: xcode-select --install, then wait for it to finish\n'
    return 0
  fi

  info "Starting the installer. A macOS dialog opens."
  xcode-select --install >/dev/null 2>&1 || true

  echo "  Click Install in the dialog and accept the licence."
  echo "  Waiting. This takes a few minutes."

  waited=0
  while ! xcode-select -p >/dev/null 2>&1; do
    sleep 15
    waited=$((waited + 15))
    printf '.'
    if [ "$waited" -ge 1800 ]; then
      echo
      err "Still not installed after 30 minutes."
      err "Install it by hand, then run this script again."
      return 1
    fi
  done
  echo
  ok "installed at $(xcode-select -p)"
}

# ===========================================================================
# 3. Git identity
# ===========================================================================

stage_git_identity() {
  banner "3. Git identity"

  if [ "$SKIP_GIT" = "1" ]; then
    ok "skipped by --skip-git"
    return 0
  fi

  # This runs second on purpose. It is the only stage that asks you
  # questions, so it happens while you are still at the keyboard. Git
  # itself is already here: the command line developer tools from
  # stage 1 include it, and Homebrew replaces it later without
  # touching ~/.gitconfig.
  [ -f "$LIB/setup-git.sh" ] || { warn "no $LIB/setup-git.sh, skipping"; return 0; }

  DRY_RUN="$DRY_RUN" bash "$LIB/setup-git.sh"
  rc=$?

  if [ "$rc" = "4" ]; then
    note "Nobody was at the keyboard, so git was not set up. Run: $LIB/setup-git.sh"
    return 0
  fi
  return "$rc"
}

# ===========================================================================
# 4. Rosetta 2
# ===========================================================================

stage_rosetta() {
  banner "4. Rosetta 2"

  if [ "$ARCH" != "arm64" ]; then
    ok "Intel Mac, Rosetta is not needed"
    return 0
  fi
  if /usr/bin/pgrep -q oahd 2>/dev/null; then
    ok "already installed"
    return 0
  fi
  run softwareupdate --install-rosetta --agree-to-license
}

# ===========================================================================
# 5. Homebrew
# ===========================================================================

load_brew() {
  have brew && return 0
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      eval "$("$candidate" shellenv)"
      return 0
    fi
  done
  return 1
}

stage_homebrew() {
  banner "5. Homebrew"

  if load_brew; then
    ok "brew at $(command -v brew)"
    return 0
  fi

  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: the Homebrew install script from https://brew.sh\n'
    return 0
  fi

  info "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || { err "Homebrew install failed"; return 1; }

  load_brew || { err "Homebrew installed but brew is not on PATH"; return 1; }
  ok "brew at $(command -v brew)"
}

# ===========================================================================
# 6. PATH for programs macOS starts, not the shell
# ===========================================================================

stage_launchd_path() {
  banner "6. PATH for background services"

  # macOS starts applications and background services through launchd,
  # not through your shell. They get a short PATH that holds no
  # /opt/homebrew/bin, and your .zshrc never runs for them. This is why
  # omacosy's Activity pill fails to start btop until you fix it.
  #
  # launchctl config replaces the whole value. There is no way to append
  # one entry, and leaving out the system directories would break every
  # service on the machine, so the whole list is written out.

  load_brew || { warn "no brew, skipping"; return 1; }
  BREW_PREFIX="$(brew --prefix)"
  WANT="$BREW_PREFIX/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

  CURRENT="$(launchctl getenv PATH 2>/dev/null || true)"
  if [ "$CURRENT" = "$WANT" ]; then
    ok "already set"
    return 0
  fi

  run sudo launchctl config user path "$WANT"
  [ "$DRY_RUN" = "1" ] || ok "set to $WANT"
  note "Log out and back in so every background service picks up the new PATH."
}

# ===========================================================================
# 7. macOS appearance
# ===========================================================================

stage_macos_defaults() {
  banner "7. Square window corners"

  # macOS 26 rounds window corners hard. This undocumented key sets the
  # radius. Apple can rename or remove it in any build. Nothing here is
  # destructive: at worst a command does nothing.
  #
  # Do not run these with sudo. That writes to root's settings, not
  # yours, and the value then reads back as missing.

  if [ "$MACOS_MAJOR" -lt 26 ] 2>/dev/null; then
    ok "macOS $MACOS_VERSION already has small corners, key not needed"
    return 0
  fi

  run defaults write -g NSConvolutionOverride1 -float "$CORNER_RADIUS"
  run defaults write -g NSSplitViewItemSidebarDefaultsToFloatingAppearance -bool false
  run defaults write -g NSSplitViewItemGlassMinimumCornerRadius -float 6

  if [ "$DRY_RUN" != "1" ]; then
    ok "radius set to $(defaults read -g NSConvolutionOverride1 2>/dev/null || echo '?')"
  fi

  # Applications read the value when they start, so the change appears
  # only in applications you restart.
  note "Log out and back in to give every application square corners."
  note "Electron applications (VS Code, Slack, Discord) draw their own frame and stay rounded. Zen and Firefox follow the setting."
}

# ===========================================================================
# 8. Trackpad, mouse and click
# ===========================================================================

stage_trackpad() {
  banner "8. Trackpad, mouse and click"

  if [ "$SKIP_TRACKPAD" = "1" ]; then
    ok "skipped by --skip-trackpad"
    return 0
  fi

  TP="$CFG/trackpad"
  if [ ! -d "$TP" ]; then
    ok "no config/trackpad, nothing to replay"
    note "To copy your trackpad and click settings from another Mac, run lib/export-trackpad.sh --write there, then copy this folder over."
    return 0
  fi

  # This stage runs before omacosy on purpose. omacosy's
  # macos-defaults.sh turns off the four-finger Mission Control
  # gestures, so its own swipe daemon is not fighting macOS for the
  # same fingers. Running here means omacosy gets the last word on the
  # few keys they share, and everything else is yours.

  count=0

  # Whole domains, copied back exactly as they were read.
  for f in "$TP"/*.plist; do
    [ -e "$f" ] || continue
    base="$(basename "$f" .plist)"
    case "$base" in
      *.currentHost)
        domain="${base%.currentHost}"
        if [ "$DRY_RUN" = "1" ]; then
          printf '  would run: defaults -currentHost import %s "%s"\n' "$domain" "$f"
        elif defaults -currentHost import "$domain" "$f" 2>>"$LOG"; then
          ok "$domain (per machine)"
        else
          warn "could not import $domain, see $LOG"
        fi
        ;;
      *)
        if [ "$DRY_RUN" = "1" ]; then
          printf '  would run: defaults import %s "%s"\n' "$base" "$f"
        elif defaults import "$base" "$f" 2>>"$LOG"; then
          ok "$base"
        else
          warn "could not import $base, see $LOG"
        fi
        ;;
    esac
    count=$((count + 1))
  done

  # Single keys in the global domain.
  if [ -f "$TP/globals.sh" ]; then
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would run: %s\n' "$TP/globals.sh"
      grep -c '^defaults' "$TP/globals.sh" 2>/dev/null | sed 's/^/    lines: /'
    elif bash "$TP/globals.sh" >>"$LOG" 2>&1; then
      ok "$(grep -c '^defaults' "$TP/globals.sh") global setting(s)"
    else
      warn "globals.sh failed, see $LOG"
    fi
    count=$((count + 1))
  fi

  # Anything else the person enabled by renaming a .disabled file.
  for f in "$TP"/*.sh; do
    [ -e "$f" ] || continue
    case "$(basename "$f")" in globals.sh) continue ;; esac
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would run: %s\n' "$f"
    elif bash "$f" >>"$LOG" 2>&1; then
      ok "$(basename "$f")"
    else
      warn "$(basename "$f") failed, see $LOG"
    fi
    count=$((count + 1))
  done

  if [ "$count" = "0" ]; then
    ok "config/trackpad is empty, nothing to replay"
    return 0
  fi

  # A trackpad does not re-read its configuration while it is in use.
  note "Trackpad and click settings need a log out and back in. Restarting the preferences daemon is not enough."
}

# ===========================================================================
# 9. Core command line tools
# ===========================================================================

stage_brew_core() {
  banner "9. Command line tools"

  load_brew || { warn "no brew, skipping"; return 1; }

  for pkg in $CORE_FORMULAE; do
    if brew list --formula "$pkg" >/dev/null 2>&1; then
      ok "$pkg already installed"
    else
      run brew install "$pkg" || warn "brew install $pkg failed"
    fi
  done

  if brew list --cask applite >/dev/null 2>&1; then
    ok "applite already installed"
  else
    run brew install --cask applite || warn "brew install --cask applite failed"
  fi
}

# ===========================================================================
# 10. Databases
# ===========================================================================

stage_databases() {
  banner "10. Databases"

  load_brew || { warn "no brew, skipping"; return 1; }

  # SQLite needs no server. macOS already ships an sqlite3, but it is
  # old, so Homebrew installs a newer one. Homebrew calls that keg-only:
  # it does not link the command into /opt/homebrew/bin, because a copy
  # already exists in /usr/bin. ~/.zshrc.local puts the newer one first
  # on PATH.
  #
  # MySQL and PostgreSQL each install a server as well as a client.
  # Neither server starts by itself.

  if [ -z "$POSTGRES_FORMULA" ]; then
    for c in postgresql@18 postgresql@17 postgresql; do
      if brew info --formula "$c" >/dev/null 2>&1; then
        POSTGRES_FORMULA="$c"
        break
      fi
    done
  fi
  if [ -z "$POSTGRES_FORMULA" ]; then
    warn "no postgresql formula found. Set POSTGRES_FORMULA and run this stage again."
  else
    ok "PostgreSQL formula: $POSTGRES_FORMULA"
  fi

  for pkg in $DB_FORMULAE $POSTGRES_FORMULA; do
    if brew list --formula "$pkg" >/dev/null 2>&1; then
      ok "$pkg already installed"
    else
      run brew install "$pkg" || warn "brew install $pkg failed"
    fi
  done

  # The Brewfile installs DBngin, which runs its own MySQL and
  # PostgreSQL. Two servers on port 3306 or on 5432 means the second one
  # fails to start, and the error does not say why. So the Homebrew
  # servers stay stopped unless you ask for them.
  if [ "$START_DB_SERVICES" = "1" ]; then
    info "Starting the database servers at login"
    run brew services start mysql || warn "could not start mysql"
    if [ -n "$POSTGRES_FORMULA" ]; then
      run brew services start "$POSTGRES_FORMULA" || warn "could not start $POSTGRES_FORMULA"
    fi
  else
    note "MySQL and PostgreSQL are installed but not running. Start them with:"
    note "      brew services start mysql"
    note "      brew services start ${POSTGRES_FORMULA:-postgresql}"
    note "  DBngin runs its own MySQL and PostgreSQL on the same ports, 3306 and 5432. Use DBngin or Homebrew services, not both."
  fi

  if [ "$DRY_RUN" != "1" ]; then
    BREW_PREFIX="$(brew --prefix)"
    if [ -x "$BREW_PREFIX/opt/sqlite/bin/sqlite3" ]; then
      ok "newer sqlite3 at $BREW_PREFIX/opt/sqlite/bin/sqlite3"
    fi
    if [ -n "$POSTGRES_FORMULA" ] && [ -d "$BREW_PREFIX/opt/$POSTGRES_FORMULA/bin" ]; then
      ok "psql at $BREW_PREFIX/opt/$POSTGRES_FORMULA/bin"
    fi
  fi
}

# ===========================================================================
# 11. Applications
# ===========================================================================

stage_apps() {
  banner "11. Applications"

  if [ "$SKIP_APPS" = "1" ]; then
    ok "skipped by --skip-apps"
    return 0
  fi

  load_brew || { warn "no brew, skipping"; return 1; }

  BREWFILE="$CFG/Brewfile"
  [ -f "$BREWFILE" ] || { err "no $BREWFILE"; return 1; }

  # Taps first. A cask written as user/tap/name needs its tap.
  info "Adding taps"
  while IFS= read -r line; do
    case "$line" in
      tap\ *) ;;
      *) continue ;;
    esac
    t="$(printf '%s' "$line" | sed -E 's/^tap[[:space:]]+"([^"]+)".*/\1/')"
    [ -n "$t" ] || continue
    if brew tap | grep -qx "$t"; then
      ok "tap $t already added"
    else
      run brew tap "$t" || warn "brew tap $t failed"
    fi
  done < "$BREWFILE"

  # Casks named in config/casks-unquarantine.txt get the quarantine tag
  # removed from whatever app they install, straight after they install
  # it.
  #
  # This used to be `brew install --cask --no-quarantine`. That flag was
  # removed in Homebrew 5.1, and passing it now fails with "invalid
  # option". Homebrew's own answer to the question is that
  # post-processing with xattr is the supported route, the same as it
  # would be if you downloaded the app yourself.
  #
  # It is per app and deliberate. Gatekeeper stays on for everything
  # else. XProtect, the malware scanner, is untouched.
  NQ_FILE="$CFG/casks-unquarantine.txt"
  NQ=""
  if [ -f "$NQ_FILE" ]; then
    NQ=" $(grep -vE '^[[:space:]]*#|^[[:space:]]*$' "$NQ_FILE" | tr '\n' ' ')"
    [ "$NQ" = " " ] || ok "unquarantine after install:$NQ"
  fi

  # Which .app bundles exist right now. Comparing before and after an
  # install tells us exactly what that cask put on the disk, with no
  # guessing at the app name from the cask name. They often differ.
  snapshot_apps() {
    ls -1d /Applications/*.app "$HOME/Applications"/*.app 2>/dev/null | sort
  }

  # Casks one at a time, not through brew bundle. brew bundle stops at
  # the first failure, and one cask that has gone missing upstream would
  # then block all the rest. This way you get everything that works and
  # a list of what did not.
  info "Installing applications, one at a time"
  total=0
  while IFS= read -r line; do
    case "$line" in
      cask\ *) ;;
      *) continue ;;
    esac
    full="$(printf '%s' "$line" | sed -E 's/^cask[[:space:]]+"([^"]+)".*/\1/')"
    [ -n "$full" ] || continue
    short="${full##*/}"
    total=$((total + 1))

    if brew list --cask "$short" >/dev/null 2>&1; then
      ok "$short already installed"
      continue
    fi
    UNQ=0
    case "$NQ" in
      *" $short "*|*" $short") UNQ=1 ;;
    esac

    if [ "$DRY_RUN" = "1" ]; then
      printf '  would run: brew install --cask %s\n' "$full"
      [ "$UNQ" = "1" ] && printf '    then remove the quarantine tag from what it installs\n'
      continue
    fi

    [ "$UNQ" = "1" ] && BEFORE="$(snapshot_apps)"

    printf '%s==>%s installing %s\n' "$C_BLUE" "$C_OFF" "$short"
    if brew install --cask "$full" >>"$LOG" 2>&1; then
      ok "$short"

      if [ "$UNQ" = "1" ]; then
        AFTER="$(snapshot_apps)"
        NEW_APPS="$(comm -13 <(printf '%s\n' "$BEFORE") <(printf '%s\n' "$AFTER") || true)"
        if [ -z "$NEW_APPS" ]; then
          warn "$short: no new .app appeared, so nothing to unquarantine"
        else
          printf '%s\n' "$NEW_APPS" | while IFS= read -r app; do
            [ -n "$app" ] || continue
            [ -d "$app" ] || continue
            if xattr -dr com.apple.quarantine "$app" 2>/dev/null; then
              ok "  quarantine tag removed from $(basename "$app")"
            else
              warn "  could not clear the tag on $(basename "$app"). Run: ./lib/unquarantine.sh \"$(basename "$app" .app)\""
            fi
          done
        fi
      fi
    else
      warn "$short failed, see $LOG"
      CASK_FAILED="$CASK_FAILED $short"
    fi
  done < "$BREWFILE"

  ok "$total applications in the list"

  # A deprecated cask installs, with a warning. Homebrew usually
  # disables it later, and a disabled cask cannot be installed at all.
  # So the warning is worth surfacing now rather than finding out on
  # the next machine.
  if [ "$DRY_RUN" != "1" ] && [ -f "$LOG" ]; then
    DEPR="$(grep -i 'deprecated' "$LOG" 2>/dev/null | sort -u | head -20 || true)"
    if [ -n "$DEPR" ]; then
      printf '\n'
      warn "Some casks are deprecated. They installed, but Homebrew will"
      warn "disable them, and a disabled cask cannot be installed at all."
      warn "The usual cause now is that the app is not signed and"
      warn "notarised. Homebrew began removing those casks on 2026-09-01."
      printf '%s\n' "$DEPR" | sed 's/^/    /'
      note "Deprecated casks installed fine but may stop being available. The list is above and in $LOG."
    fi
  fi
  if [ -n "$CASK_FAILED" ]; then
    note "These applications did not install:$CASK_FAILED"
    note "  Read what brew said in $LOG. Three different failures look alike:"
    note "  'deprecated' still installs, so that was not the reason."
    note "  'disabled' or 'no longer available' cannot be forced. The cask is gone from Homebrew and no flag brings it back. Get the app from its own site."
    note "  'cannot be opened because the developer cannot be verified' is Gatekeeper, and it usually appears at first launch, not here. Add the name to config/casks-unquarantine.txt, or run: ./lib/unquarantine.sh <AppName>"
  fi
}

# ===========================================================================
# 12. Extra command line tools
# ===========================================================================

stage_extras() {
  banner "12. Extra command line tools"

  if [ "$SKIP_EXTRAS" = "1" ]; then
    ok "skipped by --skip-extras"
    return 0
  fi

  load_brew || { warn "no brew, skipping"; return 1; }

  EXTRAS="$CFG/Brewfile.extras"
  [ -f "$EXTRAS" ] || { warn "no $EXTRAS, skipping"; return 0; }

  # These are formulae, not casks. They install fast and none of them
  # asks for a password.
  while IFS= read -r line; do
    case "$line" in
      brew\ *) ;;
      *) continue ;;
    esac
    f="$(printf '%s' "$line" | sed -E 's/^brew[[:space:]]+"([^"]+)".*/\1/')"
    [ -n "$f" ] || continue
    if brew list --formula "$f" >/dev/null 2>&1; then
      ok "$f already installed"
    elif [ "$DRY_RUN" = "1" ]; then
      printf '  would run: brew install %s\n' "$f"
    elif brew install "$f" >>"$LOG" 2>&1; then
      ok "$f"
    else
      warn "$f failed, see $LOG"
    fi
  done < "$EXTRAS"

  note "pinentry-mac needs one line to work. Run: echo 'pinentry-program /opt/homebrew/bin/pinentry-mac' >> ~/.gnupg/gpg-agent.conf"
  note "direnv needs one line in ~/.zshrc.local: eval \"\$(direnv hook zsh)\""
}

# ===========================================================================
# 13. Neovim and LazyVim
# ===========================================================================

stage_neovim() {
  banner "13. Neovim and LazyVim"

  if [ "$SKIP_NEOVIM" = "1" ]; then
    ok "skipped by --skip-neovim"
    return 0
  fi

  load_brew || { warn "no brew, skipping"; return 1; }

  if brew list --formula neovim >/dev/null 2>&1; then
    ok "neovim already installed"
  else
    run brew install neovim || { warn "brew install neovim failed"; return 1; }
  fi

  NVIM_CFG="$HOME/.config/nvim"

  if [ "$DRY_RUN" = "1" ]; then
    printf '  would clone the LazyVim starter into %s\n' "$NVIM_CFG"
    printf '  would run: nvim --headless "+Lazy! sync" +qa\n'
    return 0
  fi

  if [ -f "$NVIM_CFG/lua/config/lazy.lua" ]; then
    ok "LazyVim already at $NVIM_CFG"
  else
    # LazyVim needs an empty slate. Old plugin state in any of these
    # four directories makes the first start fail in ways that look
    # like a broken install. Move them aside rather than delete them.
    for d in "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
      if [ -e "$d" ]; then
        mv "$d" "${d}.bak-${STAMP}"
        ok "moved $d to ${d}.bak-${STAMP}"
      fi
    done

    mkdir -p "$(dirname "$NVIM_CFG")"
    if git clone --depth 1 https://github.com/LazyVim/starter "$NVIM_CFG" >>"$LOG" 2>&1; then
      # Drop the .git directory. The starter is a template, not
      # something you track. Leaving it makes topgrade try to pull it,
      # and any change you make would show as a dirty repository.
      rm -rf "$NVIM_CFG/.git"
      ok "LazyVim starter at $NVIM_CFG"
    else
      err "could not clone the LazyVim starter, see $LOG"
      return 1
    fi
  fi

  # Download the plugins now, so the first real start is not a
  # three-minute wait inside the editor.
  info "Downloading the plugins. This takes a minute or two."
  if nvim --headless "+Lazy! sync" +qa >>"$LOG" 2>&1; then
    ok "plugins installed"
  else
    warn "the plugin download did not finish. Start nvim and let it run, or see $LOG"
  fi

  note "Your own Neovim settings go in ~/.config/nvim/lua/config/ and ~/.config/nvim/lua/plugins/. Do not edit anything under ~/.local/share/nvim; that is plugin code."
  note "Run :LazyHealth inside nvim to see what is missing. :Lazy update updates the plugins."
}

# ===========================================================================
# 14. omacosy desktop
# ===========================================================================

stage_omacosy() {
  banner "14. omacosy"

  if [ "$SKIP_OMACOSY" = "1" ]; then
    ok "skipped by --skip-omacosy"
    return 0
  fi

  # The clone location matters. macOS privacy rules stop background
  # services from reading ~/Documents, ~/Desktop and ~/Downloads, and
  # omacosy symlinks its configs into the clone.
  if [ -d "$OMACOSY_DIR/.git" ]; then
    ok "already cloned to $OMACOSY_DIR"
  else
    run mkdir -p "$(dirname "$OMACOSY_DIR")"
    run git clone "$OMACOSY_REPO" "$OMACOSY_DIR" || { err "clone failed"; return 1; }
  fi

  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: cd %s && ./install.sh\n' "$OMACOSY_DIR"
    return 0
  fi

  cat <<'EOF'

  omacosy now compiles its helper programs and asks macOS for
  permissions. Several dialogs appear. Grant them:

    Accessibility       AeroSpace, AerospaceSwipe, omacosy-ffm
                        This is the tiling itself. Nothing tiles without it.
    Input Monitoring    Karabiner-Elements, AerospaceSwipe
                        The Super key and the trackpad swipes.
    Screen Recording    omacosy-overview
                        Window previews in the workspace overview.
    Bluetooth           omacosy-bar
    Location            omacosy-bar
                        This reads only the wi-fi network name. macOS
                        classes that as location data. No position is
                        ever requested.
    Automation          omacosy-bar, theme-set

  Karabiner-Elements also asks you to approve a driver extension. It
  runs as root and it is third party. It is there to make Caps Lock the
  Super key. Refuse it and you lose the Super key and keep the rest.

EOF
  ( cd "$OMACOSY_DIR" && ./install.sh ) || { err "omacosy install.sh failed"; return 1; }
  ok "omacosy installed"
}

# ===========================================================================
# 15. Shell
# ===========================================================================

stage_shell() {
  banner "15. Shell"

  ZSHRC="$HOME/.zshrc"
  ZSHRC_LOCAL="$HOME/.zshrc.local"
  SOURCE_LINE='source "$HOME/.local/share/omacosy/zsh/zshrc"'

  # -- the two helper scripts -------------------------------------------
  # These are scripts, not shell functions, on purpose. topgrade runs
  # commands from a non-interactive shell that never reads
  # ~/.zshrc.local, so a function defined there would never run. A
  # script does not care who calls it.
  info "Installing the helper scripts"
  run mkdir -p "$HOME/.local/bin"
  for s in omacosy-safe-update omacosy-harvest-zshrc; do
    install_file "$BIN/$s" "$HOME/.local/bin/$s"
    run chmod +x "$HOME/.local/bin/$s"
  done

  # -- make ~/.zshrc a real file ----------------------------------------
  # omacosy's install.sh makes ~/.zshrc a symlink into the git clone.
  # Every installer that appends a line to ~/.zshrc then writes into the
  # clone, and the next omacosy update refuses to run.
  info "Making ~/.zshrc a real file"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would write: %s (a real file that sources omacosy)\n' "$ZSHRC"
  elif [ -L "$ZSHRC" ]; then
    cp -P "$ZSHRC" "$HOME/.zshrc.symlink-backup-$STAMP"
    rm "$ZSHRC"
    cp "$CFG/zshrc" "$ZSHRC"
    ok "replaced the symlink, backup at ~/.zshrc.symlink-backup-$STAMP"
  elif [ -f "$ZSHRC" ]; then
    if grep -q 'omacosy/zsh/zshrc' "$ZSHRC"; then
      ok "already a real file that sources omacosy"
    else
      # Keep whatever is already in there. It goes below the marker, so
      # the harvest script moves it into ~/.zshrc.local on the next
      # shell start.
      cp "$ZSHRC" "${ZSHRC}.bak-${STAMP}"
      OLD_BODY="$(grep -vE '^[[:space:]]*$' "$ZSHRC" || true)"
      cp "$CFG/zshrc" "$ZSHRC"
      if [ -n "$OLD_BODY" ]; then
        printf '%s\n' "$OLD_BODY" >> "$ZSHRC"
        ok "kept your old ~/.zshrc lines below the marker"
      fi
      ok "wrote a real ~/.zshrc, backup at ${ZSHRC}.bak-${STAMP}"
    fi
  else
    cp "$CFG/zshrc" "$ZSHRC"
    ok "created $ZSHRC"
  fi

  # -- your own config --------------------------------------------------
  info "Installing ~/.zshrc.local"
  install_file "$CFG/zshrc.local" "$ZSHRC_LOCAL"

  # -- stop the clone from blocking its own updates ---------------------
  if [ -d "$OMACOSY_DIR/.git" ]; then
    info "Making the omacosy clone update-proof"

    # install.sh builds these two .app bundles at the top of the repo
    # and does not ignore them. omacosy-update refuses to run when
    # untracked files are present, so the project blocks its own
    # updates. .git/info/exclude is local, is not versioned and
    # survives every pull.
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would add *.app/ to %s/.git/info/exclude\n' "$OMACOSY_DIR"
    else
      EXCLUDE="$OMACOSY_DIR/.git/info/exclude"
      mkdir -p "$(dirname "$EXCLUDE")"
      for pat in 'omacosy-bar.app/' 'omacosy-gesture.app/' '*.app/'; do
        grep -qxF "$pat" "$EXCLUDE" 2>/dev/null || echo "$pat" >> "$EXCLUDE"
      done
      ok "build artifacts excluded"
    fi

    # theme-set writes border colors into config/omniwm/settings.toml,
    # which is tracked and symlinked into ~/.config. Every theme change
    # therefore makes the clone dirty.
    #
    # Do NOT mark that file skip-worktree. It looks like the fix and it
    # is a trap: the flag works until upstream edits the same file, and
    # from then on every update stops with "Entry
    # 'config/omniwm/settings.toml' not uptodate. Cannot merge." The
    # flag has to be cleared by hand before anything works again.
    #
    # omacosy-safe-update handles this instead. It resets the clone to
    # upstream before each update and writes your colors back
    # afterwards, so a modified settings.toml is expected and harmless.
    # It also clears this flag on every run, in case something else set
    # it. Clear it here too, for a clone carried over from an older
    # setup.
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would clear any skip-worktree flags in the clone\n'
    else
      FLAGGED="$(git -C "$OMACOSY_DIR" ls-files -v 2>/dev/null | grep '^S' | cut -c3- || true)"
      if [ -n "$FLAGGED" ]; then
        printf '%s\n' "$FLAGGED" | while IFS= read -r f; do
          [ -n "$f" ] && git -C "$OMACOSY_DIR" update-index --no-skip-worktree "$f" 2>/dev/null || true
        done
        ok "cleared skip-worktree on $(printf '%s\n' "$FLAGGED" | grep -c .) file(s)"
      else
        ok "no skip-worktree flags, which is correct"
      fi
    fi
  else
    warn "no omacosy clone, skipping the git settings"
  fi

  # -- check the files parse --------------------------------------------
  if [ "$DRY_RUN" != "1" ] && have zsh; then
    for f in "$ZSHRC" "$ZSHRC_LOCAL"; do
      if zsh -n "$f" 2>/dev/null; then
        ok "$(basename "$f") parses"
      else
        err "$(basename "$f") has a syntax error"
        zsh -n "$f" || true
        return 1
      fi
    done
  fi
}

# ===========================================================================
# 16. Dock and menu bar
# ===========================================================================

stage_dock() {
  banner "16. Dock and menu bar"

  if [ "$SKIP_DOCK" = "1" ]; then
    ok "skipped by --skip-dock"
    return 0
  fi

  # Two sources, and a directory beats the single file.
  #
  #   config/dock/       written by lib/export-dock.sh from a real Mac.
  #                      Exact, and includes the menu bar contents.
  #   config/dock.sh     the hand-written defaults that ship with the
  #                      package. Used when there is no export.
  DOCKDIR="$CFG/dock"
  DOCKFILE="$CFG/dock.sh"

  if [ -d "$DOCKDIR" ]; then
    ok "using the exported settings in config/dock/"

    for f in "$DOCKDIR"/*.plist; do
      [ -e "$f" ] || continue
      base="$(basename "$f" .plist)"
      case "$base" in
        *.currentHost)
          domain="${base%.currentHost}"
          if [ "$DRY_RUN" = "1" ]; then
            printf '  would run: defaults -currentHost import %s\n' "$domain"
          elif defaults -currentHost import "$domain" "$f" 2>>"$LOG"; then
            ok "$domain (per machine)"
          else
            warn "could not import $domain, see $LOG"
          fi
          ;;
        *)
          if [ "$DRY_RUN" = "1" ]; then
            printf '  would run: defaults import %s\n' "$base"
          elif defaults import "$base" "$f" 2>>"$LOG"; then
            ok "$base"
          else
            warn "could not import $base, see $LOG"
          fi
          ;;
      esac
    done

    for f in "$DOCKDIR"/*.sh; do
      [ -e "$f" ] || continue
      if [ "$DRY_RUN" = "1" ]; then
        printf '  would run: %s\n' "$f"
        grep -c '^defaults' "$f" | sed 's/^/    settings: /'
      elif bash "$f" >>"$LOG" 2>&1; then
        ok "$(basename "$f"): $(grep -c '^defaults' "$f") setting(s) applied"
      else
        warn "$(basename "$f") failed, see $LOG"
      fi
    done

  elif [ -f "$DOCKFILE" ]; then
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would run: %s\n' "$DOCKFILE"
      grep -c '^defaults' "$DOCKFILE" | sed 's/^/    settings: /'
      return 0
    fi
    if bash "$DOCKFILE" >>"$LOG" 2>&1; then
      ok "$(grep -c '^defaults' "$DOCKFILE") setting(s) applied, Dock restarted"
    else
      warn "config/dock.sh failed, see $LOG"
      return 1
    fi
  else
    ok "no config/dock/ and no config/dock.sh, nothing to do"
    return 0
  fi

  note "If the menu bar still shows, log out and back in. Newer macOS builds do not re-read that setting when SystemUIServer restarts."
}

# ===========================================================================
# 17. Node
# ===========================================================================

stage_node() {
  banner "17. Node, fnm and pnpm"

  load_brew || { warn "no brew, skipping"; return 1; }
  [ -f "$LIB/setup-node-toolchain.sh" ] || { err "no $LIB/setup-node-toolchain.sh"; return 1; }

  NODE_VERSIONS="$NODE_VERSIONS" \
  DEFAULT_NODE_VERSION="$DEFAULT_NODE_VERSION" \
  DRY_RUN="$DRY_RUN" \
    bash "$LIB/setup-node-toolchain.sh"
}

# ===========================================================================
# 18. Python
# ===========================================================================

stage_python() {
  banner "18. Python and uv"

  load_brew || { warn "no brew, skipping"; return 1; }
  [ -f "$LIB/setup-python-toolchain.sh" ] || { err "no $LIB/setup-python-toolchain.sh"; return 1; }

  info "Python versions: $UV_PYTHON_MINORS $UV_PYTHON_EXACT"
  info "This is the long step. Each version is a download."

  UV_PYTHON_MINORS="$UV_PYTHON_MINORS" \
  UV_PYTHON_EXACT="$UV_PYTHON_EXACT" \
  BREW_PYTHONS="$BREW_PYTHONS" \
  UV_TOOLS="$UV_TOOLS" \
  INSTALL_TOOLS=1 \
  DRY_RUN="$DRY_RUN" \
    bash "$LIB/setup-python-toolchain.sh"
}

# ===========================================================================
# 19. Rust
# ===========================================================================

stage_rust() {
  banner "19. Rust"

  if have rustc && [ -x "$HOME/.cargo/bin/rustup" ]; then
    ok "already installed: $(rustc --version 2>/dev/null)"
    return 0
  fi

  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: the rustup installer from https://rustup.rs\n'
    return 0
  fi

  # --no-modify-path matters. Without it rustup appends its own PATH
  # line to ~/.zshrc. ~/.zshrc.local already puts ~/.cargo/bin on PATH,
  # so a second copy would only add noise.
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path \
    || { err "rustup install failed"; return 1; }

  ok "installed $("$HOME/.cargo/bin/rustc" --version 2>/dev/null || echo rust)"
}

# ===========================================================================
# 20. LLM agent harnesses
# ===========================================================================

stage_agents() {
  banner "20. LLM agent harnesses"

  if [ "$SKIP_AGENTS" = "1" ]; then
    ok "skipped by --skip-agents"
    return 0
  fi

  AGENTS_FILE="$CFG/agents.txt"
  [ -f "$AGENTS_FILE" ] || { warn "no $AGENTS_FILE, skipping"; return 0; }

  load_brew || warn "no brew, some agents may fail"

  # This stage runs after node, because one of the agents installs
  # through pnpm and pnpm needs fnm to have set up Node first.
  if have fnm; then
    eval "$(fnm env --shell bash)" 2>/dev/null || true
  fi

  # Fields are separated by tabs. IFS is set to a tab only, so an
  # install command that contains spaces stays in one piece.
  while IFS="$(printf '\t')" read -r name check cmd; do
    case "$name" in
      ""|\#*) continue ;;
    esac
    [ -n "${cmd:-}" ] || { warn "$name: no install command, skipping"; continue; }

    if have "$check"; then
      ok "$name already installed: $(command -v "$check")"
      continue
    fi
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would run: %s\n' "$cmd"
      continue
    fi

    printf '%s==>%s installing %s\n' "$C_BLUE" "$C_OFF" "$name"
    if sh -c "$cmd" >>"$LOG" 2>&1; then
      if have "$check"; then
        ok "$name at $(command -v "$check")"
      else
        ok "$name installed. Open a new terminal window to get the $check command."
      fi
    else
      warn "$name failed, see $LOG"
      FAILED_AGENTS="$FAILED_AGENTS $name"
    fi
  done < "$AGENTS_FILE"

  if [ -n "${FAILED_AGENTS:-}" ]; then
    note "These agents did not install:$FAILED_AGENTS. The install command for each one is in config/agents.txt."
  fi

  # Every one of these needs an account or an API key, and each asks in
  # its own way. None of them can be set up without you.
  note "Sign in to each agent before you use it: claude, codex login, hermes setup."
}

# ===========================================================================
# 21. Configuration files
# ===========================================================================

stage_configs() {
  banner "21. Configuration files"

  # -- Ghostty ----------------------------------------------------------
  # This path is yours. omacosy never touches it. It is not
  # ~/.config/ghostty/config, which is a symlink into the clone.
  # Ghostty reads both and this one wins.
  GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
  info "Ghostty"
  install_file "$CFG/ghostty-config" "$GHOSTTY_DIR/config"

  # background-blur-radius was renamed to background-blur in newer
  # builds. An unknown key stops Ghostty at launch, so check and fix.
  GHOSTTY_BIN="/Applications/Ghostty.app/Contents/MacOS/ghostty"
  if [ "$DRY_RUN" != "1" ] && [ -x "$GHOSTTY_BIN" ]; then
    if "$GHOSTTY_BIN" +show-config >/dev/null 2>&1; then
      ok "Ghostty accepts the config"
    else
      sed -i '' 's/^background-blur-radius/background-blur/' "$GHOSTTY_DIR/config"
      if "$GHOSTTY_BIN" +show-config >/dev/null 2>&1; then
        ok "renamed background-blur-radius to background-blur for this build"
      else
        warn "Ghostty rejects the config. Check it with: $GHOSTTY_BIN +show-config"
      fi
    fi
  fi

  # -- starship ---------------------------------------------------------
  # ~/.config/starship.toml is a symlink into the clone and starship
  # reads exactly one file, with no overrides layer. So point
  # STARSHIP_CONFIG at your own copy instead, which ~/.zshrc.local
  # already does.
  info "starship prompt"
  install_file "$CFG/starship-mine.toml" "$HOME/.config/starship-mine.toml"

  # -- topgrade ---------------------------------------------------------
  info "topgrade"
  install_file "$CFG/topgrade.toml" "$HOME/.config/topgrade.toml"

  # -- uv ---------------------------------------------------------------
  info "uv"
  install_file "$CFG/uv.toml" "$HOME/.config/uv/uv.toml"

  # -- omacosy focus ring -----------------------------------------------
  # Two copies of borders.conf exist. The daemon reads the one in
  # ~/.config/omacosy. The copy inside the clone is only the source.
  BORDERS="$HOME/.config/omacosy/borders.conf"
  info "omacosy focus ring"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would set radius=%s in %s\n' "$RING_RADIUS" "$BORDERS"
  elif [ -f "$BORDERS" ]; then
    cp "$BORDERS" "${BORDERS}.bak-${STAMP}"
    sed -i '' -E "s/^radius=.*/radius=$RING_RADIUS/" "$BORDERS"
    ok "ring radius set to $RING_RADIUS"
    # The daemon watches the file. Killing it is the reliable way to
    # make it re-read; launchd starts it again at once.
    pkill -f omacosy-borders 2>/dev/null || true
  else
    warn "no $BORDERS yet. Run this stage again after omacosy is installed:"
    warn "  ./install.sh --only configs"
  fi
}

# ===========================================================================
# 22. Zed
# ===========================================================================

stage_zed() {
  banner "22. Zed"

  info "settings"
  install_file "$CFG/zed/settings.json" "$HOME/.config/zed/settings.json"

  # Zed loads every theme file in ~/.config/zed/themes. One file gives
  # you the whole Mixtape collection, with no extension to install.
  info "Mixtape themes"
  install_file "$CFG/zed/themes/mixtape.json" "$HOME/.config/zed/themes/mixtape.json"

  # The same theme as a dev extension, in case you want to edit it.
  # Zed: Extensions, then Install Dev Extension, then pick this folder.
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would copy the dev extension to ~/.config/zed/dev-extensions/mixtape\n'
  else
    mkdir -p "$HOME/.config/zed/dev-extensions"
    rm -rf "$HOME/.config/zed/dev-extensions/mixtape"
    cp -R "$CFG/zed/extension" "$HOME/.config/zed/dev-extensions/mixtape"
    ok "dev extension at ~/.config/zed/dev-extensions/mixtape"
  fi

  note "Zed settings name three fonts: Ioskeley Mono, Maple Mono and MesloLGS NF. The Brewfile installs all three."
}

# ===========================================================================
# 23. Zen Browser
# ===========================================================================

stage_zen() {
  banner "23. Zen Browser"

  [ -x "$LIB/apply-zen-profile.sh" ] || run chmod +x "$LIB/apply-zen-profile.sh"

  DRY_RUN="$DRY_RUN" bash "$LIB/apply-zen-profile.sh"
  rc=$?

  if [ "$rc" = "3" ]; then
    note "Zen has no profile yet. Start Zen once, quit it with Cmd-Q, then run: $LIB/apply-zen-profile.sh"
    return 0
  fi
  return "$rc"
}

# ===========================================================================
# Run
# ===========================================================================

run_stage() {
  local name="$1" fn
  fn="stage_$(printf '%s' "$name" | tr '-' '_')"
  stage_wanted "$name" || return 0
  if "$fn"; then
    return 0
  else
    FAILED="$FAILED $name"
    warn "stage '$name' did not finish cleanly"
    return 0
  fi
}

if [ "$DRY_RUN" != "1" ]; then
  mkdir -p "$LOG_DIR"
  : > "$LOG"
fi

for s in $ALL_STAGES; do
  run_stage "$s"
done

# ===========================================================================
# Summary
# ===========================================================================

banner "Done"

if [ "$DRY_RUN" = "1" ]; then
  echo
  echo "That was a dry run. Nothing changed."
  echo "Run it for real with:  ./install.sh"
  exit 0
fi

if [ -n "$FAILED" ]; then
  FIRST_FAILED="$(printf '%s' "$FAILED" | awk '{print $1}')"
  echo
  err "These stages did not finish:$FAILED"
  echo "  Run one again with:  ./install.sh --only $FIRST_FAILED"
  echo "  The log is at $LOG"
fi

if [ -n "$NOTES" ]; then
  echo
  printf '%sStill to do by hand:%s%s\n' "$C_BOLD" "$C_OFF" "$NOTES"
fi

cat <<EOF

${C_BOLD}Next${C_OFF}

  1. Log out and back in. This is what makes the new background PATH and
     the square corners reach every application.
  2. Open a new terminal window. Do not use 'exec zsh'.
  3. Check the result:

       ${HERE}/lib/verify.sh

The log is at $LOG
EOF
