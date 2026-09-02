# New Mac setup

This folder sets up a new Mac in one run. It installs the tools, the
applications and the desktop, and it puts every configuration file in
the right place.

Run this:

```sh
cd ~/Downloads && unzip -o mac-setup.zip && cd mac-setup && ./install.sh
```

Do a dry run first. It prints every action and changes nothing:

```sh
./install.sh --dry-run
```

**If nobody experienced is at the keyboard, run it in two parts
instead.** See "Running it without help" below.

The whole run takes 60 to 120 minutes, most of it downloads. You are at
the keyboard for about 10 minutes of that, in the first 20.

---

## Running it without help

The riskiest stage by a wide margin is omacosy. It is pre-1.0, it
compiles six Swift binaries, it asks for seven permission grants, and
`docs/omacosy-guide.md` lists nine ways it has misbehaved. Everything
else either works or fails quietly and gets reported.

So split the run. Part 1 leaves you a good Mac even if part 2 never
happens.

```sh
./install.sh --dry-run          # read this, change nothing
./install.sh --part1            # everything except the desktop
./lib/verify.sh                 # in a NEW terminal window
```

Log out and back in. Use the Mac for a day. Then:

```sh
./install.sh --part2            # omacosy, and the two stages after it
./lib/verify.sh
```

If part 2 goes wrong, the desktop can be removed without touching
anything part 1 installed:

```sh
cd ~/.local/share/omacosy && ./uninstall.sh
```

`uninstall.sh` is manifest-driven. It removes what this machine actually
gained and leaves what was already there. Or park it without removing
it:

```sh
omacosy-toggle off              # a plain Mac again
omacosy-toggle on
```

### Sending back what happened

```sh
./lib/report.sh
```

That writes one file, `~/Desktop/mac-setup-report.txt`, holding the
machine details, the `verify.sh` output, the last install log, the
installed formulae and casks, both PATHs, the shell config state, the
omacosy git state and which commands are missing. Send that one file.

It reads only. It holds no keys, no passwords and no personal files.
Read it first if you want to check.

### Watching from somewhere else

macOS has screen sharing built in and it needs no setup on either side.
In Messages, start a conversation with the other person, then choose
Ask to Share Screen from the Details menu. The person at the Mac
approves it, and can hand over control. This is the closest thing to
sitting next to them, and it costs nothing.

---

## macOS updates

Stage 1 asks Apple what is available and prints it. It installs nothing
by default.

That is deliberate. Installing a macOS update restarts the Mac, and a
restart in the middle of a 90 minute run kills it. Doing it first, or
not at all, is a decision worth making with your eyes open. Two ways:

```sh
# From System Settings, General, Software Update. The reliable way.
# Then start install.sh again.

./install.sh --update-macos     # or let the script do it and restart
```

On Apple silicon, an update that needs a restart also needs the password
of a volume owner, and `softwareupdate` cannot always collect that from
a script. If `--update-macos` fails, that is why, and System Settings
works.

**A major version upgrade is never installed.** The stage reports one if
Apple offers it, and stops there. omacosy is built and tested on macOS
26, and the square window corners rely on an undocumented key that Apple
can remove in any build. Upgrading to a new major version is a separate
decision, not a side effect of setting up a Mac.

---

## Before you start

- A Mac with macOS 26 or later. Apple silicon or Intel.
- An internet connection.
- Your macOS password. The script asks for it once, early.
- Do **not** use `sudo` to run the script. It stops if you do. It asks
  for the password itself when a step needs one.

---

## What it installs

| Group | What |
| --- | --- |
| System | Command line developer tools, Rosetta 2, Homebrew |
| Command line | git, mas, topgrade, fnm, pnpm, uv, go, rust, zsh plugins |
| Databases | MySQL, PostgreSQL, SQLite |
| Applications | Applite, and the 99 applications and fonts in `config/Brewfile` |
| Desktop | omacosy, with AeroSpace, Karabiner and the status bar |
| Agents | Claude Code, Codex, Hermes |
| Extras | gh, jq, fd, direnv, ffmpeg and more. See `config/Brewfile.extras`. |
| Editors | Zed with the Mixtape themes, and Neovim with LazyVim |
| Terminal | Ghostty, with the Aci colors, and the starship prompt |
| Browser | Zen, with the square chrome and the Betterfox settings |

---

## The stages

The script runs 23 stages in this order. Each one is skipped if it is
already done, so you can run the script again at any time.

