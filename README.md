Personal dotfiles
=================

This repo contains my personal dotfiles and scripts to set up a new Linux machine.

**Included Configurations**
* bash + readline
* nvim
* vim (very minimal, mostly using nvim)
* tmux
* git
* wezterm

**Scripts**
* install essential packages via apt/dnf (Tested in Debian/Ubuntu and Fedora)
* compile gcc/gdb from source code
* compile llvm(clang) from source code
* compile boost C++ from source code


**Installation**

Execute the following command to bootstrap the new Linux machine (installing essential packages + configuration setup).

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh)"
```

