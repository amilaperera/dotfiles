# Detect OS
OS_ID := $(shell . /etc/os-release && echo $$ID)

# Package manager by OS
ifeq ($(OS_ID),fedora)
	PKG_MANAGER := dnf
else ifeq ($(OS_ID),almalinux)
	PKG_MANAGER := dnf
else ifeq ($(OS_ID),debian)
	PKG_MANAGER := apt
else
	$(error Unsupported OS: $(OS_ID). Only Fedora, AlmaLinux, and Debian are supported.)
endif

SHELL := /bin/bash

# -e option: exit immediately if a command exits with a non-zero status
# -u option: treat unset variables as an error and exit immediately
# -o pipefail option: the return value of a pipeline is the status of the last command to exit with a non-zero status,
#  or zero if no command exited with a non-zero status
#  -c option: read commands from the command string operand
.SHELLFLAGS := -eu -o pipefail -c

# Base packages (common across all supported OSes)
BASE_COMMON := curl git tree wget tmux vim

# OS-specific base packages
BASE_FEDORA := fastfetch ripgrep btop htop bat xclip dictd
BASE_ALMA :=
BASE_DEBIAN := $(BASE_FEDORA)

# Dev packages (common)
DEV_COMMON := cmake unzip texinfo ninja-build

# OS-specific dev packages
DEV_FEDORA := @development-tools ccache gmp-devel mpfr-devel libmpc-devel isl-devel libzstd-devel
DEV_ALMA := gcc gcc-c++ make autoconf automake libtool gmp-devel mpfr-devel libmpc-devel libzstd-devel
DEV_DEBIAN := build-essential pkg-config libevent-dev bison byacc npm nodejs libgmp-dev libmpfr-dev libmpc-dev libisl-dev libzstd-dev flex help2man

# Python packages
PYTHON_FEDORA := python3 python3-pip python3-devel
PYTHON_ALMA := python python-pip python3-devel
PYTHON_DEBIAN := python3 python3-pip python3-dev

# Resolve packages and install command based on detected OS
ifeq ($(OS_ID),fedora)
	BASE_PKGS := $(BASE_COMMON) $(BASE_FEDORA)
	DEV_PKGS  := $(DEV_COMMON) $(DEV_FEDORA)
	PYTHON_PKGS := $(PYTHON_FEDORA)
	INSTALL   := dnf install -y
else ifeq ($(OS_ID),almalinux)
	BASE_PKGS := $(BASE_COMMON) $(BASE_ALMA)
	DEV_PKGS  := $(DEV_COMMON) $(DEV_ALMA)
	PYTHON_PKGS := $(PYTHON_ALMA)
	INSTALL   := dnf install -y
else ifeq ($(OS_ID),debian)
	BASE_PKGS := $(BASE_COMMON) $(BASE_DEBIAN)
	DEV_PKGS  := $(DEV_COMMON) $(DEV_DEBIAN)
	PYTHON_PKGS := $(PYTHON_DEBIAN)
	INSTALL   := apt-get install -y
endif

.PHONY: help base dev pydev github nvim ai-opencode ai-kilocode dotfiles

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  base     Install base packages (git, tmux, vim, curl, etc.)"
	@echo "  dev      Install development tools (compilers, cmake, etc.)"
	@echo "  pydev    Install Python dev tools and uv/uvx"
	@echo "  github   Install gh CLI and setup SSH authentication"
	@echo "  nvim     Install Neovim stable release from AppImage (optional: NVIM_TAG=vX.XX)"
	@echo "  ai-tools Install AI coding assistants (opencode, kilocode)"
	@echo "  dotfiles Clone dotfiles repo and set up configs (bash, tmux, vim, etc.)"
	@echo "  help     Show this help message"
	@echo ""
	@echo "Detected OS: $(OS_ID)"
	@echo "Package manager: $(PKG_MANAGER)"

base:
	@echo "Installing base packages ($(PKG_MANAGER))..."
	sudo $(INSTALL) $(BASE_PKGS)

