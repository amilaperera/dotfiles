#!/bin/bash

# gcc installation manual very clearly says that it relies on a POSIX
# compliant shell to do the building and installtion. It very specifically
# mentions that zsh will not work with the installation.
# Therefore this particular script is run using bash (look at the shebang!!!)


# utilities
source .common.sh

########################################
# main
########################################

# Parse gcc version
if [[ -z ${1} ]]; then
  echo "install_gcc.sh <VERSION1> <VERSION2> ..."
  die "No gcc version supplied"
fi

# OS infomation probing
probe_os_info

# Install pre-requisites
install_packages pre_requisites

# Working directory
cwd=${HOME}/work

# Project directory
project_directory=${cwd}/gcc

# Prepare build directory
build_dir=${project_directory}/build

function prepare_project_for_building()
{
    # If project_directory doesn't exist create it and clone the project.
    # Otherwise this script assumes that the project has already been cloned.
    if [[ ! -e ${project_directory} ]]; then
        # Clone the repository
        mkdir -p ${cwd}
        cd ${cwd} && git clone https://github.com/gcc-mirror/gcc
        die_if_error $? "Cloning gcc failed"
    else
        # Fresh build each time!!!!
        cd ${project_directory} && git co master && git clean -dfx

        if [[ -d "${build_dir}" ]]; then
            rm -rf "${build_dir}"
        fi
        die_if_error $? "Removing the existing build directory failed"
    fi

    cd ${project_directory} && git pull
    die_if_error $? "Pulling failed"
}

function install_version()
{
    prepare_project_for_building

    local version="${1}"
    yellow "Installing gcc version: ${version}"

    local branch=${version}
    if [[ "$version" != "trunk" ]]; then
        branch="releases/gcc-${version}"
    fi

    cd ${project_directory} && git checkout ${branch}
    die_if_error $? "Checking out ${branch} failed"

    mkdir -p "${build_dir}"
    die_if_error $? "Creating the build directory failed"

    # configure
    cd ${build_dir} && ../configure -v --prefix=$HOME/.local/gcc-${version} \
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
    cd ${build_dir} && make -j4
    die_if_error $? "make failed"

    # make install
    cd ${build_dir} && make install -j4
    die_if_error $? "make install failed"

    echo
    green "gcc-${version} installation successful"
    echo
}

for version in "$@"; do
    install_version "${version}"
done

unset project_directory build_dir cwd

echo "Done. Have a good day !!!"

