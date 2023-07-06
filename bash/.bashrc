#!/bin/bash

# source the utility functions
source "$HOME/.bash/bash_utility.sh"

BASH_PATH=${HOME}/.bash

# configuration files of the entire bash system
# NOTE: Order of the files getting sourced matters.
config_file_list="bash_env bash_prompt bash_alias bash_func bash_bm bash_comp"

for config_file in ${config_file_list}; do
    file=${BASH_PATH}/${config_file}.sh
    [ -f ${file} ] && source ${file}
done

unset BASH_PATH config_file_list

# local environment
[ -f ~/.local/.local.bash ] && source ~/.local/.local.bash

# fzf install
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
