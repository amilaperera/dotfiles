#!/bin/sh

install_command=

function install()
{
	sh -c "sudo ${install_command} ${@} -y"
}

function install_essentials()
{
	echo "Installing essentials..."
	essential_pkgs="zsh \
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
		wget \
		curl \
		xclip \
		"
	pkgs=$(eval echo $essential_pkgs | tr -s ' ')
	install $pkgs

	if [ -z "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
		# assume the shell is not zsh
		echo "Changing to zsh..."
		sh -c "chsh --shell /bin/zsh"
	fi
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
# deduce the installation command
if [[ -x `which apt-get` ]]; then
	install_command="apt-get install"
elif [[ -x `which dnf` ]]; then
	install_command="dnf install"
fi

install_essentials
# install_dictionary

unset install_command
