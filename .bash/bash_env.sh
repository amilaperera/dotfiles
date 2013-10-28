#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: bash_env.sh
#############################################################

# set workinghost
export workinghost=$(uname)

################################################################################
## getting the Linux Distrubution Version
## this works on Ubuntu
## FIXME: lsb_release might not work on distrubutions other than Ubuntu
################################################################################
if [[ $workinghost == "Linux" ]]; then
	for path in ${PATH//:/ }; do
		if [ -f ${path}/lsb_release ]; then
			export distroname=$(lsb_release -si) # distro name
			export distrover=$(lsb_release -sr)  # distibution version
			export arch=$(uname -m)              # architecture
			break;
		fi
	done
fi

# set umask to 644 permission(files when touch) and 755(directories when mkdir)
# same can be done with umask u=rwx,g=rx,o=rx
UMASK=022
umask $UMASK

#####################################################################
## _contains_path()
## returns 1 if a path contains a given directory
#####################################################################
function _contains_path()
{
	local path=":${1}:" dir="${2}"
	case $path in
	*:$dir:*)	return 1;;
	*		)	return 0;;
	esac
}

#####################################################################
## _clean_path()
## remove duplicate path entries and cleans PATH variable
#####################################################################
function _clean_path()
{
	local path="${1}"
	local newpath= directory=
	[ -z $path ] && return 1

	# remove duplicate entries from the path
	for directory in ${path//:/ }; do
		[ -d $directory ] \
			&& _contains_path "${newpath}" "${directory}" \
			&& newpath="${newpath}":"${directory}"
	done

	# removes unnecessary : marks
	newpath=$(echo $newpath | sed -e 's/^:*//' -e 's/:*$//' -e 's/::*/:/g')
	# returns newpath
	echo $newpath
}

#####################################################################
## _set_path()
## sets path from the mypathstring selecting existing directories
#####################################################################
function _set_path()
{
	# If you want to add a path permenantly add it to mypathstring
	# priority of the path is increased as the paths are added to the bottom of the mypathstring
	local mypatharray=(
					"/cygdrive/c/Windows/System32"
					"/cygdrive/c/Vim/vim73"
					"/user/games"
					"/sbin"
					"/bin"
					"/usr/bin"
					"/usr/sbin"
					"/usr/local/bin"
					"/usr/local/sbin"
					"$HOME/bin"
					)

	local path=
	for path in "${mypatharray[@]}"; do
		if [ -d "$path" ]; then
			_contains_path "$PATH" "$path" && PATH=$path:$PATH
		fi
	done

	PATH=$(_clean_path $PATH)
	[ -d "/cygdrive/c/Program Files/Vim/vim73" ] && PATH=$PATH:"/cygdrive/c/Program Files/Vim/vim73"
}

# sets and export PATH
_set_path
export PATH

# setting term colors
[ -z $TMUX ] && TERM=xterm-256color               # let tmux decide TERM to use,
                                                  # otherwise set it to xterm-256color

export HISTSIZE=5000                              # No of commands in history stack in memory
export HISTFILESIZE=5000                          # No of commands in history file
export HISTCONTROL=ignoredups:ignorespace         # omit dups and lines starting with spaces
export HISTTIMEFORMAT=': %Y-%m-%d_%H:%M:%S; '     # time stamp of histfile

export HOSTFILE='/etc/hosts'                      # use this file for hostname completion
export LC_COLLATE='C'                             # set traditional C sort order

export LESS="--LONG-PROMPT --RAW-CONTROL-CHARS --clear-screen --QUIET"

# setting man page viewr to less
export MANPAGER="less"

#ulimit -S -c 0 >/dev/null 2>&1    # no core files by default
case $workinghost in
CYGWIN*		)	export VISUAL='gvim' ;;
*			)	export VISUAL='vim' ;;
esac

export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export CVS_EDITOR="$VISUAL"
export FCEDIT="$VISUAL"

export LS_OPTIONS="--color=auto -F -h"

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# loads rvm functions
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# the default ruby/rails version did not work properly when
# switching to tmux
# the following fixed it
if _check_if_command_exists rvm; then
	[[ $TERM = "screen-256color" ]] && rvm use default > /dev/null
fi

################################################################################
## shell behaviour adjustment with shopt options and set options
################################################################################
shopt -s histappend   # appends rather than overwrite history on exit
shopt -s cdspell      # correct minor spelling mistakes with cd command
shopt -s checkwinsize # update COLUMNS and LINES variables according to window size
shopt -s cmdhist      # makes multiline commands 1 line in history
shopt -s extglob      # extended globbing
shopt -s globstar     # ** globbing operator matches file names and directories recursively
shopt -s sourcepath   # The source builtin uses $PATH to find the file to be sourced
shopt -s autocd       # a name of a dir is executed as if it were the argument to cd

shopt -u mailwarn     # disable mail mail warning
unset MAILCHECK

set -o ignoreeof    # Dont let Ctrl+D exit the shell
set -o noclobber    # prevents overwriting existing files
set -o vi           # specifies vi editing mode for command-line editing
