#!/usr/bin/env bash

export STARSHIP_CONFIG=~/.config/starship/config.toml
eval "$(starship init bash)"
export PROMPT_COMMAND="starship_precmd;${PROMPT_COMMAND/starship_precmd;/}"
