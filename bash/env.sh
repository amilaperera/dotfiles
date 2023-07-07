#!/bin/bash

# set umask to 644 permission(files when touch) and 755(directories when mkdir)
# same can be done with umask u=rwx,g=rx,o=rx
UMASK=022
umask $UMASK

# Set PATH variable
# Reference: https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there
function aep_add_path()
{
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Now set path variable
path_array=("$HOME/.local/bin")

for p in ${path_array[@]}; do
    aep_add_path $p
done
export PATH
unset path_array

# Export some useful information about the distibution
if [[ $(uname) == "Linux" ]]; then
    if aep_command_exists lsb_release; then
        export aep_distro_name=$(lsb_release -si) # distro name
        export aep_distro_ver=$(lsb_release -sr)  # distibution version
        export aep_arch=$(uname -m)               # architecture
    fi
fi

# History manipulation
#
# Lines are appended to history file
shopt -s histappend
# Save multi-line commands as one command
shopt -s cmdhist
# Re-edit the command line for failing history expansions
shopt -s histreedit
# Re-edit the result of history expansions
shopt -s histverify
# save history with newlines instead of ; where possible
shopt -s lithist
# No of commands in history stack in memory (unlimited)
export HISTSIZE=
# No of commands in history file
export HISTFILESIZE=30000
# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"
# Don't record some commands
export HISTIGNORE="exit:ls:bg:fg:history:clear"
export HISTTIMEFORMAT='%F %T '

export LC_COLLATE='C'
export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS --clear-screen --QUIET"

# setting man page viewr to less
export MANPAGER="less"

# set VISUAL; we prioritize nvim
if aep_command_exists nvim; then
    export VISUAL='nvim'
else
    export VISUAL='vim'
fi

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

