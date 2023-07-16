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

# Pager related
export LESS="-R"
export PAGER="less -R"
# colorizing man pages via bat
batcmd=
if aep_command_exists bat; then
    batcmd=bat
elif aep_command_exists batcat; then
    batcmd=batcat
fi

if [ -n "$batcmd" ]; then
    export MANPAGER="sh -c 'col -bx | ${batcmd} -l man -p'"
    export MANROFFOPT="-c"
fi
unset batcmd

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
    export LC_CTYPE=${LANG%%:*}
fi

# set VISUAL; we prioritize nvim
if aep_command_exists nvim; then
    export VISUAL='nvim'
else
    export VISUAL='vim'
fi

export EDITOR="$VISUAL"
export FCEDIT="$VISUAL"

# shell behaviour adjustment with shopt options and set options
set -o vi             # specifies vi editing mode for command-line editing

set -o noclobber    # prevents overwriting existing files
set -o ignoreeof    # Dont let Ctrl+D exit the shell

shopt -s cdspell      # correct minor spelling mistakes with cd command
shopt -s checkwinsize # update COLUMNS and LINES variables according to window size
shopt -s extglob      # extended globbing
shopt -s globstar     # ** globbing operator matches file names and directories recursively
shopt -s sourcepath   # The source builtin uses $PATH to find the file to be sourced

# Prepend cd to directory names automatically
shopt -s autocd 2>/dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

shopt -u mailwarn     # disable mail warning
unset MAILCHECK

# This defines where cd looks for targets
CDPATH=".:~:~/work"
