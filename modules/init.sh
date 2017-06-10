#!/usr/bin/env bash

DOTFILES_MODULES="${DOTFILES}/modules"

# Sensible defaults for BASH
if [ -f "${DOTFILES_MODULES}/.bash-sensible/sensible.bash" ]; then
  source $DOTFILES_MODULES/.bash-sensible/sensible.bash
fi

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

# Bash theme
source $DOTFILES_MODULES/themes/liquidprompt.bash

