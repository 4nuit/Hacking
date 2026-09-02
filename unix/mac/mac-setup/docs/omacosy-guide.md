# omacosy on macOS: setup, customization, and every gotcha

Worked out over several sessions on a fresh omacosy install
(`paulsp94/omacosy`, pre-1.0) on Apple Silicon, macOS 26.

Read §A first. It is the short list of permanent fixes. Everything after
it explains why each one is needed.

---

## Contents

| § | Topic |
|---|---|
| **A** | **Do these first: the five permanent fixes** |
| B | The one idea behind most problems |
| 1 | Which files are yours, which belong to the repo |
| 2 | The launchd PATH |
| 3 | sudo breaks your terminal |
| 4 | The btop / Activity pill failure |
| 5 | Gotcha: `command =` in Ghostty's config |
| 6 | App shortcuts |
| 7 | Terminal appearance |
| 8 | Dock filling with terminal icons |
| 9 | Shell config: the new normal |
| 10 | Making `~/.zshrc` installer-proof |
| 11 | The prompt (starship) |
| 12 | Tiling problems |
| 13 | Updates that do not break your setup |
| 14 | What this project is and is not |
| 15 | Square corners |

---

# A. Do these first: the five permanent fixes

Each one stops a problem from ever recurring. Do them in order. Total
time is about ten minutes.

## A1. Give GUI apps a usable PATH

