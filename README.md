Personal dotfiles
=================

This repo contains my personal dotfiles mainly related to zsh/bash, vim, tmux and irb.

The best way to install the environment is to use the ruby script which is provided with the
dotfiles.

**Installation**

1. Install ruby on your system

    On Fedora/CentOS/RHEL

        sudo yum install ruby

    On Ubuntu/Debian

        sudo apt-get install ruby

2. clone the dotfiles in to your local home directory

        git clone https://github.com/amilaperera/dotfiles.git ~/.dotfiles

3. move to the setup directory

        cd ~/.dotfiles/setup

4. execute the interactive environment setup script

        ruby setup_env.rb


**Interactive ruby shell settings**

My personal preferences for IRB customizations are stored in dotfiles/.irbrc.

To get the most out of these you should install the following gems.

 * wirble
 * awesome_print
 * hirb

To install the above gems

    gem install wirble awesome_print hirb --no-rdoc --no-ri

