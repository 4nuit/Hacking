#!/usr/bin/env bash
#
# setup-git.sh — ask for your git identity and make an SSH key.
#
#   ./lib/setup-git.sh
#
# install.sh runs this early, so all the typing happens at the start.
# You can also run it alone at any time.
#
# It asks for two things: your name and your email address. Git puts
# both into every commit you make. A repository with no identity set
# refuses to commit at all.
#
# It changes nothing outside ~/.gitconfig, ~/.gitignore_global and
# ~/.ssh. It never touches a project.

set -uo pipefail

DRY_RUN="${DRY_RUN:-0}"
STAMP="$(date +%Y%m%d-%H%M%S)"

if [ -t 1 ]; then
  B=$'\033[0;34m'; G=$'\033[0;32m'; Y=$'\033[0;33m'; R=$'\033[0;31m'; BD=$'\033[1m'; O=$'\033[0m'
else
  B=""; G=""; Y=""; R=""; BD=""; O=""
fi
info() { printf '%s==>%s %s\n' "$B" "$O" "$*"; }
ok()   { printf '%s  ok%s %s\n' "$G" "$O" "$*"; }
warn() { printf '%s  !!%s %s\n' "$Y" "$O" "$*" >&2; }
err()  { printf '%serror%s %s\n' "$R" "$O" "$*" >&2; }

command -v git >/dev/null 2>&1 || { err "git is not installed yet."; exit 1; }

# ---------------------------------------------------------------------------
# Is there anything to do?
# ---------------------------------------------------------------------------

CUR_NAME="$(git config --global user.name 2>/dev/null || true)"
CUR_EMAIL="$(git config --global user.email 2>/dev/null || true)"
KEY="$HOME/.ssh/id_ed25519"

if [ -n "$CUR_NAME" ] && [ -n "$CUR_EMAIL" ] && [ -f "$KEY" ]; then
  ok "already set up: $CUR_NAME <$CUR_EMAIL>, key at $KEY"
  exit 0
fi

if [ "$DRY_RUN" = "1" ]; then
  printf '  would ask for your name and email, then set them in ~/.gitconfig\n'
  printf '  would make an SSH key at %s\n' "$KEY"
  exit 0
fi

# Nothing here can run without someone to answer. A script started by
# another script, or by a scheduler, has no terminal to read from.
if [ ! -t 0 ]; then
  warn "No terminal to ask on. Run this yourself later:"
  warn "  $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup-git.sh"
  exit 4
fi

# ---------------------------------------------------------------------------
# Ask
# ---------------------------------------------------------------------------

cat <<EOF

${BD}Git needs to know who you are.${O}

Your name and email go into every commit you make, and they are public
in any repository you push. Use the same email as your GitHub account,
or GitHub's no-reply address if you would rather not publish yours.
The no-reply address looks like:

  12345678+yourname@users.noreply.github.com

You can find it in GitHub, under Settings, Emails.

EOF

ask_name() {
  while :; do
    printf 'Your name: '
    IFS= read -r NAME
    NAME="$(printf '%s' "$NAME" | sed -e 's/^ *//' -e 's/ *$//')"
    [ -n "$NAME" ] && return 0
    warn "The name cannot be empty."
  done
}

ask_email() {
  while :; do
    printf 'Your email: '
    IFS= read -r EMAIL
    EMAIL="$(printf '%s' "$EMAIL" | sed -e 's/^ *//' -e 's/ *$//')"
    case "$EMAIL" in
      "")        warn "The email cannot be empty." ;;
      *" "*)     warn "An email address holds no spaces." ;;
      *@*.*)     return 0 ;;
      *)         warn "That does not look like an email address." ;;
    esac
  done
}

if [ -n "$CUR_NAME" ]; then
  ok "name already set: $CUR_NAME"
  NAME="$CUR_NAME"
else
  ask_name
fi

if [ -n "$CUR_EMAIL" ]; then
  ok "email already set: $CUR_EMAIL"
  EMAIL="$CUR_EMAIL"
else
  ask_email
fi

printf '\n  %s <%s>\n\n' "$NAME" "$EMAIL"
printf 'Is that right? [Y/n] '
IFS= read -r CONFIRM
case "$CONFIRM" in
  [Nn]*) echo "Nothing changed. Run this script again when you are ready."; exit 0 ;;
esac

