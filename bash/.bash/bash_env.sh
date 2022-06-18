#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: bash_env.sh
#############################################################

# set workinghost
export workinghost=$(uname)

# getting the Linux Distrubution Version
if [[ $workinghost == "Linux" ]]; then
    for path in ${PATH//:/ }; do
        if [ -f ${path}/lsb_release ]; then
            export distroname=$(lsb_release -si) # distro name
            export distrover=$(lsb_release -sr)  # distibution version
            export arch=$(uname -m)              # architecture
            break;
        fi
    done
fi

# set umask to 644 permission(files when touch) and 755(directories when mkdir)
# same can be done with umask u=rwx,g=rx,o=rx
UMASK=022
umask $UMASK

# returns 1 if a path contains a given directory
function _contains_path()
{
    local path=":${1}:" dir="${2}"
    case $path in
        *:$dir:*) return 1;;
        *)        return 0;;
    esac
}

# remove duplicate path entries and cleans PATH variable
function _clean_path()
{
    local path="${1}"
    local newpath= directory=
    [ -z $path ] && return 1

    # remove duplicate entries from the path
    for directory in ${path//:/ }; do
        [ -d $directory ] \
            && _contains_path "${newpath}" "${directory}" \
            && newpath="${newpath}":"${directory}"
        done

    # removes unnecessary : marks
    newpath=$(echo $newpath | sed -e 's/^:*//' -e 's/:*$//' -e 's/::*/:/g')
    # returns newpath
    echo $newpath
}

# sets path from the mypathstring selecting existing directories
function _set_path()
{
    # If you want to add a path permenantly add it to mypathstring
    # priority of the path is increased as the paths are added to the bottom of the mypathstring
    local mypatharray=(
    "/sbin"
    "/bin"
    "/usr/bin"
    "/usr/sbin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "$HOME/.local/bin"
)

local path=
for path in "${mypatharray[@]}"; do
    if [ -d "$path" ]; then
        _contains_path "$PATH" "$path" && PATH=$path:$PATH
    fi
done

PATH=$(_clean_path $PATH)
}

# sets and export PATH
_set_path
export PATH

# setting term colors
[ -z $TMUX ] && TERM=xterm-256color               # let tmux decide TERM to use,
# otherwise set it to xterm-256color

export HISTSIZE=5000                              # No of commands in history stack in memory
export HISTFILESIZE=5000                          # No of commands in history file
export HISTCONTROL=ignoredups:ignorespace         # omit dups and lines starting with spaces
export HISTTIMEFORMAT=': %Y-%m-%d_%H:%M:%S; '     # time stamp of histfile

export HOSTFILE='/etc/hosts'                      # use this file for hostname completion
export LC_COLLATE='C'                             # set traditional C sort order

export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS --clear-screen --QUIET"

# setting man page viewr to less
export MANPAGER="less"

#ulimit -S -c 0 >/dev/null 2>&1    # no core files by default
case $workinghost in
    CYGWIN*		)	export VISUAL='vim' ;;
    *			)	export VISUAL='vim' ;;
esac

export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export CVS_EDITOR="$VISUAL"
export FCEDIT="$VISUAL"

export LS_OPTIONS="--color=auto -F -h"

# shell behaviour adjustment with shopt options and set options
shopt -s histappend   # appends rather than overwrite history on exit
shopt -s cdspell      # correct minor spelling mistakes with cd command
shopt -s checkwinsize # update COLUMNS and LINES variables according to window size
shopt -s cmdhist      # makes multiline commands 1 line in history
shopt -s extglob      # extended globbing
shopt -s globstar     # ** globbing operator matches file names and directories recursively
shopt -s sourcepath   # The source builtin uses $PATH to find the file to be sourced
shopt -s autocd       # a name of a dir is executed as if it were the argument to cd
shopt -s histverify   # resulting history line is loaded to the readline editing buffer
                      # before being executed

shopt -u mailwarn     # disable mail warning
unset MAILCHECK

set -o ignoreeof    # Dont let Ctrl+D exit the shell
set -o noclobber    # prevents overwriting existing files
set -o vi           # specifies vi editing mode for command-line editing

# Start SSH Agent
# Reference: https://gist.github.com/bsara/5c4d90db3016814a3d2fe38d314f9c23
GITHUB_ID="${HOME}/.ssh/id_github_personal"
SSH_ENV="$HOME/.ssh/environment"
SSH_CONFIG="$HOME/.ssh/config"

function run_ssh_env
{
    . "${SSH_ENV}" > /dev/null
}

function start_ssh_agent
{
    echo "Initializing new SSH agent..."
    ssh-agent | sed 's/^echo/#echo/' >| "${SSH_ENV}"
    echo "succeeded"
    chmod 600 "${SSH_ENV}"

    run_ssh_env

    ssh-add "${GITHUB_ID}"
}

if [ -f "${GITHUB_ID}" ]; then
    if [ ! -f "${SSH_CONFIG}" ]; then
        echo "Host github.com
 Hostname github.com
 identityFile ~/.ssh/id_github_personal" >> ${SSH_CONFIG}
    fi

    if [ -f "${SSH_ENV}" ]; then
        run_ssh_env
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_ssh_agent
        }
    else
        start_ssh_agent
    fi
fi

