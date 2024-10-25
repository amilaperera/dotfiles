#!/bin/bash

# some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# resource files used by bootstraping
INFO_FILE=$HOME/.config/.bootstrap_info

# constants
OS_UPDATE_INTERVAL_DAYS=5
OS_UPDATE_INTERVAL_SECONDS=$(( ${OS_UPDATE_INTERVAL_DAYS}*24*60*60 ))

function yellow()
{
    printf "${YELLOW}$@${NC}\n"
}

function red()
{
    printf "${RED}$@${NC}\n"
}

function green()
{
    printf "${GREEN}$@${NC}\n"
}

function confirm()
{
    read -p "${@} " answer
    [[ ! "$answer" =~ ^[Yy]$ ]] && return 1 || return 0
}

function show_os_info()
{
    local os_name=`grep -E '^NAME=' /etc/os-release | sed 's/^[^=]*=//; s/"//g'`
    local version=`grep -E '^VERSION=' /etc/os-release | sed 's/^[^=]*=//; s/"//g'`
    if [[ -n $os_name ]]; then
        echo -e "Operating System: ${GREEN}${os_name} ${version}${NC}"
    else
        echo -e "Operating System: ${RED}"Unknown"${NC}"
    fi
    echo -e "Host: ${GREEN}$(hostname)${NC}"
    echo -e "User: ${GREEN}${USER}${NC}"
}

function update_os()
{
    if should_update_os; then
        yellow "Updating packages"
        local cmd=`echo sudo ${update_os_command}`
        echo $cmd
        sh -c "$cmd"
        [[ $? -eq 0 ]] && update_last_update_timestamp
    fi
}

function should_update_os()
{
    if [[ ! -f ${INFO_FILE} ]]; then
        # File doesn't exist. Probably the first time doing bootstraping
        cat << EOF > ${INFO_FILE}
last_update: 
repo_site: 
email: 
EOF
        return 0
    fi

    # if the file exists, let's check if we have gone beyond the interval
    # read last_update timestamp
    last_update_timestamp=$(sed -n -E "s/^last_update: (.*)/\1/p" ${INFO_FILE})
    current_timestamp=$(date +%s)

    difference=$((current_timestamp - last_update_timestamp))
    if (( difference > OS_UPDATE_INTERVAL_SECONDS )); then
        # Now get the confirmation
        yellow "You haven't updated the packages in $(( difference / 86400 )) days."
        read -p "Continue to update packages (y/n): " input
        if [[ "$input" =~ ^[Yy]$ ]]; then
            return 0
        else
            return 1
        fi
    fi
    return 1
}

function update_last_update_timestamp()
{
    sed -i -E "s/(^last_update: )(.*)$/\1$(date +%s)/" ${INFO_FILE}
}

function export_install_command()
{
    if which dnf &> /dev/null; then
        HAS_DNF=1
        install_command="dnf install -y"
        update_os_command="dnf update -y"
    elif which apt-get &> /dev/null; then
        HAS_APT=1
        install_command="apt-get install -y"
        update_os_command="apt-get update -y"
    elif which pacman &> /dev/null; then
        HAS_PACMAN=1
        install_command="pacman --noconfirm -Sy"
        update_os_command="pacman --noconfirm -Syu"
    fi
    if [[ -n $install_command ]]; then
        echo -e "Install Command: ${GREEN}${install_command}${NC}"
    else
        echo -e "Install Command: ${RED}"Unknown"${NC}"
        exit 1
    fi
}

function probe_os_info()
{
    yellow "Probing OS information"
    show_os_info
    export_install_command
    echo
}

function install()
{
    local cmd=`echo "sudo ${install_command} ${@}"`
    echo $cmd
    sh -c "$cmd"
}

function check_dependencies()
{
    # We rely on dialog, if this doesn't exist install it first
    yellow "Checking dependencies for bootstraping"
    which dialog &> /dev/null
    if [[ $? -ne 0 ]]; then
        install dialog
    fi
}

function pip_install()
{
    local cmd=`echo "pip3 install ${@}"`
    echo $cmd
    sh -c "$cmd"
}