```sh
sudo launchctl config user path /opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Fixes the btop Activity pill and anything else omacosy launches that
calls a Homebrew binary. Details in §2 and §4.

Verify:

```sh
launchctl getenv PATH
```

## A2. Make `~/.zshrc` a real file

Right now it is a symlink into the git clone. Any installer that appends
to it writes into the repo and blocks your next update.

```sh
git -C ~/.local/share/omacosy diff zsh/zshrc      # check before discarding
git -C ~/.local/share/omacosy restore zsh/zshrc
cp -P ~/.zshrc ~/.zshrc.symlink-backup
rm ~/.zshrc
printf '%s\n' 'source "$HOME/.local/share/omacosy/zsh/zshrc"' > ~/.zshrc
```

Details in §10.

## A3. Install `~/.zshrc.local`

Your PATH entries, aliases and tool setup live here. `install.sh` backs
up your old `~/.zshrc` but never migrates it, so until you do this your
shell is missing everything you had. Details in §9.

Use `configs/zshrc.local` from this package as a starting point.

## A4. Install the two scripts

```sh
cp bin/omacosy-safe-update bin/omacosy-harvest-zshrc ~/.local/bin/
chmod +x ~/.local/bin/omacosy-safe-update ~/.local/bin/omacosy-harvest-zshrc
```

`omacosy-safe-update` makes updates stop destroying your setup.
`omacosy-harvest-zshrc` moves installer appends into `~/.zshrc.local`
automatically, so you never have to check.

Point topgrade at it in `~/.config/topgrade.toml`:

```toml
[commands]
"omacosy" = "$HOME/.local/bin/omacosy-safe-update"
```

This is the fix that makes updates stop destroying your customizations.
Details in §13.

## A5. Tell git to ignore the files omacosy writes to itself

The script in A4 does this automatically, but you can apply it now:

```sh
git -C ~/.local/share/omacosy update-index --skip-worktree config/omniwm/settings.toml
printf '%s\n' 'omacosy-bar.app/' 'omacosy-gesture.app/' '*.app/' >> ~/.local/share/omacosy/.git/info/exclude
```

## Check it all worked

```sh
launchctl getenv PATH                            # includes /opt/homebrew/bin
ls -l ~/.zshrc                                   # no arrow
which python pnpm fnm                            # your config is loading
ls -l ~/.local/bin/omacosy-*                     # both executable
git -C ~/.local/share/omacosy status --short     # silence
```

---

# B. The one idea behind most problems

**A process keeps the environment it was born with.**

macOS launches GUI apps through launchd, not through your shell. They
get launchd's minimal PATH:

```
/usr/bin:/bin:/usr/sbin:/sbin
```

No `/opt/homebrew/bin`. No `~/.local/bin`. Your `.zshrc` never runs for
them, so `brew shellenv` never runs either.

Three consequences:

1. A GUI-launched process cannot find Homebrew binaries by bare name.
2. Fixing PATH afterwards does not reach an already-running process. You
   must restart whatever consumes it.
3. `sudo` runs as root, which has yet another environment. Root has none
   of your terminfo, Homebrew, or config.

A fourth idea appears later and matters just as much:

**Shell functions do not exist outside an interactive shell.** A wrapper
function in `~/.zshrc.local` never runs when another program calls a
binary by absolute path. This is why the update wrappers in earlier
versions of this guide silently did nothing under topgrade. Scripts work
everywhere. Functions do not.

---

# 1. Which files are yours, which belong to the repo

`install.sh` symlinks the repo's configs into your home directory. Edit
through a symlink and you are editing the git working tree.
`omacosy-update` refuses a clone with local changes, so those edits cost
you the ability to update.

| File | Owner | Edit? |
|---|---|---|
| `~/.local/share/omacosy/**` | repo | **No** |
| `~/.config/ghostty/config` | symlink to repo | **No** |
| `~/.config/starship.toml` | symlink to repo | **No** |
| `~/.config/omniwm/` | symlink to repo | **No** (see §13) |
| `~/.zshrc` | symlink to repo | **No**, until §10 makes it yours |
| `~/Library/Application Support/com.mitchellh.ghostty/config` | **you** | Yes |
| `~/.zshrc.local` | **you** | Yes |
| `~/.config/starship-mine.toml` | **you** | Yes |
| `~/.config/omacosy/borders.conf` | **you**, but rewritten by updates | Yes |
| `config/apps.local.conf` | **you**, gitignored | Yes |

Check before editing anything:

```sh
ls -l ~/.config/ghostty/config ~/.zshrc ~/.config/starship.toml
```

An arrow means hands off.

## If the clone is already dirty

```sh
cd ~/.local/share/omacosy && git status
```

Modified tracked files block updates. Look at what changed before
discarding it:

```sh
git -C ~/.local/share/omacosy diff <file>
git -C ~/.local/share/omacosy restore <file>       # modern
git -C ~/.local/share/omacosy checkout -- <file>   # older, same effect
```

`--` separates paths from branch names. Both commands discard
uncommitted work permanently. Use `git stash` instead if you might want
it back.

Untracked files also block `omacosy-update`, which is unusually strict.
`install.sh` builds `omacosy-bar.app/` and `omacosy-gesture.app/` at the
repo root and does not gitignore them, so the project blocks its own
updates. Fix locally:

```sh
printf '%s\n' 'omacosy-bar.app/' 'omacosy-gesture.app/' '*.app/' >> ~/.local/share/omacosy/.git/info/exclude
```

`.git/info/exclude` is local git metadata. It is not versioned, not
distributed, and survives pulls.

---

# 2. The launchd PATH

Do this before anything else.

```sh
sudo launchctl config user path /opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

Apple's documentation says this needs a reboot. In practice it took
effect immediately in one test. Check rather than assume.

## What the long string is

Six directories joined by colons. It is an ordered search list. Type a
command and the system walks it left to right. First match wins.

| Directory | Contents |
|---|---|
| `/opt/homebrew/bin` | Homebrew on Apple Silicon |
| `/usr/local/bin` | Homebrew on Intel, and manual installs |
| `/usr/bin` | Apple's commands (`login`, `grep`) |
| `/bin` | Essentials (`ls`, `cat`, `sh`) |
| `/usr/sbin`, `/sbin` | Admin tools |

Homebrew comes first so `brew install python` wins over Apple's older
copy. You write the whole list because `launchctl config` replaces the
value. There is no append form, and omitting the system directories
would break every service on the machine.

## Verify

```sh
launchctl getenv PATH        # what GUI apps and services get
echo $PATH | tr ':' '\n'     # what your shell gets, much longer
```

Those two being different is the entire problem in one command pair.

## Things that look like fixes and are not

| Attempt | Why it fails |
|---|---|
| `source ~/.zshrc` | GUI apps never read shell config |
| `launchctl setenv PATH ...` | Session only. Dies at logout. |
| `sudo ln -s ... /usr/local/bin/` | `/usr/local/bin` is not in launchd's default either |
| `command =` in Ghostty's config | A command passed via `-e` overrides it. See §5. |

The symlink one sounds bulletproof and is not. launchd's default really
is only those four system directories.

---

# 3. sudo breaks your terminal

```
sudo nano ~/.config/ghostty/config
'xterm-ghostty': unknown terminal type.
```

Root does not have Ghostty's terminfo.

You do not need sudo for files in your own home directory. Using it
creates root-owned files that cause permission trouble later.

```sh
nano ~/.config/ghostty/config      # correct
```

Already did it? Fix ownership:

```sh
sudo chown -R $(whoami) ~/.config/ghostty
```

When you genuinely need sudo inside Ghostty:

```sh
sudo TERM=xterm-256color nano somefile
```

Or install the terminfo system-wide. This also fixes SSH to hosts that
do not know `xterm-ghostty`:

```sh
infocmp -x xterm-ghostty | sudo tic -x -o /usr/share/terminfo -
```

## Saving in nano

`Ctrl-O` then `Enter` writes. `Ctrl-X` exits. Or `Ctrl-X`, `Y`, `Enter`.
The `^` in nano's bottom bar means Ctrl. `M-` means Option.

Useful keys when editing configs:

| Key | Action |
|---|---|
| `Ctrl-W` | search (Enter again finds next) |
| `Alt-\` / `Alt-/` | top / bottom of file |
| `Ctrl-K` / `Ctrl-U` | cut line / paste, for moving a misplaced key |
| `Ctrl-A` / `Ctrl-E` | start / end of line |

You cannot run shell commands while nano is open. Search in the editor
instead.

Landed in vim by accident? `Esc`, then `:wq` to save and quit, or `:q!`
to discard.

---

# 4. The btop / Activity pill failure

Symptom:

```
Ghostty failed to launch the requested command:
  /usr/bin/login -flp <user> btop
Runtime: 25 ms
```

## The chain

1. `omacosy-bar` is a launchd agent, so it gets the minimal PATH.
2. It spawns Ghostty passing `btop` as a bare name.
3. Ghostty on macOS runs commands via `/usr/bin/login -flp $USER <cmd>`,
   executing them directly without a shell. `.zshrc` and `brew shellenv`
   never run.
4. Bare `btop` cannot be resolved. Exec fails in about 25 ms.

## Diagnostic ladder

```sh
command -v btop                        # installed?
/opt/homebrew/bin/btop --version
file /opt/homebrew/bin/btop            # right architecture?

ghostty -e btop                        # uses your shell's PATH
open -na Ghostty --args -e btop        # uses LaunchServices PATH
```

If the first Ghostty command works and the second fails, the problem is
the GUI environment, not the binary.

## Fix

Apply §2, then restart the agent. The restart is the step people miss.
The bar has been running since login and still holds the old
environment.

```sh
launchctl list | grep omacosy
launchctl kickstart -k gui/$(id -u)/com.omacosy.bar
```

Logging out and back in does the same for all agents.

## If it still fails

With Homebrew visibly in `launchctl getenv PATH` and the bar freshly
restarted, the agent's plist may set its own PATH. `launchctl config`
says as much in its own help: a service's parameter is preferred over
the domain default.

```sh
grep -A6 EnvironmentVariables ~/Library/LaunchAgents/com.omacosy.bar.plist
```

If there is a PATH entry there, no system setting reaches it. The fix
belongs upstream.

## `ghostty: command not found`

Only if `/Applications/Ghostty.app/Contents/MacOS` is not on your PATH.
omacosy's zshrc adds it, so check before adding an alias:

```sh
ghostty +show-config | head
```

## btop usage

btop needs at least 80x24 cells. If you see "Terminal size too small",
`Cmd+-` shrinks the font, which gives more columns in the same pixels.
`Cmd+0` resets. `Super+F` fullscreens. Keys `1` to `4` toggle boxes off.

Sorting keys, which differ from htop:

| Key | Action |
|---|---|
| Left / Right arrow | cycle sort column. This is how you sort by memory. |
| `r` | reverse sort order |
| `e` | tree view |
| `f` | filter by name (`Esc` clears) |
| `m` | **menu**, not memory sort |
| `q` | quit |

`m` is htop's memory-sort key and btop's menu key. Easy trap.

btop writes `~/.config/btop/btop.conf` when you quit with `q`. Closing
the window with `Super+W` or `Cmd-Q` may skip that write.

```sh
grep proc_sorting ~/.config/btop/btop.conf     # want "memory"
```

Editing that file by hand works, but not while btop is running. It
overwrites on exit.

---

# 5. Gotcha: `command =` in Ghostty's config

This looks like the obvious fix for §4 and is not:

```
command = /opt/homebrew/bin/btop
```

1. A command passed via `-e` overrides the config entirely. The bar
   passes `-e btop`, so your line is ignored.
2. It is global. Every Ghostty window would open btop instead of a
   shell.
3. `~/.config/ghostty/config` is symlinked into the repo, so the edit
   blocks future updates.

---

# 6. App shortcuts

Defaults are Ghostty, Safari, Spotify, Slack. Override in a gitignored
file.

Get the exact variable names and bundle names first:

```sh
cat ~/.local/share/omacosy/config/apps.conf
ls /Applications | grep -iE "zen|wez|alfred|zed|bloom"
```

`open -a` needs the name exactly. Alfred is often `Alfred 5.app`.

```sh
nano ~/.local/share/omacosy/config/apps.local.conf
```

```conf
TERMINAL=WezTerm
BROWSER=Zen
MUSIC=
MESSENGER=
```

Re-run the installer. It regenerates `aerospace.toml` from these:

```sh
cd ~/.local/share/omacosy && ./install.sh
```

**Only use variable names that exist in `apps.conf`.** An invented one
is silently ignored. Nothing reads it, nothing warns you, and it looks
like the change simply did not work.

## Gotcha: the launcher is hardcoded

`LAUNCHER=` does not exist. The binding is baked into the template:

```sh
grep -n "Raycast" ~/.local/share/omacosy/config/aerospace/aerospace.toml
# 94:cmd-ctrl-alt-space = 'exec-and-forget open -a Raycast'
```

To use Alfred instead without editing the template, clear Raycast's own
hotkey in its settings, then set Alfred's to `Cmd-Ctrl-Opt-Space`.
AeroSpace still fires `open -a Raycast` in the background, but with its
hotkey cleared that is a window you can ignore. Quitting Raycast makes
it a no-op.

## Bindings that are not substitutions

`apps.local.conf` only swaps the apps behind existing keys. New bindings
would mean editing `aerospace.template.toml`, which dirties the clone.

Use your launcher instead. Super is `Cmd-Ctrl-Opt`, so create hotkeys in
Alfred or Raycast:

- `Cmd-Ctrl-Opt-Shift-Z` for Zed
- `Cmd-Ctrl-Opt-Shift-B` for Bloom

This survives every update and costs nothing.

---

# 7. Terminal appearance

## Where settings go

`~/Library/Application Support/com.mitchellh.ghostty/config` is yours.
`install.sh` never touches it. Ghostty reads both this and the repo's
file and merges them, with this one winning.

If Ghostty has never been configured, this file exists but contains only
a commented-out template. Safe to overwrite.

## Porting a WezTerm config

| WezTerm | Ghostty |
|---|---|
| `font = wezterm.font("X")` | `font-family = X` |
| `font_size` | `font-size` |
| `color_scheme` | `theme` (`ghostty +list-themes`) |
| `colors.background` | `background` |
| `colors.ansi` / `brights` | `palette = 0=#111111` ... `15=#ffffff` |
| `window_background_opacity` | `background-opacity` |
| `macos_window_background_blur` | `background-blur-radius` |
| `window_padding` | `window-padding-x` / `-y` |
| ligatures off | `font-feature = -calt,-liga,-dlig` |

On newer builds `background-blur-radius` is just `background-blur`. If
the config errors at launch, that is the line.

## Extracting a scheme Ghostty does not ship

Ghostty bundles the iTerm2 collection, but not everything:

```sh
ghostty +list-themes | grep -i <name>
```

If it is missing, dump it from WezTerm, which has schemes compiled in.
Back up first, then add above `return config` in `~/.wezterm.lua`:

```lua
local s = wezterm.color.get_builtin_schemes()['Aci (Gogh)']
local f = io.open('/tmp/aci.json', 'w')
f:write(wezterm.json_encode(s))
f:close()
```

Match the module variable name from the top of your config. It is
`wezterm` in most configs but sometimes `w`. This is the step that trips
people.

Quit WezTerm with `Cmd-Q` and relaunch. The config only runs at startup.
Read `/tmp/aci.json`, then restore your backup.

Gotcha: `wezterm.serde.json_encode` only exists on newer builds. Older
ones use `wezterm.json_encode`. If neither exists, write the fields out
with plain string concatenation.

## Working example

See `configs/ghostty-config` in this package. It contains the Aci scheme
ported from WezTerm, 0.8 opacity, blur, and the process-lifecycle fix
from §8.

Theme conflict: `Super+Shift+T` rewrites terminal colors per the omarchy
convention, so a hardcoded palette fights it. Opacity and blur are not
part of that convention and always persist.

---

# 8. Dock filling with terminal icons

Symptom: seven Ghostty tiles, one visible window. Those are not stale
icons. They are seven live processes.

## Cause

`~/.local/bin/omacosy-spawn` uses `open -na "$APP"`. The `-n` is
deliberate and necessary. Without it, `open -a` on a running app focuses
the existing window instead of creating one, which would make
`Super+Enter` useless. The script also serializes spawns so the dwindle
split hint can keep up.

macOS does not quit an app when its last window closes. Normally this is
invisible, because one app means one process and one tile. TextEdit
stays in the Dock as a single icon however many documents you open. With
`-n` you get N windowless processes and N tiles, which is not normal
macOS behavior.

`exit` and `Cmd-Q` are not the same:

- `exit` ends the shell, the window closes, **the process survives**
- `Cmd-Q` quits the application and the process exits
- `Cmd-W` closes one window; other windows of that process live on

## Fix

In your personal Ghostty config:

```
quit-after-last-window-closed = true
```

Optionally hide the tiles entirely, which is reasonable under a tiling
window manager:

```
macos-dock = false
```

Clear strays with `pkill -f Ghostty`.

WezTerm does not show this. It quits on last window close by default and
uses one process for many windows.

---

# 9. Shell config: the new normal

Before omacosy, `~/.zshrc` was a normal file you owned. After, it is a
symlink into a git repo, and editing it dirties the clone.

**Do §10 as well.** The `.zshrc.local` mechanism below protects what you
write and nothing else. It does not stop third-party installers from
appending to `~/.zshrc` behind your back. For that you need the symlink
gone.

**`~/.zshrc.local` is your `~/.zshrc`.** Everything you used to put in
one goes in the other: aliases, exports, functions, PATH additions, tool
setup. The repo sources it:

```sh
grep -n "zshrc.local" ~/.zshrc
# 20: [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
# 22: # CLI stack (after .zshrc.local so frameworks there can't clobber these)
```

The `[ -f ]` guard means a missing file is skipped silently. It does not
exist until you create it.

**Translating tutorials:** wherever one says `~/.zshrc`, type
`~/.zshrc.local`. Nothing else changes.

**Line 22 matters.** The CLI stack loads after your file, so anything of
theirs you redefine gets overridden. This is also why oh-my-zsh can
safely be loaded from `.zshrc.local`. The ordering is deliberate.

## Migrating your old config

`install.sh` backs up what it replaces. Find it:

```sh
ls -la ~ | grep -i zshrc
```

Look for the timestamped one matching your install date, named
`.zshrc.bak.YYYYMMDDHHMMSS`. Older `.bak` files are archaeology from
previous setups. A root-owned `.zshrc.save` is nano's crash-recovery
file, not a real backup.

**The installer does not migrate the contents for you.** Until you do
this manually, your PATH entries and aliases are simply gone.

### The one line you must not carry over

```sh
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
```

That resets PATH from scratch. It is correct as the first line of a
standalone `.zshrc` and destructive in a file sourced partway through
someone else's, because it wipes everything set before it. Append only.
Everything else, like `export PATH="$HOME/.cargo/bin:$PATH"`, is safe
anywhere.

### Skip what the repo already provides

starship, and the CLI stack (fzf, eza, zoxide, ripgrep, bat, lazygit,
btop). Duplicating them hits the line-22 ordering conflict.

```sh
grep -n shellenv ~/.zshrc
grep -nE "autosuggestions|syntax-highlighting" ~/.zshrc
```

### Verify

```sh
which python pnpm fnm
echo $PATH | tr ':' '\n'
```

Duplicate PATH entries are normal and harmless. Both your file and the
repo's prepend the same directories, and the shell stops at the first
match.

## PATH ordering decides which binary you get

This caused the hardest bug of the migration.

Your old `~/.zshrc` had PATH exports scattered throughout. Grouping them
tidily at the top is tempting. Do not.

Later exports win. Where a line sits is part of its meaning.

Concrete example. `eval "$(fnm env --use-on-cd)"` prepends fnm's shim
directory to PATH. A pnpm block placed above it gets shadowed, so you
run fnm's bundled pnpm 9 instead of your standalone pnpm 11. The symptom
gives no hint of the cause:

```
ERR_PNPM_NO_PKG_MANIFEST  No package.json found in ~/Library/pnpm/global/5
```

pnpm 9 uses the `global/5` store layout. Your packages live in
`global/v11`. Nothing in the error mentions versions.

```sh
which -a pnpm     # shows EVERY match on PATH, in order. This is the diagnostic.
pnpm --version    # compare with ~/Library/pnpm/bin/pnpm --version
```

So pnpm belongs after the fnm line:

```sh
eval "$(fnm env --use-on-cd)"

export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PNPM_HOME/bin:$PATH"
```

Note `$PNPM_HOME` itself, not only `$PNPM_HOME/bin`. pnpm's global bin
directory is the parent. `bin/` holds pnpm's own executables. Both need
to be on PATH. Using only `/bin` gives:

```
ERROR The configured global bin directory ... is not in PATH
```

**When migrating, preserve the original order.** Drop what is redundant,
keep everything else where it was. Reorganize later, one change at a
time, testing between.

Watch for installers re-adding an fnm line at the end of your file. That
puts fnm back in front of pnpm and restores the bug. Also delete any
hardcoded `node-versions/vNN/installation/bin` PATH entry. It pins one
Node version and defeats fnm's `--use-on-cd` switching.

## Never put `exec zsh` in a config file

```sh
exec zsh   # in ~/.zshrc.local, this loops forever
```

The shell starts, sources `.zshrc.local`, hits `exec zsh`, replaces
itself with a new shell, which sources `.zshrc.local` again. The symptom
is a hang, not an error, and you get a bare prompt with no starship
because zsh never finishes.

The same applies to one-off verification commands like `pnpm -g bin` or
`echo $PATH`. A config file holds definitions and settings only.
Anything you would run once to check something belongs at the prompt.

Diagnose a hanging config:

```sh
zsh -n ~/.zshrc.local                                # syntax check, silence is good
zsh -x -c 'source ~/.zshrc.local' 2>&1 | tail -20    # Ctrl-C when it stalls
```

The last line printed is where it is stuck.

## Restoring autosuggestions and completion

The grey inline suggestion from history is a shell feature, not a
terminal one. WezTerm was not providing it. Your zsh config was.

```sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

Check whether omacosy already loads them first:

```sh
grep -nE "autosuggestions|syntax-highlighting" ~/.zshrc
ls /opt/homebrew/share/zsh-autosuggestions/ /opt/homebrew/share/zsh-syntax-highlighting/
brew install zsh-autosuggestions zsh-syntax-highlighting   # if missing
```

Two ordering constraints:

1. syntax-highlighting must be sourced last of the two. It wraps the
   line editor and breaks if anything initialises after it.
2. Both must come after `compinit`.

Tab completion itself comes from `compinit`:

```sh
autoload -Uz compinit
compinit
```

If completion is slow or the shell hangs on startup, a stale
`~/.zcompdump` is the usual cause. Remove it and let it rebuild.

## Starship warning on first launch

```
[WARN] (starship::utils): Executing command ".../bin/node" timed out.
```

Harmless. Starship shells out to `node --version` and fnm's shim was
slower than the 500 ms default, usually because it had just been
rebuilt. Raise `command_timeout` if it persists.

---

# 10. Making `~/.zshrc` installer-proof

Do this once. It closes the hole `.zshrc.local` leaves open.

## The problem

`.zshrc.local` protects your own edits. It does nothing about other
programs writing to `~/.zshrc`. Installers append to it routinely: nvm,
conda, pnpm, cua, various brew formulae. Because the path is a symlink,
they write straight into the git clone without knowing it.

You find out later, from topgrade:

```
==> clone: /Users/you/.local/share/omacosy (on main)
     M zsh/zshrc
==> the clone has local changes — commit, stash or discard them first
```

A real example from a Rust CLI's install script:

```diff
+# Added by cua-driver-rs installer — see https://github.com/trycua/cua
+export PATH="/Users/you/.local/bin:$PATH"
```

Harmless in itself, and already duplicated by `.zshrc.local`, but it
blocked every future update until cleared.

## The fix

Replace the symlink with a real file that sources the repo's. Everything
behaves identically. Installers now write to a file you own.

**Keep your current terminal open throughout.** If something breaks,
that window still has a working shell to fix it from.

### 1. Clear the existing damage

```sh
git -C ~/.local/share/omacosy diff zsh/zshrc
```

Read it. If the added lines duplicate something already in
`~/.zshrc.local`, discard them. If you need them, copy them into
`~/.zshrc.local` first.

```sh
git -C ~/.local/share/omacosy restore zsh/zshrc
git -C ~/.local/share/omacosy status --short     # silence means clean
```

### 2. Back up the symlink

```sh
ls -l ~/.zshrc                          # confirm the arrow is there
cp -P ~/.zshrc ~/.zshrc.symlink-backup
```

`-P` copies the symlink itself instead of following it.

### 3. Replace it with a real file

```sh
rm ~/.zshrc
cat > ~/.zshrc << 'EOF'
# Real file, not a symlink into the omacosy clone.
# install.sh wants to symlink this path. omacosy-safe-update undoes that
# after every update.
#
# Installers that append to ~/.zshrc now write below, harmlessly.

source "$HOME/.local/share/omacosy/zsh/zshrc"
EOF
```

`rm` on a symlink removes only the pointer. The real file at
`~/.local/share/omacosy/zsh/zshrc` is untouched.

### 4. Make it survive updates

`install.sh` recreates the symlink on every update.
`omacosy-safe-update` from §13 undoes it each time. Install that script
and this stays fixed permanently.

### 5. Test in a new window

Open a new terminal. Leave the old one open.

```sh
ls -l ~/.zshrc                                 # no arrow means real file
which python pnpm fnm                          # config still loading
git -C ~/.local/share/omacosy status --short   # silence means clean
```

If the new window is broken, fix it from the old one:

```sh
mv ~/.zshrc.symlink-backup ~/.zshrc
```

### 6. Clean up

```sh
rm ~/.zshrc.symlink-backup
```

## What lives where now

| File | Owner | Contents |
|---|---|---|
| `~/.zshrc` | **you** | One `source` line, plus whatever installers append |
| `~/.zshrc.local` | **you** | Your deliberate config |
| `~/.local/share/omacosy/zsh/zshrc` | repo | Shared baseline. Never edit. |

Load order: `~/.zshrc` sources the repo's zshrc, which sources
`~/.zshrc.local` at line 20, then loads the CLI stack at line 22.

Installer lines appended to `~/.zshrc` run after everything else, so
they win any PATH conflict. Usually that is what you want. Given the
pnpm and fnm ordering problem in §9, it is worth remembering if an
appended line ever changes which binary you get.

---

# 11. The prompt (starship)

omacosy wires starship, not powerlevel10k. Starship is a shell prompt
doing the same job: Rust, one binary, works across zsh, bash and fish,
configured in TOML. p10k is zsh-only with a faster cold start.

Theme switching covers the bar, borders, wallpaper and terminal. It does
**not** cover the prompt. Prompt colors are static either way, so that
is not an argument for one over the other.

## Keeping p10k instead

Two lines in `~/.zshrc.local`. Sourcing after starship's init means p10k
wins, because it sets `PROMPT` last:

```sh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
```

Check what your p10k config contains before bothering:

```sh
grep -A40 "LEFT_PROMPT_ELEMENTS" ~/.p10k.zsh | grep -v "^\s*#"
```

The stock rainbow preset, with thirty version managers and the
block-fade separators, has nothing personal to preserve.

## Customizing starship

`~/.config/starship.toml` is a symlink into the repo, and starship reads
exactly one config file. There is no overrides layer. Redirect it
instead, which leaves the symlink untouched:

```sh
cp ~/.local/share/omacosy/config/starship.toml ~/.config/starship-mine.toml
echo 'export STARSHIP_CONFIG="$HOME/.config/starship-mine.toml"' >> ~/.zshrc.local
```

Open a new terminal window to test. Do not use `exec zsh`. See §9.

### Reading the config: three kinds of brackets

TOML plus starship's own syntax means `[` means three different things
in one file.

| Appearance | Meaning |
|---|---|
| `[username]` alone on a line | TOML table header. Every key below belongs to this module until the next header. |
| `[$user ]($style)` inside a string | Starship styling. Borrowed from Markdown links. Nothing to do with TOML. |
| `[](fg:#DA627D bg:#9A348E)` | Same styling syntax wrapping a powerline separator glyph. That is what draws the arrow between segments. |

Many modules have their own `format` key, so `grep format` returns a
dozen hits. The top-level one, which controls prompt layout, has no
header above it:

```sh
grep -n "^format" ~/.config/starship-mine.toml   # ^ excludes indented module keys
head -25 ~/.config/starship-mine.toml            # before the first [word] is top level
```

### Two-line prompt, with input on its own line

```toml
format = """
[](#9A348E)\
$username\
[](bg:#DA627D fg:#9A348E)\
$directory\
[](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#33658A)\
$time\
[ ](fg:#33658A)\
$line_break\
$character"""

[character]
success_symbol = '[❯](bold #A3BE8C)'
error_symbol = '[❯](bold #BF616A)'
```

**The trailing backslashes matter.** In a TOML `"""` string, a trailing
`\` swallows the newline that follows it. Starship's format has to be
one continuous string, so every line needs one, except where you want a
break. `$line_break` provides that break.

Two rules follow, and both bite:

1. A line missing its `\` adds a blank line you did not ask for.
2. The last module must have no `\`, and `"""` must close on the same
   line. A newline before the closing quotes is also part of the string.

Correct:

```toml
$character"""
```

Both of these produce a stray blank line:

```toml
[ ](fg:#33658A)        <- missing backslash
$line_break\
$character\            <- backslash should not be here
"""                    <- and this newline is part of the string
```

If a gap persists after fixing the backslashes, check `add_newline`. It
is a top-level key controlling the blank line before each prompt, and
with a two-line prompt it is usually redundant:

```toml
add_newline = false
```

### Gotcha: "Unknown key" warnings

```
[WARN] - (starship::config): Error in 'Character' at 'add_newline': Unknown key
```

A key ended up under the wrong table header. Adding a `[character]`
section near the bottom easily sweeps a following top-level key into it,
because everything after a header belongs to that header until the next
one.

`[character]` should contain only `success_symbol`, `error_symbol`, and
optionally `vimcmd_symbol`. Move anything else above the first
`[section]` line.

### Nerd Font glyphs paste badly

They live in Unicode's Private Use Area and render as boxes anywhere
without the font: chats, issue trackers, `git log` on a server.

```toml
[nodejs]
symbol = 'node '
[git_branch]
symbol = 'git:'
[os]
disabled = true
```

The characters `❯`, `♥` and `~` are real Unicode and copy fine.

### Transient prompt

Past prompts collapse to just `❯` once a command runs. In
`~/.zshrc.local`:

```sh
starship_transient_prompt_func() { starship module character; }
enable_transience
```

### Clock on the right instead of inline

Remove `$time\` and the color transitions around it from `format`, then
add as a top-level key:

```toml
right_format = "$time"
```

---

# 12. Tiling problems

Windows opening floating instead of tiling. Check whether AeroSpace sees
them:

```sh
aerospace list-windows --workspace focused
```

Listed means tracked but floating. `Super+T` toggles that window back
in. One float holding focus means the next window has no tiled sibling
to split against, so the problem chains. Fixing the first one often
fixes everything after it.

Reset the layout:

```sh
aerospace flatten-workspace-tree
```

Not listed at all means AeroSpace is not detecting them. Check
Accessibility in System Settings, Privacy and Security. Grants are tied
to a binary's code signature, so rebuilds without an Apple Development
identity lose them.

Verify the dwindle hint:

```sh
cat /tmp/omacosy-split-state-$(id -u)   # window id, geometry, timestamp
grep -n "on-focus-changed" ~/.local/share/omacosy/config/aerospace/aerospace.toml
```

The binding should call `$HOME/.local/bin/omacosy-helper` by absolute
path. A bare name there would be the same PATH bug in a different place.

## Permissions stop working after an update

Symptom: gestures, window management or the bar's Bluetooth and Location
readings stop working, and macOS re-prompts:

```
"omacosy-gesture.app" would like to control this Mac and access your data.
```

The confusing part is that System Settings still lists the app with its
toggle **on**.

**Cause.** macOS ties permission grants to a binary's **code signature**,
not to its path or name. `install.sh` rebuilds `omacosy-gesture.app` and
`omacosy-bar.app` on every update. Without a stable Apple Development
signing identity, each rebuild produces a new signature. macOS keeps the
old entry visible and enabled while silently refusing the new binary.

**Toggling off and on does not fix it.** The stale entry has to be
deleted so macOS re-registers the new signature.

1. System Settings, Privacy and Security, Accessibility
2. Select the app, click the **minus** button to remove it entirely
3. Restart the agent:

```sh
launchctl kickstart -k gui/$(id -u)/com.omacosy.gesture
launchctl kickstart -k gui/$(id -u)/com.omacosy.bar
```

4. When the prompt reappears, grant it fresh

Check the agent is actually running first. If it is not listed, the
update may have failed partway and re-running `install.sh` is the
answer:

```sh
launchctl list | grep omacosy
pgrep -fl omacosy-gesture
```

Also check **Input Monitoring** in the same settings pane. Gesture
handling sometimes needs both Accessibility and Input Monitoring, and
only one of them gets prompted for.

The same applies to Bluetooth, Location and Automation grants for
`omacosy-bar.app`. If the bar's wi-fi or Bluetooth pills go blank after
an update, this is why.

**This recurs on every update** that rebuilds a helper app. Deleting the
build artifacts to force a rebuild has the same effect, which is why
`.git/info/exclude` (§1) is better than removing them.

---

# 13. Updates that do not break your setup

This is the section that took longest to get right.

## Why every earlier attempt failed

Three separate problems, discovered one at a time.

**Problem 1: omacosy writes into its own clone.** `bin/theme-set` writes
border colors to `$HOME/.config/omniwm/settings.toml`, and
`install.sh:153` symlinks `~/.config/omniwm` to `config/omniwm` in the
repo. So changing a theme modifies a tracked file. Every pull then
conflicts:

```
error: Your local changes to the following files would be overwritten by merge:
  config/omniwm/settings.toml
```

**Problem 2: build artifacts block updates.** `install.sh` creates
`omacosy-bar.app/` and `omacosy-gesture.app/` at the repo root without
gitignoring them, and `omacosy-update` refuses to run with untracked
files present. The project blocks its own updates.

**Problem 3, the important one: shell functions never ran.** The obvious
fix is a wrapper function in `~/.zshrc.local`:

```sh
omacosy-update() {
  command omacosy-update "$@"
  omacosy-borders-tweak
}
```

Topgrade runs `/bin/zsh -c '$HOME/.local/bin/omacosy-update'`. That is
the binary by absolute path, from a non-interactive shell that never
sources `~/.zshrc.local`. The function does not exist there. It only
ran when you typed `omacosy-update` yourself, which is not when updates
actually happen.

That is why the border color kept reverting no matter what was added to
the shell config.

## The fix: a script, not a function

A script works regardless of who calls it. Install
`bin/omacosy-safe-update` from this package:

```sh
cp bin/omacosy-safe-update ~/.local/bin/
chmod +x ~/.local/bin/omacosy-safe-update
```

Point topgrade at it in `~/.config/topgrade.toml`:

```toml
[commands]
"omacosy" = "$HOME/.local/bin/omacosy-safe-update"
```

Use the absolute path. Topgrade's subprocesses may not inherit your
interactive PATH, per §B.

### What the script does

1. **Copies `~/.zshrc` to a temp file before the update.** This matters
   more than it looks. `install.sh` replaces `~/.zshrc` with a symlink,
   so anything a third-party installer appended to your real file would
   be destroyed. See "Installing things that expect ~/.zshrc" below.
2. Adds `*.app/` to `.git/info/exclude`, so build artifacts stop
   blocking updates.
3. Runs `git update-index --skip-worktree config/omniwm/settings.toml`.
   This is the real fix for the border color. Git permanently ignores
   changes to that file, so pulls leave your colors alone and no
   post-update patching is needed.
4. Discards any other stray modification to tracked files. Nothing of
   yours should live in the repo.
5. Runs the real `omacosy-update`.
6. **Restores `~/.zshrc` from the copy**, installer appends included. If
   there was no copy, writes a fresh one-line file. Then checks the
   `source` line is present and re-adds it if not, so a bad restore
   cannot leave you with a shell that loads none of omacosy's config.
7. Re-applies the square ring radius to `borders.conf`, which
   `install.sh` overwrites every time.
8. Re-applies border colors as a fallback.
9. Restarts the borders daemon.

Edit the four variables at the top of the script to match your own
radius and color.

### Verify after the first run

```sh
git -C ~/.local/share/omacosy status --short   # silence
ls -l ~/.zshrc                                 # no arrow
grep -E "^radius" ~/.config/omacosy/borders.conf
```

## Installing things that expect `~/.zshrc`

Plenty of tools install with a one-liner that appends to your shell
config:

```sh
curl -fsSL https://example.dev/install.sh | sh
```

**After §10 this works normally.** `~/.zshrc` is a real file you own, so
the installer appends to it, the line takes effect on your next shell,
and the git clone is untouched. Nothing to do.

Before §10 the same command would have written into the clone through
the symlink and blocked your next update.

**One thing to know.** `install.sh` re-symlinks `~/.zshrc` on every
omacosy update, which would throw away those appended lines. That is why
`omacosy-safe-update` copies the file out beforehand and restores it
afterwards. Without that step you would silently lose installer setup
every time you updated.

### Harvesting appends automatically

You should not have to check `~/.zshrc` after every install.
`bin/omacosy-harvest-zshrc` moves whatever installers appended into
`~/.zshrc.local` on its own.

```sh
cp bin/omacosy-harvest-zshrc ~/.local/bin/
chmod +x ~/.local/bin/omacosy-harvest-zshrc
```

The hook that calls it is already in `configs/zshrc.local`, §8. Nothing
else to wire up.

**How it works.** It runs once per shell from a `precmd` hook, after
config loading finishes. Rewriting `~/.zshrc` while zsh is sourcing it
would be unsafe, so the move lands in the next shell. The current shell
has already executed those lines, so nothing is missing either way.

On first run it appends a marker to `~/.zshrc`:

```
source "$HOME/.local/share/omacosy/zsh/zshrc"
# ── INSTALLER APPENDS BELOW — harvested into ~/.zshrc.local ──
```

Everything below that marker gets moved. The `source` line above it is
never touched.

**Safety properties**, all tested:

| Property | Behavior |
|---|---|
| Nothing to harvest | Silent no-op |
| Same line appended twice | Skipped, never duplicated |
| `~/.zshrc` still a symlink | Exits immediately, changes nothing |
| Several terminals opening at once | `mkdir` lock, one winner |
| Write interrupted | Atomic temp-file plus `mv` |
| Something goes wrong | Both files backed up to `~/.local/state/omacosy-harvest/`, last 20 kept |

When it moves something it tells you:

```
omacosy-harvest: moved 3 line(s) from ~/.zshrc to ~/.zshrc.local
omacosy-harvest: they take effect in your next shell.
```

To disable, comment out the `add-zsh-hook` line in §8 of
`~/.zshrc.local`.

**One consequence worth knowing.** Harvested lines move from the end of
`~/.zshrc`, which runs last, to `~/.zshrc.local`, which runs earlier.
That changes PATH precedence. For a typical installer adding its own bin
directory this makes no difference. If a tool ships its own Node,
Python or package-manager shim, check after the move:

```sh
which -a node python3 pnpm
```

If something now resolves somewhere unexpected, move that line below
your fnm block in §5 of `~/.zshrc.local`. Same class of problem as the
pnpm and fnm ordering in §9.

### Doing it by hand instead

If you prefer to stay in control, skip the harvester and check after
each install:

```sh
tail -20 ~/.zshrc                                # see what landed
git -C ~/.local/share/omacosy status --short     # confirm still clean
```

## Stop topgrade pulling the clone twice

Topgrade's "Git repositories" step auto-discovers repos and pulls them,
duplicating what your `omacosy` command does. In `~/.config/topgrade.toml`:

```toml
[git]
pull_predefined = false
arguments = "--autostash"
```

`pull_predefined = false` stops auto-discovery, so only repos you list
explicitly get pulled. `--autostash` is a safety net for the rest.

## Your customizations, all update-safe

| What | Where |
|---|---|
| Terminal colors, opacity, Dock behavior | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| Shell config, aliases, PATH, tool setup | `~/.zshrc.local` |
| Third-party installer appends | `~/.zshrc` (a real file after §10) |
| Which apps the keybindings launch | `config/apps.local.conf` (gitignored) |
| Prompt styling | `~/.config/starship-mine.toml` |
| Ring radius and border color | variables in `omacosy-safe-update` |
| Extra app hotkeys | Alfred or Raycast, not the repo |
| PATH for GUI apps and services | `sudo launchctl config user path` |

## If something breaks after a reboot or update

1. `launchctl getenv PATH` — did the PATH survive?
2. `launchctl list | grep omacosy` — are the agents up?
3. `pgrep -fl AeroSpace` — is the window manager running?
4. `launchctl kickstart -k gui/$(id -u)/com.omacosy.bar` — restart a
   stale agent
5. `aerospace flatten-workspace-tree` — reset a mangled layout
6. `git -C ~/.local/share/omacosy status --short` — did something dirty
   the clone?
7. Gestures or bar readings dead? A rebuilt helper app lost its
   permission grant. See §12, "Permissions stop working after an
   update". The toggle looks enabled and is not.

## Escape hatches

```sh
omacosy-toggle off     # vanilla Mac, without uninstalling
omacosy-toggle on
cd ~/.local/share/omacosy && ./uninstall.sh
```

`uninstall.sh` is manifest-driven. `install.sh` recorded what this
machine actually gained, so uninstall removes and restores exactly that.
Tools you already had are left alone.

---

# 14. What this project is and is not

## What the README promises, and delivers

The author is upfront: pre-1.0, built for macOS 26 on one desk, "works
for me" is the stated support tier. Take that literally. The engineering
that is there is good. The dwindle split-hint timing, the
manifest-driven uninstall, the permissions table and the memory
accounting all show real thought.

## Where it is rough

The pattern in everything hit here: the desktop-environment code is
careful, and the integration with a machine that already has a setup is
not.

| Problem | What it cost |
|---|---|
| `btop` passed by bare name from a launchd agent | Hours. The hardest bug here. |
| `~/.zshrc` backed up but never migrated | Silent loss of PATH, aliases and tool setup until noticed |
| `~/.zshrc` symlinked into the clone | Any installer appending to it blocks the next update |
| `theme-set` writes to a tracked file | Every theme change conflicts with every pull |
| Build artifacts not gitignored | The project blocks its own updates |
| `omacosy-spawn`'s `-n` leaks a process per window | Dock fills with terminal icons |
| Activity pill hardcodes Ghostty | Ignores your `TERMINAL=` choice |
| Launcher hardcoded to Raycast | `LAUNCHER=` looks like it should work and does nothing |
| Helper apps rebuilt unsigned each update | Accessibility grants silently break while showing as enabled |

None are hard to fix. All surface the moment a second person installs
it.

## Whether to keep it

Reasons it earns its place: the tiling is good, the bar is light,
`omacosy-toggle off` gives you a vanilla Mac in one command, and
`uninstall.sh` is manifest-driven rather than scorched-earth. The exit
path is unusually well built for a pre-1.0 project, which is itself a
signal the author is being straight with you.

Reasons to hesitate: it is one person's desk, tested on one hardware
configuration, and it installs Karabiner-Elements, which ships a
DriverKit extension and root daemons. That is the most privileged
third-party thing on your Mac and it is there to remap Caps Lock. The
README says so plainly. Skip it if that trade is wrong for you. You lose
the Super key and keep everything else.

## If you file issues

Useful reports from this work, in rough priority:

1. `helper/bar.swift` should use an absolute path or `zsh -lc` for
   spawned commands. launchd agents do not get Homebrew on PATH.
2. `theme-set` writes to a tracked file via a symlink. Settings the app
   modifies at runtime should live outside the clone.
3. Gitignore `*.app/`. The build artifacts block the project's own
   updater.
4. `install.sh` should migrate or at least warn about the replaced
   `~/.zshrc`.
5. Symlinking `~/.zshrc` into the clone means any third-party installer
   that appends to it blocks the next update. Shipping a real `~/.zshrc`
   that sources the repo's would avoid this entirely.
6. Ship `quit-after-last-window-closed = true` in the Ghostty config.
7. Activity pill should respect `TERMINAL=`.
8. Launcher should be a `LAUNCHER=` variable like `TERMINAL` and
   `BROWSER`.
9. Sign the helper apps with a stable identity, or skip rebuilding them
   when unchanged. Every rebuild invalidates the Accessibility grant
   while System Settings continues to show it as enabled, which is a
   confusing failure to diagnose.

Frame each as: what you ran, what happened, what you expected. The btop
one has a clean reproduction. `open -na Ghostty --args -e btop` fails
from a launchd context while `ghostty -e btop` works from a shell.

## Do not patch your clone

Tempting, and it breaks updates. Every fix in this guide lives outside
the repo for that reason. If a problem can only be fixed inside
`~/.local/share/omacosy`, the right move is a pull request, not a local
edit.

---

# 15. Square corners

macOS 26 introduced aggressive window rounding. Removing it means
changing three independent layers together. Miss one and you get
mismatched corners.

| Layer | Controlled by |
|---|---|
| macOS window corners | Undocumented `defaults` key |
| omacosy focus ring | `borders.conf` |
| Zen Browser chrome | `userChrome.css` |

Version support: not needed on macOS 15 and earlier, where corners are
already about 9pt and the key does not exist. Works on 26 Tahoe, where
the key was found. Confirmed working through Golden Gate Beta 6, where
Apple reduced and unified the radius but not to square.

This is an undocumented key on a beta OS. Apple can rename or remove it
in any build. Nothing here is destructive. Worst case a command silently
does nothing.

## Layer 1: macOS window corners

```sh
defaults write -g NSConvolutionOverride1 -float 0.1
defaults read -g NSConvolutionOverride1     # should print 0.1
```

Use `0.1`, not `0`. Plain zero behaves oddly in some apps.

Apps read the value at launch, so `killall Finder` covers Finder only.
Log out and back in to catch everything.

Reference values, approximate, in points:

| Value | Matches |
|---|---|
| `0.1` | Square |
| `4` | Catalina |
| `9` to `10` | Sequoia and earlier |
| `15` to `20` | Golden Gate default (sources differ) |
| `17.1` | Measured on macOS 26 by circle-fitting live window alpha |
| `26` | Tahoe default, per forum reports |

`4` is a good middle ground if full square is too much. Below about 8
you may see minor scroll bar clipping in a few apps.

Revert with `defaults delete -g NSConvolutionOverride1`, then log out.

**What it does not affect:**

- Display corners, drawn by the compositor. No defaults key touches
  them. Overlay utilities drawing click-through caps are the only
  option.
- Electron and Chromium apps. VS Code, Slack, Brave, WhatsApp and
  Discord draw their own chrome and ignore the key. Zen and Firefox
  respect it.
- Quick Look previews. Still rounded, no known override.

Optional related prefs:

```sh
defaults write -g NSSplitViewItemSidebarDefaultsToFloatingAppearance -bool false
defaults write -g NSSplitViewItemGlassMinimumCornerRadius -float 6
```

**Gotchas:**

*`defaults read` says the key does not exist after writing it.* The
write did not run. Either the value got dropped from a mangled paste, in
which case `defaults` prints usage text and exits 255, or you used
`sudo`, which writes to root's domain instead of yours. Retype by hand,
one line, no sudo. Same root cause as §3.

*Key reads correctly but corners are still round.* You did not relaunch.
`Cmd-Q` the app fully or log out. Test with TextEdit, which respects the
override reliably. If TextEdit is square and your app is not, that app
is Electron and out of reach.

*Corners changed but barely.* You set a value close to the default. Use
`0.1` to confirm the mechanism works, then dial back up.

## Layer 2: omacosy focus rings

omacosy draws its focus ring with its own binary, `omacosy-borders`, not
JankyBorders. If `borders style=square` returns `command not found`,
that is why.

```sh
pgrep -l -f "borders|omacosy|sketchybar|aerospace"
```

Two copies of `borders.conf` exist:

| Path | Read by the daemon? |
|---|---|
| `~/.local/share/omacosy/config/borders.conf` | **No**, repo source copy |
| `~/.config/omacosy/borders.conf` | **Yes**, the live one |

```sh
ls -l ~/.config/omacosy/borders.conf
```

An arrow means symlink and either path works. No arrow means it is a
real copy, so edit `~/.config/omacosy/borders.conf` only.

**The concentric rule**, from the config's own comments:

```
ring radius = window corner radius + gap + width/2
```

With omacosy's defaults of `gap=-1` and `width=3` that reduces to
`window radius + 0.5`. So for square windows at `0.1`:

```
radius=0.6
```

The daemon re-reads on file change. If it does not pick up:

```sh
pkill -f omacosy-borders     # launchd relaunches it immediately
```

**Per-app overrides** use `radius:AppName=N`, keyed on the frontmost app
name as shown in Cmd-Tab.

- Delete overrides for native apps. They now follow the global square
  setting, so an old override re-rounds them.
- Keep overrides for Electron apps. Those windows are still rounded, so
  the ring must match or you get a wedge of desktop in the corner. Use
  the app's own radius plus 0.5, for example `radius:WhatsApp=13.5`.

Measured values from the config comments: macOS 26 standard about
17.1pt, WhatsApp about 12.9pt.

**Surviving updates:** `install.sh` re-copies `borders.conf` on every
update, so your radius gets overwritten. `omacosy-safe-update` from §13
re-applies it. That is why the script exists.

**Gotchas:**

*Ring is square but the window is not*, leaving a wedge of desktop in
the corner. That app ignores the defaults key. Add a per-app ring
override matching its real radius instead of fighting it.

*Ring is round but the window is square.* You edited the repo copy of
`borders.conf`.

*Rings look subtly off after an update.* An update changed `width` or
`gap`. The concentric rule ties all three together and the script only
rewrites `radius`. Recompute: window radius + gap + width/2.

## Layer 3: Zen Browser

Zen's corner radius is CSS, not preferences. No `user.js` line controls
it. An upstream request for adjustable corner radius is still open. What
`user.js` does is unlock the mechanism.

Zen's outer window already follows Layer 1, since Zen is Firefox-based.
Only its internal chrome needs CSS.

Enable custom stylesheets in `about:config` or `user.js`:

```js
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
```

These affect the content area only, not the sidebar chrome:

```js
user_pref("zen.view.experimental-rounded-view", false);
user_pref("zen.theme.content-element-separation", 0);
```

**Find the right profile folder. Do not guess.** Zen installs multiple
channels, each with its own profile. A file in the wrong one is a silent
no-op that looks exactly like broken CSS.

```sh
ls -d ~/Library/Application\ Support/zen/Profiles/*/chrome/
```

Open `about:profiles` in the Zen window you actually use and find the
entry marked in use. Its Root Directory is your answer. Then `cd` in
with quotes, because some names contain spaces and parentheses, and an
unquoted glob fails with `cd: too many arguments` when several match.

**Create the right file.** Inside `chrome/` you will likely see:

| Item | Use it? |
|---|---|
| `zen-themes.css` | **No**, generated by ZenMods, overwritten on any mod change |
| `zen-themes/` | **No**, downloaded mod files, clobbered on mod update |
| `userChrome.css` | **Yes**, create it. Nothing regenerates this. |

Zen does not apply `userChrome.css` live. Quit fully with `Cmd-Q` and
reopen. Closing the window is not enough.

Square outer bar, rounded inner elements:

```css
:root {
  --inner-radius: 10px;

  /* These drive the OUTER bar. Keep at 0 or the panel re-rounds. */
  --zen-border-radius: 0px !important;
  --zen-panel-radius: 0px !important;
  --zen-button-border-radius: 0px !important;
  --border-radius-small: 0px !important;
  --border-radius-medium: 0px !important;
  --border-radius-large: 0px !important;
  --toolbarbutton-border-radius: 0px !important;
  --tab-border-radius: 0px !important;
  --urlbar-border-radius: 0px !important;
}

