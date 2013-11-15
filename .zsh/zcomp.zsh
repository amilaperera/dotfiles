#############################################################
# Author: Amila Perera
# File Name: zcomp.zsh
#############################################################

setopt auto_menu
setopt complete_in_word
setopt completealiases
setopt always_to_end

# enable menu selection
zstyle ':completion:*' menu select
# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# use exported LS_COLORS for completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
