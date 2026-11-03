#!/usr/bin/env bash
# Build and run the Docker environments used to smoke-test this repository.
# Run from anywhere; paths are resolved relative to this script.
#
# Usage: tests/docker.sh {build|run|exec|test|list} [distro|all]

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TESTS_DIR="$ROOT/tests"
DISTROS=(alma debian fedora ubuntu)

NC=$'\033[0m'
BOLD=$'\033[1m'
RED=$'\033[91m'
GREEN=$'\033[92m'
YELLOW=$'\033[93m'
BLUE=$'\033[94m'
CYAN=$'\033[96m'

usage() {
	cat <<EOF
${BOLD}Usage:${NC} tests/docker.sh <command> [distro|all]

${BOLD}Commands:${NC}
  build <distro|all>  Build the Docker test image
  run <distro>        Start an interactive container
  exec <distro>       Open a shell in an existing container
  test <distro|all>   Build the image and run "make dev" inside it
  list                List supported distros

${BOLD}Distros:${NC} ${DISTROS[*]}
EOF
}

die() {
	printf '%bError: %s%b\n' "$RED" "$*" "$NC" >&2
	exit 1
}

image_name() {
	printf 'dotfiles-test-%s' "$1"
}

require_distro() {
	local distro="$1"
	local candidate

	for candidate in "${DISTROS[@]}"; do
		if [[ "$candidate" == "$distro" ]]; then
			return 0
		fi
	done

	die "unsupported distro '$distro' (choose from: ${DISTROS[*]})"
}

build() {
	local distro="$1"
	local dockerfile="$TESTS_DIR/Dockerfile.$distro"
	local tag
	tag="$(image_name "$distro")"

	[[ -f "$dockerfile" ]] || die "$dockerfile not found"

	printf '%b========================================%b\n' "$BLUE" "$NC"
	printf '%bBuilding %s with tag: %s%b\n' "$BLUE" "$distro" "$tag" "$NC"
	printf '%b========================================%b\n' "$BLUE" "$NC"

	if docker build -f "$dockerfile" -t "$tag" "$ROOT"; then
		printf '%bPASS: %s%b\n' "$GREEN" "$distro" "$NC"
	else
		die "failed to build $distro"
	fi
}

run() {
	local distro="$1"
	local tag
	tag="$(image_name "$distro")"

	docker image inspect "$tag" >/dev/null 2>&1 ||
		die "image $tag not found; run tests/docker.sh build $distro first"

	printf '%bRunning %s...%b\n' "$CYAN" "$tag" "$NC"
	docker run --name "$distro" -it "$tag" /bin/bash
}

exec_container() {
	local distro="$1"

	if [[ -n "$(docker ps -aq -f "name=^/${distro}$")" ]]; then
		docker start "$distro" >/dev/null
		docker exec -it "$distro" /bin/bash
	else
		die "container $distro not found; run tests/docker.sh run $distro first"
	fi
}

test_dev() {
	local distro="$1"

	build "$distro"
	printf '%bRunning make dev in %s...%b\n' "$CYAN" "$distro" "$NC"
	docker run --rm "$(image_name "$distro")" make dev
}

with_distros() {
	local action="$1"
	local target="${2:-}"

	if [[ "$target" == "all" ]]; then
		local distro
		for distro in "${DISTROS[@]}"; do
			"$action" "$distro"
		done
	elif [[ -n "$target" ]]; then
		require_distro "$target"
		"$action" "$target"
	else
		usage
		exit 1
	fi
}

main() {
	local command="${1:-}"
	local target="${2:-}"

	case "$command" in
	build)
		with_distros build "$target"
		;;
	test)
		with_distros test_dev "$target"
		;;
	run)
		[[ -n "$target" ]] || { usage; exit 1; }
		require_distro "$target"
		run "$target"
		;;
	exec)
		[[ -n "$target" ]] || { usage; exit 1; }
		require_distro "$target"
		exec_container "$target"
		;;
	list)
		printf '%s\n' "${DISTROS[*]}"
		;;
	help | -h | --help | "")
		usage
		;;
	*)
		usage
		exit 1
		;;
	esac
}

main "$@"
