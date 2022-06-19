#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: bash_func.sh
#############################################################

# path in a more readable manner
function path()
{
    echo $PATH | tr ':' '\n'
}

# keeps the csh users happy
function setenv()
{
    if [ $# -eq 2 ]; then
        eval $1=$2
        export $1
    else
        echo "Usage: setenv NAME VALUE" 1>&2
    fi
}

# fuzzy cd function
# NOTE: ignore-case does not work with fuzzy cd
function cdf()
{
    cd *$1*
}

# goes up in the directory hierachy
function up()
{
    : ${CDUPVALUEDEFAULT:=5} # set default value to 5 if not set externally

    local upvalue= upcount=0 cdupcount=0

    if (( $# > 1 )); then
        echo "Usage: up [numeric_value]" 1>&2
        return 101
    elif (( $# == 0 )); then
        # if no argument is supplied goes one level up
        upvalue="../"
    else
        # if one argument is supplied then go up the directory hierachy
        if(( $1 > $CDUPVALUEDEFAULT )); then
            # limits the maximum up levels to the value defined by CDVALUEDEFAULT
            cdupcount=$CDUPVALUEDEFAULT
        else
            cdupcount=$1
        fi
        # construct the upvalue string
        for (( upcount=0; upcount<$cdupcount; upcount++ )); do
            upvalue="$upvalue../"
        done
    fi

    cd "$upvalue" # use user define cd not builtin cd
    return 0
}

# histroy tail function
function ht()
{
    : ${HISTORYTAILDEFAULT:=30}
    if [  $# -eq 0 ]; then
        printf "%s\n" "Last $HISTORYTAILDEFAULT History Status ====>"
        history | tail -n $HISTORYTAILDEFAULT
    elif [  $# -gt 1 ]; then
        echo "Usage: ht <numerical value>"
    else
        printf "%s\n" "Last $1 History Status ====>"
        history | tail -n $1
    fi

    return $?
}

# history grep
function hig()
{
    # this function removes the default grep line number from the history which is troublsome
    # line number is given in GREP_OPTIONS variable
    history | egrep --color=always "${@}"
}

# Trivial command line calculator
function calc()
{
    awk "BEGIN {print \"The answer is : \" $*}";
}

# creates a new directory and cd to it
function take()
{
    mkdir -p -- "${1}" && cd -P -- "${1}"
}

# displays the umask in both permission bits and acl
function um()
{
    if (($# != 0)); then
        echo "Usage: um"
        return 101
    fi
    echo "umask is set as follows"
    umask && umask -S
}

# make backup file(s)
function bak()
{
    local ext="bak"
    if [[ "${1}" == "-o" ]]; then
        shift
        ext="orig"
    fi
    for file in "${@}"; do
        cp -f $file $file"."$ext
    done
}

# swap two files
function swap()
{
    local tempfile=swaptemp.$$
    mv -f "${1}" "${tempfile}" && mv -f "${2}" "${1}" && mv -f "${tempfile}" "${2}"
}

# opens firefox
function ff()
{
    firefox "${@}" 2>/dev/null &
}

# opens acroread
function pdf()
{
    acroread "${@}" 2>/dev/null &
}

# diff with colordiff
# in order to have bash completion worked properly you may have
# to comment the existing cdiff completion which is hardly used
# refer to /etc/bash_completion file
function cdiff()
{
    colordiff -puw "${@}" | less -R
}

# view man page in english
function engman()
{
    local lang=$LANG
    LANG=en_US.UTF8 && man "${@}"
    export LANG=$lang
}

# find man pages colorizing the matching result
function fman()
{
    apropos "$@" | grep -i --color=auto "$@"
}

# display ansi color combinations
# hacked from http://www.pixelbeat.org/docs/terminal_colours/
function color_codes()
{
    e="\033["
    vline=$(tput smacs 2>/dev/null; printf 'x'; tput rmacs 2>/dev/null)
    [ "$vline" = "x" ] && vline="|"

    #printf "${e}4m%80s${e}0m\n"
    printf "${e}1;4mf\\\\b${e}0m${e}4m none  white    black     red    green    yellow   blue    magenta    cyan  ${e}0m\\n"

    rows='brgybmcw'

    for f in 0 7 `seq 6`; do
        no=""; bo=""; p=""
        for b in n 7 0 `seq 6`; do
            co="3$f"; [ $b = n ] || co="$co;4$b"
            no="${no}${e}${co}m  ${p}${co} ${e}0m"
            bo="${bo}${e}1;${co}m${p}1;${co} ${e}0m"
            p=" "
        done
        fc=$(echo $rows | cut -c$((f+1)))
        printf "$fc $vline$no\nb$fc$vline$bo\n"
    done
}

# start tmux session
# NOTE: This function can be called in .bashrc
function tmux_start()
{
    local session_name= archey_cmd="archey"

    [ $# -eq 0 ] && session_name="$USER" || session_name=$1

    if _check_if_command_exists tmux; then
        if [[ "$TERM" != "screen-256color" ]]; then
            tmux attach-session -t "$session_name"
            if [ $? -ne 0 ]; then
                # if a $session_name named tmux session doesn't exist,
                # then create a new session
                tmux new-session -s "$session_name" -d # first create in detached mode
                tmux attach-session # attach the session
            fi
        fi
    fi
}

# display tmux colors
function tmux_colors()
{
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i}\n"
    done | less
}

# cd and list
cl()
{
    local ls_command="ls -al --color=auto -F -h"
    if (( $# == 0 )); then
        # if no argument is supplied, just ls
        eval $ls_command
    else
        # change the directory
        cd "$1"
        if (($? != 0)); then
            return $?
        fi
        # list the directory contents
        eval $ls_command
    fi
}

# view man pages in colors
# copied from https://wiki.archlinux.org/index.php/Man_Page
function man()
{
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;34m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[01;33;40m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[01;04;35m' \
        man "$@"
    }

