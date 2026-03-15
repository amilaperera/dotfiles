#!/bin/bash

# first source compiler activating script
source "$HOME/.local/dev_stuff/.local.bash"

old_dir=$(pwd)

if (($# < 3)); then
    echo "$0 <git_root_dir> <gcc|clang> <debug|release> [build targets]"
    exit 1
fi

git_root_dir=$1
build_dir=${git_root_dir}

if [[ ! -d $git_root_dir ]]; then
    echo "Can't find git directory: " ${git_root_dir}
    exit 1
fi

if [[ $2 == "gcc" ]]; then
    activate_gcc
    if [[ "$3" ==  "debug" ]]; then
        build_dir="${build_dir}/build.gcc"
    else
        build_dir="${build_dir}/build.gcc.${3}"
    fi
else
    activate_clang
    if [[ "$3" == "debug" ]]; then
        build_dir="${build_dir}/build.clang"
    else
        build_dir="${build_dir}/build.clang.${3}"
    fi
fi

cd $build_dir
ninja -j8 "${@:4}"
cd $old_dir