function essentials()
{
    local pkgs=()
    pkgs+=(git)
    pkgs+=(ripgrep)
    pkgs+=(tree)
    pkgs+=(htop)
    pkgs+=(bat)
    pkgs+=(wget)
    pkgs+=(curl)
    pkgs+=(xclip)
    pkgs+=(dictd)
    pkgs+=(neofetch)
    pkgs+=(tmux)
    pkgs+=(vim)

    install ${pkgs[*]}
}

function dev_tools()
{
    local pkgs=()
    # more selective ones
    if [[ $HAS_DNF -eq 1 ]]; then
        pkgs+=(@development-tools)
        pkgs+=(boost-devel)
        pkgs+=(ninja-build)
        pkgs+=(python3-devel) # for building boost
    elif [[ $HAS_APT -eq 1 ]]; then
        pkgs+=(build-essential)
        pkgs+=(libboost-all-dev)
        pkgs+=(ninja-build)
        pkgs+=(pkg-config)
        pkgs+=(libevent-dev)
        pkgs+=(bison)
        pkgs+=(byacc)
        pkgs+=(python3-dev)
    else
        pkgs+=(base-devel)
        pkgs+=(boost boost-libs)
        pkgs+=(python3-devel)
    fi

    pkgs+=(clang)
    pkgs+=(cmake)
    pkgs+=(ccache)
    pkgs+=(unzip)
    [[ $HAS_APT -eq 1 ]] && pkgs+=(exuberant-ctags) || pkgs+=(ctags)

    install ${pkgs[*]}
}

function python_stuff()
{
    local pkgs=()
    if [[ $HAS_APT -eq 1 ]]; then
        # force python3
        pkgs+=(python3)
        pkgs+=(python3-pip)
        pkgs+=(ipython3)
        pkgs+=(python3-venv)
    else
        pkgs+=(python)
        pkgs+=(python-pip)
        pkgs+=(ipython)
        pkgs+=(python-jedi)
    fi

    install ${pkgs[*]}
}

function extra_repos()
{
    # more selective ones
    if [[ $HAS_DNF -eq 1 ]]; then
        local ver=$(rpm -E %fedora)
        repos+=("https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${ver}.noarch.rpm")
        repos+=("https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${ver}.noarch.rpm")
        repos+=("fedora-workstation-repositories")

        install ${repos[*]}
        sh -c "sudo dnf config-manager --set-enabled google-chrome"

        pkgs+=(google-chrome-stable)

        install ${pkgs[*]}
    fi
}

# install latest nvim from source code
function nvim_from_sources()
{
    echo "  - Installing pre-requisites..."
    pre_requisites=()
    if [[ $HAS_APT -eq 1 ]]; then
        pre_requisites=(ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip)
        install ${pre_requisites[*]}
    elif [[ $HAS_DNF -eq 1 ]]; then
        pre_requisites=(ninja-build libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl)
        install ${pre_requisites[*]}
    fi

    echo "  - Cloning neovim..."
    # create tmp directory if not exists
    if [ ! -d $HOME/tmp/neovim ]; then
        git clone https://github.com/neovim/neovim.git ~/tmp/neovim
    else
        cd ~/tmp/neovim && git pull
    fi
    # switch to stable branch
    echo "  - Switching to stable..."
    cd ~/tmp/neovim && git checkout stable && git pull
    echo "  - Building and installing neovim..."
    cd ~/tmp/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=${HOME}/.local install
}

function vim_from_sources()
{
    echo "  - Cloning vim..."
    [[ -d ~/tmp/vim ]] && rm -rf ~/tmp/vim

    mkdir -p ~/tmp/vim
    git clone https://github.com/vim/vim.git ~/tmp/vim

    echo "  - Building and installing vim..."
    cd ~/tmp/vim && ./configure --with-features=huge \
        --enable-terminal \
        --enable-multibyte \
        --enable-python3interp=yes \
        --with-python3-config-dir=$(python3-config --configdir) \
        --prefix=${HOME}/.local
    cd ~/tmp/vim && make && make install
}