| # | Stage | What it does |
| --- | --- | --- |
| 1 | `macos-update` | Looks for macOS updates. Installs none by default. |
| 2 | `xcode` | Command line developer tools. A macOS dialog opens. |
| 3 | `git-identity` | Asks for your name, email and SSH key. |
| 4 | `rosetta` | Rosetta 2, on Apple silicon only. |
| 5 | `homebrew` | Homebrew, if it is missing. |
| 6 | `launchd-path` | Gives background services a PATH that holds Homebrew. |
| 7 | `macos-defaults` | Square window corners. |
| 8 | `trackpad` | Replays `config/trackpad/`, if you made one. |
| 9 | `brew-core` | The command line tools and Applite. |
| 10 | `databases` | MySQL, PostgreSQL and SQLite. |
| 11 | `apps` | The applications from `config/Brewfile`, one at a time. |
| 12 | `extras` | The command line tools from `config/Brewfile.extras`. |
| 13 | `neovim` | Neovim, the LazyVim starter, and the plugins. |
| 14 | `omacosy` | Clones and installs the desktop. Asks for permissions. |
| 15 | `shell` | `~/.zshrc`, `~/.zshrc.local` and the two update scripts. |
| 16 | `dock` | Dock at the bottom, hidden. Menu bar hidden. |
| 17 | `node` | fnm, pnpm, Node 22 and 24, and their settings. |
| 18 | `python` | uv, the Python versions, ruff and pyrefly. |
| 19 | `rust` | rustup and the Rust toolchain. |
| 20 | `agents` | The agent harnesses from `config/agents.txt`. |
| 21 | `configs` | Ghostty, starship, topgrade, uv and the focus ring. |
| 22 | `zed` | Settings and the Mixtape themes. |
| 23 | `zen` | userChrome.css and user.js in the Zen profile. |

Run one stage on its own:

```sh
./install.sh --only zen
./install.sh --only configs,zed
```

---

## What you have to do yourself

Four things. The script prints them again at the end.

**1. Grant the permissions omacosy asks for.** Several macOS dialogs
appear during stage 9. Accessibility is the tiling itself and nothing
works without it. Karabiner-Elements also asks you to approve a driver
extension; that is what makes Caps Lock the Super key. The script prints
the full list with what each grant buys.

**2. Log out and back in.** Two settings only reach running programs
after that: the new PATH for background services, and the square window
corners.

**3. Set up Zen.** Zen makes its profile the first time it starts. If
Zen had no profile during the run, start Zen, quit it with `Cmd-Q`, then
run:

```sh
./lib/apply-zen-profile.sh
```

Quit Zen with `Cmd-Q` again afterwards. Zen reads `userChrome.css` and
`user.js` only when it starts. Closing the window is not enough.

**4. Sign in to the agents and start the databases.** Both sections
below have the exact commands.

Stage 2 also asks for your git name and email. That happens near the
start, not at the end.

---

## LLM agent harnesses

Three are installed. `config/agents.txt` holds the list, one agent per
line, with the command that installs it. Delete a line to skip an
agent. Add a line to add one.

| Agent | Command | Installed with |
| --- | --- | --- |
| Claude Code | `claude` | `brew install --cask claude-code` |
| OpenAI Codex | `codex` | `brew install --cask codex` |
| Hermes Agent | `hermes` | the Nous Research install script |

Each one needs an account or an API key, and each asks in its own way.
None of them can be set up without you:

```sh
claude          # opens the browser to sign in
codex login
hermes setup    # the wizard the installer skipped
```

Three things to know.

**DeepSeek Harness was tried and dropped.** It was judged not ready in
early 2026. The line is still in `config/agents.txt`, commented out with
that reason on it, so nobody re-adds it from memory without knowing it
was already tested. Remove the `#` to try it again.

Its entry was also removed from `config/zed/settings.json`. That entry
was `"type": "custom"` pointing at the `dsh` command, so with the
command gone Zed would have shown a broken agent in its panel. The ten
other agent servers there are `"type": "registry"`, which Zed fetches
itself, so none of them depend on anything this script installs. To put
it back, add this inside `agent_servers`:

```json
"DeepSeek Harness": {
  "type": "custom",
  "command": "dsh",
  "args": ["--profile", "acp"],
  "env": {}
},
```

**Pi is not in the list.** Zed needs nothing for it. `settings.json`
lists `pi-acp` with `"type": "registry"`, which means Zed downloads and
runs it itself. For a terminal Pi, the maintained fork is Oh My Pi,
which runs as `omp` and wants Bun as its runtime. There is a commented
line at the bottom of `config/agents.txt` for it. Check the project page
before you remove the `#`; the package name was not confirmed.

**The `hermes-desktop` cask is a different thing.** It is a community
GUI from `fathah/hermes-desktop` that wraps the same agent. Installing
the cask alone does not give you the `hermes` command. The app can run
the same installer for you from its own interface, so use one route or
the other, not both.

**Claude Code from Homebrew does not update itself.** `topgrade`
upgrades it along with everything else, which is enough. If you want it
to update on its own like the native install does, add this line to
`~/.zshrc.local`:

```sh
export CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE=1
```

---

## Extra developer tools

`config/Brewfile.extras` holds command line tools that were not in the
application list. None is required. Delete any line, or skip the file
with `--skip-extras`.

| Group | Tools |
| --- | --- |
| Git | `gh`, `git-delta`, `git-lfs` |
| Data | `jq`, `yq`, `fd`, `sd`, `tree`, `wget` |
| Projects | `direnv`, `just`, `watchexec`, `hyperfine`, `mkcert` |
| Shell scripts | `shellcheck`, `shfmt` |
| Signed commits | `gnupg`, `pinentry-mac` |
| Media | `ffmpeg`, `imagemagick`, `pandoc` |
| Comfort | `tealdeer`, `coreutils` |

