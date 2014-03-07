Personal dotfiles
=================

This repo contains my personal dotfiles mainly related to zsh/bash, vim, tmux and irb.

The best way to install the environment is to use the
[environment setup](https://github.com/amilaperera/dotfiles/blob/master/scripts/setup_env.rb) script which is provided with the
dotfiles.

**Installation**

1. Install ruby on your system

    On Fedora/CentOS/RHEL

        sudo yum install ruby

    On Ubuntu/Debian

        sudo apt-get install ruby

2. clone the dotfiles in to your local home directory

        git clone https://github.com/amilaperera/dotfiles.git ~/.dotfiles

3. move to the scripts directory

        cd ~/.dotfiles/scripts

4. execute the [environment setup](https://github.com/amilaperera/dotfiles/blob/master/scripts/setup_env.rb)
script

        ruby setup_env.rb


**Interactive ruby shell settings**

My personal preferences for IRB customizations are stored in dotfiles/.irbrc.

To get the most out of these you should install the following gems.

 * wirble
 * awesome\_print
 * hirb

To install the above gems

    gem install wirble awesome_print hirb --no-rdoc --no-ri

**NOTE**

There are some forked repositories that I use (such as oh-my-zsh, vim-snippets etc.).

These repositories can be synchronized with the upstream by executing the
[fork_sync.rb](https://github.com/amilaperera/dotfiles/blob/master/scripts/fork_sync.rb) script which
is also provided with the dotfiles.
This script reads details about the forked repositories from the
[.fork_sync.yaml](https://github.com/amilaperera/dotfiles/blob/master/scripts/.fork_sync.yaml) file.

**_Remember to push the commits after synchronization._**
