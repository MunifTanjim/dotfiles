#!/usr/bin/env bash

# Sensible defaults for BASH
if [ -f "${DOTFILES_MODULES}/.bash-sensible/sensible.bash" ]; then
  source $DOTFILES_MODULES/.bash-sensible/sensible.bash
fi

DOTFILES_MODULES="${DOTFILES}/modules"

_HELPERS="${DOTFILES_MODULES}/helpers/*.bash"
for file in $_HELPERS; do
  if [ -e "${file}" ]; then
    source $file
  fi
done

for module_type in "aliases" "plugins" "completion"; do
  _load_modules $module_type
done

unset file module_type

# LiquidPrompt
source $DOTFILES_MODULES/.liquidprompt/liquidprompt