Nothing here repeats what omacosy already wires up: fzf, eza, zoxide,
ripgrep, bat, lazygit and btop.

Two of them need one more line each.

```sh
# direnv, in ~/.zshrc.local
eval "$(direnv hook zsh)"

# pinentry-mac, so GPG asks for the passphrase in a macOS window
echo 'pinentry-program /opt/homebrew/bin/pinentry-mac' >> ~/.gnupg/gpg-agent.conf
```

---

## Trackpad, mouse and click

Nothing is replayed unless you make a `config/trackpad/` folder. There
is none in the package, because these settings are yours and I have no
way to know them.

To copy them from the Mac you already tuned, run this **on that Mac**:

```sh
./lib/export-trackpad.sh            # print what is set, change nothing
./lib/export-trackpad.sh --write    # print it and save it
```

The first form only reads. Look at the output, then run the second
form. It creates `config/trackpad/`. Copy the whole `mac-setup` folder
to the new Mac and stage 7 picks it up. On a Mac that is already set up:

```sh
./install.sh --only trackpad
```

### What it copies, and why two ways

macOS stores these settings in two different shapes, so the export has
two shapes as well.

| Shape | What is in it | How it comes back |
| --- | --- | --- |
| `*.plist` | whole preference domains: the built-in trackpad, an external Magic Trackpad, a Magic Mouse | `defaults import`, exact |
| `globals.sh` | single keys: tracking speed, natural scrolling, tap to click, force click, spring loading | one `defaults write` per line |

The single keys live in `NSGlobalDomain`, next to several hundred
unrelated settings. Copying that domain whole would carry your entire
system configuration across, so those keys are written one at a time.
`globals.sh` is plain text and every line is readable. Delete any line
you do not want.

Some keys are stored per machine, which macOS calls the current host.
Tap to click is one of them, which is why it is easy to miss when you
copy settings by hand. Both the normal and the per-machine copies are
read and replayed.

### The four gestures omacosy claims

The exporter also finds the Mission Control, App Exposé, Show Desktop
and Launchpad gesture switches, and writes them to
`dock-gestures.sh.disabled`. The name ends in `.disabled` and the stage
does not run it.

omacosy turns those four off deliberately. Its swipe daemon and macOS
Mission Control would otherwise both answer the same four fingers, and
workspace swiping stops working. omacosy's `uninstall.sh` puts them back
if you ever remove omacosy.

If you want them anyway, rename the file to `dock-gestures.sh`. It then
runs with everything else.

Stage 7 sits before omacosy for the same reason. Where the two overlap,
omacosy writes last and wins. Everything else is yours.

### Applying them

Log out and back in. A trackpad does not re-read its configuration
while it is in use, and restarting the preferences daemon is not
enough.

---

## Dock and menu bar

Two sources, and the exported one wins.

```sh
./lib/export-dock.sh            # print what is set, change nothing
./lib/export-dock.sh --write    # print it and save it to config/dock/
```

Run that on the Mac you already tuned. It writes `config/dock/`, holding
the Dock keys, the hot corners, the menu bar keys, and the Control
Centre and clock domains copied whole. The dock stage uses that
directory when it exists.

With no export, the stage falls back to `config/dock.sh`, a
hand-written default: Dock at the bottom, hidden with no delay, recent
apps off, menu bar hidden. Six settings, one per line, each commented.

The Dock contents themselves, meaning which apps sit in it, are written
to `com.apple.dock.full.plist.optional` and **not** replayed. Those
entries are file paths, and a path to an app that does not exist on the
other Mac shows as a question mark icon. Drop the `.optional` from the
name if you want them anyway.

Stage 16 runs it, and it runs **after** omacosy so these win. The
trackpad stage runs before omacosy for the opposite reason: there
omacosy has to win, because it needs the four-finger gestures free for
its own swipe daemon.

Hiding the menu bar pairs with omacosy, which draws its own status bar
with the clock, battery, wi-fi and workspaces. Without omacosy running
you lose sight of all of those until you move the pointer to the top of
the screen, so comment that line out if you are not using the desktop.

If the menu bar still shows after the run, log out and back in. Newer
macOS builds do not re-read that setting when SystemUIServer restarts.
The Dock re-reads its settings the moment it restarts, so that part is
immediate.

---

## Applications that will not install

Three different failures produce a similar-looking error, and only one
of them can be forced. Read what brew actually said, in
`~/.local/state/mac-setup/install-*.log`.

**Deprecated.** brew prints a warning and installs it anyway. This was
never the reason a cask failed.

**Disabled, or no longer available.** The cask has been removed from
Homebrew, usually because the project died or moved. No flag brings it
back. `--force` does not apply. Get the app from its own site, or find
the successor project.

---

## Applications that install but will not open

This is a separate problem from the one above, and it is the reason the
script cannot fix it for you.

An unsigned or un-notarised app installs without error. brew copies it
into Applications and reports success. The refusal comes later, the
first time you double-click it, with "cannot be opened because the
developer cannot be verified". By then the run finished hours ago, and
the app never appeared in the failed list because nothing failed.

So no amount of watching the install tells the script which apps this
will hit. It has to be told, or fixed afterwards.

