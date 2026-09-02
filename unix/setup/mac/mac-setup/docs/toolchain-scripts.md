# Toolchain setup for a new macOS machine

This folder contains two scripts.

| Script | Installs | Configures |
| --- | --- | --- |
| `setup-node-toolchain.sh` | `fnm`, `pnpm`, Node | pnpm `config.yaml`, `~/.npmrc`, `~/.zshrc` |
| `setup-python-toolchain.sh` | `uv`, Python | `~/.config/uv/uv.toml`, `~/.config/pip/pip.conf`, `~/.zshrc` |

Neither script installs packages. Both are independent. Run one or both.

## What you need first

- macOS on Apple silicon or Intel
- Homebrew. Install it from https://brew.sh if it is missing.
- zsh as your shell. This is the default on macOS.

Do not run the script with `sudo`. It stops if you do.

## How to run them

1. Copy both files to the new machine.
2. Open Terminal and go to the folder that holds them.
3. Run the dry run first. It prints every action and changes nothing.

   ```bash
   DRY_RUN=1 bash setup-node-toolchain.sh
   DRY_RUN=1 bash setup-python-toolchain.sh
   ```

4. Read the output. If it is correct, run the scripts.

   ```bash
   bash setup-node-toolchain.sh
   bash setup-python-toolchain.sh
   ```

5. Open a new terminal, or run `exec zsh`.

# Node: setup-node-toolchain.sh

## Options

Set these variables on the command line.

| Variable | Default | Effect |
| --- | --- | --- |
| `NODE_VERSIONS` | `22 24` | Space separated list of Node versions to install. |
| `DEFAULT_NODE_VERSION` | `24` | The version that new shells use. |
| `DRY_RUN` | `0` | Set to `1` to print actions without doing them. |

Each entry in `NODE_VERSIONS` can be a major version such as `22`, an exact version such as `24.20.0`, or the word `lts`. fnm resolves a major version to its latest release.

Examples:

```bash
# Only the version from the old machine
NODE_VERSIONS=24.20.0 DEFAULT_NODE_VERSION=24.20.0 bash setup-node-toolchain.sh

# Three majors, with 22 as the default
NODE_VERSIONS="20 22 24" DEFAULT_NODE_VERSION=22 bash setup-node-toolchain.sh
```

`DEFAULT_NODE_VERSION` must match an entry in `NODE_VERSIONS`. The script does not check this. fnm fails at the last step if the version is not installed.

Each project still selects its own version through its `.node-version` or `.nvmrc` file. `FNM_VERSION_FILE_STRATEGY` is `local` by default, and the fnm line in `~/.zshrc` uses `--use-on-cd`, so the switch happens when you change directory.

Two more values are near the top of the script. Edit the file to change them.

- `PNPM_MIN_RELEASE_AGE_MINUTES` is `10080`, which is 7 days.
- `NPM_MIN_RELEASE_AGE_DAYS` is `7`.
- `IGNORE_SCRIPTS` is `true`.

## What the script does

1. Checks that you are on macOS and that Homebrew is available.
2. Installs `fnm` and `pnpm` with Homebrew. It skips a package that is already installed.
3. Adds the fnm line to `~/.zshrc`, unless fnm is already set up there.
4. Installs every Node version in the list and sets one of them as the default.
5. Writes the pnpm global config file.
6. Updates `~/.npmrc`.
7. Runs `pnpm setup` to create `PNPM_HOME`.
8. Prints the result of `pnpm config list`, `fnm env`, and `fnm ls`.

The script is idempotent. You can run it more than once with the same result.

## Files it creates or changes

| Path | Content |
| --- | --- |
| `~/Library/Preferences/pnpm/config.yaml` | `minimumReleaseAge` and `ignoreScripts` |
| `~/.npmrc` | `ignore-scripts` and `min-release-age` |
| `~/.zshrc` | The fnm line, and the pnpm lines from `pnpm setup` |
| `~/.local/share/fnm/` | Installed Node versions and aliases |
| `~/Library/pnpm/` | Global packages, binaries, and the content store |

The script makes a backup of any file it replaces. The backup name ends with `.bak-<timestamp>`.

