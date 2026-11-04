#!/usr/bin/env bash
# Smoke-test config linking without touching the real HOME or asking for
# identity details. Safe to run on the host or inside a container.
#
# Usage: tests/config-test.sh
#
# Environment:
#   NETWORK=1       Also test the network downloads (fzf, git-prompt.sh)
#   TEST_NAME=...   Override the fixture git user name
#   TEST_EMAIL=...  Override the fixture git email
#   KEEP_TEST_HOME=1  Keep the temporary HOME for inspection

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$ROOT/config"

NC=$'\033[0m'
RED=$'\033[91m'
GREEN=$'\033[92m'
YELLOW=$'\033[93m'
CYAN=$'\033[96m'

TEST_NAME="${TEST_NAME:-Dotfiles Test}"
TEST_EMAIL="${TEST_EMAIL:-dotfiles-test@example.com}"
NETWORK="${NETWORK:-0}"

fail() {
	printf '%bFAIL: %s%b\n' "$RED" "$*" "$NC" >&2
	exit 1
}

pass() {
	printf '%bPASS:%b %s\n' "$GREEN" "$NC" "$*"
}

info() {
	printf '%b%s%b\n' "$CYAN" "$*" "$NC"
}

assert_symlink() {
	local link="$1"
	local target="$2"
	local actual expected

	[[ -L "$link" ]] || fail "$link is not a symlink"
	actual="$(readlink -f "$link")"
	expected="$(readlink -f "$target")"
	[[ "$actual" == "$expected" ]] || fail "$link -> $actual (expected $expected)"
	pass "$link -> $expected"
}

assert_file() {
	local file="$1"

	[[ -s "$file" ]] || fail "$file is missing or empty"
	pass "$file exists"
}

assert_git_config() {
	local key="$1"
	local expected="$2"
	local actual

	actual="$(git config --global --get "$key" || true)"
	[[ "$actual" == "$expected" ]] || fail "git config $key is '$actual' (expected '$expected')"
	pass "git config $key = $expected"
}

[[ -f "$CONFIG_DIR/Makefile" ]] ||
	fail "config/Makefile not found; run from a dotfiles checkout"

TEST_HOME="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-config-test.XXXXXX")"
cleanup() {
	if [[ "${KEEP_TEST_HOME:-0}" == "1" ]]; then
		printf '%bKept test HOME:%b %s\n' "$YELLOW" "$NC" "$TEST_HOME"
	else
		rm -rf "$TEST_HOME"
	fi
}
trap cleanup EXIT

export HOME="$TEST_HOME"

make_args=(NAME="$TEST_NAME" EMAIL="$TEST_EMAIL")
if [[ "$NETWORK" != "1" ]]; then
	make_args+=(OFFLINE=1)
fi

printf '%b========================================%b\n' "$CYAN" "$NC"
printf '%bConfig smoke test%b\n' "$CYAN" "$NC"
printf 'Home:   %s\n' "$TEST_HOME"
printf 'Name:   %s\n' "$TEST_NAME"
printf 'Email:  %s\n' "$TEST_EMAIL"
printf 'Network: %s\n' "$([[ "$NETWORK" == "1" ]] && echo enabled || echo disabled)"
printf '%b========================================%b\n' "$CYAN" "$NC"

info "Linking configs..."
make -C "$ROOT" config "${make_args[@]}"

info "Checking symlinks..."
assert_symlink "$HOME/.bashrc" "$CONFIG_DIR/bash/.bashrc"
assert_symlink "$HOME/.bash_profile" "$CONFIG_DIR/bash/.bash_profile"
assert_symlink "$HOME/.inputrc" "$CONFIG_DIR/bash/.inputrc"
assert_symlink "$HOME/aep_bash_lib" "$CONFIG_DIR/bash/aep_bash_lib"
assert_symlink "$HOME/.config/nvim" "$CONFIG_DIR/nvim"
assert_symlink "$HOME/.vimrc" "$CONFIG_DIR/vim/.vimrc"
assert_symlink "$HOME/.tmux.conf" "$CONFIG_DIR/tmux/.tmux.conf"
assert_symlink "$HOME/.gdbinit" "$CONFIG_DIR/gdb/.gdbinit"
assert_symlink "$HOME/.wezterm.lua" "$CONFIG_DIR/wezterm/.wezterm.lua"
assert_symlink "$HOME/wallpapers" "$ROOT/wallpapers"

info "Checking generated files..."
assert_file "$HOME/.gitconfig"
[[ -d "$HOME/.local" ]] || fail "$HOME/.local was not created"
pass "$HOME/.local exists"

if [[ "$NETWORK" == "1" ]]; then
	assert_file "$HOME/.local/git-prompt.sh"
	[[ -x "$HOME/.fzf/install" ]] || fail "$HOME/.fzf/install is missing"
	pass "$HOME/.fzf/install exists"
else
	pass "Skipped network artifact checks (NETWORK=0)"
fi

info "Checking git config..."
assert_git_config user.name "$TEST_NAME"
assert_git_config user.email "$TEST_EMAIL"
assert_git_config alias.st status
assert_git_config core.editor nvim
assert_git_config core.autocrlf input

info "Checking shell syntax..."
bash -n "$HOME/.bashrc" || fail "bash syntax error in $HOME/.bashrc"
pass "bash -n $HOME/.bashrc"
bash -n "$HOME/.bash_profile" || fail "bash syntax error in $HOME/.bash_profile"
pass "bash -n $HOME/.bash_profile"

printf '\n%bAll config checks passed.%b\n' "$GREEN" "$NC"
