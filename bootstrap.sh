#!/bin/bash

# some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

function yellow() {
  printf "${YELLOW}$@${NC}\n"
}

function red() {
  printf "${RED}$@${NC}\n"
}

function green() {
  printf "${GREEN}$@${NC}\n"
}

function show_os_info() {
  local os_name=`awk -F= '/^NAME/{print $2}' /etc/os-release 2> /dev/null`
  if [[ -n $os_name ]]; then
    echo -e "Operating System: ${GREEN}${os_name}${NC}"
  else
    echo -e "Operating System: ${RED}"Unknown"${NC}"
    exit 1
  fi
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
  if [[ -n $install_command ]]; then
    echo -e "Install Command: ${GREEN}${install_command}${NC}"
  else
    echo -e "Install Command: ${RED}"Unknown"${NC}"
    exit 1
  fi
}

function probe_os_info() {
  yellow "Probing OS information"
  show_os_info
  export_install_command
  echo
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

function change_to_zsh() {
  local result=`$SHELL -c 'echo $ZSH_VERSION'`
  if [[ -z $result ]]; then
    # assuming the shell is not zsh, change it to zsh
    echo "Changing to zsh..."

    if [[ $HAS_DNF -eq 1 ]]; then
      # Fedora doesn't have chsh installed
      local cmd=`echo "sudo lchsh -i ${USER}"`
      sh -c "${cmd}"
    else
      local zsh_prg=`which zsh`
      local cmd=`echo "chsh --shell ${zsh_prg}"`
      sh -c "$cmd"
    fi
  else
    echo "ZSH already selected as the login shell"
  fi
}

function essentials() {
  local essential_pkgs=()
  essential_pkgs+=(zsh)
  essential_pkgs+=(git gitk)
  [[ $HAS_APT -eq 1 ]] && essential_pkgs+=(silversearcher-ag) || essential_pkgs+=(the_silver_searcher)
  essential_pkgs+=(tree)
  [[ $HAS_DNF -eq 1 ]] && essential_pkgs+=(redhat-lsb)
  essential_pkgs+=(htop)
  essential_pkgs+=(wget)
  essential_pkgs+=(curl)
  essential_pkgs+=(xclip)
  essential_pkgs+=(dictd)

  install ${essential_pkgs[*]}
}

# The reason for this to be out of essential_pkgs is that
# for some installations installing ruby may be deemed redundant
function tmux() {
  local essential_pkgs=(tmux)
  essential_pkgs+=(ruby) # for tmuxinator
  install ${essential_pkgs[*]}

  # now tmuxinator
  sh -c "sudo gem install tmuxinator"
}

function dev_tools() {
  local dev_tools=()
  # more selective ones
  if [[ $HAS_DNF -eq 1 ]]; then
    dev_tools+=(@development-tools)
    dev_tools+=(boost-devel)
  elif [[ $HAS_APT -eq 1 ]]; then
    dev_tools+=(build-essential)
    dev_tools+=(libboost-all-dev)
  else
    dev_tools+=(base-devel)
    dev_tools+=(boost boost-libs)
  fi
  dev_tools+=(clang)
  dev_tools+=(cmake)
  [[ $HAS_APT -eq 1 ]] && dev_tools+=(exuberant-ctags) || dev_tools+=(ctags)
  install ${dev_tools[*]}
}

function arm_cortex_dev_tools() {
  local dev_tools=()
  [[ $HAS_DNF -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs) || dev_tools+=(arm-none-eabi-gcc)
  [[ $HAS_DNF -eq 1 ]] && dev_tools+=(arm-none-eabi-gcc-cs-c++) || dev_tools+=(arm-none-eabi-g++)
  dev_tools+=(arm-none-eabi-gdb)
  dev_tools+=(openocd)

  install ${dev_tools[*]}
}

function arm_linux_dev_tools() {
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

function python_stuff() {
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
function nvim_from_sources() {
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

function snaps() {
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
}

function setup_github_personal_ssh() {
  ssh_key_file="${HOME}/.ssh/id_github_personal"
  if [[ ! -f ${ssh_key_file} ]]; then
    yellow "Setting up ssh keys ${ssh_key_file}"
    green "Generatig ed25519 key with no passphrase"
    cmd="ssh-keygen -N '' -t ed25519 -C \"github, personal, perera.amila@gmail.com\" -f ${ssh_key_file}"
    eval ${cmd}
    eval "$(ssh-agent -s)" && green "ssh agent started" || return 2
    eval ssh-add ${ssh_key_file} && \
      green "ssh keys added\nCopy & paste the following key to Github\n\n" || \
      return 2
    eval cat ${ssh_key_file}.pub
    echo
  else
    yellow "Not setting up ssh keys since ${ssh_key_file} already exists..."
    return 1
  fi
  return 0
}

function check_if_auth_ok() {
  ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
  return $?
}

function setup_configs() {
  if [[ ! -d "$HOME/.dotfiles" ]]; then
    green "Cloning dotfiles"
    git clone git@github.com:amilaperera/dotfiles ~/.dotfiles
  else
    yellow "$HOME/.dotfiles directory already exists"
  fi
  echo
  cd ~/.dotfiles/scripts && python setup_env.py -e zsh nvim misc tmux_sessions
}

function setup_configs_if_auth_ok() {
  yellow "Check if the user can be validated with the ssh keys..."
  if check_if_auth_ok; then
    green "Authentication successful with GitHub"
    setup_configs
  fi
}

# Function wrapper to install packages
function install_packages() {
  yellow "Installing ${@}..."
  ${@}
  echo
}

########################################
# main
########################################

if [[ ${ALL} -eq 1 ]]; then
  PKG_INSTALL=1
  CONFIG_SETUP=1
fi

probe_os_info

# Uncomment the necessary installations
if [[ ${PKG_INSTALL} -eq 1 ]]; then
  install_packages essentials
  install_packages dev_tools
  install_packages snaps
  install_packages tmux
  # install_packages python_stuff
  # install_packages arm_cortex_dev_tools
  # install_packages arm_linux_dev_tools
  # install_packages nvim_from_sources
  change_to_zsh
fi

if [[ ${CONFIG_SETUP} -eq 1 ]]; then
  # First setup github ssh keys
  if setup_github_personal_ssh; then # new ssh keys created
    # Wait until the user wishes to continue
    read  -n 1 -p "Continue with setup [c] or anyother key to abort:" input

    if [[ "$input" = "c" ]]; then
      echo
      setup_configs_if_auth_ok
    fi
  elif [[ $? -eq 1 ]]; then # ssh keys already exists
    setup_configs_if_auth_ok
  fi
fi
green "Bye...."

unset HAS_DNF HAS_APT HAS_PACMAN RED YELLOW GREEN NC install_command
unset -f yellow red green
unset -f install

