#!/usr/bin/env bash

RBENV_PATH=${RBENV_PATH:-"${HOME}/.rbenv"}

pathmunge "${RBENV_PATH}/bin"

( command_exists rbenv ) && eval "$(rbenv init -)"

if [ -d "${RBENV_PATH}/plugins/ruby-build" ]; then
  pathmunge "${RBENV_PATH}/plugins/ruby-build/bin"
fi

# Completion
if [ -e "${RBENV_PATH}/completions/rbenv.bash" ]; then
  source "${RBENV_PATH}/completions/rbenv.bash"
fi

