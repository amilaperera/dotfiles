#!/bin/bash

# uv and uvx shell completion
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"