/* SQUARE: outer bar and its wrappers */
#navigator-toolbox,
#titlebar,
#zen-main-app-wrapper,
#zen-sidebar-box,
#zen-tabbox-wrapper,
#toolbar-menubar,
#TabsToolbar,
.browserSidebarContainer {
  border-radius: 0 !important;
  clip-path: none !important;
}

/* ROUNDED: inner elements, set explicitly, never via the variables above */
.tabbrowser-tab .tab-background,
.tabbrowser-tab[zen-essential="true"] .tab-background,
.zen-essentials-container .tab-background,
#zen-essentials-container,
#zen-workspaces-button,
#zen-current-workspace-indicator {
  border-radius: var(--inner-radius) !important;
}

#urlbar,
#urlbar[breakout],
#urlbar[breakout-extend],
#urlbar-input-container,
#urlbar-background,
#identity-box,
#zen-sidebar-top-buttons-customization-target {
  border-radius: var(--inner-radius) !important;
}

.toolbarbutton-1 > .toolbarbutton-icon,
.toolbarbutton-1 > .toolbarbutton-badge-stack,
#zen-sidebar-top-buttons toolbarbutton,
toolbarbutton .toolbarbutton-icon,
.urlbar-icon {
  border-radius: var(--inner-radius) !important;
}
```

Change `--inner-radius` to taste. Square everything by setting the inner
selectors to `0`. Round everything by deleting the file.

**Gotchas:**

*The `:root` variables control the OUTER bar.* This is the most
important item here and the least obvious. Setting `--zen-border-radius`
and friends to `0px` squares the outer panel. Setting them non-zero
re-rounds it, even with an explicit `border-radius: 0 !important` on
`#navigator-toolbox` in the same file. So you cannot round the inner
elements by raising those variables. Keep the variables at `0` and set
inner radii explicitly per element. Getting this backwards produces the
exact opposite of what you want and looks like the selectors are broken.

