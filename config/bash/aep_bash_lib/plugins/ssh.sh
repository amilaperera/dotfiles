#!/bin/bash

# Start SSH Agent
# Reference: https://gist.github.com/bsara/5c4d90db3016814a3d2fe38d314f9c23
GITHUB_ID="${HOME}/.ssh/id_github_personal"
SSH_ENV="$HOME/.ssh/environment"
SSH_CONFIG="$HOME/.ssh/config"

function run_ssh_env
{
    . "${SSH_ENV}" > /dev/null
}

function start_ssh_agent
{
    echo "Initializing new SSH agent..."
    ssh-agent | sed 's/^echo/#echo/' >| "${SSH_ENV}"
    echo "succeeded"
    chmod 600 "${SSH_ENV}"

    run_ssh_env

    ssh-add "${GITHUB_ID}"
}

if [ -f "${GITHUB_ID}" ]; then
    if [ ! -f "${SSH_CONFIG}" ]; then
        echo "Host github.com
 Hostname github.com
 identityFile ~/.ssh/id_github_personal" >> ${SSH_CONFIG}
    fi

    if [ -f "${SSH_ENV}" ]; then
        run_ssh_env
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_ssh_agent
        }
    else
        start_ssh_agent
    fi
fi


