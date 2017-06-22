#!/usr/bin/env bash

export DOTFILES_MODULES="${DOTFILES}/modules"

# Sensible defaults for BASH
if [ -f "${DOTFILES_MODULES}/.bash-sensible/sensible.bash" ]; then
  source "${DOTFILES_MODULES}/.bash-sensible/sensible.bash"
fi

# Load library files
_LIBS=${DOTFILES_MODULES}/lib/*.bash
for lib in ${_LIBS}; do
  [[ -e "${lib}" ]] && source "${lib}"
done
unset _LIBS lib

# Load custom modules
for module in ${DOTFILES_MODULES}/custom/*.bash; do
  [[ -e "${module}" ]] && source "${module}"
done

# Load enabled modules
if [ -d "${DOTFILES_MODULES}/enabled" ]; then
  _MODULES="${DOTFILES_MODULES}/enabled/*.module.bash"
  for module in ${_MODULES}; do
    [[ -e "${module}" ]] && source "${module}"
  done
  unset _MODULES module
fi

# Load prompt theme
source "${DOTFILES_MODULES}/themes/liquidprompt.bash"
