#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: bash_alias.sh
#############################################################

#ls family aliases
alias ls="ls $LS_OPTIONS"            # add colors for filetype recognition
alias la="ls $LS_OPTIONS -Al"        # long list with hidden files
alias ll="ls $LS_OPTIONS -l"         # long listing
alias lld="ls $LS_OPTIONS -ld"       # long list of directories
alias lr="ls $LS_OPTIONS -lR"        # recursive ls
alias lc="ls $LS_OPTIONS -ltcr"      # sort by and show change time, most recent last
alias lu="ls $LS_OPTIONS -ltur"      # sort by and show access time, most recent last
alias lk="ls $LS_OPTIONS -lSr"       # sort by size, biggest last
alias lx="ls $LS_OPTIONS -lXB"       # sort by extension
alias lm="ls $LS_OPTIONS -Al | more" # pipe through 'more'
alias lz="ls $LS_OPTIONS -lZ"        # SELinux contexts
alias ldz="ls $LS_OPTIONS -ldZ"      # SELinux contexts for a directory

alias tree='tree -C'                 # nice alternative to recursive ls
alias treel='tree -C | less -R'      # nice alternative to recursive ls

alias h='history'
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

alias Q='exit'
alias quit='exit'
alias cls='clear'
alias clr='cd ~/ && clear'

alias _='sudo'

alias du='du -kh'
alias df='df -kTh'

alias more='less'
alias e='$VISUAL'       # edit in VISUAL, E is a function to edit in gvim in background
alias view='$VISUAL -R' # opens the file in readonly mode
alias vi='$VISUAL'

alias path="echo $PATH | tr ':' '\n'"
alias flist="find . -type f | sed -n 's/.*\/\(.*\)/\1/p'"

alias ct='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q  $(find . \( -name "*.c" -o -name "*.cpp" -o -name "*.cxx" -o -name "*.h" \) -type f)'

alias rmtmp='find . -name "*~" -type f | xargs -I {} rm -rf {}'

alias ag="ag --pager='less -R'"

# alias alternative to up() function
alias ,='cd -'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# this distro identification may not work for some systems
if [[ $distroname == "Ubuntu" ]]; then
	alias U='sudo apt-get update && sudo apt-get upgrade -y'
else
	alias U='sudo dnf update -y'
fi

# build & compiling related
alias mk='make clean && make'

alias t='tmux -2'
alias ta='tmux -2 attach-session -t'
alias tk='tmux -2 kill-session -t'
alias tl='tmux -2 list-sessions'

function current_git_branch()
{
  git branch --no-color | grep -E '^\*' | awk '{print $2}' \
    || echo "default_value"
}

# git aliases
alias ga='git add'
alias gb='git branch'
alias gca='git commit -v -a'
alias gst='git status'
alias gd='git diff'
alias gdca='git diff --cached'
alias gl='git pull'
alias ggpull='git pull origin "$(current_git_branch)"'
alias ggpush='git push origin "$(current_git_branch)"'
alias gpsup='git push --set-upstream origin "$(current_git_branch)"'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --stat'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --all'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

