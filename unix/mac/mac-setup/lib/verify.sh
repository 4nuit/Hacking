#!/usr/bin/env bash
#
# verify.sh — check that the setup worked.
#
#   ./lib/verify.sh
#
# It changes nothing. Every line is a pass, a warning or a failure.
# Run it in a NEW terminal window, not with `exec zsh`, so the shell
# has read the new config.

PASS=0
FAIL=0
WARN=0

if [ -t 1 ]; then
  G=$'\033[0;32m'; R=$'\033[0;31m'; Y=$'\033[0;33m'; B=$'\033[1m'; O=$'\033[0m'
else
  G=""; R=""; Y=""; B=""; O=""
fi

head()  { printf '\n%s%s%s\n' "$B" "$*" "$O"; }
pass()  { printf '%s  ok  %s%s\n' "$G" "$O" "$*"; PASS=$((PASS+1)); }
fail()  { printf '%sFAIL  %s%s\n' "$R" "$O" "$*"; FAIL=$((FAIL+1)); }
soft()  { printf '%s  ??  %s%s\n' "$Y" "$O" "$*"; WARN=$((WARN+1)); }

have()  { command -v "$1" >/dev/null 2>&1; }

check_cmd() {
  if have "$1"; then pass "$1 at $(command -v "$1")"; else fail "$1 not found"; fi
}

check_file() {
  if [ -f "$1" ]; then pass "$1"; else fail "missing $1"; fi
}

head "Base system"
if xcode-select -p >/dev/null 2>&1; then
  pass "command line tools at $(xcode-select -p)"
else
  fail "command line tools not installed"
fi

if [ "$(uname -m)" = "arm64" ]; then
  if /usr/bin/pgrep -q oahd 2>/dev/null; then pass "Rosetta 2 running"; else soft "Rosetta 2 not detected"; fi
else
  pass "Intel Mac, Rosetta not needed"
fi

check_cmd brew
check_cmd git
check_cmd mas
check_cmd topgrade

head "PATH for background services"
# This is what programs macOS starts get, not what your shell gets.
# Those two being different is the whole problem this line fixes.
LAUNCH_PATH="$(launchctl getenv PATH 2>/dev/null)"
case "$LAUNCH_PATH" in
  *homebrew/bin*|*/usr/local/bin*)
    pass "launchctl PATH holds Homebrew: $LAUNCH_PATH" ;;
  "")
    fail "launchctl PATH is not set. Run: ./install.sh --only launchd-path" ;;
  *)
    fail "launchctl PATH has no Homebrew: $LAUNCH_PATH" ;;
esac

head "Trackpad and click"
TP_TAP="$(defaults -currentHost read -g com.apple.mouse.tapBehavior 2>/dev/null)"
case "$TP_TAP" in
  1) pass "tap to click is on" ;;
  0) pass "tap to click is off" ;;
  *) soft "tap to click is not set" ;;
esac
TP_SCALE="$(defaults read -g com.apple.trackpad.scaling 2>/dev/null)"
[ -n "$TP_SCALE" ] && pass "tracking speed $TP_SCALE" || soft "tracking speed is not set"
TP_NAT="$(defaults read -g com.apple.swipescrolldirection 2>/dev/null)"
case "$TP_NAT" in
  1) pass "natural scrolling is on" ;;
  0) pass "natural scrolling is off" ;;
  *) soft "scroll direction is not set" ;;
esac

head "Window corners"
RADIUS="$(defaults read -g NSConvolutionOverride1 2>/dev/null)"
if [ -n "$RADIUS" ]; then
  pass "NSConvolutionOverride1 = $RADIUS"
else
  soft "NSConvolutionOverride1 is not set. On macOS 25 and older this is normal."
fi

head "Shell"
if [ -L "$HOME/.zshrc" ]; then
  fail "~/.zshrc is still a symlink. Installers writing to it will block omacosy updates."
elif [ -f "$HOME/.zshrc" ]; then
  pass "~/.zshrc is a real file"
  if grep -q 'omacosy/zsh/zshrc' "$HOME/.zshrc"; then
    pass "~/.zshrc sources omacosy"
  else
    fail "~/.zshrc does not source omacosy. Your shell loads none of its config."
  fi
else
  fail "no ~/.zshrc"
fi