# ---------------------------------------------------------------------------
# Write the settings
# ---------------------------------------------------------------------------

info "Writing ~/.gitconfig"
[ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "$HOME/.gitconfig.bak-$STAMP"

git config --global user.name  "$NAME"
git config --global user.email "$EMAIL"
ok "identity set"

# A few settings that are not personal, only sensible. Each one is
# printed, so nothing here is hidden from you.
#
#   init.defaultBranch      new repositories start on main, and git
#                           stops warning that it picked one for you
#   push.autoSetupRemote    `git push` on a new branch works without
#                           --set-upstream
#   pull.rebase false       `git pull` merges, which is the safe
#                           default when you are not sure
#   credential.helper       HTTPS passwords go in the macOS keychain
#   core.excludesfile       files ignored in every repository
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true
git config --global pull.rebase false
git config --global credential.helper osxkeychain
git config --global core.excludesfile "$HOME/.gitignore_global"
ok "init.defaultBranch = main"
ok "push.autoSetupRemote = true"
ok "pull.rebase = false"
ok "credential.helper = osxkeychain"
ok "core.excludesfile = ~/.gitignore_global"

# git-delta comes from Brewfile.extras. Only wire it up if it is there.
if command -v delta >/dev/null 2>&1; then
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  ok "delta is your diff viewer. n and N move between files."
fi

if [ ! -f "$HOME/.gitignore_global" ]; then
  cat > "$HOME/.gitignore_global" <<'EOF'
# Files to ignore in every repository, not just this one.
#
# macOS
.DS_Store
.AppleDouble
._*

# Editors
.idea/
*.swp
.vscode/

# Environment files that hold secrets
.env
.env.local
EOF
  ok "wrote ~/.gitignore_global"
fi

# ---------------------------------------------------------------------------
# SSH key
# ---------------------------------------------------------------------------

info "SSH key"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ -f "$KEY" ]; then
  ok "already have a key at $KEY"
else
  cat <<'EOF'

  ssh-keygen asks for a passphrase next.

  A passphrase protects the key if someone copies the file off your
  Mac. macOS stores it in the keychain, so you type it once and not
  again. Press Enter twice for no passphrase, which is easier and less
  safe.

EOF
  if ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY"; then
    ok "made $KEY"
  else
    err "ssh-keygen failed"
    exit 1
  fi
fi

# This makes macOS load the key at login and remember the passphrase.
# Without AddKeysToAgent and UseKeychain you retype it every reboot.
SSH_CONFIG="$HOME/.ssh/config"
if [ ! -f "$SSH_CONFIG" ] || ! grep -q "UseKeychain" "$SSH_CONFIG" 2>/dev/null; then
  [ -f "$SSH_CONFIG" ] && cp "$SSH_CONFIG" "$SSH_CONFIG.bak-$STAMP"
  {
    printf '\n'
    printf 'Host *\n'
    printf '  AddKeysToAgent yes\n'
    printf '  UseKeychain yes\n'
    printf '  IdentityFile %s\n' "$KEY"
  } >> "$SSH_CONFIG"
  chmod 600 "$SSH_CONFIG"
  ok "wrote $SSH_CONFIG"
fi

ssh-add --apple-use-keychain "$KEY" >/dev/null 2>&1 && ok "key loaded into the agent" \
  || warn "could not load the key into the agent. Run: ssh-add --apple-use-keychain $KEY"

# ---------------------------------------------------------------------------
# Give the key to GitHub
# ---------------------------------------------------------------------------

echo
if command -v gh >/dev/null 2>&1; then
  cat <<EOF
${BD}One step left.${O}

GitHub needs the public half of the key. gh does it for you:

  gh auth login

Pick GitHub.com, then SSH, then the key it offers. It uploads the key
and signs you in at the same time.
EOF
else
  cat <<EOF
${BD}One step left.${O}

GitHub needs the public half of the key. Copy it:

  pbcopy < ${KEY}.pub

Then paste it into GitHub, under Settings, SSH and GPG keys, New SSH key.
EOF
fi

cat <<EOF

Your public key. This one is safe to share. The file without .pub is
the private half and must never leave this Mac.

EOF
cat "${KEY}.pub"

cat <<EOF

Check it works, once the key is on GitHub:

  ssh -T git@github.com

The first connection asks you to accept GitHub's fingerprint. A reply
that says you have authenticated but GitHub does not provide shell
access is the success message.
EOF
