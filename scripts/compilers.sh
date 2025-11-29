#!/bin/bash

#
# Source from .bashrc to activate compilers

# locally installed compilers reside here
compiler_root="$HOME/.local"

# latest stuff
function activate_gcc()
{
    if ! activate_gcc15; then
        return 1
    fi
}

function activate_clang()
{
    if ! activate_clang21; then
        return 1
    fi
}

# gcc
function activate_gcc15()
{
    if ! activate_gcc_compiler "15.2.0"; then
        return 1
    fi

    activate_debugger gdb "15.2"
    export BOOST_ROOT=${compiler_root}/boost_1.89.0.gcc
}

function activate_gcc14()
{
    if ! activate_gcc_compiler "14.2.0"; then
        return 1
    fi

    activate_debugger gdb "15.2"
    export BOOST_ROOT=${compiler_root}/boost_1.86.0.gcc
}

# clang
function activate_clang21()
{
    if ! activate_clang_compiler "21.1.0" "clang" "21.1.0"; then
        return 1
    fi
    export BOOST_ROOT=${compiler_root}/boost_1.89.0.clang
}

function activate_clang19()
{
    if ! activate_clang_compiler "19.1.3" "clang" "19.1.3"; then
        return 1
    fi
    export BOOST_ROOT=${compiler_root}/boost_1.86.0.clang
}

# helpers
function sanitize_compiler_path()
{
    echo $(echo ${1} | tr ':' '\n' | sed -e '/gcc\|clang/d' | tr '\n' ':' | sed -e 's/.$//')
}

function sanitize_debugger_path()
{
    echo $(echo ${1} | tr ':' '\n' | sed -e '/gdb\|lldb/d' | tr '\n' ':' | sed -e 's/.$//')
}

function set_compiler_path()
{
    if [[ $# -ne 2 ]]; then
        echo "Usage: set_compiler_path <name> <version>" 1>&2
        return 1
    fi

    local name_cc="${1}"
    local version="${2}"

    local name_cxx=
    if [[ "$name_cc" == "gcc" ]]; then
        name_cxx="g++"
    elif [[ "$name_cc" == "clang" ]]; then
        name_cxx="clang++"
    else
        echo "Unsupported"
        return 1
    fi

    local compiler_version_path=${compiler_root}/${name_cc}-${version}
    local compiler_bin_path=${compiler_version_path}/bin

    # export PATH with the compiler binary path prepended
    local sanitized_path=$(sanitize_compiler_path $PATH)
    if [[ -z $sanitized_path ]]; then
        export PATH=${compiler_bin_path}
    else
        export PATH=${compiler_bin_path}:$sanitized_path
    fi

    # export CC & CXX
    if [[ "$name_cc" == "gcc" ]]; then
        export CC=${compiler_bin_path}/${name_cc}-${version}
        export CXX=${compiler_bin_path}/${name_cxx}-${version}
    elif [[ "$name_cc" == "clang" ]]; then
        export CC=${compiler_bin_path}/${name_cc}
        export CXX=${compiler_bin_path}/${name_cxx}
    fi

    # set up symlinks
    if [[ ! -e "${compiler_bin_path}/${name_cc}" ]]; then
        ln -sf $CC ${compiler_bin_path}/${name_cc}
    fi
    if [[ ! -e "${compiler_bin_path}/${name_cxx}" ]]; then
        ln -sf $CXX ${compiler_bin_path}/${name_cxx}
    fi
}

function set_gcc_ld_lib_path()
{
    if [[ $# -ne 2 ]]; then
        echo "Usage: set_gcc_ld_lib_path <variant> <version>" 1>&2
        return 1
    fi

    local lib_variant_name="${1}"
    local lib_variant_version="${2}"
    local lib_search_path=${compiler_root}/${lib_variant_name}-${lib_variant_version}
    local lib_path_entry=$(find $lib_search_path -name "*libstdc++.so*" | head -n 1)
    if [[ -z $lib_path_entry ]]; then
        echo "Error: Couldn't find libstd++ under $lib_search_path"
        return 1
    fi

    local ld_path=$(dirname $lib_path_entry)
    export LD_LIBRARY_PATH=${ld_path}
    return 0
}

function set_clang_ld_lib_path()
{
    local lib_variant_name="${1}"
    local lib_variant_version="${2}"
    local lib_search_path=${compiler_root}/${lib_variant_name}-${lib_variant_version}
    local lib_path_entry=$(find $lib_search_path -name "*libc++.so" | head -n 1)
    if [[ -z $lib_path_entry ]]; then
        echo "Error: Couldn't find libcxx under $lib_search_path"
        return 1
    fi

    local ld_path=$(dirname $lib_path_entry)
    export LD_LIBRARY_PATH=${ld_path}
    return 0
}

function activate_gcc_compiler()
{
    if [[ $# -ne 1 ]]; then
        echo "Usage: activate_gcc_compiler <version>" 1>&2
        return 1
    fi

    if ! set_compiler_path "gcc" "${1}"; then
        return 1
    fi

    if ! set_gcc_ld_lib_path "gcc" "${1}"; then
        return 1
    fi

    return 0
}

function activate_clang_compiler()
{
    if [[ $# -ne 3 ]]; then
        echo "Usage: activate_clang_compiler <version> <library_variant> <library_variant_version>" 1>&2
        return 1
    fi

    if ! set_compiler_path "clang" "${1}"; then
        return 1
    fi

    if ! set_clang_ld_lib_path "${2}" "${3}"; then
        return 1
    fi

    return 0
}

function activate_debugger()
{
    if [[ $# -ne 2 ]]; then
        echo "Usage: activate_debugger <gdb|lldb> <version>" 1>&2
        return 1
    fi

    local name="${1}"
    local version="${2}"

    local debugger_version_path=${compiler_root}/${name}-${version}
    local debugger_bin_path=${debugger_version_path}/bin

    # export PATH with the compiler binary path prepended
    local sanitized_path=$(sanitize_debugger_path $PATH)
    if [[ -z $sanitized_path ]]; then
        export PATH=${debugger_bin_path}
    else
        export PATH=${debugger_bin_path}:$sanitized_path
    fi
}

function check_compiler()
{
    echo "PATH"
    echo $PATH | tr ':' '\n'
    echo
    echo -n "CC = $CC"
    [[ -f $CC ]] && echo " [FOUND]" || echo " [NOT FOUND]"

    echo -n "CXX = $CXX"
    [[ -f $CXX ]] && echo " [FOUND]" || echo " [NOT FOUND]"

    echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"

    echo -n "BOOST_ROOT = $BOOST_ROOT"
    [[ -d $BOOST_ROOT ]] && echo " [FOUND]" || echo " [NOT FOUND]"
}
