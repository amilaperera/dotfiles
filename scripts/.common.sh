#!/bin/bash

# common utilities

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
        pkgs+=(ninja-build)
        pkgs+=(git)
    fi
    # gdb specific
    pkgs+=(texinfo)
    pkgs+=(gmp-devel)
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

