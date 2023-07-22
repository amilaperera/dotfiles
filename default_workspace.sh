#!/bin/bash

dir=$(realpath $0)
root=$(dirname ${dir})
session="default"

# If the session already exists do nothing
tmux has-session -t "${session}" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "${session} already exists."
    exit 0
fi

tmux new-session -s "${session}" -c "${root}" -d -n "Main"
tmux send-keys -t "${session}:1" "nvim" Enter

tmux new-window -c "${root}" -t "${session}:2" -d -n "Shell"

tmux new-window -c "${root}" -t "${session}:3" -d -n "Scratch"
tmux split-window -c "${root}" -t "${session}:3"
tmux select-layout -t "${session}:3.1" "even-horizontal"
tmux send-keys -t "${session}:3.1" "nvim" Enter
tmux send-keys -t "${session}:3.2"

tmux new-window -c "${root}" -t "${session}:4" -d -n "Htop"
tmux send-keys -t "${session}:4.1" "htop" Enter

# If we're within TMXU, attach to the newly created session
if [ -z $TMUX ]; then
    tmux attach-session -t "${session}"
fi

unset dir root session
