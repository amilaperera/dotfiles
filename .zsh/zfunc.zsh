#############################################################
# Author: Amila Perera
# File Name: zfunc.zsh
#############################################################

# diff() {{{
# diff with colordiff
# in order to have bash completion worked properly you may have
# to comment the existing cdiff completion which is hardly used
# refer to /etc/bash_completion file
cdiff()
{
	colordiff -puw "${@}" | less -R
}
# }}}

# svndiff() {{{
# svn diff with colordiff
svndiff()
{
	svn diff "${@}" | colordiff | less -R
}
# }}}

# cvsdiff() {{{
# cvs diff with colordiff
cvsdiff()
{
	cvs diff "${@}" | colordiff | less -R
}
# }}}

# engman() {{{
# view man page in english
engman()
{
	local lang=$LANG
	LANG=en_US.UTF8 && man "${@}"
	export LANG=$lang
}
# }}}

# color_codes() {{{
# display ansi color combinations
# hacked from http://www.pixelbeat.org/docs/terminal_colours/
color_codes()
{
	e="\033["
	vline=$(tput smacs 2>/dev/null; printf 'x'; tput rmacs 2>/dev/null)
	[ "$vline" = "x" ] && vline="|"

	#printf "${e}4m%80s${e}0m\n"
	printf "${e}1;4mf\\\\b${e}0m${e}4m none  white    black     red    green    yellow   blue    magenta    cyan  ${e}0m\\n"

	rows='brgybmcw'

	for f in 0 7 `seq 6`; do
		no=""; bo=""; p=""
		for b in n 7 0 `seq 6`; do
			co="3$f"; [ $b = n ] || co="$co;4$b"
			no="${no}${e}${co}m  ${p}${co} ${e}0m"
			bo="${bo}${e}1;${co}m${p}1;${co} ${e}0m"
			p=" "
		done
		fc=$(echo $rows | cut -c$((f+1)))
		printf "$fc $vline$no\nb$fc$vline$bo\n"
	done
}
# }}}

# tmux_colors() {{{
# display tmux colors
##################################################################
tmux_colors()
{
	for i in {0..255}; do
		printf "\x1b[38;5;${i}mcolour${i}\e[0m\n"
	done | less -R
}
# }}}

