#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: bash_comp.sh
#############################################################

# general bash completions
[ -f /etc/bash_completion ] && source /etc/bash_completion

bash_comp_file=/usr/share/bash-completion/bash_completion
[ -f $bash_comp_file ] && source $bash_comp_file

# rvm completions
[ -r $rvm_path/scripts/completion ] && . $rvm_path/scripts/completion

# tmuxinator completions
[ -f $HOME/bin/tmuxinator_completion ] && source $HOME/bin/tmuxinator_completion

# rails completion
[ -f $HOME/bin/rails.bash ] && source $HOME/bin/rails.bash

# rails completion
[ -f $HOME/bin/rails.bash ] && source $HOME/bin/rails.bash

# folder bookmark completions
complete -F _bm_comp bm B

complete -o dirnames -f -X '!*.@(?([xX]|[sS])[hH][tT][mM]?([lL]))' ff cb
complete -o dirnames -f -X '!*.[pf]df' pdf

function _bm_comp()
{
	local file="$HOME/.bmarks"
	local cur=
	COMPREPLY=()
	cur=${COMP_WORDS[$COMP_CWORD]}
	if (( $COMP_CWORD == 1 )); then
		if [ -f $file ]; then
			COMPREPLY=( $(compgen -W "$(awk -F':' '{ print $1 }' $file) -c -d -r -m -e -l -h" -- "${cur}") )
		else
			COMPREPLY=( $(compgen -W "-c -h" -- "${cur}") )
		fi
	elif (( $COMP_CWORD == 2 )) && [[ ${COMP_WORDS[1]} =~ -[rm] ]]; then
		COMPREPLY=( $(compgen -W "$(awk -F':' '{ print $1 }' $file)" -- "${cur}") )
	elif (( $COMP_CWORD >= 2 )) && [[ ${COMP_WORDS[1]} =~ -[de] ]]; then
		COMPREPLY=( $(compgen -W "$(awk -F':' '{ print $1 }' $file)" -- "${cur}") )
	elif (( $COMP_CWORD == 3 )) && [[ ${COMP_WORDS[1]} =~ -[cm] ]]; then
		_filedir -d
	fi
}
