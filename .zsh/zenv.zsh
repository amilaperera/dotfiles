#############################################################
# Author: Amila Perera
# File Name: zenv.zsh
#############################################################

# shell parameters {{{
# setting PATH variable {{{2
# making path array to contain only unique values
declare -U path
# adding addition directories to the path array
path=($path $HOME/bin)
# }}}2

# set workinghost {{{2
export workinghost=$(uname)
# }}}2

## getting the linux distrubution version {{{2
## NOTE: lsb_release might not work on distrubutions other than Ubuntu
if [[ $workinghost == "Linux" ]]; then
	if _check_if_command_exists lsb_release; then
		export distroname=$(lsb_release -si) # distro name
		export distrover=$(lsb_release -sr)  # distibution version
		export arch=$(uname -m)              # architecture
	fi
fi
# }}}2

# setting term colors {{{2
[ -z $TMUX ] && export TERM=xterm-256color  # let tmux decide TERM to use,
                                              # otherwise set it to xterm-256color
# }}}2

# history related stuff {{{2
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
# }}}2

# setting editor {{{2
export VISUAL='vim'
export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export CVS_EDITOR="$VISUAL"
export FCEDIT="$VISUAL"
# }}}2

# loads rvm environment {{{2
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
# }}}2
# }}}

# zsh options {{{
# changing directories {{{2
setopt autocd
# }}}2

# dirstack {{{2
# taken from Arch linux wiki https://wiki.archlinux.org/index.php/zsh
DIRSTACKFILE="$HOME/.dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
	dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
	[[ -d $dirstack[1] ]] && cd $dirstack[1]
fi

chpwd() {
	print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=50

setopt autopushd pushdsilent pushdtohome

## Remove duplicate entries
setopt pushdignoredups

## This reverts the +/- operators.
setopt pushdminus
# }}}2

# Changing/making/removing directory {{{2
setopt auto_name_dirs
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
# }}}2

# history {{{2
setopt appendhistory
setopt extendedhistory
setopt histignorealldups
setopt sharehistory
# }}}2
# }}}
