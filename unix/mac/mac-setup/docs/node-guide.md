# Node.js Ecosystem Management Guide for macOS

## New Method: Install FNM (Fast Node Manager)

### Cleanup First

```bash
# Remove all the broken shit
sudo rm -rf /opt/homebrew/bin/node
sudo rm -rf /opt/homebrew/bin/npm
sudo rm -rf /opt/homebrew/bin/npx
sudo rm -rf /opt/homebrew/bin/pnpm
sudo rm -rf /opt/homebrew/bin/yarn
sudo rm -rf /opt/homebrew/bin/corepack

# Force uninstall everything
brew uninstall --ignore-dependencies --force node
brew uninstall --ignore-dependencies --force pnpm
brew uninstall --ignore-dependencies --force yarn

# Clean up any leftover shit
sudo rm -rf /opt/homebrew/lib/node_modules
sudo rm -rf /opt/homebrew/Cellar/node
sudo rm -rf /opt/homebrew/Cellar/pnpm
sudo rm -rf /opt/homebrew/Cellar/yarn

# Clean Homebrew cache
brew cleanup --prune=all
```

### The Problem with Homebrew + Node.js

**Why Homebrew Breaks Node.js:**

- Homebrew uses symlinks that break during updates
- Multiple Node.js sources create conflicts
- `brew upgrade` can orphan npm/pnpm/yarn
- System updates mess with `/opt/homebrew/bin` permissions

**Common Errors:**

```
env: node: No such file or directory
/opt/homebrew/bin/npm failed: exit status: 127
```

### The Solution: Separate Concerns

| Tool     | Purpose                     | Manager            | Why                             |
| -------- | --------------------------- | ------------------ | ------------------------------- |
| **fnm**  | Node.js versions            | Homebrew           | Lightweight, fast, reliable     |
| **npm**  | Package manager             | Comes with Node.js | Built-in, always compatible     |
| **pnpm** | Fast package manager        | npm global         | Stable, self-updating           |
| **yarn** | Alternative package manager | npm global         | Consistent across Node versions |

### Setup Commands

#### Initial Setup

```bash
# Remove Homebrew Node.js
brew uninstall --ignore-dependencies node npm pnpm yarn

# Install fnm
brew install fnm
echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc
source ~/.zshrc

# Install Node.js
fnm install --lts
fnm use lts-latest
fnm default lts-latest

# Install package managers
npm install -g pnpm yarn
```

#### Update Commands

```bash
# Update Node.js
fnm install --lts
fnm use lts-latest
fnm default lts-latest

# Update npm
npm install -g npm@latest

# Update pnpm
pnpm add -g pnpm

# Update yarn
npm install -g yarn@latest
```

## Key Benefits

✅ **No more broken symlinks**
 ✅ **Each tool updates independently**
 ✅ **Homebrew only manages fnm (stable)**
 ✅ **Easy version switching per project**
 ✅ **Works across macOS updates**

### Project-Level Version Control

```bash
# Create .nvmrc in project root
echo "20.15.0" > .nvmrc

# Auto-switch when entering directory
cd my-project  # fnm automatically switches to .nvmrc version
```

### Emergency Fix

If things break:

```bash
# Quick diagnosis
ls -la /opt/homebrew/bin/node
which node
echo $PATH | grep homebrew

# Quick fix (if using Homebrew)
brew unlink node && brew link node
```

### Best Practices

1. **Never install Node.js via Homebrew** - Use fnm
2. **Install package managers via npm** - Not Homebrew
3. **Pin LTS versions** - For stability
4. **Use .nvmrc files** - For project consistency
5. **Clean up old versions** - `fnm list` and `fnm uninstall`

### Troubleshooting

| Problem                           | Solution              |
| --------------------------------- | --------------------- |
| `node: No such file or directory` | `fnm use lts-latest`  |
| `pnpm not found`                  | `npm install -g pnpm` |
| `yarn not found`                  | `npm install -g yarn` |
| Wrong Node version                | `fnm use <version>`   |
| Global packages missing           | Reinstall via npm     |

------

**Remember:** Homebrew is great for system tools, terrible for language runtimes. Use the right tool for the right job!

To avoid this mess in the future, use **fnm** (Fast Node Manager) instead of Homebrew for Node.js:

```bash
# Install fnm via Homebrew (ironically, but this works better)
brew install fnm

# Add to your shell profile (~/.zshrc or ~/.bash_profile)
echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc

# Restart your terminal or source the file
source ~/.zshrc

# Install latest Node.js
fnm install --lts
fnm use lts-latest
fnm default lts-latest
```

### Why This Fixes It Forever

1. **fnm** manages Node.js versions independently of Homebrew
2. No more broken symlinks when Homebrew updates
3. Easy to switch between Node versions
4. Each project can use different Node versions with `.nvmrc` files

### Quick Check

After setup, verify everything works:

```bash
node --version
npm --version
which node
which npm
```

This approach eliminates the Homebrew + Node.js headache permanently. You'll never have to reinstall Node.js again because of Homebrew issues.

### How it works:

```bash
# After you do this:
brew uninstall node
brew install fnm

# Homebrew only manages fnm (the version manager)
# fnm manages all your Node.js versions
```

