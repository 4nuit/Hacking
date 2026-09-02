#!/usr/bin/env bash
#
# setup-node-toolchain.sh
#
# Installs and configures fnm and pnpm on a new macOS machine.
# Reproduces the configuration of the previous machine.
# Installs no npm packages.
#
# Usage:
#   bash setup-node-toolchain.sh
#   NODE_VERSIONS="20 22 24" DEFAULT_NODE_VERSION=22 bash setup-node-toolchain.sh
#   DRY_RUN=1 bash setup-node-toolchain.sh
#
# The script is idempotent. You can run it more than once.

set -euo pipefail

# ---------------------------------------------------------------------------
# Settings. Change these values if you want a different setup.
# ---------------------------------------------------------------------------

# Space separated list. Each entry can be a major ("22"), an exact version
# ("24.20.0"), or "lts" for the latest long term support release.
NODE_VERSIONS="${NODE_VERSIONS:-22 24}"
# The version that new shells use. It must match one entry above.
DEFAULT_NODE_VERSION="${DEFAULT_NODE_VERSION:-24}"
PNPM_MIN_RELEASE_AGE_MINUTES=10080      # 7 days, applies to pnpm
NPM_MIN_RELEASE_AGE_DAYS=7              # 7 days, applies to npm
IGNORE_SCRIPTS=true                     # blocks lifecycle scripts
DRY_RUN="${DRY_RUN:-0}"

PNPM_CONFIG_DIR="$HOME/Library/Preferences/pnpm"
PNPM_CONFIG_FILE="$PNPM_CONFIG_DIR/config.yaml"
NPMRC_FILE="$HOME/.npmrc"
# Which file the shell lines go into.
#
# ADAPTED FOR THIS PACKAGE: the default is ~/.zshrc.local, not ~/.zshrc.
# Under omacosy, ~/.zshrc holds one source line and nothing else. Your
# own settings live in ~/.zshrc.local. Override with SETUP_ZSHRC=...
ZSHRC="${SETUP_ZSHRC:-${ZDOTDIR:-$HOME}/.zshrc.local}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

info()  { printf '\033[0;34m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[0;32m  ok\033[0m %s\n' "$*"; }
warn()  { printf '\033[0;33m  !!\033[0m %s\n' "$*" >&2; }
die()   { printf '\033[0;31merror\033[0m %s\n' "$*" >&2; exit 1; }

run() {
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: %s\n' "$*"
  else
    "$@"
  fi
}

# Appends a line to a file only if the line is not already there.
append_once() {
  local file="$1" line="$2"
  if [ -f "$file" ] && grep -Fqx "$line" "$file"; then
    ok "line already in $(basename "$file")"
    return 0
  fi
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would append to %s: %s\n' "$file" "$line"
    return 0
  fi
  mkdir -p "$(dirname "$file")"
  printf '\n%s\n' "$line" >> "$file"
  ok "added line to $file"
}

backup_file() {
  local file="$1"
  [ -f "$file" ] || return 0
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  run cp "$file" "${file}.bak-${stamp}"
  ok "backed up $file"
}

# ---------------------------------------------------------------------------
# 0. Checks
# ---------------------------------------------------------------------------

[ "$(uname -s)" = "Darwin" ] || die "This script runs on macOS only."
[ "$(id -u)" -ne 0 ] || die "Do not run this script with sudo."

info "Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  # Homebrew is not on PATH. Try the two standard locations.
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      eval "$("$candidate" shellenv)"
      break
    fi
  done
fi
command -v brew >/dev/null 2>&1 || die "Homebrew is missing. Install it from https://brew.sh first."
ok "brew at $(command -v brew)"

# ---------------------------------------------------------------------------
# 1. Install fnm and pnpm
# ---------------------------------------------------------------------------

info "Installing fnm and pnpm"
for pkg in fnm pnpm; do
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    ok "$pkg is already installed"
  else
    run brew install "$pkg"
  fi
done

# ---------------------------------------------------------------------------
# 2. Shell setup for fnm
# ---------------------------------------------------------------------------
# fnm has no config file. It reads environment variables that come from
# `fnm env`. The line below sets them and turns on automatic version switching
# when you change directory.

info "Configuring the shell for fnm"
FNM_LINE='eval "$(fnm env --use-on-cd --shell zsh)"'
if grep -Eq 'fnm env|plugins=.*\bfnm\b' "$ZSHRC" 2>/dev/null; then
  ok "fnm is already set up in $ZSHRC"
else
  append_once "$ZSHRC" "# fnm"
  append_once "$ZSHRC" "$FNM_LINE"
fi

# ---------------------------------------------------------------------------
# 3. Install Node
# ---------------------------------------------------------------------------