*Container selectors square the whole bar.* `#navigator-toolbox`,
`#zen-sidebar-box`, `#zen-tabbox-wrapper`, `#zen-main-app-wrapper` and
`.browserSidebarContainer` all affect the outer panel. If you want it
round, remove every one rather than overriding them later in the file.

*Never use a descendant catch-all.*

```css
/* Don't */
#navigator-toolbox * { border-radius: 0 !important; }
```

It hits wrappers you meant to keep round and makes any selective choice
impossible afterwards.

*`overflow: hidden` and `clip-path` matter more than `border-radius`.*
When a blanket `border-radius: 0` visibly does nothing, the rounding is
usually on a parent wrapper with `overflow: hidden` or a `clip-path`,
not on the element you targeted. Add `clip-path: none !important` to
container rules.

*Selector names drift between Zen versions.* Some selectors above may
not exist on your build, which is harmless, and something unlisted may
stay round. Do not iterate on guessed IDs. Use the inspector.

**Finding the real selector:**

1. `about:config`, set `devtools.chrome.enabled` to `true`
2. `about:config`, set `devtools.debugger.remote-enabled` to `true`
3. Restart Zen
4. `Cmd-Opt-Shift-I` opens the Browser Toolbox. Accept the prompt.
5. Click the element-picker icon, top left
6. Click the stubborn corner

The Rules pane shows which selector sets `border-radius` and which
stylesheet it came from.

## Full teardown

```sh
defaults delete -g NSConvolutionOverride1
defaults delete -g NSSplitViewItemSidebarDefaultsToFloatingAppearance

sed -i '' -E 's/^radius=.*/radius=17.5/' ~/.config/omacosy/borders.conf
pkill -f omacosy-borders

rm "$HOME/Library/Application Support/zen/Profiles/<profile>/chrome/userChrome.css"
```

Then set `RING_RADIUS` back in `omacosy-safe-update`, quit Zen with
`Cmd-Q`, and log out.
