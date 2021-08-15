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

# work out priority
priority=`echo ${version} | cut -d'.' -f 1`

echo
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
yellow "   \$ sudo ln -sf /usr/local/gcc-${version}/lib64/libstdc++.so.6 /lib/x86_64-linux-gnu/libstdc++.so.6"
echo
echo   "Bye..."

