# Dotfiles installer — self-contained on purpose so it can be copied anywhere
# (e.g. /tmp) and run standalone: curl -o /tmp/Makefile ... && make dev
# Repo-only targets (config, test, dotfiles, docker) degrade gracefully outside a checkout.

# Directory containing this Makefile (repo root when run from a checkout).
ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Colors
NC := \033[0m
BOLD := \033[1m
RED := \033[91m
GREEN := \033[92m
YELLOW := \033[93m
BLUE := \033[94m
MAGENTA := \033[95m
CYAN := \033[96m

# Detect OS
OS_ID := $(shell . /etc/os-release && echo $$ID)

# Package manager by OS
ifeq ($(OS_ID),fedora)
	PKG_MANAGER := dnf
else ifeq ($(OS_ID),almalinux)
	PKG_MANAGER := dnf
else ifeq ($(OS_ID),debian)
	PKG_MANAGER := apt
else ifeq ($(OS_ID),ubuntu)
	PKG_MANAGER := apt
else
	$(error Unsupported OS: $(OS_ID). Only Fedora, AlmaLinux, Debian, and Ubuntu are supported.)
endif

SHELL := /bin/bash

# Run each target's recipe as a single shell script so variables and shell state
# are preserved across recipe lines.
.ONESHELL:

# -e option: exit immediately if a command exits with a non-zero status
# -u option: treat unset variables as an error and exit immediately
# -o pipefail option: the return value of a pipeline is the status of the last command to exit with a non-zero status,
#  or zero if no command exited with a non-zero status
#  -c option: read commands from the command string operand
.SHELLFLAGS := -eu -o pipefail -c

# Base packages (common across all supported OSes)
BASE_COMMON := curl git tree wget tmux vim luarocks gawk

# OS-specific base packages
BASE_FEDORA := fastfetch ripgrep btop htop bat xclip dictd
BASE_ALMA :=
BASE_DEBIAN := $(BASE_FEDORA)
BASE_UBUNTU := $(BASE_FEDORA)

# Dev packages (common)
DEV_COMMON := cmake unzip texinfo ninja-build

# OS-specific dev packages
DEV_FEDORA := @development-tools ccache gmp-devel mpfr-devel libmpc-devel isl-devel libzstd-devel clang clang-tools-extra llvm libcxx libcxx-devel lld nodejs npm
DEV_ALMA := gcc gcc-c++ make autoconf automake libtool gmp-devel mpfr-devel libmpc-devel libzstd-devel clang llvm lld nodejs npm
DEV_DEBIAN := build-essential pkg-config libevent-dev bison byacc npm nodejs libgmp-dev libmpfr-dev libmpc-dev libisl-dev libzstd-dev flex help2man clang clang-tools libc++-dev libc++abi-dev llvm lld
DEV_UBUNTU := $(DEV_DEBIAN)

# Python packages
PYTHON_FEDORA := python3 python3-pip python3-devel
PYTHON_ALMA := python python-pip python3-pip python3-devel
PYTHON_DEBIAN := python3 python3-pip python3-dev
PYTHON_UBUNTU := $(PYTHON_DEBIAN)

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
else ifeq ($(OS_ID),ubuntu)
	BASE_PKGS := $(BASE_COMMON) $(BASE_UBUNTU)
	DEV_PKGS  := $(DEV_COMMON) $(DEV_UBUNTU)
	PYTHON_PKGS := $(PYTHON_UBUNTU)
	INSTALL   := apt-get install -y
endif

.PHONY: help config test base dev pydev docker github use-ssh nvim tree-sitter ai-opencode ai-kilocode ai-tools dotfiles

help:
	@printf '%b\n' "$(BOLD)$(CYAN)Usage:$(NC) make [target]"
	printf '\n'
	printf '%b\n' "$(BOLD)$(GREEN)Targets:$(NC)"
	printf ' %bconfig%b       Link all configs (needs NAME=... EMAIL=...)\n' "$(YELLOW)" "$(NC)"
	printf ' %btest%b         Smoke-test config linking in an isolated HOME\n' "$(YELLOW)" "$(NC)"
	printf ' %bbase%b         Install base packages (git, tmux, vim, curl, etc.)\n' "$(YELLOW)" "$(NC)"
	printf ' %bdev%b          Install development tools (compilers, cmake, etc.)\n' "$(YELLOW)" "$(NC)"
	printf ' %bpydev%b        Install Python dev tools, uv/uvx, and conan\n' "$(YELLOW)" "$(NC)"
	printf ' %bdocker%b       Install Docker Engine (docker-ce, cli, compose, buildx)\n' "$(YELLOW)" "$(NC)"
	printf ' %bgithub%b       Install gh CLI and setup SSH authentication\n' "$(YELLOW)" "$(NC)"
	printf ' %buse-ssh%b      Switch this checkout to the GitHub SSH remote\n' "$(YELLOW)" "$(NC)"
	printf ' %bnvim%b         Install Neovim stable release from AppImage\n' "$(YELLOW)" "$(NC)"
	printf ' %btree-sitter%b  Install tree-sitter CLI binary\n' "$(YELLOW)" "$(NC)"
	printf ' %bai-tools%b     Install AI coding assistants (opencode, kilocode)\n' "$(YELLOW)" "$(NC)"
	printf ' %bdotfiles%b     Clone dotfiles repo and set up configs\n' "$(YELLOW)" "$(NC)"
	printf ' %bhelp%b         Show this help message\n' "$(YELLOW)" "$(NC)"
	printf '\n'
	printf '%bDocker tests:%b ./tests/docker.sh {build|dev|config|run|exec|list} [os|all]\n' "$(BOLD)$(MAGENTA)" "$(NC)"
	printf '\n'
	printf '%bDetected OS:%b %b%s%b\n' "$(BOLD)$(MAGENTA)" "$(NC)" "$(BLUE)" "$(OS_ID)" "$(NC)"
	printf '%bPackage manager:%b %b%s%b\n\n' "$(BOLD)$(MAGENTA)" "$(NC)" "$(BLUE)" "$(PKG_MANAGER)" "$(NC)"

config:
	@if [ ! -f "$(ROOT)config/Makefile" ]; then
		printf '%bError: config/Makefile not found. This target needs a dotfiles checkout.%b\n' "$(RED)" "$(NC)"
		exit 1
	fi
	@if [ -z "$(NAME)" ] || [ -z "$(EMAIL)" ]; then
		printf '%bError: NAME and EMAIL are both required. Pass them as: make config NAME="Your Name" EMAIL="your@email.com"%b\n' "$(RED)" "$(NC)"
		exit 1
	fi
	$(MAKE) -C "$(ROOT)config" all NAME="$(NAME)" EMAIL="$(EMAIL)"

test:
	@if [ ! -f "$(ROOT)tests/config-test.sh" ]; then
		printf '%bError: tests/config-test.sh not found. This target needs a dotfiles checkout.%b\n' "$(RED)" "$(NC)"
		exit 1
	fi
	NETWORK="$(NETWORK)" "$(ROOT)tests/config-test.sh"

base:
	@printf '%bInstalling base packages (%s)...%b\n' "$(CYAN)" "$(PKG_MANAGER)" "$(NC)"
	if [ "$(OS_ID)" = "almalinux" ]; then
		printf '%bEnabling EPEL repository (required for luarocks)...%b\n' "$(CYAN)" "$(NC)"
		sudo dnf install -y epel-release;
	fi
	sudo $(INSTALL) $(BASE_PKGS)
	printf '%bBase packages installed successfully!%b\n' "$(GREEN)" "$(NC)"

dev: base
	@printf '%bInstalling development packages (%s)...%b\n' "$(CYAN)" "$(PKG_MANAGER)" "$(NC)"
	sudo $(INSTALL) $(DEV_PKGS)
	printf '%bDevelopment packages installed successfully!%b\n' "$(GREEN)" "$(NC)"

pydev:
	@printf '%bInstalling Python packages (%s)...%b\n' "$(CYAN)" "$(PKG_MANAGER)" "$(NC)"
	sudo $(INSTALL) $(PYTHON_PKGS)
	printf '%bInstalling uv...%b\n' "$(CYAN)" "$(NC)"
	curl -LsSf https://astral.sh/uv/install.sh | sh
	printf '\n%buv and uvx installed.%b Run %bsource $$HOME/.local/bin/env%b or restart your shell.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"
	printf '%bInstalling conan...%b\n' "$(CYAN)" "$(NC)"
	# PEP 668 "externally managed" distros (Fedora 39+, Debian 12+, Ubuntu 23.04+)
	# reject plain pip installs; retry with --break-system-packages when supported.
	python3 -m pip install --user conan || python3 -m pip install --user --break-system-packages conan
	printf '\n%bconan installed.%b Run %b$$HOME/.local/bin/conan --version%b to verify.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

docker:
	@printf '%bInstalling Docker Engine (%s)...%b\n' "$(CYAN)" "$(PKG_MANAGER)" "$(NC)"
	if [ "$(OS_ID)" = "fedora" ] || [ "$(OS_ID)" = "almalinux" ]; then
		# Docker's AlmaLinux repo is published under "centos"; Fedora uses its own path.
		repo_os="$(OS_ID)"
		if [ "$(OS_ID)" = "almalinux" ]; then
			repo_os="centos"
		fi
		sudo curl -fsSL "https://download.docker.com/linux/$$repo_os/docker-ce.repo" -o /etc/yum.repos.d/docker-ce.repo
		sudo $(INSTALL) docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	elif [ "$(OS_ID)" = "debian" ] || [ "$(OS_ID)" = "ubuntu" ]; then
		sudo $(INSTALL) ca-certificates curl
		sudo install -m 0755 -d /etc/apt/keyrings
		sudo curl -fsSL "https://download.docker.com/linux/$(OS_ID)/gpg" -o /etc/apt/keyrings/docker.asc
		sudo chmod a+r /etc/apt/keyrings/docker.asc
		echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$(OS_ID) $$(. /etc/os-release && echo $$VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update
		sudo $(INSTALL) docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	fi
	if type -p systemctl >/dev/null; then
		printf '%bEnabling Docker service...%b\n' "$(CYAN)" "$(NC)"
		sudo systemctl enable --now docker
	fi
	if getent group docker >/dev/null; then
		sudo usermod -aG docker "$$(id -un)"
	fi
	docker --version
	printf '\n%bDocker installed.%b Log out and back in to run %bdocker%b without sudo.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

github:
	@printf '%bInstalling GitHub CLI (gh)...%b\n' "$(CYAN)" "$(NC)"
	if [ "$(OS_ID)" = "fedora" ] || [ "$(OS_ID)" = "almalinux" ]; then
		sudo $(INSTALL) gh;
	elif [ "$(OS_ID)" = "debian" ] || [ "$(OS_ID)" = "ubuntu" ]; then
		(type -p curl >/dev/null || sudo apt install curl -y) && sudo mkdir -p -m 755 /etc/apt/keyrings &&
		curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
			sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null &&
		sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
		echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
			sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null &&
		sudo apt update &&
		sudo $(INSTALL) gh
	fi
	printf '\n%bSetting up SSH authentication with GitHub...%b\n' "$(CYAN)" "$(NC)"
	printf 'This will open a browser to authenticate with GitHub.\n\n'
	gh auth login --hostname github.com --git-protocol ssh --web
	printf '\n%bVerifying authentication...%b\n' "$(CYAN)" "$(NC)"
	gh auth status
	printf '\n%bGitHub CLI setup complete.%b Run %bgh auth status%b to verify.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"
	if [ -d "$(ROOT).git" ]; then
		url=$$(git -C "$(ROOT)" remote get-url origin 2>/dev/null || true)
		case "$$url" in
			https://github.com/*)
				printf '\n%bNext:%b run %bmake use-ssh%b to switch this checkout from HTTPS to SSH.\n' "$(BOLD)" "$(NC)" "$(YELLOW)" "$(NC)"
				;;
		esac
	fi

use-ssh:
	@if [ ! -d "$(ROOT).git" ]; then
		printf '%bError: no git checkout found. Run this target from the dotfiles repository.%b\n' "$(RED)" "$(NC)"
		exit 1
	fi
	if ! url=$$(git -C "$(ROOT)" remote get-url origin 2>/dev/null); then
		printf '%bError: the origin remote is not configured.%b\n' "$(RED)" "$(NC)"
		exit 1
	fi
	case "$$url" in
		git@github.com:* | ssh://git@github.com/*)
			printf '%bAlready using SSH:%b %s\n' "$(GREEN)" "$(NC)" "$$url"
			;;
		https://github.com/*)
			repo=$$(printf '%s' "$$url" | sed -E 's#^https://github\.com/##; s#\.git$$##')
			git -C "$(ROOT)" remote set-url origin "git@github.com:$${repo}.git"
			printf '%bSwitched origin to:%b git@github.com:%s.git\n' "$(GREEN)" "$(NC)" "$$repo"
			;;
		*)
			printf '%bError: origin is not a GitHub HTTPS or SSH URL:%b %s\n' "$(RED)" "$(NC)" "$$url"
			exit 1
			;;
	esac
	git -C "$(ROOT)" remote -v

nvim: tree-sitter
	@printf '%bInstalling Neovim...%b\n' "$(CYAN)" "$(NC)"
	NVIM_ARCH=$$(uname -m);
	if [ "$$NVIM_ARCH" = "x86_64" ]; then
		NVIM_ARCH="x86_64"
	else
		printf '%bUnsupported architecture: %s%b\n' "$(RED)" "$$NVIM_ARCH" "$(NC)"
		exit 1
	fi
	APPIMAGE="nvim-linux-$$NVIM_ARCH.appimage"
	if [ -z "$(NVIM_TAG)" ]; then
		NVIM_TAG="stable"
	fi
	printf '%bVersion:%b %s\n' "$(MAGENTA)" "$(NC)" "$$NVIM_TAG"
	printf '%bDownloading %s...%b\n' "$(CYAN)" "$$APPIMAGE" "$(NC)"
	mkdir -p $$HOME/.local
	if ! curl -fSL "https://github.com/neovim/neovim/releases/download/$$NVIM_TAG/$$APPIMAGE" -o $$HOME/.local/$$APPIMAGE; then
		printf '%bFailed to download %s%b\n' "$(RED)" "$$APPIMAGE" "$(NC)"
		rm -f $$HOME/.local/$$APPIMAGE
		exit 1
	fi
	printf '%bMaking AppImage executable...%b\n' "$(CYAN)" "$(NC)"
	chmod u+x $$HOME/.local/$$APPIMAGE
	printf '%bExtracting AppImage...%b\n' "$(CYAN)" "$(NC)"
	cd $$HOME/.local && ./$$APPIMAGE --appimage-extract
	printf '%bCreating symlink...%b\n' "$(CYAN)" "$(NC)"
	mkdir -p $$HOME/.local/bin
	ln -sf $$HOME/.local/squashfs-root/usr/bin/nvim $$HOME/.local/bin/nvim;
	printf '\n%bNeovim installed successfully!%b Run %bnvim%b to start.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

tree-sitter:
	@printf '%bInstalling tree-sitter CLI...%b\n' "$(CYAN)" "$(NC)"
	TS_ARCH=$$(uname -m);
	if [ "$$TS_ARCH" = "x86_64" ]; then
		TS_BINARY="tree-sitter-linux-x64.gz"
	elif [ "$$TS_ARCH" = "aarch64" ]; then
		TS_BINARY="tree-sitter-linux-arm64.gz"
	else
		printf '%bUnsupported architecture: %s%b\n' "$(RED)" "$$TS_ARCH" "$(NC)"
		exit 1
	fi
	mkdir -p $$HOME/.local/bin
	if [ -f $$HOME/.local/bin/tree-sitter ]; then
		printf '%btree-sitter CLI already exists, skipping.%b\n' "$(YELLOW)" "$(NC)"
	else
		printf '%bDownloading %s...%b\n' "$(CYAN)" "$$TS_BINARY" "$(NC)"
		curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/$$TS_BINARY" | gzip -d > $$HOME/.local/bin/tree-sitter
		chmod +x $$HOME/.local/bin/tree-sitter
	fi
	TS_VERSION=$$($$HOME/.local/bin/tree-sitter --version);
	printf '%b%s installed.%b Run %btree-sitter --help%b to get started.\n' "$(GREEN)" "$$TS_VERSION" "$(NC)" "$(YELLOW)" "$(NC)"

ai-opencode:
	@printf '%bInstalling opencode CLI...%b\n' "$(CYAN)" "$(NC)"
	curl -fsSL https://opencode.ai/v2/install | bash
	printf '%bopencode CLI installed.%b Run %bopencode%b to start.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

ai-kilocode:
	@printf '%bInstalling kilocode CLI...%b\n' "$(CYAN)" "$(NC)"
	curl -fsSL https://kilo.ai/cli/install | bash
	printf '%bkilocode CLI installed.%b Run %bkilo%b to start.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

ai-tools: ai-opencode ai-kilocode
	@printf '\n%bAI tools installed successfully!%b You can now use %bopencode%b and %bkilo%b commands.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

dotfiles:
	@if [ -z "$(NAME)" ] || [ -z "$(EMAIL)" ]; then
		printf '%bError: NAME and EMAIL are both required. Pass them as: make dotfiles NAME="Your Name" EMAIL="your@email.com"%b\n' "$(RED)" "$(NC)"
		exit 1
	fi
	@printf '%bSetting up dotfiles...%b\n' "$(CYAN)" "$(NC)"
	if [ ! -d "$$HOME/.dotfiles" ]; then
		printf '%bCloning dotfiles repository...%b\n' "$(CYAN)" "$(NC)"
		if ssh -T git@github.com 2>&1 | grep -q "You've successfully authenticated"; then
			git clone git@github.com:amilaperera/dotfiles.git $$HOME/.dotfiles
		else
			printf '%bWARNING: SSH is not set up for GitHub. Falling back to HTTPS.%b\n' "$(YELLOW)" "$(NC)"
			git clone https://github.com/amilaperera/dotfiles.git $$HOME/.dotfiles
		fi
	else
		printf '%b%s directory already exists%b\n' "$(YELLOW)" "$$HOME/.dotfiles" "$(NC)"
	fi
	printf '%bSetting up personal dotfiles...%b\n' "$(CYAN)" "$(NC)"
	$(MAKE) -C "$$HOME/.dotfiles" config NAME="$(NAME)" EMAIL="$(EMAIL)"
	printf '\n%bDotfiles configs setup complete!%b\n' "$(GREEN)" "$(NC)"