**Afterwards, per app.** Right-click the app in Applications and choose
Open. macOS then offers Open Anyway and remembers. Or, after a refused
launch, System Settings, Privacy and Security, Open Anyway. Or from the
terminal:

```sh
./lib/unquarantine.sh FreeTube
./lib/unquarantine.sh              # lists apps carrying the tag
```

It asks before changing anything, and touches only the app you name.

Before it asks, it runs `spctl -a -vv` on the app and shows you what
Gatekeeper thinks. That step only assesses and writes nothing. Read it
before answering:

| What it says | What it means |
| --- | --- |
| `accepted, source=Notarized Developer ID` | Signed and notarised. Gatekeeper is not your problem, so removing the tag will not help. |
| `rejected, source=no usable signature` | Unsigned. This is the case the tag removal is for, and it is normal for open source apps. |
| `rejected, source=Unnotarized Developer ID` | Signed by someone, never submitted to Apple. Common with smaller commercial apps. |

None of those tells you the app is safe. They tell you who, if anyone,
put their name to it.

### Two things this deliberately does not do

**It does not run after the apps stage.** Stripping the tag from 107
freshly installed apps in one pass would defeat the only warning macOS
gives about software nobody has vetted, and it would do it for the 100
apps that had no problem in order to fix the handful that did. The tag
costs nothing until an app actually refuses to open. Fix them when they
refuse, one at a time, having looked at the assessment.

**It does not use `spctl --add`.** That writes a permanent exemption
into the system policy database, which outlives the app, survives you
deleting it, and applies machine-wide rather than to one copy of one
bundle. `xattr -dr` changes one attribute on one directory and is undone
by reinstalling the app. It is also worth knowing that `spctl --add` is
not what the Open Anyway button does; that button records approval in
the quarantine attribute itself. Whether `spctl --add` still works
without disabling SIP on current macOS I have not verified, which is a
second reason not to build on it.

`spctl --master-disable` turns Gatekeeper off for the whole machine.
Nothing here uses it and nothing should.

**In advance, for the next machine.** Add the cask's short name to
`config/casks-unquarantine.txt`, one per line, then:

```sh
./install.sh --only apps
```

The apps stage installs those casks normally, notes which `.app` bundle
appeared, and clears the tag from that one bundle. It compares the
contents of `/Applications` before and after the install rather than
guessing the app name from the cask name, because the two often differ.
`zen` installs `Zen Browser.app`.

It applies to the apps named and to nothing else. It does not disable
Gatekeeper, and XProtect, the malware scanner, still runs.

The list ships empty on purpose. The quarantine tag is the only warning
macOS gives about an app nobody has vetted. Adding a name is you saying
you have vetted it.

You will find `sudo xattr -rd com.apple.quarantine /Applications/*`
suggested in forums as a shortcut. A Homebrew maintainer answered that
one plainly: it makes the machine trust everything in the folder with no
reservations, so you would only run it if you fully trust every download
of every program in there. Name the apps instead.

### This used to be a brew flag, and no longer is

Earlier versions of this package used
`brew install --cask --no-quarantine`. **Homebrew removed that flag in
version 5.1.** Passing it now fails with `invalid option`. Asked what
replaces it, the Homebrew maintainers answered that post-processing is
required, the same as it would be if you downloaded and extracted the
app yourself. That is what the stage now does.

If you find older instructions using `--no-quarantine`, including
instructions from me in this conversation before I checked, they no
longer work.

**Deprecation has nothing to do with this.** A deprecated cask is one
Homebrew plans to remove. It says nothing about how the app is signed.
`metasploit` is deprecated and opens fine; FreeTube is not deprecated
and gets refused. Nothing in the script promotes a cask from one list to
the other, because that would guess wrong in both directions.

### Nine casks were taken out

Homebrew audits every cask for Apple code signing and notarisation,
deprecates the ones that fail, and began removing them from the official
tap on **2026-09-01**. Nine of yours failed that audit and are no longer
in `config/Brewfile`:

`freetube`, `imhex`, `makemkv`, `metasploit`, `qbittorrent`, `whisky`,
`xld`, `zenmap`, `xact`

Leaving them in would mean every run either printing eight warnings or
failing outright, with no fix available from inside Homebrew. A removed
cask cannot be forced by any flag.

The apps still exist. Only the Homebrew route closed.

```sh
./lib/removed-casks.sh
```

That checks the live status of each one and prints its official
homepage, read from Homebrew's own record rather than from a list in a
document.

To install them:

```sh
./lib/install-dropped.sh              # what it can and cannot do
./lib/install-dropped.sh freetube     # one app
```

Five of the nine come from their project's own GitHub releases, except
`metasploit`, which uses the official Rapid7 nightly installer. The script shows you the
release, file name, size and full URL and waits for a yes before
downloading, then asks again before clearing the quarantine tag. Nothing
signs these apps, so that prompt is the only check in the chain.

The other four have no release feed a script can read.
`docs/manual-installs.md` covers those, and which two are worth building
from source.

The apps stage still reports any deprecation warning it sees at the end
of a run, so a tenth cask going the same way will announce itself.

---

## Applications that install but will not open

