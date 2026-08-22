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
else
	$(error Unsupported OS: $(OS_ID). Only Fedora, AlmaLinux, and Debian are supported.)
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

.PHONY: help base dev pydev github nvim ai-opencode ai-kilocode dotfiles build-alma build-fedora build-debian run-alma run-fedora run-debian

# Building a docker image using the corresponding docker file
define docker_build
	@img="$(1)"
	dockerfile="$(CURDIR)/Dockerfile.$$img"
	tag="dotfiles-test-$$img"
	if [[ ! -f "$${dockerfile}" ]]; then
		printf '%bError: Dockerfile.%s not found%b\n' "$(RED)" "$$img" "$(NC)"
		exit 1
	fi
	printf '%b========================================%b\n' "$(BLUE)" "$(NC)"
	printf '%bBuilding %s with tag: %s%b\n' "$(BLUE)" "$$img" "$$tag" "$(NC)"
	printf '%b========================================%b\n' "$(BLUE)" "$(NC)"
	if docker build -f "$${dockerfile}" -t "$${tag}" "$(CURDIR)"; then
		printf '%bPASS: %s%b\n' "$(GREEN)" "$$img" "$(NC)"
	else
		printf '%bFAIL: %s%b\n' "$(RED)" "$$img" "$(NC)"
		exit 1
	fi
endef

# Run the docker file
define docker_run
	@img="dotfiles-test-$(1)"
	if docker image inspect "$$img" >/dev/null 2>&1; then
		printf '%bRunning %s docker container...%b\n' "$(CYAN)" "$$img" "$(NC)"
		docker run -it --rm "$$img" /bin/bash
	else
		printf '%bError: Docker image %s not found. Please run %bmake build-%s%b first.%b\n' "$(RED)" "$$img" "$(YELLOW)" "$(1)" "$(RED)" "$(NC)"
	fi
endef

help:
	@printf '%b\n' "$(BOLD)$(CYAN)Usage:$(NC) make [target]"
	printf '\n'
	printf '%b\n' "$(BOLD)$(GREEN)Targets:$(NC)"
	printf ' %bbase%b         Install base packages (git, tmux, vim, curl, etc.)\n' "$(YELLOW)" "$(NC)"
	printf ' %bdev%b          Install development tools (compilers, cmake, etc.)\n' "$(YELLOW)" "$(NC)"
	printf ' %bpydev%b        Install Python dev tools and uv/uvx\n' "$(YELLOW)" "$(NC)"
	printf ' %bgithub%b       Install gh CLI and setup SSH authentication\n' "$(YELLOW)" "$(NC)"
	printf ' %bnvim%b         Install Neovim stable release from AppImage\n' "$(YELLOW)" "$(NC)"
	printf ' %bai-tools%b     Install AI coding assistants (opencode, kilocode)\n' "$(YELLOW)" "$(NC)"
	printf ' %bdotfiles%b     Clone dotfiles repo and set up configs\n' "$(YELLOW)" "$(NC)"
	printf ' %bbuild-alma%b   Build AlmaLinux Docker test image\n' "$(YELLOW)" "$(NC)"
	printf ' %bbuild-fedora%b Build Fedora Docker test image\n' "$(YELLOW)" "$(NC)"
	printf ' %bbuild-debian%b Build Debian Docker test image\n' "$(YELLOW)" "$(NC)"
	printf ' %brun-alma%b     Run AlmaLinux Docker test image\n' "$(YELLOW)" "$(NC)"
	printf ' %brun-fedora%b   Run Fedora Docker test image\n' "$(YELLOW)" "$(NC)"
	printf ' %brun-debian%b   Run Debian Docker test image\n' "$(YELLOW)" "$(NC)"
	printf ' %bhelp%b         Show this help message\n' "$(YELLOW)" "$(NC)"
	printf '\n'
	printf '%bDetected OS:%b %b%s%b\n' "$(BOLD)$(MAGENTA)" "$(NC)" "$(BLUE)" "$(OS_ID)" "$(NC)"
	printf '%bPackage manager:%b %b%s%b\n\n' "$(BOLD)$(MAGENTA)" "$(NC)" "$(BLUE)" "$(PKG_MANAGER)" "$(NC)"

base:
	@printf '%bInstalling base packages (%s)...%b\n' "$(CYAN)" "$(PKG_MANAGER)" "$(NC)"
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

github:
	@printf '%bInstalling GitHub CLI (gh)...%b\n' "$(CYAN)" "$(NC)"
	if [ "$(OS_ID)" = "fedora" ] || [ "$(OS_ID)" = "almalinux" ]; then
		sudo $(INSTALL) gh;
	elif [ "$(OS_ID)" = "debian" ]; then
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

nvim:
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

ai-opencode:
	@printf '%bInstalling opencode CLI...%b\n' "$(CYAN)" "$(NC)"
	curl -fsSL https://opencode.ai/install | bash
	printf '%bopencode CLI installed.%b Run %bopencode%b to start.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

ai-kilocode:
	@printf '%bInstalling kilocode CLI...%b\n' "$(CYAN)" "$(NC)"
	curl -fsSL https://kilo.ai/cli/install | bash
	printf '%bkilocode CLI installed.%b Run %bkilo%b to start.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

ai-tools: ai-opencode ai-kilocode
	@printf '\n%bAI tools installed successfully!%b You can now use %bopencode%b and %bkilo%b commands.\n' "$(GREEN)" "$(NC)" "$(YELLOW)" "$(NC)"

dotfiles:
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
	cd $$HOME/.dotfiles/config && $(MAKE) all
	printf '\n%bDotfiles configs setup complete!%b\n' "$(GREEN)" "$(NC)"

build-alma:
	$(call docker_build,alma)

run-alma:
	$(call docker_run,alma)

build-fedora:
	$(call docker_build,fedora)

run-fedora:
	$(call docker_run,fedora)

build-debian:
	$(call docker_build,debian)

run-debian:
	$(call docker_run,debian)
