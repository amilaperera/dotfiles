Personal dotfiles
=================

This repo contains my personal dotfiles mainly related to _zsh_, _bash_, _vim_, _tmux_, _git_ etc.


**Installation**

Execute the following command to bootstrap the new Linux machine (installing essential packages + configuration setup).

        curl -s https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh | ALL=1 bash

If you need to install packages without setting up the configuration,

        curl -s https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh | PKG_INSTALL=1 bash

If you need to setup configuration without installing packages

        curl -s https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh | CONFIG_SETUP=1 bash

**Note**

_zsh_ configurations depends on a personal fork of [ohmyzsh](https://github.com/amilaperera/ohmyzsh)

The personal repository can be synchronized with the upstream by executing the
[fork_sync.py](https://github.com/amilaperera/dotfiles/blob/master/scripts/fork_sync.py) script which is provided with the dotfiles.
This script reads details about the forked repositories from the
[forks.json](https://github.com/amilaperera/dotfiles/blob/master/scripts/forks.json) file.