This is a separate problem from the one above, and it is the reason the
script cannot fix it for you.

An unsigned or un-notarised app installs without error. brew copies it
into Applications and reports success. The refusal comes later, the
first time you double-click it, with "cannot be opened because the
developer cannot be verified". By then the run finished hours ago, and
the app never appeared in the failed list because nothing failed.

So no amount of watching the install tells the script which apps this
will hit. It has to be told, or fixed afterwards.

**Afterwards, per app.** Right-click the app in Applications and choose
Open. macOS then offers Open Anyway and remembers. Or, after a refused
launch, System Settings, Privacy and Security, Open Anyway. Or from the
terminal:

```sh
./lib/unquarantine.sh FreeTube
./lib/unquarantine.sh              # lists apps carrying the tag
```

It asks before changing anything, and touches only the app you name.

Before it asks, it runs `spctl -a -vv` on the app and shows you what
Gatekeeper thinks. That step only assesses and writes nothing. Read it
before answering:

| What it says | What it means |
| --- | --- |
| `accepted, source=Notarized Developer ID` | Signed and notarised. Gatekeeper is not your problem, so removing the tag will not help. |
| `rejected, source=no usable signature` | Unsigned. This is the case the tag removal is for, and it is normal for open source apps. |
| `rejected, source=Unnotarized Developer ID` | Signed by someone, never submitted to Apple. Common with smaller commercial apps. |

None of those tells you the app is safe. They tell you who, if anyone,
put their name to it.

### Two things this deliberately does not do

**It does not run after the apps stage.** Stripping the tag from 107
freshly installed apps in one pass would defeat the only warning macOS
gives about software nobody has vetted, and it would do it for the 100
apps that had no problem in order to fix the handful that did. The tag
costs nothing until an app actually refuses to open. Fix them when they
refuse, one at a time, having looked at the assessment.

**It does not use `spctl --add`.** That writes a permanent exemption
into the system policy database, which outlives the app, survives you
deleting it, and applies machine-wide rather than to one copy of one
bundle. `xattr -dr` changes one attribute on one directory and is undone
by reinstalling the app. It is also worth knowing that `spctl --add` is
not what the Open Anyway button does; that button records approval in
the quarantine attribute itself. Whether `spctl --add` still works
without disabling SIP on current macOS I have not verified, which is a
second reason not to build on it.

`spctl --master-disable` turns Gatekeeper off for the whole machine.
Nothing here uses it and nothing should.

**In advance, for the next machine.** Add the cask's short name to
`config/casks-unquarantine.txt`, one per line, then:

```sh
./install.sh --only apps
```

The apps stage installs those casks normally, notes which `.app` bundle
appeared, and clears the tag from that one bundle. It compares the
contents of `/Applications` before and after the install rather than
guessing the app name from the cask name, because the two often differ.
`zen` installs `Zen Browser.app`.

It applies to the apps named and to nothing else. It does not disable
Gatekeeper, and XProtect, the malware scanner, still runs.

The list ships empty on purpose. The quarantine tag is the only warning
macOS gives about an app nobody has vetted. Adding a name is you saying
you have vetted it.

You will find `sudo xattr -rd com.apple.quarantine /Applications/*`
suggested in forums as a shortcut. A Homebrew maintainer answered that
one plainly: it makes the machine trust everything in the folder with no
reservations, so you would only run it if you fully trust every download
of every program in there. Name the apps instead.

### This used to be a brew flag, and no longer is

Earlier versions of this package used
`brew install --cask --no-quarantine`. **Homebrew removed that flag in
version 5.1.** Passing it now fails with `invalid option`. Asked what
replaces it, the Homebrew maintainers answered that post-processing is
required, the same as it would be if you downloaded and extracted the
app yourself. That is what the stage now does.

If you find older instructions using `--no-quarantine`, including
instructions from me in this conversation before I checked, they no
longer work.

**Deprecation has nothing to do with this.** A deprecated cask is one
Homebrew plans to remove. It says nothing about how the app is signed.
`metasploit` is deprecated and opens fine; FreeTube is not deprecated
and gets refused. Nothing in the script promotes a cask from one list to
the other, because that would guess wrong in both directions.

### Deprecated, and why so many at once

Eight casks in `config/Brewfile` are marked deprecated, in place, on
their own lines:

`freetube`, `imhex`, `makemkv`, `metasploit`, `qbittorrent`, `whisky`,
`xld`, `zenmap`

This is not a coincidence and it is not eight separate stories.
Homebrew now audits every cask for Apple code signing and notarisation,
deprecates the ones that fail, and **began removing them from the
official tap on 2026-09-01**. The warning brew prints names the cause:
the cask does not pass the macOS Gatekeeper check.

So this list is a snapshot of a moving deadline, not a stable fact. Some
of the eight may already be gone by the time the script runs. A run
today will tell you which, and the apps stage prints every deprecation
warning it sees at the end, so the picture stays current without anyone
maintaining a list.

A disabled cask cannot be installed by any means, on any machine, with
any flag. When one goes, the app itself usually still exists; only the
Homebrew route closes. Get it from the project's own site, or from a
third-party tap if the community makes one.

