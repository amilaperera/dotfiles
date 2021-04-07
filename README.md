Personal dotfiles
=================

This repo contains my personal dotfiles mainly related to _zsh_/_bash_, _vim_, _tmux_, _git_ etc.

The best way to install the environment is to use the
[environment setup](https://github.com/amilaperera/dotfiles/blob/master/scripts/setup_env.py) script which is provided with the dotfiles.

**Installation**
1. Execute the following command to bootstrap the new Linux machine.

        curl -s https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh | bash

2. Clone the dotfiles in to your local home directory

        git git@github.com:amilaperera/dotfiles.git ~/.dotfiles

3. Change to scripts directory

        cd ~/.dotfiles/scripts

4. Execute the [environment setup](https://github.com/amilaperera/dotfiles/blob/master/scripts/setup_env.py)
script to install the necessary target environments. Currently supported target environments are
_bash_, _zsh_, _vim_ & _misc_. The _misc_ environment sets up configurations such as _tmux_, _ag_, _git configuration_ etc.

**Example usages:**

* To setup zsh, vim and misc environments in current user's home directory.

        python setup_env.py -e zsh vim misc

* To setup bash and vim environment in some other directory.

        python setup_env.py -e bash vim -d /home/tester


**Note**

_zsh_ configurations depends on a personal fork of [ohmyzsh](https://github.com/amilaperera/ohmyzsh)

The personal repository can be synchronized with the upstream by executing the
[fork_sync.py](https://github.com/amilaperera/dotfiles/blob/master/scripts/fork_sync.py) script which is also provided with the dotfiles.
This script reads details about the forked repositories from the
[forks.json](https://github.com/amilaperera/dotfiles/blob/master/scripts/forks.json) file.
If syncing with the forks result in a need to push changes to the origin, the script will let you know.

