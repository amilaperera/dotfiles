#!/bin/sh

function install_essentials()
{
	echo "Installing zsh..."
	sh -c "sudo apt-get install \
		zsh \
		tmux \
		tmuxinator \
		exuberant-ctags \
		ack \
		silversearcher-ag \
		tree \
		mc \
		lfm \
		htop \
		vim \
		weechat \
		-y"

	echo "Changing to zsh..."
	sh -c "chsh --shell /bin/zsh"
}

function install_dictionary()
{
	echo "Installing dictionary..."
	sh -c "sudo apt-get install \
		dictd \
		dict-gcide \
		dict-moby-thesaurus \
		-y"
}

function install_python_stuff()
{
}

########################################
# main
########################################

# install_essentials
# install_dictionary
