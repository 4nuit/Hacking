# Install order

`README.md` is the full guide. This is the placement cheatsheet.

Do these in order. Keep one terminal window open throughout, so you
always have a working shell to fix things from.

---

## 1. GUI apps need a usable PATH

```sh
sudo launchctl config user path /opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
launchctl getenv PATH
```

Fixes the btop Activity pill. README §2 and §4.

## 2. Clean the clone

```sh
cd ~/.local/share/omacosy && git status
```

If tracked files are modified, look at the diff before discarding:

```sh
git -C ~/.local/share/omacosy diff <file>
git -C ~/.local/share/omacosy restore <file>
```

## 3. Make `~/.zshrc` a real file

```sh
cp -P ~/.zshrc ~/.zshrc.symlink-backup
rm ~/.zshrc
printf '%s\n' 'source "$HOME/.local/share/omacosy/zsh/zshrc"' > ~/.zshrc
```

Stops third-party installers from writing into the git clone.
README §10.

## 4. `configs/zshrc.local` goes to `~/.zshrc.local`

```sh
cp ~/.zshrc.local ~/.zshrc.local.bak 2>/dev/null
cp configs/zshrc.local ~/.zshrc.local
zsh -n ~/.zshrc.local          # syntax check, silence is good
```

Your PATH entries, aliases, history settings and tool setup.

**Edit it for your machine before trusting it.** The paths in §1 of that
file are one person's. Remove what you do not have.

Two checks noted in its header:

```sh
grep -n shellenv ~/.zshrc
grep -nE "autosuggestions|syntax-highlighting" ~/.zshrc
```

Then open a **new terminal window** (not `exec zsh`) and verify:

```sh
which python pnpm fnm
pnpm --version        # want 11.x, not 9.x
```

## 5. Both scripts go to `~/.local/bin/`

```sh
cp bin/omacosy-safe-update bin/omacosy-harvest-zshrc ~/.local/bin/
chmod +x ~/.local/bin/omacosy-safe-update ~/.local/bin/omacosy-harvest-zshrc
ls -l ~/.local/bin/omacosy-*                # want -rwxr-xr-x on both
```

`omacosy-harvest-zshrc` needs no configuration. The hook that calls it
is already in `configs/zshrc.local` §8. It moves anything installers
append to `~/.zshrc` into `~/.zshrc.local` on the next shell start.

**Edit the four variables at the top** to match your ring radius and
border color.

Then point topgrade at it in `~/.config/topgrade.toml`:

```toml
[commands]
"omacosy" = "$HOME/.local/bin/omacosy-safe-update"

[git]
pull_predefined = false
arguments = "--autostash"
```

This is what makes updates stop destroying your customizations.
README §13.

Test it before relying on it:

```sh
~/.local/bin/omacosy-safe-update
```

## 6. `configs/ghostty-config` goes to Application Support

```sh
cp configs/ghostty-config \
   "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
```

Aci colors, 0.8 opacity, blur, and `quit-after-last-window-closed`.

**Not** `~/.config/ghostty/config`. That one is symlinked into the clone
and editing it blocks updates.

If Ghostty errors on launch, change `background-blur-radius` to
`background-blur`. It was renamed in newer builds.

## 7. `configs/starship.toml` is optional

Only if you want the powerlevel10k rainbow layout rebuilt in starship.
Do not overwrite `~/.config/starship.toml`, which is a symlink into the
clone. Redirect instead:

```sh
cp configs/starship.toml ~/.config/starship-mine.toml
```

`~/.zshrc.local` already sets `STARSHIP_CONFIG` to that path.

---

## Final check

```sh
launchctl getenv PATH                            # includes /opt/homebrew/bin
ls -l ~/.zshrc                                   # no arrow
which python pnpm fnm                            # config loading
pnpm --version                                   # 11.x
ghostty +show-config | head                      # colors applied
ls -l ~/.local/bin/omacosy-*                     # both executable
git -C ~/.local/share/omacosy status --short     # silence
```

The last one matters most. A dirty clone silently blocks every future
update.

## Cleanup once it all works

```sh
rm ~/.zshrc.symlink-backup ~/.zshrc.local.bak
```
