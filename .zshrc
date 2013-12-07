#############################################################
# Author: Amila Perera
# File Name: .zshrc
#############################################################

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# my personal theme
ZSH_THEME="amifav"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git svn rails tmux tmuxinator ruby jump)

# source personal utility functions, which are used in
# custom zsh files
source $ZSH/custom/lib/zutil.zsh

# source main oh-my-zsh configuration file
source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/bin:/usr/local/bin:$PATH
export MANPATH="/usr/local/man:$MANPATH"

# start tmux on start
tmux_start
