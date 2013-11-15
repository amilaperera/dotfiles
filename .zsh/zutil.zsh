#!/bin/zsh
#############################################################
# Author: Amila Perera
# File Name: zutil.zsh
#############################################################

# defining zsh true/false {{{
zsh_true=0
zsh_false=1
# }}}

# regular colors {{{
zsh_red_color="\033[0;31m"
zsh_green_color="\033[0;32m"
zsh_yellow_color="\033[0;33m"
zsh_blue_color="\033[0;34m"

zsh_bold_red_color="\033[1;31m"
zsh_bold_green_color="\033[1;32m"
zsh_bold_yellow_color="\033[1;33m"
zsh_bold_blue_color="\033[1;34m"

zsh_reset_color="\033[0m"
# }}}

# echo in red color {{{
_echo_red()
{
	echo -e $zsh_red_color"$@"$zsh_reset_color
}
# }}}

# echo in green color {{{
_echo_green()
{
	echo -e $zsh_green_color"$@"$zsh_reset_color
}
# }}}

# echo in yellow color {{{
_echo_yellow()
{
	echo -e $zsh_yellow_color"$@"$zsh_reset_color
}
# }}}

# echo in blue color {{{
_echo_blue()
{
	echo -e $zsh_blue_color"$@"$zsh_reset_color
}
# }}}

# outputs console log {{{
_console_log()
{
	echo '['$(date +'%a %Y-%m-%d %H:%M:%S %z')']' $1
}
# }}}

# prompts the user for confirmation and returns 'y'/'n' {{{
_confirm()
{
	local answer=''
	local choice=''

	local prompt="confirm [y/n] > "

	until [[ "$choice" = "y" || "$choice" = "n" ]]; do

		read -r "answer?$prompt"
		case "$answer" in
			[yY] ) choice='y';;
			[nN] ) choice='n';;
			* ) ;;
		esac
	done

	[ "$choice" = "y" ] && return $zsh_true || return $zsh_false
}
# }}}

# checks if the current shell is interactive {{{
_check_for_shell_interactivity()
{
	case "$-" in
		*i* ) return $zsh_true;;
		* ) return $zsh_false;;
	esac
}
# }}}

# checks if command exists {{{
_check_if_command_exists()
{
	if  (($# != 1)) ; then
		echo "_check_if_command_exists function should take exactly one argument"
		return $zsh_false
	fi

	type $1 >/dev/null 2>&1
}
# }}}
