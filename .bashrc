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
config_file_list="bash_env bash_colors bash_prompt bash_alias bash_func bash_fbm bash_comp"

for file in ${config_file_list}; do
	abs_file_path=${BASH_PATH}/${file}.sh
	[ -f ${abs_file_path} ] && source ${abs_file_path}
done

# fires up a tmux session with the user's name at start up
tmux_start $USER

unset BASH_PATH config_file_list
