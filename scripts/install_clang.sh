#!/bin/bash

# utilities
source .common.sh

########################################
# main
########################################

# Parse clang version
if [[ -z ${1} ]]; then
  echo "install_clang.sh <VERSION>"
  die "No clang version supplied"
fi

version=${1}

# OS infomation probing
probe_os_info

# Install pre-requisites
install_packages pre_requisites

# Working directory
cwd=${HOME}/work

# Project directory
project_directory=${cwd}/llvm-project

# If project_directory doesn't exist create it and clone the project.
# Otherwise this script assumes that the project has already been cloned.
if [[ ! -e ${project_directory} ]]; then
  # Clone the repository
  mkdir -p ${cwd}
  cd ${cwd} && git clone https://github.com/llvm/llvm-project.git
  die_if_error $? "Cloning llvm-project failed"
fi

# Work out the branch with the version provided
branch='${version}'
if [[ "$version" != "main" ]]; then
  branch="release/${version}"
fi

cd ${project_directory} && git pull
die_if_error $? "Pulling failed"

cd ${project_directory} && git checkout ${branch}
die_if_error $? "Checking out ${branch} failed"

# Prepare build directory
build_dir=${project_directory}/build
# Fresh build each time!!!!
if [[ -d "${build_dir}" ]]; then
    rm -rf "${build_dir}"
fi
die_if_error $? "Removing the existing build directory failed"
mkdir -p "${build_dir}"
die_if_error $? "Creating the build directory failed"

# Configure CMake
cd ${build_dir} && cmake -G "Ninja" \
                            -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
                            -DLLVM_TARGETS_TO_BUILD=X86 \
                            -DCMAKE_INSTALL_PREFIX=${HOME}/.local/clang-${version} \
                            -DCMAKE_BUILD_TYPE=Release \
                            ../llvm
die_if_error $? "CMake configuration failed"

# make
cd ${build_dir} && ninja -j8
die_if_error $? "ninja build failed"

# make install
cd ${build_dir} && ninja install -j8
die_if_error $? "ninja install failed"

# epilogue

# work out priority
priority=`echo ${version} | cut -d'.' -f 1`
major_version=${priority}
if [[ "$version" == "main" ]]; then
  priority=100 # some high number if this is the main branch
  major_version='main'
fi

echo
green "clang-${version} installation successful"
echo
echo  "Make sure you do the following before start using the latest gcc version"
echo
echo   " - Add the installed version as an alternative to the system (Assuming you assign priority of ${priority})"
yellow "   \$ sudo update-alternatives --install /usr/bin/clang clang /usr/local/clang-${version}/bin/clang-${major_version} ${priority}"
yellow "   \$ sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/local/clang-${version}/bin/clang++ ${priority}"
echo
echo   " - Configure the alternative"
yellow "   \$ sudo update-alternatives --config clang++"
echo
echo   "Bye..."