function setup_github_personal_ssh()
{
    ssh_key_file="${HOME}/.ssh/id_github_personal"
    if [[ ! -f ${ssh_key_file} ]]; then
        yellow "Setting up ssh keys ${ssh_key_file}"
        green "Generatig ed25519 key with no passphrase"
        cmd="ssh-keygen -N '' -t ed25519 -C \"github, personal(${USER})\" -f ${ssh_key_file}"
        eval ${cmd}
        eval "$(ssh-agent -s)" && green "ssh agent started" || return 2
        eval ssh-add ${ssh_key_file} && \
            green "ssh keys added\nCopy & paste the following key to Github\n\n" || \
            return 2
        eval cat ${ssh_key_file}.pub
        echo
    else
        yellow "Not setting up ssh keys since ${ssh_key_file} already exists..."
        eval "$(ssh-agent -s)" && green "ssh agent started" || return 2
        eval ssh-add ${ssh_key_file}
        return 1
    fi
    return 0
}

function check_if_auth_ok()
{
    ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
    return $?
}

function setup_configs()
{
    url='git@github.com:amilaperera/dotfiles'
    if [[ ${BYPASS_SSH} -eq 1 ]]; then
        url='https://github.com/amilaperera/dotfiles'
    fi
    if [[ ! -d "$HOME/.dotfiles" ]]; then
        green "Cloning dotfiles"
        git clone ${url} ~/.dotfiles
    else
        yellow "$HOME/.dotfiles directory already exists"
    fi
    echo

    green "Setting up personal dotfiles"
    prev=$(pwd)
    cd ~/.dotfiles && make all
    cd $prev
}

function setup_configs_if_auth_ok()
{
    yellow "Check if the user can be validated with the ssh keys..."
    if check_if_auth_ok; then
        green "Authentication successful with GitHub"
        setup_configs
    fi
}

function nerd_fonts()
{
    echo "  - Downloading Nerd fonts..."
    curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip --output /tmp/Hack.zip
    if [[ $? -eq 0 ]]; then
        echo "  - Downloading finished"
        mkdir -p ~/.fonts
        unzip /tmp/Hack.zip -d ~/.fonts
        echo "  - Updating font cache"
        fc-cache -fv
    else
        red "Error downloading Nerd fonts"
        return 1
    fi
    return $?
}

# Function wrapper to install packages
function install_packages()
{
    yellow "Installing ${@}..."
    ${@}
    echo
}

########################################
# main
########################################
probe_os_info

# confirm before continuing
if ! confirm "Continue the rest of bootstrapping with ROOT privileges to update/install packages (y/n) ?"; then
    echo "Exiting."
    exit 1
fi

check_dependencies
update_os

cmd=(dialog --separate-output --no-tags --checklist "Select Options:" 22 76 16)
options=(
    1 "Essential packages (bash, tmux, git, curl etc.)"          on
    2 "Development tools"                                        off
    3 "Python stuff"                                             off
    4 "Extra repositories (Fedor Only)"                          off
    5 "Install vim latest from sources (Recommended for Debian)" off
    6 "Install nvim latest from sources"                         off
    7 "Setup github SSH"                                         off
    8 "Setup personal configs(bash,tmux,vim etc.)"               off
    9 "Install Nerd fonts(Hack)"                                 off
)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

for choice in $choices; do
    case $choice in
        1)
            install_packages essentials
            ;;
        2)
            install_packages dev_tools
            ;;
        3)
            install_packages python_stuff
            ;;
        4)
            install_packages extra_repos
            ;;
        5)
            install_packages nvim_from_sources
            ;;
        6)
            if setup_github_personal_ssh; then
                # wait until the user wishes to continue
                if ! confirm "Continue with setup (y/n) ?"; then
                    break
                fi
            fi
            ;;
        7)
            setup_configs_if_auth_ok
            ;;
        8)
            install_packages nerd_fonts
            ;;
    esac
done

green "Bye...."

unset HAS_DNF HAS_APT HAS_PACMAN RED YELLOW GREEN NC install_command
unset INFO_FILE OS_UPDATE_INTERVAL_DAYS OS_UPDATE_INTERVAL_SECONDS
unset -f yellow red green
unset -f install

