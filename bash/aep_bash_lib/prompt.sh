#!/bin/bash

NONE="\[\033[0m\]"    # unsets color to term's fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"

# different color if we're in a ssh session
HC=${C}
if [[ -n $SSH_CLIENT ]]; then
    HC="${EMB}"
fi

git_prompt_file=
if [ -f "$HOME/.local/git-prompt.sh" ]; then
    git_prompt_file="$HOME/.local/git-prompt.sh"
elif [ -f "/usr/share/git-core/contrib/completion/git-prompt.sh" ]; then
    git_prompt_file="/usr/share/git-core/contrib/completion/git-prompt.sh"
fi

if [[ -f $git_prompt_file ]]; then
    . $git_prompt_file
    export GIT_PS1_SHOWCOLORHINTS=true
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    export GIT_PS1_SHOWUPSTREAM="auto"
fi

function aep_update_history() { history -a ; history -c ; history -r ; }

function aep_prompt_command()
{
    aep_update_history
    if (($UID != 0)); then
        PS1="${C}\u${NONE}@${HC}\h${NONE}:${EMW}\w${NONE}$(__git_ps1) \\$ "
    else
        PS1="${EMR}\u${NONE}@${HC}\h${NONE}:${EMW}\w${NONE}$(__git_ps1) \\$ "
    fi
}

# Automatically trim long paths
export PROMPT_DIRTRIM=${PROMPT_DIRTRIM:-2}

export PROMPT_COMMAND=aep_prompt_command

PS2="${EMK}-${EMB}-${EMK}Continue${EMB}:${NONE} "
PS3=$(echo -e -n "\033[1;34m-\033[1;30m-Enter Your Option\033[1;34m:\033[0m ")
PS4="+xtrace $0[$LINENO]: "

# NONE K R G Y B M C W EMK EMR EMG EMY EMB EMM EMC EMW BGK BGR BGG BGY BGB BGM BGC BGW
