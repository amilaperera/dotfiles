Dotfiles — Amila Perera
-----------------------

Personal dotfiles and scripts to quickly bootstrap a Linux workstation.

Included configurations
- bash (with aep_bash_lib)
- nvim
- vim (minimal)
- tmux
- git
- wezterm

Scripts
- Install packages (apt/dnf/pacman supported)
- Build compilers and libraries (gcc, clang, boost)

Quick start
- Remote bootstrap:
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh)"
- Local:
  ./bootstrap.sh

Apply or test individual configs
- make -C config all    # install/link everything
- make -C config nvim   # install/link only nvim config

Edit files under config/ and run the Makefile targets to apply changes.

