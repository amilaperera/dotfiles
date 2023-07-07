#!/bin/bash

# defining bash true/false
aep_true=0
aep_false=1

# regular colors
aep_red="\033[0;31m"
aep_green="\033[0;32m"
aep_yellow="\033[0;33m"
aep_blue="\033[0;34m"

aep_bold_red="\033[1;31m"
aep_bold_green="\033[1;32m"
aep_bold_yellow="\033[1;33m"
aep_bold_blue="\033[1;34m"

aep_reset="\033[0m"

function aep_echo_red() { echo -e $aep_red"$@"$aep_reset ; }
function aep_echo_green() { echo -e $aep_green"$@"$aep_reset ; }
function aep_echo_yellow() { echo -e $aep_yellow"$@"$aep_reset ; }
function aep_echo_blue() { echo -e $aep_blue"$@"$aep_reset ; }
function aep_console_log() { echo '['$(date +'%a %Y-%m-%d %H:%M:%S %z')']' $1 ; }

function aep_debug() { aep_echo_green "$@"; }
function aep_warn() { aep_echo_yellow "$@"; }
function aep_error() { aep_echo_red "$@"; }

function aep_confirm()
{
    local answer=''
    local choice=''

    local prompt="confirm [y/n] > "

    until [[ "$choice" = "y" || "$choice" = "n" ]]; do

        read -p "$prompt" answer
        case "$answer" in
            [yY] ) choice='y';;
            [nN] ) choice='n';;
            * ) ;;
        esac
    done

    [ "$choice" = "y" ] && return $aep_true || return $aep_false
}

function aep_interactive_shell()
{
    case "$-" in
        *i* ) return $aep_true;;
        * ) return $aep_false;;
    esac
}

# checks if a command exists
function aep_command_exists() { [[ $# -ne 1 ]] && $aep_false || type -P $1 >/dev/null ; }

