
# Git credentials

- https://git-scm.com/docs/gitcredentials.html
- https://docs.gitlab.com/user/profile/personal_access_tokens/

## Custom credential helper (token stored in file)

Useful for GitLab HTTPS authentication without putting
the token in Git commands or shell history.

### 1. Store token

```bash
chmod 600 ~/.ssh/token
```
### 2. Create credential helper

```bash
echo -ne '
#!/bin/sh
case "$1" in
    get)
        echo "username=$USER"
        echo "password=$(cat ~/.ssh/token)"
        echo
        ;;
esac' > ~/.git-credential-token

chmod 700 ~/.git-credential-token
```
### 3. Configure Git

```bash
git config --global \
  credential.https://gitlab.example.com.helper \
  '!~/.git-credential-token'
```
### 4. Use normally

```bash
git clone https://gitlab.example.com/group/project.git
git pull
git push
```