dev: base
	@echo "Installing development packages ($(PKG_MANAGER))..."
	sudo $(INSTALL) $(DEV_PKGS)

pydev:
	@echo "Installing Python packages ($(PKG_MANAGER))..."
	sudo $(INSTALL) $(PYTHON_PKGS)
	@echo "Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
	@echo "uv and uvx installed. Run 'source $$HOME/.local/bin/env' or restart your shell."

github:
	@echo "Installing GitHub CLI (gh)..."
	@if [ "$(OS_ID)" = "fedora" ] || [ "$(OS_ID)" = "almalinux" ]; then \
		sudo $(INSTALL) gh; \
	elif [ "$(OS_ID)" = "debian" ]; then \
		(type -p curl >/dev/null || sudo apt install curl -y) && \
		sudo mkdir -p -m 755 /etc/apt/keyrings && \
		curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
		sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
		echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
		sudo apt update && \
		sudo $(INSTALL) gh; \
	fi
	@echo ""
	@echo "Setting up SSH authentication with GitHub..."
	@echo "This will generate an SSH key and add it to your GitHub account."
	@echo ""
	gh auth login --hostname github.com --git-protocol ssh --web
	@echo ""
	@echo "Verifying authentication..."
	gh auth status
	@echo ""
	@echo "GitHub CLI setup complete. Run 'gh auth status' to verify."

nvim:
	@echo "Installing Neovim..."
	@NVIM_ARCH=$$(uname -m); \
	if [ "$$NVIM_ARCH" = "x86_64" ]; then \
		NVIM_ARCH="x86_64"; \
	else \
		echo "Unsupported architecture: $$NVIM_ARCH"; \
		exit 1; \
	fi; \
	APPIMAGE="nvim-linux-$$NVIM_ARCH.appimage"; \
	if [ -z "$(NVIM_TAG)" ]; then \
		NVIM_TAG="stable"; \
	fi; \
	echo "Installing version: $$NVIM_TAG"; \
	echo "Downloading $$APPIMAGE..."; \
	mkdir -p $$HOME/.local; \
	if ! curl -fSL "https://github.com/neovim/neovim/releases/download/$$NVIM_TAG/$$APPIMAGE" -o $$HOME/.local/$$APPIMAGE; then \
		echo "Failed to download $$APPIMAGE"; \
		rm -f $$HOME/.local/$$APPIMAGE; \
		exit 1; \
	fi; \
	echo "Making AppImage executable..."; \
	chmod u+x $$HOME/.local/$$APPIMAGE; \
	echo "Extracting AppImage..."; \
	cd $$HOME/.local && ./$$APPIMAGE --appimage-extract; \
	echo "Creating symlink..."; \
	mkdir -p $$HOME/.local/bin; \
	ln -sf $$HOME/.local/squashfs-root/usr/bin/nvim $$HOME/.local/bin/nvim; \
	echo "Neovim installed successfully. Run 'nvim' to start."

ai-opencode:
	@echo "Installing opencode CLI..."
	@curl -fsSL https://opencode.ai/install | bash
	@echo "opencode CLI installed. Run 'opencode' to start."

ai-kilocode:
	@echo "Installing kilocode CLI..."
	@curl -fsSL https://kilo.ai/cli/install | bash
	@echo "kilocode CLI installed. Run 'kilo' to start."

ai-tools: ai-opencode ai-kilocode
	@echo "AI tools installed. You can now use 'opencode' and 'kilo' commands."

dotfiles:
	@echo "Setting up dotfiles configs..."
	@if [ ! -d "$$HOME/.dotfiles" ]; then \
		echo "Cloning dotfiles repository..."; \
		git clone git@github.com:amilaperera/dotfiles.git $$HOME/.dotfiles; \
	else \
		echo "$$HOME/.dotfiles directory already exists"; \
	fi
	@echo "Setting up personal dotfiles..."
	@cd $$HOME/.dotfiles/config && $(MAKE) all
	@echo "Dotfiles configs setup complete."
