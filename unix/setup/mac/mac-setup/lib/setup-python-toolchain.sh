#!/usr/bin/env bash
#
# setup-python-toolchain.sh
#
# Installs and configures uv and Python on a new macOS machine.
# The defaults reproduce the state found on the source machine.
#
# Usage:
#   bash setup-python-toolchain.sh
#   INSTALL_TOOLS=1 bash setup-python-toolchain.sh
#   DRY_RUN=1 bash setup-python-toolchain.sh
#
# The script is idempotent. You can run it more than once.

set -euo pipefail

# ---------------------------------------------------------------------------
# Settings. Change these values if you want a different setup.
# ---------------------------------------------------------------------------

# uv-managed Python. One entry per minor version.
UV_PYTHON_MINORS="${UV_PYTHON_MINORS:-3.8 3.9 3.10 3.11 3.12 3.13}"

# uv-managed Python at an exact patch level. The source machine holds these in
# addition to the latest patch of the same minor. Projects that pin an exact
# version need them. Set to "" to skip.
UV_PYTHON_EXACT="${UV_PYTHON_EXACT:-3.9.22 3.10.17 3.11.12 3.12.10}"

# Homebrew Python formulae. The source machine has these three.
BREW_PYTHONS="${BREW_PYTHONS:-python@3.12 python@3.13 python@3.14}"

# Global `uv python pin` value. The source machine has no global pin, so this
# is empty by default. Set it to a version such as 3.13 if you want one.
GLOBAL_PYTHON_PIN="${GLOBAL_PYTHON_PIN:-}"

# Refuse to install any distribution published less than this long ago.
UV_EXCLUDE_NEWER="${UV_EXCLUDE_NEWER:-7 days}"

# Write `python-preference` to uv.toml. The source machine does not set it, so
# this is empty and the key is left out. Values: managed, only-managed, system.
PYTHON_PREFERENCE="${PYTHON_PREFERENCE:-}"

# Write a matching age gate to the pip config. The source machine has no
# pip.conf. This adds one. Set to 0 to skip.
CONFIGURE_PIP="${CONFIGURE_PIP:-1}"

# uv tools from the source machine. Off by default.
UV_TOOLS="${UV_TOOLS:-ruff pyrefly git-filter-repo marker-pdf browser-use}"
INSTALL_TOOLS="${INSTALL_TOOLS:-0}"

DRY_RUN="${DRY_RUN:-0}"

UV_CONFIG_DIR="$HOME/.config/uv"
UV_CONFIG_FILE="$UV_CONFIG_DIR/uv.toml"
PIP_CONFIG_DIR="$HOME/.config/pip"
PIP_CONFIG_FILE="$PIP_CONFIG_DIR/pip.conf"
# Which file the shell lines go into.
#
# ADAPTED FOR THIS PACKAGE: the default is ~/.zshrc.local, not ~/.zshrc.
# Under omacosy, ~/.zshrc holds one source line and nothing else. Your
# own settings live in ~/.zshrc.local. Override with SETUP_ZSHRC=...
ZSHRC="${SETUP_ZSHRC:-${ZDOTDIR:-$HOME}/.zshrc.local}"
MIN_UV_VERSION="0.9.17"

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

