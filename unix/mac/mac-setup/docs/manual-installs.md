# Installing the nine apps Homebrew dropped

Nine casks were taken out of `config/Brewfile`. This explains why, and
what to do about each one.

Check the live status first. It changes:

```sh
./lib/removed-casks.sh
```

That reads Homebrew's own record for each name and prints the current
status and the official homepage, so it stays right without anyone
editing this file.

---

## Why they went

Homebrew now audits every cask for Apple code signing and notarisation.
Casks that fail are deprecated, and removal from the official tap began
on **2026-09-01**. All nine failed that audit. The warning brew prints
names the cause directly: the cask does not pass the macOS Gatekeeper
check.

Two things follow.

**This is not about the apps being bad.** FreeTube and qBittorrent are
widely used open source projects. What they lack is an Apple Developer
certificate, which costs $99 a year and which many volunteer projects
decline to buy. Homebrew decided to stop shipping software that cannot
clear Apple's bar. That is a defensible policy and it is also why your
list shrank.

**A removed cask cannot be forced.** No flag installs it. The
`--no-quarantine` flag that used to help was itself removed in Homebrew
5.1. The app still exists; only the Homebrew route closed.

---

## The nine

| Cask | What it is | Where to get it |
| --- | --- | --- |
| `freetube` | YouTube client | freetubeapp.io, or GitHub releases |
| `imhex` | Hex editor for reverse engineering | GitHub, WerWolv/ImHex releases |
| `makemkv` | Blu-ray and DVD ripper | makemkv.com |
| `metasploit` | Penetration testing framework | the Rapid7 nightly installer, documented at docs.metasploit.com |
| `qbittorrent` | BitTorrent client | qbittorrent.org |
| `whisky` | Windows app runner | GitHub, Whisky-App/Whisky releases |
| `xld` | X Lossless Decoder, audio converter | the author's own site |
| `zenmap` | Graphical front end for Nmap | nmap.org, inside the macOS download |
| `xact` | Audio compression front end | already gone before this package |

Run `./lib/removed-casks.sh` for live links rather than trusting the
column above. URLs in a document rot; Homebrew's record does not.

**`whisky` is a special case.** It is discontinued upstream as well as
unsigned, so no further version is coming and no certificate will ever
be bought. If you want it, download it now.

---

## Installing one with the script

```sh
./lib/install-dropped.sh              # what it can and cannot do
./lib/install-dropped.sh freetube     # one app
./lib/install-dropped.sh --all        # each in turn, asking every time
```

Five of the nine can be automated, and `metasploit` two ways:

| Cask | How |
| --- | --- |
| `freetube` | latest release from `FreeTubeApp/FreeTube` |
| `imhex` | latest release from `WerWolv/ImHex` |
| `whisky` | latest release from `Whisky-App/Whisky` |
| `qbittorrent` | latest release from `qbittorrent/qBittorrent` |
| `metasploit` | the official Rapid7 nightly installer |
| `metasploit-src` | `git clone` into `~/src`, for working on the code |

It asks the GitHub API for the newest release, picks the macOS asset,
and then **stops and shows you the release tag, the file name, the size
and the full URL** before downloading anything.

That prompt is not a formality. These apps left Homebrew because nothing
signs them, so nothing else in the chain checks them either. The script
does not verify signatures, because there are none, and it does not
check hashes, because no list of known-good hashes exists once a project
is outside Homebrew. All it can do is show you where the file came from.
Read the URL. If it is not the repository you expect, answer no.

After installing, it runs `spctl -a -vv` on the app, shows you what
Gatekeeper says, and asks separately before clearing the quarantine tag.
Two questions, not one, because installing an app and telling macOS to
trust it are two different decisions.

It uses `ditto` rather than `cp` to copy the app out of the disk image,
which keeps extended attributes and code signatures intact.

For `metasploit` it clones rather than downloading a build, because that
is how the project is normally run and it updates with a pull. It does
not run `bundle install` for you; that compiles native gems and takes a
while, so it is left as a deliberate step.