# vim_bundle_update() {{{
# updates vim bundles
vim_bundle_update()
{
	local vim_bundle_dir=$HOME/.vim/bundle
	if [ ! -d $vim_bundle_dir ]; then
		echo "couldn't find the directory : $vim_bundle_dir"
		return 1
	fi

	_check_if_command_exists git || { echo "couldn't find git command"; return 1; }

	local current_dir=$(pwd)

	for d in $vim_bundle_dir/*; do
		cd $d
		echo "entering $d"
		if [ -d ".git" ]; then
			echo "updating from $(git remote -v | head -n 1 | tr '\t' ' ' | cut -d" " -f 2)"
			git pull
		else
			_echo_red "  couldn't find .git directory\n  leaving directory without updating"
		fi
		cd ..
	done

	cd $current_dir
}
# }}}

# bak() {{{
# make backup file(s)
bak()
{
	local ext="bak"
	if [[ "${1}" == "-o" ]]; then
		shift
		ext="orig"
	fi
	for file in "${@}"; do
		cp -f $file $file"."$ext
	done
}
# }}}

# swap() {{{
# swap two files
swap()
{
	local tempfile=swaptemp.$$
	mv -f "${1}" "${tempfile}" && mv -f "${2}" "${1}" && mv -f "${tempfile}" "${2}"
}
# }}}

# mcd() {{{
# creates a new directory and cd to it
mcd()
{
	local dir=
	local mcd_usage="Usage: mcd <mode> directory"

	if (($# == 0 || $# > 2 )); then
		echo "$mcd_usage"
	else
		if [ -n "$2" ]; then
			if [[ -d "$2" ]]; then
				echo "${2} already exists. changing directory"
				dir="$2"
			else
				command mkdir -p -m $1 "$2" && dir="$2"
			fi
		else
			if [ -d "$1" ]; then
				echo "$1 already exists. changing directory"
				dir="$1"
			else
				command mkdir -p "$1" && dir="$1"
			fi
		fi
	fi

	cd "$dir"
}
# }}}

# cl() {{{
# cd and list
cl()
{
	if (( $# == 0 )); then
		# if no argument is supplied, just ls
		ls -al --color=auto -F -h
	else
		if [[ -d "$1" ]]; then
			cd "$1"
			ls -al --color=auto -F -h
		else
			echo "bash: cl: '$1': Directory not found"
		fi
	fi
}
# }}}

# tmux_start() {{{
# start tmux session
# NOTE: This function can be called in shell initialization to start
# tmux on start up of the terminal
tmux_start()
{
	local session_name=

	(($# == 0))  && session_name="$USER" || session_name=$1

	if _check_if_command_exists tmux; then
		if [[ "$TERM" != "screen-256color" ]]; then
			tmux attach-session -t "$session_name"
			if (($? != 0)); then
				# if a $session_name named tmux session doesn't exist,
				# then create a new session
				tmux new-session -s "$session_name" -d # first create in detached mode
				tmux attach-session # attach the session
			fi
		fi
	fi
}
# }}}

# ghc() {{{
# github clone
ghc()
{
	if [[ "${1}" == "-a" ]]; then
		# cloning a repo from personal github account
		shift; git clone https://github.com/amilaperera/"${@}"
	elif [[ "${1}" == "-v" ]]; then
		# cloning a repo from vim-scripts github account
		shift; git clone https://github.com/vim-scripts/"${@}"
	else
		git clone https://github.com/"${@}"
	fi
}
# }}}

# man() {{{
# view man pages in colors
# copied from https://wiki.archlinux.org/index.php/Man_Page
man()
{
	env LESS_TERMCAP_mb=$'\E[01;31m' \
	LESS_TERMCAP_md=$'\E[01;34m' \
	LESS_TERMCAP_me=$'\E[0m' \
	LESS_TERMCAP_se=$'\E[0m' \
	LESS_TERMCAP_so=$'\E[01;33;40m' \
	LESS_TERMCAP_ue=$'\E[0m' \
	LESS_TERMCAP_us=$'\E[01;04;35m' \
	man "$@"
}
# }}}

# cdf() {{{
# fuzzy cd function
# NOTE: ignore-case does not work with fuzzy cd
cdf()
{
	cd *$1*
}
# }}}

# calc() {{{
# Trivial command line calculator
calc()
{
	awk "BEGIN {print \"The answer is : \" $*}";
}
# }}}

# ff() {{{
# opens firefox
ff()
{
	firefox "${@}" 2>/dev/null &
}
# }}}

# cb() {{{
# opens chromium browser
cb()
{
	if [[ $distroname == "Fedora" ]]; then
		google-chrome "${@}" 2>/dev/null &
	else
		chromium-browser "${@}" 2>/dev/null &
	fi
}
# }}}

# pdf() {{{
# opens acrobat reader
pdf()
{
	acroread "${@}" 2>/dev/null &
}
# }}}

# diff() {{{
# diff with colordiff
# in order to have bash completion worked properly you may have
# to comment the existing cdiff completion which is hardly used
# refer to /etc/bash_completion file
cdiff()
{
	colordiff -puw "${@}" | less -R
}
# }}}

# svndiff() {{{
# svn diff with colordiff
svndiff()
{
	svn diff "${@}" | colordiff | less -R
}
# }}}

# cvsdiff() {{{
# cvs diff with colordiff
cvsdiff()
{
	cvs diff "${@}" | colordiff | less -R
}
# }}}

# _synchronize_files() {{{
# synchronize from_dir with to_dir
# this should be called as _synchronize_files from_dir to_dir
_synchronize_files()
{
	if (($# != 2)); then
		echo "function is called with wrong number of arguments"
		return 1
	fi

	[ ! -d $1 ] && { echo "source directory($1) doesn't exist"; return 1; }
	[ ! -d $2 ] && { echo "destination directory($2) doesn't exist"; return 1; }

	local src=$1 dst=$2
	echo "You are about to copy files from $src to $dst"
	! _confirm && return 0

	local abs_src_file_list=

	file_list=(.ackrc .bash_logout .bash_profile .bashrc .colordiffrc .gvimrc .inputrc)
	file_list=(.zshrc $file_list)
	file_list=(.irbrc .tmux.conf .vimrc $file_list)

	for f in $file_list; do
		echo $src/$f
		[ -f $src/$f ] && abs_src_file_list="$abs_src_file_list $src/$f"
	done

	[ -d $src/.bash ] && abs_src_file_list="$abs_src_file_list $src/.bash"
	[ -d $src/.zsh ] && abs_src_file_list="$abs_src_file_list $src/.zsh"

	echo "synchronizing $src with $dst"
	eval rsync -av $abs_src_file_list $dst
}
# }}}

# sync_dotfiles_with_orig() {{{
# synchronize local dotfiles files in git directory with the
# originals
sync_dotfiles_with_orig()
{
	_synchronize_files $HOME $HOME/WORK/src/dotfiles
}
# }}}

# sync_orig_with_dotfiles() {{{
# synchronize original files with those in local dotfiles
# directory
sync_orig_with_dotfiles()
{
	_synchronize_files $HOME/WORK/src/dotfiles $HOME
}
# }}}

