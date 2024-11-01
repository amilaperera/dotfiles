#!/bin/bash

# user
default_username=`getent passwd $(whoami) | cut -d ':' -f 5 | cut -d ',' -f 1`

read -p "User name [$default_username]: " user_name
name=${user_name:-$default_username}

read -p "Email : " email

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
