#!/bin/bash

#ls family aliases

# colors whenever possible
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias ip="ip -color=auto"

export LS_OPTIONS="--color=auto -F -h"
alias ls="ls $LS_OPTIONS"            # add colors for filetype recognition
alias la="ls $LS_OPTIONS -Al"        # long list with hidden files
alias ll="ls $LS_OPTIONS -lAFh"      # long listing
alias lld="ls $LS_OPTIONS -ld"       # long list of directories
alias lr="ls $LS_OPTIONS -lR"        # recursive ls
alias lc="ls $LS_OPTIONS -ltcr"      # sort by and show change time, most recent last
alias lu="ls $LS_OPTIONS -ltur"      # sort by and show access time, most recent last
alias lk="ls $LS_OPTIONS -lSr"       # sort by size, biggest last
alias lx="ls $LS_OPTIONS -lXB"       # sort by extension
alias lm="ls $LS_OPTIONS -Al | more" # pipe through 'more'
alias lz="ls $LS_OPTIONS -lZ"        # SELinux contexts
alias ldz="ls $LS_OPTIONS -ldZ"      # SELinux contexts for a directory

alias perm='stat --printf "%a %n \n "' # permission as number
alias tree='tree -C'                   # nice alternative to recursive ls
alias treel='tree -C | less -R'        # nice alternative to recursive ls

alias h='history'
alias hg='history | grep --color=always'
alias r='fc -s --'
alias j='jobs -l'

# processes
alias p='ps -ef'   # every process on the system
alias pz='ps -efZ' # SELinux contexts

alias B='bm'  # folder bookmark utility

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias cls='clear'
alias clr='cd ~/ && clear'

alias _='sudo'

alias e='$VISUAL'       # edit in VISUAL, E is a function to edit in gvim in background
alias view='$VISUAL -R' # opens the file in readonly mode
alias vi='$VISUAL'

alias ag="ag --pager='less -R'"
alias agcpp="ag -G '\.(cpp|cc|cxx|hpp|hh|hxx|h|ipp)$'"
alias agcm="ag -G '(cmake|CMakeLists.txt)$'"

# alias alternative to up() function
alias ,='cd -'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# NOTE: Supports just Debian & Fedora
if [[ $aep_distro_name == "Debian" ]]; then
    alias U='sudo apt-get update && sudo apt-get upgrade -y'
else
    alias U='sudo dnf update -y'
fi

alias src='source ~/.bashrc'

# fzf
alias f='"$EDITOR" $(fzf --preview "less {}")'

