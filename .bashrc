#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: .bashrc
#
# Description:
# bash initialization file
# source configuration files from $HOME/.bash directory
#############################################################

# source the utility functions
source "$HOME/.bash/bash_utility.sh"

BASH_PATH=${HOME}/.bash

# configuration files of the entire bash system
# NOTE: Order of the files getting sourced matters.
config_file_list="bash_env bash_colors bash_prompt bash_alias bash_func bash_bm bash_comp"

for config_file in ${config_file_list}; do
	file=${BASH_PATH}/${config_file}.sh
	[ -f ${file} ] && source ${file}
done

# DR specific - BEGIN
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
unset LC_COLLATE
unset LD_LIBRARY_PATH
export TERM=xterm

export PYTHON_BUILD_CACHE_PATH="${PYENV_ROOT}/source"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell $PYTHON_2_VERSION $PYTHON_3_VERSION

alias build='perl /work/Build/Tools/Shared/Builder/builder.pl'

cd # take me to /home/builder
# DR specific - END

unset BASH_PATH config_file_list
