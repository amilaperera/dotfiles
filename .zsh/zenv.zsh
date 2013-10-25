#############################################################
# Author: Amila Perera
# File Name: env.zsh
#############################################################

#############################################################
# shell parameters
#############################################################

# setting PATH variable
path=($path $HOME/bin)

# setting term colors
[[ -z $TMUX ]] && export TERM=xterm-256color  # let tmux decide TERM to use,
                                              # otherwise set it to xterm-256color

# history related stuff
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

# setting editor
export VISUAL='vim'
export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export CVS_EDITOR="$VISUAL"
export FCEDIT="$VISUAL"

export LS_OPTIONS="--color=auto -F -h"

# loads rvm environment
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#############################################################
# zsh options
#############################################################

# changing directories
setopt autocd

# history
setopt appendhistory
setopt extendedhistory
setopt histignorealldups
setopt sharehistory
