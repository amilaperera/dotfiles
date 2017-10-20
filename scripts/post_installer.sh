#!/bin/bash

install_command=
HAS_APT=0
HAS_YUM=0

function install()
{
	cmd=`echo "sudo ${install_command} ${@} -y"`
	echo $cmd
	sh -c "$cmd"
}

function install_essentials()
{
	echo "Installing essentials..."
	local essential_pkgs=()
	essential_pkgs+=(zsh)
	essential_pkgs+=(tmux)
	essential_pkgs+=(tmuxinator)
	essential_pkgs+=(git)
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=(ack) || essential_pkgs+=(ack-grep)
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=(the_silver_searcher) || essential_pkgs+=(silversearcher-ag)
	essential_pkgs+=(tree)
	essential_pkgs+=(mc)
	[[ $HAS_APT -eq 1 ]] && essential_pkgs+=(lfm)
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=(redhat-lsb)
	essential_pkgs+=(htop)
	essential_pkgs+=(vim)
	essential_pkgs+=(wget)
	essential_pkgs+=(curl)
	essential_pkgs+=(xclip)

	install ${essential_pkgs[*]}

	if [ -z "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
		# assuming the shell is not zsh, change it to zsh

		# Fedora doesn't have chsh installed
		[[ $HAS_YUM -eq 1 ]] && \
			echo "Changing to zsh..." && \
			sh -c "sudo lchsh -i ${USER}"

		# For Ubuntu this works, coz it doesn't have lchsh installed
		[[ $HAS_APT -eq 1 ]] && \
			echo "Changing to zsh..." && \
			local zsh_exe=`which zsh` && \
			sh -c "chsh --shell ${zsh_exe}"
	else
		echo "ZSH already selected as the login shell"
	fi
}

function install_dictionary()
{
	echo "Installing dictionary..."
	dict_pkgs=(dictd dict-gcide dict-moby-thesaurus)

	install ${dict_pkgs[*]}
}

function install_misc_dev_tools()
{
	echo "Installing dev tools..."
	local dev_tools+=()
	dev_tools+=(cmake)
	dev_tools+=(build-essential)
	[[ $HAS_YUM -eq 1 ]] && dev_tools+=(ctags) || dev_tools+=(exuberant-ctags)

	install ${dev_tools[*]}
}

function install_arm_cortex_dev_tools()
{
	echo "Installing arm cortex dev tools..."
	local dev_tools=()
	[[ $HAS_YUM -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs) || dev_tools+=(arm-none-eabi-gcc)
	[[ $HAS_YUM -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs-c++) || dev_tools+=(arm-none-eabi-g++)
	dev_tools+=(arm-none-eabi-gdb)
	dev_tools+=(openocd)

	install ${dev_tools[*]}
}

function install_arm_linux_dev_tools()
{
	echo "Installing arm arm-linux dev tools..."
	local dev_tools=()
	dev_tools+=()
	if [[ $HAS_YUM -eq 1 ]]; then
		sudo dnf copr enable lantw44/arm-linux-gnueabihf-toolchain
		dev_tools+=(arm-linux-gnueabihf-binutils)
		dev_tools+=(arm-linux-gnueabihf-gcc)
		dev_tools+=(arm-linux-gnueabihf-glibc)
	else
		dev_tools+=(gcc-arm-linux-gnueabihf)
		dev_tools+=(g++-arm-linux-gnueabih)
	fi

	install ${dev_tools[*]}
}

function install_python_stuff()
{
	echo "Installing python stuff..."
	local python_stuff=()
	python_stuff+=(python)

	install ${python_stuff[*]}
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
install_misc_dev_tools
# install_arm_cortex_dev_tools
# install_arm_linux_dev_tools
install_python_stuff

unset install_command