## Why the two config files hold different settings

pnpm version 10 and later read only auth and registry settings from `.npmrc` files. Every other pnpm setting must go in a YAML file. This is why the script writes `ignoreScripts` to `config.yaml` for pnpm, and `ignore-scripts` to `.npmrc` for npm. The two files use different key names for the same idea.

`.npmrc` can hold auth tokens. The script keeps every line it does not manage, and it sets the file mode to `600`.

## Check the result

```bash
pnpm config list     # expect minimumReleaseAge and ignoreScripts
node --version
echo "$PNPM_HOME"    # expect ~/Library/pnpm
fnm ls
```

## Known problems

**fnm is set up twice.** The script looks for `fnm env` and for `fnm` in an oh-my-zsh `plugins=(...)` list in `~/.zshrc`. It skips its own line if it finds either one. If your fnm setup lives in a different file, such as `~/.zshenv` or an oh-my-zsh custom file, the script does not see it and adds a second setup. Remove one of the two.

**`ZDOTDIR` is set.** The script writes to `${ZDOTDIR:-$HOME}/.zshrc`. This is correct for most setups.

**`pnpm setup` fails.** The script prints a warning and continues. Run `pnpm setup` by hand after the script finishes.

**Homebrew is not on `PATH`.** The script looks in `/opt/homebrew/bin/brew` and `/usr/local/bin/brew`. It stops if it finds neither.

## What the script does not do

- It installs no global packages. Export the list from the old machine with `pnpm ls -g --depth 0` and reinstall by hand.
- It copies no auth tokens. Add those with `pnpm config set` after the script finishes.
- It copies no content store. The store rebuilds on the first install.

# Python: setup-python-toolchain.sh

`uv` handles Python versions, virtual environments, packages, and standalone tools. The defaults in this script reproduce the source machine.

## Options

| Variable | Default | Effect |
| --- | --- | --- |
| `UV_PYTHON_MINORS` | `3.8 3.9 3.10 3.11 3.12 3.13` | uv-managed Python, latest patch of each minor. |
| `UV_PYTHON_EXACT` | `3.9.22 3.10.17 3.11.12 3.12.10` | uv-managed Python at an exact patch level. |
| `BREW_PYTHONS` | `python@3.12 python@3.13 python@3.14` | Homebrew Python formulae. |
| `GLOBAL_PYTHON_PIN` | empty | A `uv python pin --global` value. Empty means no pin. |
| `UV_EXCLUDE_NEWER` | `7 days` | Age gate for package distributions. |
| `PYTHON_PREFERENCE` | empty | Writes `python-preference` only when you set it. |
| `CONFIGURE_PIP` | `1` | Set to `0` to leave `~/.config/pip/pip.conf` alone. |
| `UV_TOOLS` | `ruff pyrefly git-filter-repo marker-pdf browser-use` | Tools to install when `INSTALL_TOOLS=1`. |
| `INSTALL_TOOLS` | `0` | Set to `1` to install the tools above. |
| `DRY_RUN` | `0` | Set to `1` to print actions without doing them. |

Examples:

```bash
# uv-managed Python only, no Homebrew Python, plus the tools
BREW_PYTHONS="" INSTALL_TOOLS=1 PYTHON_PREFERENCE=only-managed \
  bash setup-python-toolchain.sh

# A smaller set of Python versions
UV_PYTHON_MINORS="3.12 3.13" UV_PYTHON_EXACT="" bash setup-python-toolchain.sh
```

## What the script does

1. Checks that you are on macOS and that Homebrew is available.
2. Installs `uv`, then checks it is version 0.9.17 or later.
3. Installs the Homebrew Python formulae.
4. Writes `~/.config/uv/uv.toml`.
5. Writes `~/.config/pip/pip.conf`.
6. Installs every uv-managed Python version in the two lists.
7. Runs `uv tool update-shell` and adds completions to `~/.zshrc`.
8. Installs the uv tools, only when `INSTALL_TOOLS=1`.
9. Prints the config file, the installed versions, and the uv directories.

## Files it creates or changes

