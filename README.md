Personal dotfiles
=================

This repo contains my personal dotfiles mainly related to _zsh_, _bash_, _vim_, _tmux_, _git_ etc.


**Installation**

Execute the following command to bootstrap the new Linux machine (installing essential packages + configuration setup).

        ALL=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh)"

If you need to install packages without setting up the configuration,

        PKG_INSTALL=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh)"

If you need to setup configuration without installing packages

        CONFIG_SETUP=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh)"

**Note**

_zsh_ configurations depends on a personal fork of [ohmyzsh](https://github.com/amilaperera/ohmyzsh)

The personal repository can be synchronized with the upstream by executing the
[fork_sync.py](https://github.com/amilaperera/dotfiles/blob/master/scripts/fork_sync.py) script which is provided with the dotfiles.
This script reads details about the forked repositories from the
[forks.json](https://github.com/amilaperera/dotfiles/blob/master/scripts/forks.json) file.