info "Installing Node: $NODE_VERSIONS"
if [ "$DRY_RUN" = "1" ]; then
  for v in $NODE_VERSIONS; do
    printf '  would run: fnm install %s\n' "$v"
  done
  printf '  would run: fnm default %s\n' "$DEFAULT_NODE_VERSION"
else
  eval "$(fnm env --shell bash)"
  for v in $NODE_VERSIONS; do
    if [ "$v" = "lts" ]; then
      fnm install --lts
    else
      fnm install "$v"
    fi
    ok "installed $v"
  done

  if [ "$DEFAULT_NODE_VERSION" = "lts" ]; then
    fnm default lts-latest
  else
    fnm default "$DEFAULT_NODE_VERSION"
  fi
  fnm use default >/dev/null 2>&1 || true
  ok "default is node $(node --version 2>/dev/null || echo '(new shell needed)')"
fi

# ---------------------------------------------------------------------------
# 4. pnpm global config
# ---------------------------------------------------------------------------
# pnpm 10 and later read only auth and registry settings from .npmrc files.
# Every other setting lives in this YAML file.

info "Writing the pnpm global config"
backup_file "$PNPM_CONFIG_FILE"
if [ "$DRY_RUN" = "1" ]; then
  printf '  would write %s\n' "$PNPM_CONFIG_FILE"
else
  mkdir -p "$PNPM_CONFIG_DIR"
  cat > "$PNPM_CONFIG_FILE" <<EOF
# Wait this many minutes after a version is published before it is installable.
minimumReleaseAge: ${PNPM_MIN_RELEASE_AGE_MINUTES}
# Do not run install and postinstall scripts of dependencies.
ignoreScripts: ${IGNORE_SCRIPTS}
EOF
  ok "wrote $PNPM_CONFIG_FILE"
fi

# ---------------------------------------------------------------------------
# 5. npm user config
# ---------------------------------------------------------------------------
# This file can hold auth tokens. The script keeps every line that is not one
# of the two settings it manages.

info "Updating $NPMRC_FILE"
backup_file "$NPMRC_FILE"
if [ "$DRY_RUN" = "1" ]; then
  printf '  would set ignore-scripts and min-release-age in %s\n' "$NPMRC_FILE"
else
  tmp="$(mktemp)"
  if [ -f "$NPMRC_FILE" ]; then
    grep -Ev '^[[:space:]]*(ignore-scripts|min-release-age)[[:space:]]*=' "$NPMRC_FILE" > "$tmp" || true
  fi
  {
    printf 'ignore-scripts=%s\n' "$IGNORE_SCRIPTS"
    printf 'min-release-age=%s\n' "$NPM_MIN_RELEASE_AGE_DAYS"
  } >> "$tmp"
  mv "$tmp" "$NPMRC_FILE"
  chmod 600 "$NPMRC_FILE"
  ok "wrote $NPMRC_FILE"
fi

# ---------------------------------------------------------------------------
# 6. pnpm home directory and shell setup
# ---------------------------------------------------------------------------
# `pnpm setup` creates PNPM_HOME at ~/Library/pnpm and adds it to PATH.
# Global packages install there.

info "Running pnpm setup"
if [ "$DRY_RUN" = "1" ]; then
  printf '  would run: pnpm setup\n'
elif grep -q 'PNPM_HOME' "$ZSHRC" 2>/dev/null; then
  # ADAPTED FOR THIS PACKAGE: ~/.zshrc.local already exports PNPM_HOME
  # and puts it on PATH, in the correct place relative to fnm. Running
  # `pnpm setup` here would append a second copy of those lines in the
  # wrong order, which brings back the pnpm 9 problem. Create the
  # directory instead, which is the only other thing `pnpm setup` does.
  mkdir -p "$HOME/Library/pnpm/bin"
  ok "PNPM_HOME is already in $ZSHRC, created $HOME/Library/pnpm"
else
  SHELL="$(command -v zsh)" pnpm setup || warn "pnpm setup failed. Run it by hand."
fi

# ---------------------------------------------------------------------------
# 7. Verify
# ---------------------------------------------------------------------------

if [ "$DRY_RUN" = "1" ]; then
  info "Dry run finished. Nothing changed."
  exit 0
fi

info "Result"
printf '\n--- pnpm config list ---\n'
pnpm config list || true
printf '\n--- fnm env ---\n'
fnm env || true
printf '\n--- installed node versions ---\n'
fnm ls || true

cat <<'EOF'

Done. Open a new terminal, or run: exec zsh

Then check these values:
  pnpm config list     # expect minimumReleaseAge and ignoreScripts
  node --version
  echo "$PNPM_HOME"    # expect ~/Library/pnpm

The script wrote backups of any file it replaced, with a .bak-<timestamp> suffix.
EOF
