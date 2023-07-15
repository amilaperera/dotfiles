DIR     := $(shell pwd)
BASH    := $(DIR)/bash
NVIM    := $(DIR)/nvim.lua
VIM     := $(DIR)/vim
MISC    := $(DIR)/misc
HOMEDIR := ~/

# OS detection
OS=$(shell lsb_release -si)

ifeq ($(OS),Fedora)
	update=sudo dnf update -y
	command=sudo dnf install -y
else ifeq ($(OS),Debian)
	update=sudo apt-get update -y && sudo apt-get upgrade -y
	command=sudo apt-get install -y
else
	 $(error "Unsupported OS")
endif

.PHONY: all update bash nvim vim misc

all: bash nvim vim misc
	@echo
	@echo "All done. Good day!!!"

bash:
	@echo
	@echo "================= Installing bash configs ================="
	ln -sf $(BASH)/.bashrc $(HOMEDIR)
	ln -sf $(BASH)/.bash_profile $(HOMEDIR)
	ln -sf $(BASH)/.inputrc $(HOMEDIR)
	ln -sf $(BASH)/aep_bash_lib $(HOMEDIR)
	source ~/.bashrc

nvim:
	@echo
	@echo "================= Installing nvim configs ================="
	ln -sfT $(NVIM) $(HOMEDIR).config/nvim
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

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
	ln -sf $(MISC)/.agignore $(HOMEDIR)
	mkdir -p $(HOMEDIR).local && ln -sf $(MISC)/build_wrapper.sh $(HOMEDIR).local/

update:
	@echo
	@echo "==================== Upgrading system ===================="
	$(update)

