#############################################################
# Author: Amila Perera
# File Name: alias.zsh
#############################################################

##ls family aliases
ls_options="--color=auto -F -h"
alias ls="ls $ls_options"            # add colors for filetype recognition
alias la="ls $ls_options -Al"        # long list with hidden files
alias ll="ls $ls_options -l"         # long listing
alias lld="ls $ls_options -ld"       # long list of directories
alias lr="ls $ls_options -lR"        # recursive ls
alias lc="ls $ls_options -ltcr"      # sort by and show change time, most recent last
alias lu="ls $ls_options -ltur"      # sort by and show access time, most recent last
alias lk="ls $ls_options -lSr"       # sort by size, biggest last
alias lx="ls $ls_options -lXB"       # sort by extension
alias lm="ls $ls_options -Al | more" # pipe through 'more'
alias lz="ls $ls_options -lZ"        # SELinux contexts
alias ldz="ls $ls_options -ldZ"      # SELinux contexts for a directory
alias tree='tree -C'                 # nice alternative to recursive ls
alias treel='tree -C | less -R'      # nice alternative to recursive ls

alias h='history -E 1'
alias r='fc -s --'
alias j='jobs -l'

# processes
alias p='ps -ef'   # every process on the system
alias pz='ps -efZ' # SELinux contexts

alias F='fbm'  # folder bookmark utility

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

alias Q='exit'
alias quit='exit'
alias cls='clear'
alias clr='cd ~/ && clear'

alias S='source'

alias du='du -kh'
alias df='df -kTh'

alias more='less'
alias e='$VISUAL'       # edit in VISUAL, E is a function to edit in gvim in background
alias view='$VISUAL -R' # opens the file in readonly mode
alias vi='$VISUAL'

alias flist="find . -type f | sed -n 's/.*\/\(.*\)/\1/p'"

alias ct='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q  $(find . \( -name "*.c" -o -name "*.cpp" -o -name "*.cxx" -o -name "*.h" \) -type f)'

alias rmtmp='find . -name "*~" -type f | xargs -I {} rm -rf {}'

## encoding conversion
alias nkfeuc='nkf -Lu -e --overwrite' # converts to EUC and overwrites the file
alias nkfutf='nkf -Lu -w --overwrite' # converts to UTF-8 and overwrites the file

## linking cunit and gcov when compiling
alias cunit='gcc -lcunit -lcurses -fprofile-arcs -ftest-coverage'

## build & compiling related
alias mk='make clean && make'

## start tmux
alias t='tmux'
alias ta='tmux attach-session -t'
alias tk='tmux kill-session -t'
alias tl='tmux list-sessions'

## start irb(interactive ruby shell)
alias R='irb'

