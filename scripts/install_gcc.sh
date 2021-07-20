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
  local version=`awk -F= '/^\<VERSION\>/{print $2}' /etc/os-release 2> /dev/null`
  local sanitized_version=`echo "$version" | tr -d '"'`
  if [[ -n $os_name ]]; then
    echo -e "Operating System: ${GREEN}${os_name} ${sanitized_version}${NC}"
  else
    echo -e "Operating System: ${RED}"Unknown"${NC}"
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
    install_command="pacman --noconfirm -S"
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
  # latest neovim in the case of Fedore/Arch
  [[ $HAS_DNF -eq 1 || $HAS_PACMAN -eq 1 ]] && essential_pkgs+=(neovim)

  install ${essential_pkgs[*]}
}

# install latest nvim from source code
function nvim_from_sources() {
  [[ $HAS_APT -ne 1 ]] && yellow "Not installing neovim from sources for non Debian based distros...."
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

function pre_requisites() {
  local pkgs=()
  if [[ $HAS_APT -eq 1 ]]; then
    pkgs+=(build-essential)
    pkgs+=(libgmp-dev)
    pkgs+=(libmpfr-dev)
    pkgs+=(libmpc-dev)
    pkgs+=(libisl-dev)
    pkgs+=(libzstd-dev)
  fi
  install ${pkgs[*]}
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

probe_os_info

# Uncomment the necessary installations
install_packages pre_requisites

# downloading gcc source archive
# https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/

ver_major_minor=11.1
ver=${ver_major_minor}.0
archive_dir=/tmp/gcc-${ver}
archive=${archive_dir}.tar.gz
curl "https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-${ver}/gcc-${ver}.tar.gz" --output ${archive}

# extract
cd /tmp && tar -zxvf ${archive}

# prepare build directory
build_dir=${archive_dir}/build
mkdir -p ${build_dir}

# configure
cd ${build_dir} && ../configure -v --prefix=/usr/local/gcc-${ver} \
                                   --host=x86_64-pc-linux-gnu \
                                   --enable-bootstrap \
                                   --enable-shared \
                                   --enable-checking=release \
                                   --enable-__cxa_atexit \
                                   --enable-languages=c,c++,lto \
                                   --enable-lto \
                                   --enable-threads=posix \
                                   --enable-vtable-verify \
                                   --disable-multilib \
                                   --program-suffix=-${ver_major_minor}

# make
cd ${build_dir} && make -j 8 && sudo make install -j 8


unset HAS_DNF HAS_APT HAS_PACMAN RED YELLOW GREEN NC install_command
unset -f yellow red green
unset -f install

