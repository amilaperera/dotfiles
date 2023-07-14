#!/bin/bash

# Creates a new directory and cd to it
function take() { mkdir -p -- "$1" && cd -P -- "$1"; }

# Mute output of a command
function quiet()
{
    "$@" &> /dev/null &
}

# Creates a zip archive of a folder
function zipf() { zip -r "$1".zip "$1" ; }

# Extract most know archives with one command
function extract()
{
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Takes the back up of a file with timestamp
function buf()
{
  local filename filetime
  filename=$1
  filetime=$(date +%Y%m%d_%H%M%S)
  cp -a "${filename}" "${filename}_${filetime}"
}

# Moves files to hidden folder in tmp, that gets cleared on each reboot
function del() { mkdir -p /tmp/.trash && mv "$@" /tmp/.trash ; }

# Find aliases
function ff() { find -iname "$@" -type f ; } # find files

# List files
function flist() { find $1 -type f | sed -n 's/.*\/\(.*\)/\1/p' ; }

# path in a more readable manner
function path() { echo $PATH | tr ':' '\n' ; }

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

function cdf() { cd *$1*; } # fuzzy cd

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

# History manipulation
#
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
function hig() { history | egrep --color=always "${@}" ; }

# Trivial command line calculator
function calc()
{
    awk "BEGIN {print \"The answer is : \" $*}";
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

    if aep_check_if_command_exists tmux; then
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
function cl()
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

# disk usage per directory
function usage()
{
    if [ "$(uname)" = "Linux" ]; then
        if [ -n "$1" ]; then
            du -h --max-depth=1 "$1"
        else
            du -h --max-depth=1
        fi
    fi
}

function top_ps_filter()
{
    local output_type=$1
    local n=$2
    local filter=$3

    if [[ "$output_type" == "--long" ]]; then
        ps aux --sort -%${filter} | head -n $n
    elif [[ "$output_type" == "--short" ]]; then
        ps -eo user,pid,ppid,cmd,comm,%mem,%cpu --sort=-%$filter | head -n $n
    else
        echo "top$3 [--short|--long] N"
        return 2
    fi
}

function topcpu() { top_ps_filter ${1:-"--short"} ${2:-10} "cpu" ; }
function topmem() { top_ps_filter ${1:-"--short"} ${2:-10} "mem" ; }