| Path | Content |
| --- | --- |
| `~/.config/uv/uv.toml` | `exclude-newer` |
| `~/.config/pip/pip.conf` | `uploaded-prior-to` |
| `~/.zshrc` | Completion lines, and the `PATH` line from `uv tool update-shell` |
| `~/.local/share/uv/python/` | Downloaded Python versions |
| `~/.local/share/uv/tools/` | Installed tools |
| `~/.local/bin/` | Binaries of the installed tools |
| `~/.cache/uv/` | The uv cache |

## How the defaults were chosen

The source machine reported this state.

- `uv.toml` holds one line, `exclude-newer = "7 days"`. The script writes that line and nothing else. `python-preference` and `python-downloads` are left out because the machine does not set them.
- No `~/.python-version` file exists, so the script sets no global pin.
- `uv python list` showed twelve uv-managed builds. Six are the latest patch of a minor version. Four more are exact patch levels that sit beside a newer patch of the same minor, which happens when a project pins an exact version. Both lists are reproduced.
- Homebrew holds `python@3.12`, `python@3.13`, and `python@3.14`. The script reinstalls all three. Drop any that another formula pulled in as a dependency. Run `brew leaves | grep python` on the old machine to find out.
- `uv tool list` showed `ruff`, `pyrefly`, `git-filter-repo`, `marker-pdf`, and `browser-use`. These are packages, so the script skips them unless you ask.
- No `pip.conf` exists. Your pip is 26.2.1, which supports `uploaded-prior-to`, so the script adds the age gate that npm, pnpm, and uv already have.

## Two differences from the Node setup

**Config path.** uv reads the user config from `~/.config/uv/uv.toml` on macOS. pnpm reads its own from `~/Library/Preferences/pnpm/config.yaml`. The two tools do not agree on where macOS config belongs.

**Age gate name and unit.** Every package manager uses a different name and unit for the same idea.

| Tool | Key | Unit | Value for 7 days |
| --- | --- | --- | --- |
| pnpm | `minimumReleaseAge` | minutes | `10080` |
| npm | `min-release-age` | days | `7` |
| uv | `exclude-newer` | duration string | `"7 days"` |
| pip | `uploaded-prior-to` | ISO 8601 duration | `P7D` |

## Version requirements

- Relative durations for `exclude-newer` need uv 0.9.17 or later. The source machine runs 0.12.7. The script stops if uv is older.
- `uploaded-prior-to` in `pip.conf` needs pip 26.1 or later. The source machine runs 26.2.1.

## Check the result

```bash
uv --version
uv python list --only-installed
uv tool list
cat ~/.config/uv/uv.toml
uv python dir; uv tool dir; uv cache dir
```

## Known problems

**Four Python sources.** The source machine has a python.org framework build at 3.12.10, three Homebrew versions, and twelve uv-managed builds. `python3` resolves to the python.org build, because `/usr/local/bin` comes before `/opt/homebrew/bin` on `PATH`. Decide which one you want as `python3` on the new machine, and set `PATH` accordingly.

**The python.org build is not reproduced.** It is a `.pkg` installer, not a Homebrew package. Download it from https://python.org if you need it. uv and Homebrew both give you 3.12 without it.

**Exact patch versions drift.** `UV_PYTHON_EXACT` names four builds that were current when the list was made. A project that pins a version installs it on demand anyway, because `python-downloads` defaults to automatic. You can set `UV_PYTHON_EXACT=""` and let that happen.

**`uv self update` fails.** Homebrew owns the binary. Run `brew upgrade uv` instead.

**The age gate blocks a package you need now.** Add an exemption to `~/.config/uv/uv.toml`:

```toml
[exclude-newer-package]
my-internal-package = false
```

**A project ignores the age gate.** A project `pyproject.toml` or `uv.toml` overrides the user config.

## What the script does not do

- It installs no project packages.
- It skips uv tools unless `INSTALL_TOOLS=1`.
- It copies no index credentials. Add those to `~/.config/uv/uv.toml` after the script finishes.
- It copies no cache. The cache rebuilds on the first install.
- It does not restore the non-uv binaries in `~/.local/bin`, such as `claude`, `hermes`, `jan`, `unsloth`, `cua-driver`, `omacosy-*`, and `theme-*`. Copy those files by hand.
