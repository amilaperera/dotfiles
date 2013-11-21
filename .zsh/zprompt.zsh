#############################################################
# Author: Amila Perera
# File Name: zprompt.zsh
#############################################################

autoload -Uz promptinit
promptinit

# # Set required options.
# setopt promptsubst

# # Load required modules.
# autoload -U add-zsh-hook
# autoload -Uz vcs_info

# # Add hook for calling vcs_info before each command.
# add-zsh-hook precmd vcs_info

# # Set vcs_info parameters.
# zstyle ':vcs_info:*' enable hg bzr git
# zstyle ':vcs_info:*:*' check-for-changes true # Can be slow on big repos.
# zstyle ':vcs_info:*:*' unstagedstr '!'
# zstyle ':vcs_info:*:*' stagedstr '+'
# zstyle ':vcs_info:*:*' actionformats "%S" "%r/%s/%b %u%c (%a)"
# zstyle ':vcs_info:*:*' formats "%S" "%r/%s/%b %u%c"
# zstyle ':vcs_info:*:*' nvcsformats "%~" ""

# extracted from http://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/
# and tweaked accordingly
local op="("
local cp=")"
local user_host_path="${op}%B%F{magenta}%n%b%F{14}@%B%F{magenta}%m%b%F{14}:%B%F{yellow}%~%b%f${cp}"
local hist_no="${op}%F{12}%h%f${cp}"
local smiley="%(?,%{$fg[green]%}✓%{$reset_color%},%{$fg[red]%}✗%{$reset_color%})"

PROMPT="╭─${op}${smiley}${cp}─${user_host_path}
╰─${hist_no} %# "

local cur_cmd="${op}%_${cp}"
PROMPT2="%B%F{8}Continue%f%b : "