check_file "$HOME/.zshrc.local"
for f in "$HOME/.zshrc" "$HOME/.zshrc.local"; do
  [ -f "$f" ] || continue
  if zsh -n "$f" 2>/dev/null; then pass "$(basename "$f") parses"; else fail "$(basename "$f") has a syntax error"; fi
done

for s in omacosy-safe-update omacosy-harvest-zshrc; do
  if [ -x "$HOME/.local/bin/$s" ]; then pass "$s is executable"; else fail "$HOME/.local/bin/$s missing or not executable"; fi
done

head "omacosy"
if [ -d "$HOME/.local/share/omacosy/.git" ]; then
  pass "clone at ~/.local/share/omacosy"
  # A modified config/omniwm/settings.toml is expected. omacosy-safe-update
  # writes your border color into it after every update, and resets it
  # again before the next one. Anything else in the list is not expected.
  DIRTY="$(git -C "$HOME/.local/share/omacosy" status --porcelain 2>/dev/null | grep -v 'config/omniwm/settings.toml' || true)"
  if [ -z "$DIRTY" ]; then
    pass "clone is clean, apart from settings.toml, which is by design"
  else
    fail "unexpected changes in the clone:"
    printf '%s\n' "$DIRTY" | sed 's/^/        /'
  fi
  # skip-worktree looks like the way to protect settings.toml and is a
  # trap. It works until upstream edits the same file, after which every
  # update stops with "Entry ... not uptodate. Cannot merge."
  FLAGGED="$(git -C "$HOME/.local/share/omacosy" ls-files -v 2>/dev/null | grep -c '^S' || true)"
  if [ "${FLAGGED:-0}" = "0" ]; then
    pass "no skip-worktree flags, which is what you want"
  else
    fail "$FLAGGED file(s) marked skip-worktree. Updates will stop with 'not uptodate'. Run: ./install.sh --only shell"
  fi
else
  soft "no omacosy clone. Skipped on purpose?"
fi

if [ -f "$HOME/.config/omacosy/borders.conf" ]; then
  R_NOW="$(grep -E '^radius=' "$HOME/.config/omacosy/borders.conf" | head -1)"
  pass "focus ring: ${R_NOW:-not set}"
else
  soft "no ~/.config/omacosy/borders.conf"
fi

head "Node"
check_cmd fnm
check_cmd node
check_cmd pnpm
if have pnpm; then
  PNPM_V="$(pnpm --version 2>/dev/null)"
  case "$PNPM_V" in
    9.*) fail "pnpm $PNPM_V. This is fnm's bundled copy. pnpm must load after fnm in ~/.zshrc.local." ;;
    "")  fail "pnpm did not report a version" ;;
    *)   pass "pnpm $PNPM_V" ;;
  esac
  # which -a shows every match on PATH, in order. This is the check that
  # catches the fnm and pnpm ordering problem.
  COUNT="$(which -a pnpm 2>/dev/null | wc -l | tr -d ' ')"
  [ "$COUNT" -gt 1 ] && soft "pnpm resolves to $COUNT places. Run 'which -a pnpm' and check the first one is right."
fi
[ -d "$HOME/Library/pnpm" ] && pass "PNPM_HOME directory exists" || soft "no ~/Library/pnpm yet"
check_file "$HOME/Library/Preferences/pnpm/config.yaml"
check_file "$HOME/.npmrc"

head "Python"
check_cmd uv
check_file "$HOME/.config/uv/uv.toml"
if have uv; then
  N="$(uv python list --only-installed 2>/dev/null | wc -l | tr -d ' ')"
  [ "$N" -gt 0 ] && pass "$N uv-managed Python builds" || soft "no uv-managed Python found"
fi

head "Databases"
check_cmd sqlite3
if have sqlite3; then
  case "$(command -v sqlite3)" in
    /usr/bin/sqlite3) soft "sqlite3 is the macOS copy. The Homebrew one is newer. Open a NEW terminal window." ;;
    *) pass "sqlite3 $(sqlite3 --version 2>/dev/null | awk '{print $1}')" ;;
  esac
fi
check_cmd mysql
check_cmd psql
if have brew; then
  RUNNING="$(brew services list 2>/dev/null | awk '$2=="started"{print $1}' | tr '\n' ' ')"
  [ -n "$RUNNING" ] && pass "running services: $RUNNING" || soft "no Homebrew services running. DBngin may be handling the servers instead."
