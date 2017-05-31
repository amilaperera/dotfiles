#!/bin/sh

install_command=
HAS_APT=0
HAS_YUM=0

function install()
{
	echo ${@}
	echo ${install_command}
	cmd=`echo "sudo ${install_command} ${@} -y"`
	echo $cmd
	sh -c "$cmd"
}

function install_essentials()
{
	echo "Installing essentials..."
	essential_pkgs+=' zsh'
	essential_pkgs+=' tmux'
	essential_pkgs+=' tmuxinator'
	essential_pkgs+=' git'
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=' ctags' || essential_pkgs+=' exuberant-ctags'
	essential_pkgs+=' ack'
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=' the_silver_searcher' || essential_pkgs+=' silversearcher-ag'
	essential_pkgs+=' tree'
	essential_pkgs+=' mc'
	[[ $HAS_APT -eq 1 ]] && essential_pkgs+=' lfm'
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=' redhat-lsb'
	essential_pkgs+=' htop'
	essential_pkgs+=' vim'
	essential_pkgs+=' wget'
	essential_pkgs+=' curl'
	essential_pkgs+=' xclip'

	install $essential_pkgs

	if [ -z "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
		# assuming the shell is not zsh, change it to zsh
		echo "Changing to zsh..."
		sh -c "sudo lchsh -i ${USER}"
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
	:
}

########################################
# main
########################################
# deduce the installation command
which apt-get &> /dev/null
if [[ $? -eq 0 ]]; then
	HAS_APT=1
	install_command='apt-get install'
else
	which yum &> /dev/null
	if [[ $? -eq 0 ]]; then
		HAS_YUM=1
		install_command='dnf install'
	fi
fi


install_essentials
# install_dictionary

unset install_command