### What happens with updates:

**Homebrew updates:**

- `brew update` and `brew upgrade` will never touch your Node.js installations
- Homebrew only sees `fnm` (the tiny version manager tool)
- Your Node.js versions are stored in `~/.local/share/fnm/` - completely separate from Homebrew

**Node.js updates:**

```bash
# You control when and how to update Node
fnm install 20.15.0    # Install specific version
fnm install --lts      # Install latest LTS
fnm use 20.15.0        # Switch versions
```

### The beauty of separation:

- **Homebrew** manages system tools (git, wget, etc.)
- **fnm** manages Node.js versions
- They don't interfere with each other
- No more broken symlinks from Homebrew updates
- No more "node not found" after `brew upgrade`

### Your workflow becomes:

```bash
brew upgrade           # Updates everything except Node.js
fnm install --lts      # Updates Node.js when YOU want
```

This is exactly why every Node.js developer eventually stops using Homebrew for Node - the separation of concerns eliminates all the headaches you're experiencing.

### Updating Node.js with fnm

**Install latest versions:**

```bash
fnm install --lts          # Install latest LTS
fnm install latest         # Install latest stable (including non-LTS)
fnm install 22.5.1         # Install specific version
```

**Switch to the new version:**

```bash
fnm use lts-latest         # Use latest LTS
fnm use latest             # Use latest stable
fnm use 22.5.1             # Use specific version
```

**Set as default:**

```bash
fnm default lts-latest     # Make LTS your default for new shells
fnm default 22.5.1         # Make specific version your default
```

### Typical update workflow:

```bash
# See what you have
fnm list

# Install latest LTS
fnm install --lts

# Switch to it
fnm use lts-latest

# Test your projects work
npm test

# Make it your default
fnm default lts-latest

# Clean up old versions (optional)
fnm uninstall 20.15.0
```

### Pro tips:

- **Check what's available:** `fnm list-remote`
- **See current version:** `fnm current`
- **Auto-switch per project:** Create `.nvmrc` file with version number
- **Stay on LTS:** Most stable, gets security updates

So yeah, you manually control when to update Node.js instead of Homebrew randomly breaking it during system updates. Much better!

------

## OLD METHOD: Homebrew Node.js Installation & Management

### Basic Installation

```bash
# Install Node via Homebrew
brew install node

# Verify installation
which node     # Should show /opt/homebrew/bin/node
node -v        # Show version
npm -v         # Show npm version
```

### Managing Node with Homebrew

```bash
brew update              # Update Homebrew itself
brew upgrade node       # Upgrade Node
brew uninstall node    # Remove Node
brew list              # See installed packages
brew outdated          # See what needs updating
```

### Multiple Node Versions (using `n`)

```bash
# Install version manager
brew install n

# Install different Node versions
n lts           # Install LTS version
n latest        # Install latest version
n 18.17.0      # Install specific version

# Switch versions
n               # Interactive selection menu
n lts           # Use LTS version
n latest        # Use latest version

# List & Remove
n ls            # List installed versions
n rm 18.17.0    # Remove specific version
```

## Package Managers Comparison

### npm (Default with Node)

```bash
# Basic commands
npm install                 # Install all dependencies
npm install express        # Install specific package
npm install -g package     # Install global package
npm run start             # Run start script
npm update                # Update packages

# Create new project
npm init                  # Create package.json
```

### npx (Comes with npm)

```bash
# Execute packages without installing
npx create-react-app myapp
npx http-server
```

### yarn (Alternative Package Manager)

```bash
# Install yarn
npm install -g yarn

# Basic commands
yarn                      # Install dependencies
yarn add express         # Add package
yarn remove express      # Remove package
yarn start              # Run start script
```

## Best Practices

### Project Recognition

- `package-lock.json` → Use npm
- `yarn.lock` → Use yarn
- `pnpm-lock.yaml` → Use pnpm

### Rules

1. Don't mix package managers in same project
2. Stick to lock file in repository
3. npx can be used with any package manager

### Common Usage

```bash
# NPM Project
cd project-npm
npm install
npm start

# Yarn Project
cd project-yarn
yarn install
yarn start
```

### Updating Global Packages

```bash
# NPM
npm update -g

# Yarn
yarn global upgrade
```

## Tips

- Use Homebrew for Node.js installation on macOS
- Use `n` for version management
- Check lock files to determine project's package manager
- npx is useful for one-off command execution
- Keep package managers updated

Remember: Node versions and package managers can coexist, but use them separately per project!

------

On macOS, Homebrew's Node.js paths depend on your CPU architecture:

For Apple Silicon (M1/M2):

```bash
# Main executable
/opt/homebrew/bin/node

# Installation directory
/opt/homebrew/Cellar/node/

# Modules
/opt/homebrew/lib/node_modules/
```

For Intel Macs:

```bash
# Main executable
/usr/local/bin/node

# Installation directory
/usr/local/Cellar/node/

# Modules
/usr/local/lib/node_modules/
```

You can verify your path with:

```bash
which node           # Shows executable path
brew --prefix node  # Shows installation prefix
npm root -g         # Shows global modules path
```

To see all Node-related files:

```bash
brew list node      # Lists all files installed by Homebrew's Node
```