#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: .bash_func
#############################################################

##################################################################
## setenv()
## keeps tcsh users happy
##################################################################
function setenv()
{
	if [ $# -eq 2 ]; then
		eval $1=$2
		export $1
	else
		echo "Usage: setenv NAME VALUE" 1>&2
	fi
}

##################################################################
## E()
## starts gvim in background
##################################################################
function E()
{
	GVIM_COMM=/usr/bin/gvim
	case $workinghost in
		Linux )
			local vimSrvName="GVIM"
			local currentVimSrv=$($GVIM_COMM --serverlist | grep -c "$vimSrvName")
			if (($currentVimSrv > 0)); then
				## start editing with the current vim instance
				if (($# == 0)); then
					printf 'Vim instance is already started.\n'
					printf 'Use E <filename>... to open a file in already started vim instance\n'
					return 101
				else
					$GVIM_COMM --remote "${@}"
				fi
			else
				## if there's no vim start one
				$GVIM_COMM --servername "$vimSrvName" "${@}" &
			fi
			;;
		*)
			gvim "${@}" &
			;;
	esac
}
##################################################################
## cd()
## own pushd function to act as cd command
##################################################################
function cd()
{
	local directory
	if [ $# -eq 0 ]; then
		directory=$HOME
	else
		directory="${1}"
	fi
	pushd "${directory}" > /dev/null
	return $?
}

##################################################################
## cdf()
## fuzzy cd function
## NOTE: ignore-case does not work with fuzzy cd
##################################################################
function cdf()
{
	cd *$1*
}

##################################################################
## d()
## own version of dirs
## dispalys the directory stack of the current session and gets
## the directory as an input
##################################################################
function d()
{
	local tempdirstack=$(dirs)
	local dirstack=($(echo $tempdirstack | tr ' ' '\n' | sort -u))
	local temp_col=$COLUMNS
	COLUMNS=20

	select directory in "${dirstack[@]}"; do
		if [[ $REPLY == [Qq] ]]; then
			break
		elif [ -z "$directory" ]; then
			printf '%s\n' 'Invalid Entry'
			continue
		else
			[[ "$directory" =~ ^~ ]] && \
				cd "$HOME""${directory:1}" || \
				cd "$directory"
			break
		fi
	done
	COLUMNS=$temp_col   # restoring value of COLUMNS so that the change does not affect prompt PS1
						# which refer its value
	return $?
}

##################################################################
## up()
## goes up in the directory hierachy
##################################################################
function up()
{
	: ${CDUPVALUEDEFAULT:=5}	# set default value to 5 if not set externally

	local upvalue= upcount=0 cdupcount=0

	if (( $# > 1 )); then
		echo "Usage: up [numeric_value]" 1>&2
		return 101
	elif (( $# == 0 )); then
		# if no argument is supplied goes one level up
		upvalue="../"
	else
		# if one argument is supplied then go up the directory hierachy
		if(( $1 > $CDUPVALUEDEFAULT )); then
			# limits the maximum up levels to the value defined by CDVALUEDEFAULT
			cdupcount=$CDUPVALUEDEFAULT
		else
			cdupcount=$1
		fi
		# construct the upvalue string
		for (( upcount=0; upcount<$cdupcount; upcount++ )); do
			upvalue="$upvalue../"
		done
	fi

	cd "$upvalue" # use user define cd not builtin cd
	return 0
}

##################################################################
## ht()
## histroy tail function
##################################################################
function ht()
{
	: ${HISTORYTAILDEFAULT:=30}
	if [  $# -eq 0 ]; then
		printf "%s\n" "Last $HISTORYTAILDEFAULT History Status ====>"
		history | tail -n $HISTORYTAILDEFAULT
	elif [  $# -gt 1 ]; then
		echo "Usage: ht <numerical value>"
	else
		printf "%s\n" "Last $1 History Status ====>"
		history | tail -n $1
	fi

	return $?
}

##################################################################
## hig()
## history grep
##################################################################
function hig()
{
	# this function removes the default grep line number from the history which is troublsome
	# line number is given in GREP_OPTIONS variable
	history | egrep --color=always "${@}"
}

##################################################################
## calc()
## Trivial command line calculator
##################################################################
function calc()
{
	awk "BEGIN {print \"The answer is : \" $*}";
}

##################################################################
## mcd()
## creates a new directory and cd to it
##################################################################
function mcd()
{
	local dir=
	local mcd_usage="Usage: mcd <mode> directory"

	if [ $# -eq 0 -o $# -gt 2 ]; then
		echo "$mcd_usage"
	else
		if [ -n "$2" ]; then
			if [ -d "$2" ]; then
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

	cd "$dir"	#calls my own cd not the builtin
}

##################################################################
## um()
## displays the umask in both permission bits and acl
##################################################################
function um()
{
	if (($# != 0)); then
		echo "Usage: um"
		return 101
	fi
	echo "umask is set as follows"
	umask && umask -S
}

##################################################################
## bak()
## make backup file(s)
##################################################################
function bak()
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

##################################################################
## diffWithOrig()
## diff files with their .bak or .orig extension files
##################################################################
function diffWithOrig()
{
	local file= file2= opt="-puw"
	if [[ $1 == "--help" ]]; then
		cat <<- HELPMSG
			diffWithOrig [diff_options] file1 file2 ...
			Note: if no diff_options are given -puw is the default
		HELPMSG
		return 101
	elif [[ $1 =~ \-.* ]]; then
		opt="${1}"
		shift
	fi

	for file in "${@}"; do
		if [ -f ${file} ]; then
			if [ -f ${file}".bak" ]; then
				file2=${file}".bak"
				eval diff ${opt} ${file2} ${file}
			elif [ -f ${file}."orig" ]; then
				file2=${file}".orig"
				eval diff ${opt} ${file2} ${file}
			else
				printf "%s: No file to compare with\n" ${file}
			fi
		else
			printf "%s: file doesn't exist\n" ${file}
		fi
	done
}

##################################################################
## swap()
## swap two files
##################################################################
function swap()
{
	local tempfile=swaptemp.$$
	mv -f "${1}" "${tempfile}" && mv -f "${2}" "${1}" && mv -f "${tempfile}" "${2}"
}

##################################################################
## ff()
## opens firefox
##################################################################
function ff()
{
	firefox "${@}" 2>/dev/null &
}

##################################################################
## cb()
## opens chromium browser
##################################################################
function cb()
{
	if [[ $distroname == "Fedora" ]]; then
		google-chrome "${@}" 2>/dev/null &
	else
		chromium-browser "${@}" 2>/dev/null &
	fi
}

##################################################################
## pdf()
## opens acrobat reader
##################################################################
function pdf()
{
	acroread "${@}" 2>/dev/null &
}

##################################################################
## diff()
## diff with colordiff
## in order to have bash completion worked properly you may have
## to comment the existing cdiff completion which is hardly used
## refer to /etc/bash_completion file
##################################################################
function cdiff()
{
	colordiff -puw "${@}" | less -R
}

##################################################################
## svndiff()
## svn diff with colordiff
##################################################################
function svndiff()
{
	svn diff "${@}" | colordiff | less -R
}

##################################################################
## cvsdiff()
## cvs diff with colordiff
##################################################################
function cvsdiff()
{
	cvs diff "${@}" | colordiff | less -R
}

##################################################################
## engman()
## view man page in english
##################################################################
function engman()
{
	local lang=$LANG
	LANG=en_US.UTF8 && man "${@}"
	export LANG=$lang
}

##################################################################
## find man pages
## colorizing the matching result
##################################################################
function fman()
{
	apropos "$@" | grep -i "$@"
}

##################################################################
## find man pages
## colorizing the matching result
##################################################################
function gccgtk()
{
	gcc "${@}" -o gtkprg `pkg-config --cflags --libs gtk+-2.0`
}

##################################################################
## display ansi color combinations
## hacked from http://www.pixelbeat.org/docs/terminal_colours/
##################################################################
function color_codes()
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

##################################################################
## start tmux session
## NOTE: This function can be called in .bashrc
##################################################################
function tmux_start()
{
	local session_name= archey_cmd="archey"

	[ $# -eq 0 ] && session_name="$USER" || session_name=$1

	if _check_if_command_exists tmux; then
		if [[ "$TERM" != "screen-256color" ]]; then
			tmux attach-session -t "$session_name"
			if [ $? -ne 0 ]; then
				# if a $session_name named tmux session doesn't exist,
				# then create a new session
				tmux new-session -s "$session_name" -d # first create in detached mode

				_check_if_command_exists $archey_cmd && tmux send-keys -t "$session_name" "$archey_cmd" C-m

				tmux attach-session # attach the session
			fi
		fi
	fi
}

##################################################################
## display tmux colors
##################################################################
function tmux_colors()
{
	for i in {0..255}; do
		printf "\x1b[38;5;${i}mcolour${i}\n"
	done | less
}

##################################################################
## update vim plugins in .vim/bundle directory
##################################################################
function vim_bundle_update()
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

##################################################################
## synchronize from_dir with to_dir
## this should be called as _synchronize_files from_dir to_dir
##################################################################
function _synchronize_files()
{
	if [ $# -ne 2 ]; then
		echo "function is called with wrong number of arguments"
		return 1
	fi

	[ ! -d $1 ] && { echo "source directory($1) doesn't exist"; return 1; }
	[ ! -d $2 ] && { echo "destination directory($2) doesn't exist"; return 1; }

	local src=$1 dst=$2
	echo "You are about to copy files from $src to $dst"
	! _confirm && return 0

	local abs_src_file_list=

	file_list=".ackrc .bash_logout .bash_profile .bashrc .colordiffrc .gvimrc .inputrc"
	file_list=$file_list" .irbrc .tmux.conf .vimrc .vum_repos"
	for f in ${file_list}; do
		[ -f $src/$f ] && abs_src_file_list="$abs_src_file_list $src/$f"
	done

	[ -d $src/.bash ] && abs_src_file_list="$abs_src_file_list $src/.bash"

	echo "synchronizing $src with $dst"
	rsync -av $abs_src_file_list $dst
}

##################################################################
## synchronize configuration files in git directory with the
## originals
##################################################################
function sync_config_with_orig()
{
	_synchronize_files $HOME $HOME/WORK/src/configs
}

##################################################################
## synchronize original files with those in configs directory
##################################################################
function sync_orig_with_config()
{
	_synchronize_files $HOME/WORK/src/configs $HOME
}