SHELL=/bin/bash

DIR     := $(shell pwd)
BASH    := $(DIR)/bash
NVIM    := $(DIR)/nvim
MISC    := $(DIR)/misc
HOMEDIR := ~/

.PHONY: all fzf bash nvim misc gitconfig

all: fzf bash nvim misc gitconfig
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
	ln -sf $(MISC)/.vimrc $(HOMEDIR)
	ln -sf $(MISC)/.tmux.conf $(HOMEDIR)
	ln -sf $(MISC)/.gdbinit $(HOMEDIR)
	mkdir -p $(HOMEDIR).local && ln -sf $(MISC)/build_wrapper.sh $(HOMEDIR).local/
	curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh >| $(HOMEDIR).local/git-prompt.sh

gitconfig:
	@echo
	@echo "================= Installing git config ================="
	$(DIR)/scripts/create_gitconfig.sh
