# Dotfiles

Personal Linux workstation bootstrap for Fedora, AlmaLinux, Debian, and Ubuntu.

| Distro | `make dev` |
| --- | --- |
| <img src="https://cdn.simpleicons.org/almalinux/0F4266" alt="AlmaLinux" width="24"> AlmaLinux | [![AlmaLinux make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=AlmaLinux%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |
| <img src="https://cdn.simpleicons.org/debian/A81D33" alt="Debian" width="24"> Debian | [![Debian make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=Debian%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |
| <img src="https://cdn.simpleicons.org/fedora/51A2DA" alt="Fedora" width="24"> Fedora | [![Fedora make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=Fedora%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |
| <img src="https://cdn.simpleicons.org/ubuntu/E95420" alt="Ubuntu" width="24"> Ubuntu | [![Ubuntu make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=Ubuntu%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |

## Full Fedora setup

Run as your normal user with `sudo` access.

### 1. Clone

```sh
sudo dnf install -y git make curl
git clone https://github.com/amilaperera/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Packages

```sh
make dev
```

Includes `make base`.

### 3. Tools

```sh
make pydev
make docker
make nvim
make ai-tools
```

- `pydev`: Python, uv, Conan
- `docker`: Docker Engine
- `nvim`: tree-sitter, Neovim
- `ai-tools`: opencode, kilocode

Log out and back in after Docker install.

### 4. GitHub (optional)

```sh
make github
make use-ssh
ssh -T git@github.com
```

`ssh -T` exits 1 on success. `make use-ssh` is safe if already SSH.

### 5. Configs

```sh
make config NAME="Your Name" EMAIL="you@example.com"
```

Links bash, nvim, tmux, vim, gdb, wezterm, and wallpapers. Writes `~/.gitconfig`.

Test safely:

```sh
make test
```

### 6. Reload

```sh
exec bash -l
```

Only have the Makefile? `make dotfiles NAME="Your Name" EMAIL="you@example.com"` clones and links.

## Useful targets

- `make help` — list targets
- `make config NAME=... EMAIL=...` — link configs
- `make test` — test configs in an isolated HOME; `NETWORK=1` includes downloads
- `make github` — install `gh`, authenticate over SSH
- `make use-ssh` — switch remote from HTTPS to SSH
- `make docker` — install Docker Engine
- `./tests/docker.sh build|dev|config|run|exec <os>` — Docker test environments
