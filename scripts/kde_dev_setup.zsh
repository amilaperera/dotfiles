#!/usr/bin/env zsh
#
# References:
# https://community.kde.org/Get_Involved/development
# https://community.kde.org/Guidelines_and_HOWTOs/Build_from_source/Install_the_dependencies
#

# source utilities
source .common.sh

KDE_SRC_DIR=${HOME}/kde/src
KDE_SRC_BUILD=${KDE_SRC_DIR}/kdesrc-build

function basic_tools() {
  local pkgs=(git cmake dialog perl perl-IPC-Cmd perl-MD5 perl-FindBin)
  install ${pkgs[*]}
}

function framework_deps() {
  local pkgs=(bison flex giflib-devel gperf gpgmepp-devel grantlee-qt5-devel kf5-kconfigwidgets-devel libaccounts-glib-devel libaccounts-qt5-devel libattr-devel libepoxy-devel libgcrypt-devel libinsane-devel libjpeg-turbo-devel LibRaw-devel libSM-devel libxml2-devel libXrender-devel libxslt-devel lmdb-devel ModemManager-devel NetworkManager-libnm-devel openjpeg2-devel openjpeg-devel openssl-devel perl-FindBin perl-IPC-Cmd perl-JSON-PP perl-YAML-Syck polkit-devel qrencode-devel qt5-qtbase-devel qt5-qtbase-private-devel qt5-qtdeclarative-devel qt5-qtquickcontrols2-devel qt5-qtsvg-devel qt5-qtx11extras-devel signon-devel systemd-devel wayland-devel 'xcb*-devel')
  install ${pkgs[*]}
}

function clone_kde_src() {
  yellow "Cloning kdesrc-build"
  mkdir -p ${KDE_SRC_DIR} && \
    cd ${KDE_SRC_DIR} && \
    git clone https://invent.kde.org/sdk/kdesrc-build.git && cd kdesrc-build
}

function kdesrc_build_initial_setup() {
  cd ${KDE_SRC_BUILD} && ./kdesrc-build --initial-setup
  cd && source .zshrc
}

function other_deps() {
  local pkgs=(libXScrnSaver-devel)
  install ${pkgs[*]}
}


# main
probe_os_info

if [[ $HAS_DNF -ne 1 ]]; then
  die "kde dev is only supported on Fedora"
fi

install_packages basic_tools
install_packages framework_deps
install_packages other_deps

clone_kde_src
kdesrc_build_initial_setup

# build dolphin with
echo
green  " Build a project by invoking the following command"
echo   "  kdesrc-build dolphin --include-dependencies"
echo   "  kdesrc-build konsole --include-dependencies"
echo

unset KDE_SRC_DIR
