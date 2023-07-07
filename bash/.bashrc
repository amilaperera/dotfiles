#!/bin/bash

# source the utility functions
source "$HOME/.bash/utility.sh"

BASH_PATH=${HOME}/.bash

# configuration files of the entire bash system
# NOTE: Order of the files getting sourced matters.
list="env prompt aliases func bm plugins completions"

for entry in ${list}; do
    if [ -f ${BASH_PATH}/$entry.sh ]; then
        source ${BASH_PATH}/$entry.sh
    elif [ -d ${BASH_PATH}/$entry ]; then
        # go to directory and source all the files ending with '.sh'
        for f in ${BASH_PATH}/$entry/*; do
            if [ "${f: -3}" == ".sh" ]; then
                source $f
            fi
        done
    fi
done

unset BASH_PATH list

# local environment
[ -f ~/.local/.local.bash ] && source ~/.local/.local.bash

# fzf install
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