If any of the eight matters, download a copy of the installer now, while
it is still fetchable. `whisky` is the one to act on first, being
discontinued upstream as well as unsigned.

### One cask is already gone

`xact` is disabled, not deprecated. Homebrew has removed it, so
`brew install --cask xact` fails and no flag changes that. It is
commented out in `config/Brewfile` rather than deleted, with the reason
next to it, so nobody adds it back in six months wondering why it is
missing. The count is now 107.

xAct was a front end for command line audio encoders. Those encoders are
still here: `ffmpeg` from `Brewfile.extras`, and `xld`, which is itself
deprecated.

---

## Neovim and LazyVim

`brew install neovim`, then the LazyVim starter cloned into
`~/.config/nvim`, then the plugins downloaded before you ever open the
editor. The first start is then immediate instead of a three-minute
wait.

The `.git` directory is deleted after the clone. The starter is a
template you edit, not a repository you track. If it stayed, topgrade
would try to pull it and every change you make would show as a dirty
repository.

Your own settings go in two places:

| Path | What |
| --- | --- |
| `~/.config/nvim/lua/config/` | options, keymaps, autocommands |
| `~/.config/nvim/lua/plugins/` | one file per plugin you add or change |

Do not edit anything under `~/.local/share/nvim`. That is plugin code
and `:Lazy update` overwrites it.

Inside nvim:

```
:LazyHealth      what is missing or misconfigured
:Lazy update     update the plugins
:LazyExtras      turn on the language packs you want
```

LazyVim needs a Nerd Font in the terminal. The application list
installs several, and the Ghostty config does not name a font, so
Ghostty uses the system default. If the icons show as boxes, set one in
`~/Library/Application Support/com.mitchellh.ghostty/config`:

```
font-family = MesloLGS NF
```

If Neovim was already set up on this machine, the stage moves the old
`~/.config/nvim`, `~/.local/share/nvim`, `~/.local/state/nvim` and
`~/.cache/nvim` aside with a `.bak-<timestamp>` name. Old plugin state
in any of the four makes LazyVim fail on first start in a way that looks
like a broken install.

`~/.zshrc.local` now sets `EDITOR` and `VISUAL` to `nvim`, so git, less
and anything else that opens an editor use it. Change that line if you
prefer something else.

---

## Git identity and SSH key

Stage 2 asks for these. It is the only stage that asks you anything, and
it runs early so all the typing happens in the first few minutes. After
that the run is unattended, apart from the omacosy permission dialogs.

It asks two questions:

```
Your name:  Ada Lovelace
Your email: ada@example.com
```

Both go into every commit he makes, and both are public in any
repository he pushes. Use the GitHub account's email, or GitHub's
no-reply address, which looks like
`12345678+name@users.noreply.github.com` and is under Settings, Emails.
The script rejects an empty name and anything that is not an email
address, and shows both back for confirmation before writing anything.

Then it makes an SSH key at `~/.ssh/id_ed25519` and lets `ssh-keygen`
ask about a passphrase. It writes `~/.ssh/config` so macOS loads the key
at login and remembers the passphrase in the keychain, instead of asking
after every reboot.

Run it again at any time:

```sh
./lib/setup-git.sh
```

It does nothing if the name, the email and the key are all already
there.

### What it writes

Five settings beyond the name and email. None is personal; each is
printed on screen as it is set.

| Setting | Why |
| --- | --- |
| `init.defaultBranch main` | new repositories start on `main`, and git stops warning that it chose for you |
| `push.autoSetupRemote true` | `git push` works on a new branch without `--set-upstream` |
| `pull.rebase false` | `git pull` merges, which is the safe answer when you are not sure |
| `credential.helper osxkeychain` | HTTPS passwords go in the macOS keychain |
| `core.excludesfile ~/.gitignore_global` | `.DS_Store` and `.env` ignored in every repository |

If `git-delta` is installed, which it is through `Brewfile.extras`, it
also becomes the diff viewer.

### Giving the key to GitHub

The script prints the public key and the command. With `gh` installed:

```sh
gh auth login
```

Pick GitHub.com, then SSH, then the key it offers. That uploads the key
and signs him in at once. Then check it:

```sh
ssh -T git@github.com
```

A reply saying he has authenticated but GitHub does not provide shell
access is the success message.

### Per project, if he needs it

The global file is a default, not a rule. Inside any repository,
`git config user.email work@example.com` writes to that repository's
`.git/config` and wins. For a whole directory of work repositories, put
this in `~/.gitconfig`:

