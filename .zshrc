#############################################################
# Author: Amila Perera
# File Name: .zshrc
#
# Description:
# zshell initialization file
# source configuration files from $HOME/.zsh directory
#############################################################

ZSH=$HOME/.zsh

# add personal function & completion paths
[[ -d $ZSH/functions ]] && fpath=($ZSH/functions $fpath)
[[ -d $ZSH/completions ]] && fpath=($ZSH/completions $fpath)

# source all files in the ZSH directory
for config_file (zenv zalias zprompt zcomp zcolors zfunc zutil); do
	source $ZSH/$config_file.zsh
done
