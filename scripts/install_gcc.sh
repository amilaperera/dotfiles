#!/bin/bash

# gcc installation manual very clearly says that it relies on a POSIX
# compliant shell to do the building and installtion. It very specifically
# mentions that zsh is won't work with the installation.
# Therefore this particular script is run using bash (look at the shebang!!!)


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

function die() {
  red "Error: ${@}..."
  exit
}

function die_if_error {
  if [[ $1 -ne 0 ]]; then
    shift
    die "$@"
  fi
}

########################################
# main
########################################

# Parse gcc version
if [[ -z ${1} ]]; then
  echo "install_gcc.sh <VERSION>"
  die "No gcc version supplied"
fi

version=${1}

# OS infomation probing
probe_os_info

# Install pre-requisites
install_packages pre_requisites

# Downloading gcc source archive from the following site.
# https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/
archive_dir=/tmp/gcc-${version}
archive=${archive_dir}.tar.gz
curl "https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-${version}/gcc-${version}.tar.gz" --output ${archive}
die_if_error $? "Downloading the source tarball failed"

# Extract
cd /tmp && tar -zxvf ${archive}
die_if_error $? "Extracting the source tarball failed"

# Prepare build directory
build_dir=${archive_dir}/build
mkdir -p ${build_dir}
die_if_error $? "Creating the build directory failed"

# configure
cd ${build_dir} && ../configure -v --prefix=/usr/local/gcc-${version} \
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
                                   --program-suffix=-${version}

die_if_error $? "Configuration failed"

# make
cd ${build_dir} && make -j 8
die_if_error $? "make failed"

# make install
cd ${build_dir} && sudo make install -j 8
die_if_error $? "make install failed"

# epilogue
echo
priority=`echo ${version} | cut -d'.' -f 1`
green "gcc-${version} installation successful"
echo
echo  "Make sure you do the following before start using the latest gcc version"
echo
echo   " - Add the installed version as an alternative to the system (Assuming you assign priority of ${priority})"
yellow "   \$ sudo update-alternatives --install /usr/bin/gcc gcc /usr/local/gcc-${version}/bin/gcc-${version} ${priority}"
yellow "   \$ sudo update-alternatives --install /usr/bin/g++ g++ /usr/local/gcc-${version}/bin/g++-${version} ${priority}"
echo
echo   " - Configure the alternative"
yellow "   \$ sudo update-alternatives --config g++"
echo
echo   " - Update libstdc++"
yellow "   \$ sudo ln -sf /usr/local/gcc-${version}/lib64/libstdc++.so.6 libstdc++.so.6"
echo
echo   "Bye..."

unset HAS_DNF HAS_APT HAS_PACMAN RED YELLOW GREEN NC install_command
unset -f yellow red green
unset -f install