```
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

---

## Databases

MySQL and PostgreSQL are installed but they do not run. This is on
purpose. The application list also installs DBngin, which runs its own
MySQL and PostgreSQL on the same ports, 3306 and 5432. Two servers on
one port means the second one fails to start, and the error message does
not say why.

Pick one of the two.

To use the Homebrew servers:

```sh
brew services start mysql
brew services start postgresql@18     # the script prints the version it installed
```

Or start them at login as part of the run:

```sh
./install.sh --only databases --start-databases
```

To use DBngin instead, open DBngin and create the servers there.

SQLite needs no server. Homebrew installs a newer `sqlite3` than the one
macOS ships. Homebrew calls this keg-only and does not link it into
`/opt/homebrew/bin`, so `~/.zshrc.local` puts it first on PATH. The
versioned PostgreSQL formulae are keg-only for the same reason, and
`~/.zshrc.local` finds the highest version present.

---

## Checking it worked

Open a **new terminal window**. Do not use `exec zsh`. Then:

```sh
./lib/verify.sh
```

It checks about 45 things and prints a pass, a warning or a failure for
each. It changes nothing.

---

## Where every file goes

| File in this folder | Where it lands | Owner |
| --- | --- | --- |
| `config/zshrc` | `~/.zshrc` | you |
| `config/zshrc.local` | `~/.zshrc.local` | you |
| `config/ghostty-config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | you |
| `config/starship-mine.toml` | `~/.config/starship-mine.toml` | you |
| `config/topgrade.toml` | `~/.config/topgrade.toml` | you |
| `config/uv.toml` | `~/.config/uv/uv.toml` | you |
| `config/zed/settings.json` | `~/.config/zed/settings.json` | you |
| `config/zed/themes/mixtape.json` | `~/.config/zed/themes/mixtape.json` | you |
| `config/zen/userChrome.css` | `<zen profile>/chrome/userChrome.css` | you |
| `config/zen/user.js` | `<zen profile>/user.js` | you |
| `config/Brewfile.extras` | not copied; read by the extras stage | you |
| `config/agents.txt` | not copied; read by the agents stage | you |
| `config/dock.sh` | not copied; run by the dock stage | you |
| `config/casks-unquarantine.txt` | not copied; read by the apps stage | you |
| `bin/omacosy-safe-update` | `~/.local/bin/` | you |
| `bin/omacosy-harvest-zshrc` | `~/.local/bin/` | you |

Files that belong to omacosy and that you must not edit:
`~/.local/share/omacosy/**`, `~/.config/ghostty/config`,
`~/.config/starship.toml` and `~/.config/omniwm/`. All four are
symlinks into the git clone. Editing through a symlink edits the clone,
and a clone with local changes blocks every future update.

This is why the personal Ghostty config and the personal starship config
sit at different paths. `docs/omacosy-guide.md` section 1 has the full
table.

---

## How updates work

Run `topgrade`. It updates Homebrew, the applications, the toolchains
and omacosy in one go, and then cleans up the Homebrew cache.

`~/.config/topgrade.toml` points at `~/.local/bin/omacosy-safe-update`,
not at `omacosy-update`. This matters. omacosy's own `install.sh` runs
again on every update, and on its own it would:

- replace `~/.zshrc` with a symlink again, and throw away anything an
  installer appended to it,
- overwrite the focus ring radius in `borders.conf`,
- leave build artifacts that block the next update.

`omacosy-safe-update` does five things around the real updater:

1. Copies `~/.zshrc` out, and puts it back afterwards with whatever an
   installer appended to it.
2. Clears any `skip-worktree` flags in the clone.
3. Resets the clone hard to upstream, after aborting any half-finished
   merge, rebase or cherry-pick.
4. Runs `omacosy-update`.
5. Writes your ring radius and border color back, and restarts the
   borders daemon.

**The clone is treated as disposable.** Nothing of yours is stored in
it, so there is nothing in it to lose. A hard reset clears modified
files, a diverged branch, a failed merge and a force push upstream, all
in one step, instead of one repair for each.

**`skip-worktree` is a trap and the script clears it.** It is the
obvious way to protect `config/omniwm/settings.toml`, which `theme-set`
writes into and which is tracked. It works until upstream edits the same
file. From then on every update stops with:

```
error: Entry 'config/omniwm/settings.toml' not uptodate. Cannot merge.
```

and nothing works again until the flag is removed by hand. So the script
clears every such flag on each run, lets the reset revert the file, and
writes the color back afterwards. `install.sh` clears the flags too, for
a clone carried over from an older setup.

**A modified `settings.toml` is expected.** Step 5 just wrote your color
into it and step 3 reverts it next time. `verify.sh` ignores that one
file and reports anything else in the clone as a failure.

`omacosy-safe-update` is a script and not a shell function on purpose.
topgrade runs commands from a non-interactive shell that never reads
`~/.zshrc.local`, so a function defined there would never run. That is
the bug that made earlier versions of the workaround appear to do
nothing.

Four values at the top of `bin/omacosy-safe-update` set the ring radius
and the border color. Edit them there and in `~/.local/bin/` if you
change your theme.

### Installer lines in `~/.zshrc`

Many tools install with a command that appends a line to `~/.zshrc`.
That is fine here. `~/.zshrc` is a real file you own.

`omacosy-harvest-zshrc` runs once per shell and moves anything below the
marker line into `~/.zshrc.local`. You never have to check. It skips
lines that are already there, backs both files up to
`~/.local/state/omacosy-harvest/`, and does nothing at all if `~/.zshrc`
is still a symlink.

One thing to know: a harvested line moves from the end of `~/.zshrc`,
which runs last, to `~/.zshrc.local`, which runs earlier. That changes
which copy of a program you get. If a tool ships its own Node or Python,
check with `which -a node python3 pnpm` after the move.

---

## Options

