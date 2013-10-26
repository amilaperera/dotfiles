#############################################################
# Author: Amila Perera
# File Name: zcomp.zsh
#############################################################

# Use modern completion system
autoload -Uz compinit
compinit

setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' menu select=1
