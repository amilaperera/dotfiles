#############################################################
# Author: Amila Perera
# File Name: .zshrc
#
# Description:
# zshell initialization file
# source configuration files from $HOME/.zsh directory
#############################################################

# setting zsh directory
ZSH=$HOME/.zsh

# add personal function & completion paths
[ -d $ZSH/functions ] && fpath=($ZSH/functions $fpath)
[ -d $ZSH/completions ] && fpath=($ZSH/completions $fpath)

# source utility functions
[ -f $ZSH/zutil.zsh ] && source $ZSH/zutil.zsh

# source files in the ZSH directory
files=(zenv zcolors zalias zprompt zcomp zfunc zfbm)
for config_file in $files; do
	source $ZSH/$config_file.zsh
done

# setting pluigns directory
ZSH_PLUGINS_DIR=$ZSH/plugins

# plugins
plugins=(rvm tmuxinator vundle git svn)

# source plugins in the plugins directory
for plugin in $plugins; do
	if [ -f $ZSH_PLUGINS_DIR/$plugin/$plugin.plugin.zsh ]; then
		fpath=($ZSH_PLUGINS_DIR/$plugin $fpath)
		source $ZSH_PLUGINS_DIR/$plugin/$plugin.plugin.zsh
	elif [ -f $ZSH_PLUGINS_DIR/$plugin/_$plugin ]; then
		fpath=($ZSH_PLUGINS_DIR/$plugin $fpath)
	fi
done

# load and run compinit after loading all the plugins
autoload -Uz compinit
compinit

# fires up a tmux session with the user's name at start up
tmux_start $USER