```
--dry-run           Print every action. Change nothing.
--skip-omacosy      Do not install or update the desktop.
--skip-apps         Do not install the 99 applications.
--skip-extras       Do not install the extra command line tools.
--skip-agents       Do not install the LLM agent harnesses.
--skip-neovim       Do not install Neovim and LazyVim.
--skip-git          Do not ask for your git name, email and SSH key.
--skip-trackpad     Do not replay the trackpad settings.
--skip-dock         Do not apply config/dock.sh.
--update-macos      Install pending macOS updates. This restarts the Mac.
--part1             Everything except omacosy. The safe half.
--part2             omacosy, and the shell and configs stages after it.
--lean              Install Python 3.12 and 3.13 only, not all ten
                    versions. Saves about 15 minutes and several GB.
--start-databases   Start MySQL and PostgreSQL at login.
--only <stages>     Run only these stages. Comma separated, no spaces.
--help              The full list.
```

You can also set any of these before the command:

```sh
NODE_VERSIONS="20 22 24" DEFAULT_NODE_VERSION=22 ./install.sh --only node
POSTGRES_FORMULA=postgresql@17 ./install.sh --only databases
CORNER_RADIUS=4 ./install.sh --only macos-defaults
```

`CORNER_RADIUS` is 0.1 by default, which is square. 4 looks like
Catalina. 9 to 10 looks like Sequoia. Do not use plain 0; it behaves
oddly in some applications. If you change it, change `RING_RADIUS` too:
the focus ring must be the window radius plus 0.5.

---

## Running it again

The script is safe to run again. It skips what is already installed.

It does replace the configuration files it owns, and it keeps a copy of
anything it replaces with a `.bak-<timestamp>` name next to the
original. So if you have edited `~/.zshrc.local` yourself, copy your
changes out of the backup afterwards.

---

## If something goes wrong

The log is at `~/.local/state/mac-setup/install-<timestamp>.log`.

The script does not stop when one stage fails. It reports the failed
stages at the end and tells you how to run one again.

Common problems:

**An application would not install.** The script lists them at the end.
Most often the cask moved or was renamed. Try `brew install --cask
<name>` and read what brew says.

**The btop pill in the status bar does nothing.** The background PATH
did not reach the bar. Log out and back in, or run:

```sh
launchctl kickstart -k gui/$(id -u)/com.omacosy.bar
```

**Corners are still round in VS Code, Slack or Discord.** Those draw
their own window frame and ignore the setting. Zen and Firefox follow
it. Test with TextEdit, which follows it reliably.

**`pnpm --version` says 9.x.** That is the copy bundled with fnm. pnpm
must load after fnm in `~/.zshrc.local`. Run `which -a pnpm` to see
every copy on PATH, in order.

**Gestures or the status bar stop working after an update.** A rebuilt
helper application lost its Accessibility grant. System Settings still
shows the toggle as on, and turning it off and on does not fix it. Remove
the entry with the minus button, restart the agent, and grant it again.
`docs/omacosy-guide.md` section 12 has the steps.

**Something is wrong with the shell and every window is broken.** Any
open terminal that still works can fix it:

```sh
cp ~/.zshrc.bak-<timestamp> ~/.zshrc
```

---

## Reference

The five documents in `docs/` are the original notes. They explain why
each choice was made.

| File | About |
| --- | --- |
| `docs/omacosy-guide.md` | Every omacosy problem and its permanent fix. 15 sections. |
| `docs/omacosy-install-order.md` | The short placement checklist. |
| `docs/node-guide.md` | fnm, pnpm and the Node ecosystem. |
| `docs/python-guide.md` | uv and Python environments. |
| `docs/toolchain-scripts.md` | The options for the two toolchain scripts. |
| `docs/manual-installs.md` | The nine apps Homebrew dropped, and how to install them. |

Scripts in `lib/` you can run on their own:

| Script | What |
| --- | --- |
| `lib/setup-git.sh` | Asks for the git identity and makes the SSH key. |
| `lib/export-trackpad.sh` | Reads this Mac's trackpad and click settings. |
| `lib/apply-zen-profile.sh` | Puts the two files in the Zen profile. |
| `lib/verify.sh` | Checks everything. Changes nothing. |
| `lib/report.sh` | Writes one file describing what happened, to send on. |
| `lib/unquarantine.sh` | Lets one named app open when macOS refuses it. |
| `lib/removed-casks.sh` | Live status and homepage of the nine dropped casks. |
| `lib/install-dropped.sh` | Installs five of them from their own releases. |
| `lib/export-trackpad.sh` | Reads this Mac's trackpad and click settings. |
| `lib/export-dock.sh` | Reads this Mac's Dock and menu bar settings. |

Two of the scripts in `lib/` are the originals with small changes. Both
changes are marked in the files with `ADAPTED FOR THIS PACKAGE`:

- They write to `~/.zshrc.local`, not `~/.zshrc`, because under omacosy
  `~/.zshrc` holds one line and nothing else.
- The Node script no longer runs `pnpm setup`, because
  `~/.zshrc.local` already sets `PNPM_HOME` in the correct place
  relative to fnm, and `pnpm setup` would add a second copy in the wrong
  place.
