#!/usr/bin/env bash
#
# report.sh — put everything needed to diagnose this Mac into one file.
#
#   ./lib/report.sh
#
# It writes ~/Desktop/mac-setup-report.txt. Send that file to whoever
# set this up. It reads only. It changes nothing.
#
# WHAT IT DOES NOT COLLECT
#   No file contents beyond the install log, no keys, no tokens, no
#   passwords, no browsing data, no email address. The git identity is
#   included because it is already public in every commit. Read the file
#   before you send it if you would rather check.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$HOME/Desktop/mac-setup-report.txt"
[ -d "$HOME/Desktop" ] || OUT="$HOME/mac-setup-report.txt"

section() { printf '\n\n========== %s ==========\n\n' "$*"; }

{
  echo "mac-setup report"
  echo "generated $(date)"

  section "Machine"
  sw_vers 2>/dev/null
  echo "arch: $(uname -m)"
  echo "shell: ${SHELL:-unknown}"
  echo "uptime:$(uptime 2>/dev/null)"
  df -h / 2>/dev/null | tail -2

  section "verify.sh"
  # Runs in a non-interactive shell, so anything that depends on the
  # shell config having been loaded will read as unset. That is
  # expected and is noted in the output.
  bash "$HERE/verify.sh" 2>&1 || true

  section "Which stages failed"
  LOGDIR="$HOME/.local/state/mac-setup"
  if [ -d "$LOGDIR" ]; then
    ls -1t "$LOGDIR" | head -5
  else
    echo "no log directory at $LOGDIR"
  fi

  section "Last install log, final 400 lines"
  LATEST="$(ls -1t "$LOGDIR"/install-*.log 2>/dev/null | head -1)"
  if [ -n "${LATEST:-}" ]; then
    echo "file: $LATEST"
    echo
    tail -400 "$LATEST"
  else
    echo "no install log found"
  fi

  section "Homebrew"
  if command -v brew >/dev/null 2>&1; then
    brew --version 2>&1 | head -2
    echo
    echo "--- formulae ---"
    brew list --formula 2>/dev/null | tr '\n' ' '
    echo
    echo
    echo "--- casks ---"
    brew list --cask 2>/dev/null | tr '\n' ' '
    echo
    echo
    echo "--- services ---"
    brew services list 2>/dev/null
    echo
    echo "--- doctor ---"
    brew doctor 2>&1 | head -40
  else
    echo "brew is not on PATH"
  fi

  section "PATH"
  echo "shell PATH:"
  printf '%s\n' "$PATH" | tr ':' '\n' | sed 's/^/  /'
  echo
  echo "launchd PATH, which is what background services get:"
  launchctl getenv PATH 2>/dev/null | sed 's/^/  /' || echo "  (not set)"

  section "Shell config"
  echo "--- ls -l ~/.zshrc ~/.zshrc.local ---"
  ls -l "$HOME/.zshrc" "$HOME/.zshrc.local" 2>&1
  echo
  echo "--- zsh -n, silence is good ---"
  zsh -n "$HOME/.zshrc" 2>&1 && echo "  .zshrc parses"
  zsh -n "$HOME/.zshrc.local" 2>&1 && echo "  .zshrc.local parses"
  echo
  echo "--- a login shell, first 40 lines of output ---"
  zsh -l -i -c 'exit' 2>&1 | head -40

  section "omacosy"
  REPO="$HOME/.local/share/omacosy"
  if [ -d "$REPO/.git" ]; then
    echo "--- git status ---"
    git -C "$REPO" status --short 2>&1
    echo
    echo "--- branch and last commit ---"
    git -C "$REPO" log -1 --oneline 2>&1
    git -C "$REPO" rev-parse --abbrev-ref HEAD 2>&1
    echo
    echo "--- skip-worktree flags, none is correct ---"
    git -C "$REPO" ls-files -v 2>/dev/null | grep '^S' || echo "  none"
    echo
    echo "--- agents ---"
    launchctl list 2>/dev/null | grep -i omacosy || echo "  no omacosy agents running"
    echo
    echo "--- processes ---"
    pgrep -fl "omacosy|AeroSpace|karabiner" 2>/dev/null || echo "  none"
  else
    echo "no clone at $REPO"
  fi

  section "Toolchains"
  for c in git node pnpm fnm python3 uv rustc go nvim claude codex hermes psql mysql sqlite3; do
    if command -v "$c" >/dev/null 2>&1; then
      printf '%-10s %s\n' "$c" "$(command -v "$c")"
    else
      printf '%-10s %s\n' "$c" "NOT FOUND"
    fi
  done
  echo
  echo "--- which -a pnpm, the fnm ordering check ---"
  which -a pnpm 2>/dev/null || echo "  pnpm not found"

  section "Trackpad and click"
  for k in com.apple.trackpad.scaling com.apple.swipescrolldirection com.apple.trackpad.forceClick; do
    printf '%-45s %s\n' "$k" "$(defaults read -g "$k" 2>/dev/null || echo '(not set)')"
  done
  printf '%-45s %s\n' "com.apple.mouse.tapBehavior (per machine)" \
    "$(defaults -currentHost read -g com.apple.mouse.tapBehavior 2>/dev/null || echo '(not set)')"
  printf '%-45s %s\n' "NSConvolutionOverride1" \
    "$(defaults read -g NSConvolutionOverride1 2>/dev/null || echo '(not set)')"

  section "End"
  echo "nothing follows"
} > "$OUT" 2>&1

echo
echo "Report written to:"
echo "  $OUT"
echo
echo "Send that one file. Read it first if you want to check what is in it."
echo "It holds no keys, no passwords and no personal files."
