# tmux
#

# This creates a default tmux session
function aep_create_default_session()
{
    local root=$HOME
    local dotdir=$root/.dotfiles
    local session="default"

    if [ ! -d ${dotdir} ]; then
        dotdir=$root
    fi

    # If the session already exists do nothing
    tmux has-session -t "${session}" 2>/dev/null
    if [ $? -ne 0 ]; then
        TMUX='' tmux new-session -s "${session}" -c "${root}" -d -n "Shell"

        tmux new-window -c "${root}" -t "${session}:2" -d -n "Main"
        tmux send-keys -t "${session}:2" "nvim" Enter

        tmux new-window -c "${dotdir}" -t "${session}:3" -d -n "Dotfiles"
        tmux split-window -c "${dotdir}" -t "${session}:3"
        tmux select-layout -t "${session}:3.1" "even-horizontal"
        tmux send-keys -t "${session}:3.1" "nvim" Enter
        tmux send-keys -t "${session}:3.2"

        tmux new-window -c "${root}" -t "${session}:4" -d -n "Htop"
        tmux send-keys -t "${session}:4.1" "htop" Enter
    fi
    # Attach if we're outside TMUX, otherwise switch
    if [ -z $TMUX ]; then
        tmux attach-session -t "${session}"
    else
        tmux switch-client -t "${session}"
    fi
}

alias t='aep_create_default_session'
alias ta='tmux attach-session -t'
alias tl='tmux list-sessions'
alias ts='tmux new -s'

function tk()
{
    for i in $@; do tmux kill-session -t $i; done
}

