SHELL=/bin/bash

DIR     := $(shell pwd)
BASH    := $(DIR)/bash
NVIM    := $(DIR)/nvim
VIM     := $(DIR)/vim
MISC    := $(DIR)/misc
HOMEDIR := ~/

.PHONY: core all fzf bash nvim vim misc

core: bash nvim vim

all: core misc
	@echo
	@echo "All done. Good day!!!"

fzf:
	@echo
	@echo "================= Installing fzf ================="
	rm -rf ~/.fzf
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --key-bindings --completion --no-update-rc

bash: fzf
	@echo
	@echo "================= Installing bash configs ================="
	ln -sf $(BASH)/.bashrc $(HOMEDIR)
	ln -sf $(BASH)/.bash_profile $(HOMEDIR)
	ln -sf $(BASH)/.inputrc $(HOMEDIR)
	ln -sf $(BASH)/aep_bash_lib $(HOMEDIR)
	builtin source ~/.bashrc

nvim:
	@echo
	@echo "================= Installing nvim configs ================="
	ln -sfT $(NVIM) $(HOMEDIR).config/nvim

vim:
	@echo
	@echo "================= Installing vim configs =================="
	ln -sf $(VIM)/.vimrc $(HOMEDIR)

misc:
	@echo
	@echo "================= Installing misc configs ================="
	ln -sf $(MISC)/.tmux.conf $(HOMEDIR)
	ln -sf $(MISC)/.gdbinit $(HOMEDIR)
	ln -sf $(MISC)/.gitconfig $(HOMEDIR)
	mkdir -p $(HOMEDIR).local && ln -sf $(MISC)/build_wrapper.sh $(HOMEDIR).local/
	curl -L https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh >| $(HOMEDIR).local/git-prompt.sh

