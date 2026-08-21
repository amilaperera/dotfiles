#!/bin/bash

# Parse arguments
name=""
email=""
force=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            name="$2"
            shift 2
            ;;
        --email)
            email="$2"
            shift 2
            ;;
        -f)
            force=true
            shift
            ;;
        *)
            echo "Usage: $0 [-f] --name <name> --email <email>"
            exit 1
            ;;
    esac
done

if [[ -z "$name" || -z "$email" ]]; then
    echo "Error: --name and --email are required"
    echo "Usage: $0 [-f] --name <name> --email <email>"
    exit 1
fi

if [[ -f ${HOME}/.gitconfig && "$force" == false ]]; then
    echo "${HOME}/.gitconfig exists. Specify -f to overwrite."
    exit 1
fi

git config --global user.email "$email"
git config --global user.name "$name"

# aliases
git config --global alias.st 'status'
git config --global alias.ci 'commit'
git config --global alias.co 'checkout'
git config --global alias.br 'branch'
git config --global alias.graph 'log --oneline --graph --all'

# core
git config --global core.editor 'nvim'
git config --global core.autocrlf 'input'

# ui
git config --global color.ui 'auto'

# show settings
echo
echo "---- Global gitconfig settings ----"
git --no-pager config --global --list