**The repository names and asset patterns were written from knowledge,
not tested against the live API.** If one is wrong, you will see it as an
unexpected URL at the prompt, or as "no macOS asset matched". Neither
fails silently.

The other four have no release feed a script can read: `makemkv` and
`xld` are closed source with versioned download URLs that change every
release, `zenmap` comes inside the nmap installer rather than on its own,
and `xact` is gone.

---

## Installing one by hand

1. Download the `.dmg` or `.pkg` from the link.
2. Open it and drag the app to Applications.
3. macOS refuses the first launch, because these apps are unsigned and
   that is exactly why they left Homebrew.
4. Let it open:

```sh
./lib/unquarantine.sh FreeTube
```

Or right-click the app in Applications, choose Open, then Open Anyway.

`unquarantine.sh` shows you Gatekeeper's own assessment before it
changes anything, so you can see whether the app is unsigned, signed but
not notarised, or actually fine.

---

## Building from source

Five of the nine are open source and could be built: `metasploit`,
`imhex`, `freetube`, `qbittorrent` and `whisky`. That is not the same as
being worth building. Only one is normally run from source.

**`metasploit` has an official installer, and that is the right route.**
Rapid7 builds nightly installers for macOS. This is what the Metasploit
documentation tells you to run, and it is what
`./lib/install-dropped.sh metasploit` does:

```sh
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod 755 msfinstall
./msfinstall
```

It imports the Rapid7 signing key and sets up a package. The package
brings its own Ruby and PostgreSQL, so nothing fights the system Ruby.
It installs to `/opt/metasploit-framework/bin/msfconsole`, and on first
run it asks whether to set up a database and whether to add itself to
your PATH. Update it later with `msfupdate`.

If you prefer a normal double-click installer, the same build is a
`.pkg` at `https://osx.metasploit.com/metasploitframework-latest.pkg`,
with recent builds archived alongside it.

Note that the documented instructions download the script to a file and
then run it, rather than piping it straight into a shell. That leaves a
gap where you can read it first, and the script takes it: it offers to
show you the file before running anything.

**The git clone is the development route, not the normal one.** Use it
when you intend to edit modules or work on the framework itself:

```sh
./lib/install-dropped.sh metasploit-src
```

That clones into `~/src/metasploit-src`. You then need Ruby and
`bundler` yourself, and the Ruby that ships with macOS will fight you,
so use a Homebrew Ruby or a version manager. Gatekeeper never enters
into either route, because neither produces an `.app` bundle.

**`imhex` builds with cmake.** `brew install cmake ninja` first, then
follow the instructions in the repository. It has many dependencies and
takes a while. Downloading the release build is faster and gives the
same thing.

**The other seven, and why each one is a download instead.**

| Cask | Why not build it |
| --- | --- |
| `freetube` | Open source Electron. The release build is what your build would produce. |
| `qbittorrent` | Open source Qt. Same reason, and the Qt dependencies are heavy. |
| `whisky` | Open source Swift, but the build needs Xcode and would still be unsigned, so it is no better than the download. |
| `makemkv` | Closed source. There is nothing to build. |
| `xld` | Closed source. Same. |
| `zenmap` | Not a separate project. It ships inside the nmap installer. |
| `xact` | Gone. No source, no download, nothing to build. |

Note that `freetube`, `qbittorrent` and `whisky` are open source. They
are on this list because building them gains you nothing, not because
you cannot.

---

## Order of work

`./lib/removed-casks.sh` prints the status of all nine. Start with
anything marked `deprecated`, because those still have a working
download link today and may not next month. `whisky` is the clearest
case: discontinued upstream as well as unsigned, so no further version
is coming from anyone.

Anything marked `fine` needs nothing yet.

---

## If a tenth one goes

The apps stage prints every deprecation warning it sees at the end of
each run. When another cask joins this list, that is where it will
appear. Add its name to the `CASKS` list at the top of
`lib/removed-casks.sh` and it gets tracked with the others.
