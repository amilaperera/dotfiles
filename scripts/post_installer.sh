#!/bin/bash

function show_os_info() {
  local os_name=`awk -F= '/^NAME/{print $2}' /etc/os-release 2> /dev/null`
  echo "Operating System: ${os_name:-"Unknown"}"
}

function export_install_command() {
  if which dnf &> /dev/null; then
    HAS_DNF=1
    install_command="dnf install"
  elif which apt-get &> /dev/null; then
    HAS_APT=1
    install_command="apt-get install"
  elif which pacman &> /dev/null; then
    HAS_PACMAN=1
    install_command="pacman -S"
  fi
  echo "Install Command: ${install_command:?"Unknown install command"}"
}

function probe_os_info() {
  show_os_info
  export_install_command
}

function install() {
  local cmd=
  [[ $HAS_PACMAN -eq 1 ]] && cmd=`echo "sudo ${install_command} ${@}"` || cmd=`echo "sudo ${install_command} ${@} -y"`
  echo $cmd
  sh -c "$cmd"
}

function pip_install() {
  local cmd=`echo "pip3 install ${@}"`
  echo $cmd
  sh -c "$cmd"
}

function snap_install() {
  local cmd=`echo "sudo snap install ${@}"`
  echo $cmd
  sh -c "$cmd"
}

function snap_install_classic() {
  local cmd=`echo "sudo snap install ${@} --classic"`
  echo $cmd
  sh -c "$cmd"
}

function install_essentials() {
  echo "Installing essentials..."
  local essential_pkgs=()
  essential_pkgs+=(zsh)
  essential_pkgs+=(tmux)
  [[ $HAS_DNF -eq 1 ]] && essential_pkgs+=(python3-tmuxp) || essential_pkgs+=(tmuxp)
  essential_pkgs+=(git)
  [[ $HAS_APT -eq 1 ]] && essential_pkgs+=(silversearcher-ag) || essential_pkgs+=(the_silver_searcher)
  essential_pkgs+=(tree)
  [[ $HAS_DNF -eq 1 ]] && essential_pkgs+=(redhat-lsb)
  essential_pkgs+=(htop)
  essential_pkgs+=(wget)
  essential_pkgs+=(curl)
  essential_pkgs+=(xclip)
  essential_pkgs+=(dictd)

  install ${essential_pkgs[*]}

  if [ -z "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assuming the shell is not zsh, change it to zsh

    # Fedora doesn't have chsh installed
    [[ $HAS_DNF -eq 1 ]] && \
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

function install_dev_tools() {
  echo "Installing dev tools..."
  local dev_tools=()
  dev_tools+=(clang)
  dev_tools+=(cmake)
  [[ $HAS_PACMAN -eq 1 ]] && dev_tools+=(boost boost-libs) || dev_tools+=(libboost-all-dev)
  [[ $HAS_APT -eq 1 ]] && dev_tools+=(build-essential) || dev_tools+=(base-devel)
  [[ $HAS_APT -eq 1 ]] && dev_tools+=(exuberant-ctags) || dev_tools+=(ctags)
  install ${dev_tools[*]}
}

function install_arm_cortex_dev_tools() {
  echo "Installing arm cortex dev tools..."
  local dev_tools=()
  [[ $HAS_DNF -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs) || dev_tools+=(arm-none-eabi-gcc)
  [[ $HAS_DNF -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs-c++) || dev_tools+=(arm-none-eabi-g++)
  dev_tools+=(arm-none-eabi-gdb)
  dev_tools+=(openocd)

  install ${dev_tools[*]}
}

function install_arm_linux_dev_tools() {
  echo "Installing arm arm-linux dev tools..."
  local dev_tools=()
  if [[ $HAS_DNF -eq 1 ]]; then
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

function install_python_stuff() {
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
function install_nvim_from_sources() {
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

# TODO: Tested in Arch & Fedora
function install_snap() {
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
  # snaps_classic=(chromium)
  # # One per --classic command
  # for snap in "${snaps_classic[@]}"; do
  # snap_install_classic ${snap}
  # done
}


########################################
# main
########################################

#
# Uncomment the necessary installations
#
probe_os_info
install_essentials
# install_dev_tools
# install_python_stuff
# install_arm_cortex_dev_tools
# install_arm_linux_dev_tools
# install_nvim_from_sources
install_snap

unset HAS_DNF HAS_APT HAS_PACMAN install_command

