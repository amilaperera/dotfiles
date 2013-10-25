#############################################################
# Author: Amila Perera
# File Name: prompt.zsh
#############################################################

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
	file_list=$file_list" .irbrc .tmux.conf .vimrc"

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

##################################################################
## github clone
##################################################################
function ghc()
{
	git clone https://github.com/"${1}"
}

