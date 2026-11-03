# Dotfiles

Personal dotfiles and scripts to bootstrap a Linux workstation.

| Linux distribution | `make dev` status |
| --- | --- |
| <img src="https://cdn.simpleicons.org/almalinux/0F4266" alt="AlmaLinux" width="24"> AlmaLinux | [![AlmaLinux make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=AlmaLinux%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |
| <img src="https://cdn.simpleicons.org/debian/A81D33" alt="Debian" width="24"> Debian | [![Debian make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=Debian%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |
| <img src="https://cdn.simpleicons.org/fedora/51A2DA" alt="Fedora" width="24"> Fedora | [![Fedora make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=Fedora%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |
| <img src="https://cdn.simpleicons.org/ubuntu/E95420" alt="Ubuntu" width="24"> Ubuntu | [![Ubuntu make dev](https://img.shields.io/github/check-runs/amilaperera/dotfiles/master?nameFilter=Ubuntu%20make%20dev&label=make%20dev)](https://github.com/amilaperera/dotfiles/actions/workflows/dev.yml) |

## Quick start — no clone needed

### Fedora

install make + curl, download the root Makefile to /tmp, run a target:

      sudo dnf install -y make curl && \
        curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/Makefile -o /tmp/Makefile && \
        cd /tmp && make dev

### Debian/Ubuntu

Same with `sudo apt-get update && sudo apt-get install -y make curl` instead of dnf.

## Useful make targets

- `make help` — list all targets (base, dev, pydev, github, nvim, tree-sitter, ai-tools, docker)
- `make docker` — install Docker Engine (docker-ce, cli, compose, buildx)
- `./tests/docker.sh build|run|exec|test <os>` — manage Docker test environments (alma, debian, fedora, ubuntu)
- `make config NAME="Your Name" EMAIL="you@example.com"` — link configs (bash, nvim, tmux, git)
