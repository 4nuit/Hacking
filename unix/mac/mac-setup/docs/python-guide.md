# Using UV to Streamline Your Python Environment

UV is a great choice for modernizing your Python setup. It's significantly faster than pip and offers better dependency resolution. Here's how to install it, migrate your packages, and clean up your Python environment:

## 1. Install UV

```bash
# Using curl (recommended on macOS)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or using Homebrew
brew install uv
```

## 2. Verify Installation

```bash
uv --version
```

## 3. Migrate Your Existing Packages

First, let's export your current packages:

```bash
# Create a requirements file from your current environment
pip freeze > old_requirements.txt

# Filter out any packages with direct GitHub/local references if needed
cat old_requirements.txt | grep -v "git+" > clean_requirements.txt
```

Now, use UV to install them:

```bash
# Create a fresh virtual environment
python -m venv fresh_env
source fresh_env/bin/activate

# Install packages with UV
uv pip install -r clean_requirements.txt
```

## 4. Switch to UV for Project Management

For future projects, you can use UV directly:

```bash
# Create and activate a new virtual environment with UV
uv venv my_new_project
source my_new_project/bin/activate

# Install packages
uv pip install numpy pandas matplotlib
```

## 5. Clean Up Old Python Installations

### First, inspect what you have:

```bash
# List Python versions
ls -la /usr/local/bin/python*
ls -la /usr/bin/python*
ls -la ~/Library/Python/
ls -la /Library/Frameworks/Python.framework/Versions/

# List global packages
pip list
```

### Remove unused Python versions:

```bash
# Using Homebrew (if installed via brew)
brew uninstall --ignore-dependencies python@3.x

# For Python.org installations
# (Be careful with this, only if you're sure)
sudo rm -rf /Library/Frameworks/Python.framework/Versions/3.x
sudo rm -rf "/Applications/Python 3.x"
```

### Clean up unused pip caches:

```bash
# Clear pip cache
pip cache purge

# Remove leftover directories
rm -rf ~/.cache/pip
```

## 6. Switch to UV Completely

Add to your `.zshrc` or `.bash_profile`:

```bash
# UV aliases
alias pip="uv pip"
alias venv="uv venv"
```

## Best Practices Going Forward

1. **Always use virtual environments** for each project

2. **Use UV's lockfile feature** for reproducible builds:

   ```bash
   uv pip compile requirements.in -o requirements.lock
   uv pip sync requirements.lock
   ```

3. **Consider using pyproject.toml** for new projects:

   ```bash
   uv project init my_project
   ```

UV combines the speed of Rust with a familiar pip-like interface, giving you modern dependency management without learning a completely new workflow.