# Returns 0 if $1 is greater than or equal to $2.
version_ge() {
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

# ---------------------------------------------------------------------------
# 0. Checks
# ---------------------------------------------------------------------------

[ "$(uname -s)" = "Darwin" ] || die "This script runs on macOS only."
[ "$(id -u)" -ne 0 ] || die "Do not run this script with sudo."

info "Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
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
# 1. Install uv and the Homebrew Python versions
# ---------------------------------------------------------------------------

info "Installing uv"
if brew list --formula uv >/dev/null 2>&1; then
  ok "uv is already installed"
else
  run brew install uv
fi

if [ "$DRY_RUN" != "1" ]; then
  UV_VERSION="$(uv --version | awk '{print $2}')"
  ok "uv $UV_VERSION"
  if ! version_ge "$UV_VERSION" "$MIN_UV_VERSION"; then
    die "uv $UV_VERSION is too old. Relative exclude-newer durations need $MIN_UV_VERSION or later. Run: brew upgrade uv"
  fi
fi

if [ -n "$BREW_PYTHONS" ]; then
  info "Installing Homebrew Python: $BREW_PYTHONS"
  for f in $BREW_PYTHONS; do
    if brew list --formula "$f" >/dev/null 2>&1; then
      ok "$f is already installed"
    else
      run brew install "$f"
    fi
  done
fi

# ---------------------------------------------------------------------------
# 2. uv user config
# ---------------------------------------------------------------------------
# uv reads user-level settings from ~/.config/uv/uv.toml on macOS, not from
# ~/Library/Preferences. A project pyproject.toml or uv.toml overrides this file.

info "Writing the uv user config"
backup_file "$UV_CONFIG_FILE"
if [ "$DRY_RUN" = "1" ]; then
  printf '  would write %s\n' "$UV_CONFIG_FILE"
else
  mkdir -p "$UV_CONFIG_DIR"
  {
    echo "# Ignore any distribution published less than this long ago."
    echo "exclude-newer = \"${UV_EXCLUDE_NEWER}\""
    if [ -n "$PYTHON_PREFERENCE" ]; then
      echo ""
      echo "# Which Python interpreters uv is allowed to use."
      echo "python-preference = \"${PYTHON_PREFERENCE}\""
    fi
    echo ""
    echo "# To exempt a single package from the age gate, add a table like this:"
    echo "# [exclude-newer-package]"
    echo "# my-internal-package = false"
  } > "$UV_CONFIG_FILE"
  ok "wrote $UV_CONFIG_FILE"
fi

# ---------------------------------------------------------------------------
# 3. pip config
# ---------------------------------------------------------------------------
# pip has no minimum age setting. It has an upload time cutoff instead.
# Relative durations such as P7D need pip 26.1 or later.

if [ "$CONFIGURE_PIP" = "1" ]; then
  info "Writing the pip config"
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would set uploaded-prior-to in %s\n' "$PIP_CONFIG_FILE"
  elif [ -f "$PIP_CONFIG_FILE" ] && ! grep -q 'uploaded-prior-to' "$PIP_CONFIG_FILE"; then
    warn "$PIP_CONFIG_FILE exists. Add 'uploaded-prior-to = P7D' under [install] by hand."
  else
    backup_file "$PIP_CONFIG_FILE"
    mkdir -p "$PIP_CONFIG_DIR"
    cat > "$PIP_CONFIG_FILE" <<'EOF'
[install]
# Ignore any distribution uploaded in the last 7 days. Needs pip 26.1 or later.
uploaded-prior-to = P7D
EOF
    ok "wrote $PIP_CONFIG_FILE"
  fi
else
  info "Skipping the pip config"
fi

# ---------------------------------------------------------------------------
# 4. Install uv-managed Python
# ---------------------------------------------------------------------------

info "Installing uv-managed Python"
for v in $UV_PYTHON_MINORS $UV_PYTHON_EXACT; do
  if [ "$DRY_RUN" = "1" ]; then
    printf '  would run: uv python install %s\n' "$v"
  else
    uv python install "$v"
    ok "python $v"
  fi
done

if [ -n "$GLOBAL_PYTHON_PIN" ]; then
  info "Setting the global pin to $GLOBAL_PYTHON_PIN"
  run uv python pin --global "$GLOBAL_PYTHON_PIN"
else
  info "No global pin. python3 comes from PATH."
fi

# ---------------------------------------------------------------------------
# 5. Shell setup
# ---------------------------------------------------------------------------
# uv installs tool binaries to ~/.local/bin. That directory must be on PATH.

info "Configuring the shell for uv"
if [ "$DRY_RUN" = "1" ]; then
  printf '  would run: uv tool update-shell\n'
elif grep -q '\.local/bin' "$ZSHRC" 2>/dev/null; then
  # ADAPTED FOR THIS PACKAGE: ~/.zshrc.local already puts ~/.local/bin
  # on PATH. `uv tool update-shell` writes to ~/.zshrc, which under
  # omacosy holds only the source line, so let it alone.
  ok "~/.local/bin is already on PATH through $ZSHRC"
else
  uv tool update-shell || warn "uv tool update-shell failed. Add ~/.local/bin to PATH by hand."
fi

append_once "$ZSHRC" '# uv completions'
append_once "$ZSHRC" 'eval "$(uv generate-shell-completion zsh)"'
append_once "$ZSHRC" 'eval "$(uvx --generate-shell-completion zsh)"'

# ---------------------------------------------------------------------------
# 6. uv tools
# ---------------------------------------------------------------------------

if [ "$INSTALL_TOOLS" = "1" ]; then
  info "Installing uv tools: $UV_TOOLS"
  for t in $UV_TOOLS; do
    if [ "$DRY_RUN" = "1" ]; then
      printf '  would run: uv tool install %s\n' "$t"
    else
      uv tool install "$t" || warn "uv tool install $t failed"
    fi
  done
else
  info "Skipping uv tools. Run with INSTALL_TOOLS=1 to install them."
fi

# ---------------------------------------------------------------------------
# 7. Verify
# ---------------------------------------------------------------------------

if [ "$DRY_RUN" = "1" ]; then
  info "Dry run finished. Nothing changed."
  exit 0
fi

info "Result"
printf '\n--- %s ---\n' "$UV_CONFIG_FILE"
cat "$UV_CONFIG_FILE"
printf '\n--- uv-managed python ---\n'
uv python list --only-installed --managed-python 2>/dev/null \
  || uv python list --only-installed || true
printf '\n--- uv directories ---\n'
uv python dir; uv tool dir; uv cache dir

cat <<'EOF'

Done. Open a new terminal, or run: exec zsh

Two things the script cannot do for you:

1. The python.org framework build at /Library/Frameworks/Python.framework is
   not a Homebrew package. Download the installer from https://python.org if
   you want it back. You probably do not need it, because uv and Homebrew
   both provide 3.12.

2. These files in ~/.local/bin are not uv tools: claude, cua-driver, hermes,
   hermes-acp, hermes-agent, jan, unsloth, omacosy-*, theme-*. Copy them from
   the old machine, or reinstall them from wherever they came from.

Note: uv is installed by Homebrew, so `uv self update` does not work.
Use `brew upgrade uv` instead.
EOF
