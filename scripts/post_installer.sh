#!/bin/bash

install_command=
HAS_APT=0
HAS_YUM=0
HAS_PACMAN=0

function install()
{
	cmd=
	[[ $HAS_PACMAN -eq 1 ]] && cmd=`echo "sudo ${install_command} ${@} -y"` || cmd=`echo "sudo ${install_command} ${@} -y"`
	echo $cmd
	sh -c "$cmd"
}

function pip_install()
{
	cmd=`echo "pip3 install ${@}"`
	echo $cmd
	sh -c "$cmd"
}

function snap_install()
{
	cmd=`echo "sudo snap install ${@}"`
	echo $cmd
	sh -c "$cmd"
}

function snap_install_classic()
{
	cmd=`echo "sudo snap install ${@} --classic"`
	echo $cmd
	sh -c "$cmd"
}

function install_essentials()
{
	echo "Installing essentials..."
	local essential_pkgs=()
	essential_pkgs+=(zsh)
	essential_pkgs+=(tmux)
	essential_pkgs+=(tmuxp)
	essential_pkgs+=(git)
	[[ $HAS_APT -eq 1 ]] && essential_pkgs+=(silversearcher-ag) || essential_pkgs+=(the_silver_searcher)
	essential_pkgs+=(tree)
	[[ $HAS_YUM -eq 1 ]] && essential_pkgs+=(redhat-lsb)
	essential_pkgs+=(htop)
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
		[[ $HAS_APT -eq 1 || $HAS_PACMAN -eq 1 ]] && \
			echo "Changing to zsh..." && \
			local zsh_prg=`which zsh` && \
			sh -c "chsh --shell ${zsh_prg}"
	else
		echo "ZSH already selected as the login shell"
	fi
}

function install_dev_tools()
{
	echo "Installing dev tools..."
	local dev_tools=()
	dev_tools+=(cmake)
	[[ $HAS_PACMAN -eq 1 ]] && dev_tools+=(boost boost-libs) || dev_tools+=(libboost-all-dev)
	dev_tools+=(clang)
	[[ $HAS_APT -eq 1 ]] && dev_tools+=(build-essential) || dev_tools+=(base-devel)
	[[ $HAS_APT -eq 1 ]] && dev_tools+=(exuberant-ctags) || dev_tools+=(ctags)

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
	python_stuff+=(python-pip)
	python_stuff+=(ipython)
	python_stuff+=(python-jedi)

	install ${python_stuff[*]}
	local pips=()
	pips+=(pynvim)
	pip_install ${pips[*]}
}

# install latest nvim from source code
function install_nvim()
{
	echo "Installing latest nvim from sources..."
	echo "  - Installing pre-requisites..."
	local pre_requisites=()
	if [[ $HAS_APT -eq 1 ]]; then
		pre_requisites=(ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip)
	fi
	install ${pre_requisites[*]}

	echo "  - Cloning neovim..."
	# create tmp directory if not exists
	mkdir -p ~/tmp/neovim
	git clone https://github.com/neovim/neovim.git ~/tmp/neovim
	# switch to stable branch
	echo "  - Switching to stable..."
	cd ~/tmp/neovim && git checkout stable
	echo "  - Building and installing neovim..."
	cd ~/tmp/neovim && sudo make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/nvim install
}

# TODO: Only tested in Arch
function install_snap()
{
	snap_pkgs=(snapd)
	install ${snap_pkgs[*]}
	sh -c "sudo systemctl enable --now snapd.socket"
	sh -c "sudo ln -s /var/lib/snapd/snap /snap"

	# Now install the most essential snaps
	echo " - Install snap core"
	snap_core=(core)
	snap_install ${snap_core[*]}

	echo " - Installing snap-store"
	snaps=(snap-store)
	snap_install ${snaps[*]}

	# Now classics
	snaps_classic=(chromium)
	# One per --classic command
	for snap in "${snaps_classic[@]}"; do
		snap_install_classic ${snap}
	done
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
	else
		which pacman &> /dev/null
		if [[ $? -eq 0 ]]; then
			HAS_PACMAN=1
			install_command='pacman -S'
		fi
	fi
fi


#
# Uncomment the necessary installations
#
# install_essentials
# install_dev_tools
# install_python_stuff
# install_arm_cortex_dev_tools
# install_arm_linux_dev_tools
# install_nvim
# install_snap

unset install_command

