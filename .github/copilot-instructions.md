Repository: amilaperera/dotfiles — personal dotfiles and setup scripts.

1) Build, test, and lint commands

- No formal build/test/lint system in this repo (it's a dotfiles collection).
- System bootstrap (primary entrypoint):
  - From remote: bash -c "$(curl -fsSL https://raw.githubusercontent.com/amilaperera/dotfiles/master/bootstrap.sh)"
  - Local: ./bootstrap.sh  (runs interactive installer + calls make in config/)
- Per-component installs via Makefile in config/:
  - Install everything: make -C config all
  - Install one component (single-target example):
    - make -C config nvim   # install/link only nvim config
    - make -C config bash   # install/link only bash config
  - These are the recommended "single action" commands when you want to apply or test one config at a time.

2) High-level architecture (big picture)

- Top-level layout:
  - config/: app-specific configuration directories (bash, nvim, tmux, gdb, git, wezterm, vim)
  - scripts/: helper scripts for building compilers and installing packages
  - bootstrap.sh: interactive system-level entrypoint that probes OS, installs packages, offers an option list (dialog) and delegates to Makefile targets and scripts
  - wallpapers/, README.md, and helper installer scripts
- Flow for a fresh machine:
  1. Run bootstrap.sh -> probes OS, selects package manager (apt/dnf/pacman) -> installs packages/options
  2. bootstrap.sh -> calls setup_configs which clones (or updates) ~/.dotfiles and runs make in config/
  3. make -C config creates symlinks and installs per-app helpers (fzf, git prompt)

3) Key conventions and patterns

- Single-source configs: each app/config lives under config/<app>/ and Makefile symlinks them into $HOME. Prefer editing the files under config/ not the symlink targets.
- Makefile single-target usage: use make -C config <target> to apply only one subsystem (useful for incremental changes or testing).
- Bootstrap choices are interactive (dialog). To script non-interactively, inspect bootstrap.sh functions (e.g., base, dev_tools, python_stuff) and call them or run the Makefile targets directly.
- BYPASS_SSH flag: bootstrap.sh supports cloning via HTTPS when BYPASS_SSH=1 is set (useful in environments without SSH keys):
  - BYPASS_SSH=1 ./bootstrap.sh
- aep_bash_lib: reusable bash library under config/bash/aep_bash_lib; many scripts source these helpers — change with care.

4) AI / Copilot integration notes

- Neovim copilot plugin present: config/nvim/lua/plugins/ai/copilot.lua uses github/copilot.vim.
- bootstrap.sh has an "AI" option that runs ai_stuff (installs opencode via curl). Keep in mind network-based installers are invoked directly from bootstrap.

5) Files for assistant to inspect quickly

- Primary files for automation or changes: bootstrap.sh, config/Makefile, config/* (per-app configs), scripts/* (heavy tasks).
- No test harness or linter configured — changes are validated functionally by running specific make targets or the bootstrap workflow.

If this file existed previously, consider merging any local instructions into the matching sections above.

---
Generated from repository scan on 2026-06-23.