fi

head "Other toolchains"
if [ -x "$HOME/.cargo/bin/rustc" ] || have rustc; then
  pass "rust: $(rustc --version 2>/dev/null || "$HOME/.cargo/bin/rustc" --version)"
else
  fail "rust not found"
fi
check_cmd go

head "Git identity"
GN="$(git config --global user.name 2>/dev/null)"
GE="$(git config --global user.email 2>/dev/null)"
if [ -n "$GN" ] && [ -n "$GE" ]; then
  pass "$GN <$GE>"
else
  fail "no git identity. Commits will be refused. Run: ./lib/setup-git.sh"
fi
if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
  pass "SSH key at ~/.ssh/id_ed25519"
else
  soft "no SSH key at ~/.ssh/id_ed25519"
fi

head "Neovim"
check_cmd nvim
if [ -f "$HOME/.config/nvim/lua/config/lazy.lua" ]; then
  pass "LazyVim at ~/.config/nvim"
else
  soft "no LazyVim starter at ~/.config/nvim"
fi
if [ -d "$HOME/.local/share/nvim/lazy" ]; then
  pass "$(find "$HOME/.local/share/nvim/lazy" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ') plugins downloaded"
else
  soft "no plugins yet. Start nvim once, or run: nvim --headless '+Lazy! sync' +qa"
fi

head "LLM agent harnesses"
for a in claude codex hermes; do
  if have "$a"; then pass "$a at $(command -v "$a")"; else soft "$a not found"; fi
done

head "Extra developer tools"
MISSING=""
for c in gh jq yq fd sd direnv just watchexec shellcheck shfmt ffmpeg pandoc tldr delta; do
  have "$c" || MISSING="$MISSING $c"
done
if [ -z "$MISSING" ]; then
  pass "all extra tools present"
else
  soft "not installed:$MISSING"
fi

head "Configuration files"
check_file "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
check_file "$HOME/.config/starship-mine.toml"
check_file "$HOME/.config/topgrade.toml"
if [ -f "$HOME/.config/topgrade.toml" ]; then
  if grep -q 'omacosy-safe-update' "$HOME/.config/topgrade.toml"; then
    pass "topgrade calls omacosy-safe-update"
  else
    fail "topgrade calls omacosy-update directly. Updates will overwrite your settings."
  fi
fi
if [ "${STARSHIP_CONFIG:-}" = "$HOME/.config/starship-mine.toml" ]; then
  pass "STARSHIP_CONFIG points at your own copy"
else
  soft "STARSHIP_CONFIG is '${STARSHIP_CONFIG:-unset}'. Open a NEW terminal window and run this again."
fi

GHOSTTY_BIN="/Applications/Ghostty.app/Contents/MacOS/ghostty"
if [ -x "$GHOSTTY_BIN" ]; then
  if "$GHOSTTY_BIN" +show-config >/dev/null 2>&1; then
    pass "Ghostty accepts its config"
  else
    fail "Ghostty rejects its config. Run: $GHOSTTY_BIN +show-config"
  fi
fi

head "Zed"
check_file "$HOME/.config/zed/settings.json"
check_file "$HOME/.config/zed/themes/mixtape.json"

head "Zen Browser"
ZEN_ROOT="$HOME/Library/Application Support/zen"
FOUND=0
if [ -d "$ZEN_ROOT/Profiles" ]; then
  for p in "$ZEN_ROOT"/Profiles/*/; do
    [ -d "$p" ] || continue
    if [ -f "$p/chrome/userChrome.css" ]; then
      pass "userChrome.css in $(basename "$p")"
      FOUND=1
    fi
    if [ -f "$p/user.js" ]; then
      pass "user.js in $(basename "$p")"
    fi
  done
fi
if [ "$FOUND" = "0" ]; then
  soft "no userChrome.css found. Start Zen once, quit with Cmd-Q, then run lib/apply-zen-profile.sh"
fi

head "Result"
printf '  %s%s passed%s   %s%s to check%s   %s%s failed%s\n\n' \
  "$G" "$PASS" "$O" "$Y" "$WARN" "$O" "$R" "$FAIL" "$O"

if [ "$FAIL" -gt 0 ]; then
  echo "  Fix the failures above, then run this again."
  exit 1
fi
echo "  Everything that can be checked from here is in place."
exit 0
