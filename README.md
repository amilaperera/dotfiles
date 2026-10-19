# Dotfiles

Personal dotfiles and scripts to bootstrap a Linux workstation (Fedora, AlmaLinux, RHEL, Debian, Ubuntu).

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
- `make build-<os>` / `make run-<os>` / `make exec-<os>` — Docker test images
- `make all NAME="Your Name" EMAIL="you@example.com"` — link configs (bash, nvim, tmux, git)

