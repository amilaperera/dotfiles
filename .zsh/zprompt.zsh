#############################################################
# Author: Amila Perera
# File Name: zprompt.zsh
#############################################################

autoload -Uz promptinit
promptinit

setopt promptsubst # sets the PROMPT_SUBST option enabled
# extracted from http://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/
# and tweaked according to personal preferece
local op="("
local cp=")"
local username=$(whoami)
local user_host_path=
if (( $UID == 0)); then
	username=$(echo $username | tr 'a-z' 'A-Z')
	user_host_path="${op}%B%F{red}$username%b%F{14}@%B%F{magenta}%m%b%F{14}:%B%F{yellow}%~%b%f${cp}"
else
	user_host_path="${op}%B%F{magenta}$username%b%F{14}@%B%F{magenta}%m%b%F{14}:%B%F{yellow}%~%b%f${cp}"
fi
local hist_no="${op}%F{12}%h%f${cp}"
local smiley="%(?,%{$fg[green]%}✓%{$reset_color%},%{$fg[red]%}✗%{$reset_color%})"

PROMPT='╭─${op}${smiley}${cp}─${user_host_path}$(git_prompt_info)
╰─${hist_no} %# '

local cur_cmd="${op}%_${cp}"
PROMPT2="%B%F{8}Continue%f%b : "

ZSH_THEME_GIT_PROMPT_PREFIX="─%{$fg[white]%}(%{$fg_bold[white]%}git%{$reset_color%}%{$fg[white]%})%{$reset_color%}─%{$fg[white]%}(%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[white]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
