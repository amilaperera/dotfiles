#!/bin/bash

# uv and uvx shell completion
command -v uv &>/dev/null && eval "$(uv generate-shell-completion bash)"
command -v uvx &>/dev/null && eval "$(uvx --generate-shell-completion bash)"
