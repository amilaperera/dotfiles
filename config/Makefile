SHELL=/bin/bash

DIR       := $(shell pwd)
BASH      := $(DIR)/bash
NVIM      := $(DIR)/nvim
GDB       := $(DIR)/gdb
GIT       := $(DIR)/git
TMUX      := $(DIR)/tmux
VIM       := $(DIR)/vim
WEZTERM   := $(DIR)/wezterm
WALLPAPER := $(DIR)/../wallpapers

HOMEDIR := ~/
UNAME   := $(shell uname -s)

.ONESHELL:

.PHONY: all fzf bash nvim misc wallpaper gitconfig

all: fzf bash nvim misc wallpaper gitconfig
	@echo
	@echo "All done. Good day!!!"
	@echo

fzf:
	@echo
	@echo "================= Installing fzf ================="
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --key-bindings --completion --no-update-rc

bash:
	@echo
	@echo "================= Installing bash configs ================="
	ln -sf $(BASH)/.bashrc $(HOMEDIR)
	ln -sf $(BASH)/.bash_profile $(HOMEDIR)
	ln -sf $(BASH)/.inputrc $(HOMEDIR)
	ln -sf $(BASH)/aep_bash_lib $(HOMEDIR)

nvim:
	@echo
	@echo "================= Installing nvim configs ================="
	mkdir -p $(HOMEDIR).config
	ln -sfT $(NVIM) $(HOMEDIR).config/nvim

misc:
	@echo
	@echo "================= Installing misc configs ================="
	ln -sf $(VIM)/.vimrc $(HOMEDIR)
	ln -sf $(TMUX)/.tmux.conf $(HOMEDIR)
	ln -sf $(GDB)/.gdbinit $(HOMEDIR)
	ln -sf $(WEZTERM)/.wezterm.lua $(HOMEDIR)
	curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh >| $(HOMEDIR).local/git-prompt.sh

wallpaper:
	@echo
	@echo "================= Installing wallpapers ================="
	rm -rf $(HOMEDIR)wallpapers
	ln -sfT $(WALLPAPER) $(HOMEDIR)wallpapers

ifndef NAME
$(error NAME is not set. Usage: make gitconfig NAME="Your Name" EMAIL="you@example.com")
endif

ifndef EMAIL
$(error EMAIL is not set. Usage: make gitconfig NAME="Your Name" EMAIL="you@example.com")
endif

gitconfig:
	@echo
	@echo "================= Installing git config ================="
	$(GIT)/create_gitconfig.sh --name "$(NAME)" --email "$(EMAIL)" -f
