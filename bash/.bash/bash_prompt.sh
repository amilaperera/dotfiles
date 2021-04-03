#!/bin/bash
#############################################################
# Author: Amila Perera
# File Name: bash_prompt.sh
#############################################################

NONE="\[\033[0m\]"    # unsets color to term's fg color

# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"

hn=
case $workinghost in
CYGWIN*		)	hn=$(hostname) ;;
*			)	hn=$(hostname -s);;
esac

# get user name
un=$(whoami)
# for root user we just capitalize the user name, so that it becomes "ROOT"
(($UID == 0)) && un=$(echo $un | tr 'a-z' 'A-Z')

git_prompt_file=/usr/share/git-core/contrib/completion/git-prompt.sh
[ -f $git_prompt_file ] && source $git_prompt_file

##################################################################
## prompt command function
## basically extracted from http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x869.html
## and slightly adjusted
##################################################################
function prompt_command() {
	git_prompt=$(__git_ps1 " (%s)")
	curr_dir=$(pwd)
}

PROMPT_COMMAND=prompt_command

case $TERM in
xterm*|rxvt*	)	TITLEBAR='\[\033]0;\u@\h:\w\007\]' ;;
*				)	TITLEBAR="" ;;
esac

# setting PS1
# PS1 is set separately for non-root users and root users
# "\342\234\223" sequence displays a 'right' symbol if the last command executed succeeded
# "\342\234\227" sequence displays a 'wrong' symbol if the last command executed failed
if (($UID != 0)); then
	# prompt for normal user
	PS1="$TITLEBAR\
${W}┌─(${EMK}${BGW}\$un${C}@${M}\$hn${C}:${Y}\$curr_dir${W})\
${W}─(\$(if [[ \$? == 0 ]]; then echo \"${EMG}\342\234\223\"; else echo \"${EMR}\342\234\227\"; fi)${W})\n\
${W}└─(${M}\#${W})${NONE} \\$ "
else
	# prompt for root
	PS1="$TITLEBAR\
${W}┌─(${R}\$un${C}@${M}\$hn${C}:${Y}\$curr_dir${W})\
${W}─(\$(if [[ \$? == 0 ]]; then echo \"${EMG}\342\234\223\"; else echo \"${EMR}\342\234\227\"; fi)${W})\n\
${W}└─(${M}\#${W})${NONE} \\$ "
fi

PS2="${EMK}-${EMB}-${EMK}Continue${EMB}:${NONE} "
PS3=$(echo -e -n "\033[1;34m-\033[1;30m-Enter Your Option\033[1;34m:\033[0m ")
PS4="+xtrace $0[$LINENO]: "

# setting MYSql prompt
export MYSQL_PS1="\u@\h [\d] > "

unset NONE K R G Y B M C W EMK EMR EMG EMY EMB EMM EMC EMW BGK BGR BGG BGY BGB BGM BGC BGW
