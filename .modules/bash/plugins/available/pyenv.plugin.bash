#!/usr/bin/env bash

PYENV_PATH=${PYENV_PATH:-"${HOME}/.pyenv"}

pathmunge "${PYENV_PATH}/bin"

( command_exists pyenv ) && eval "$(pyenv init -)"

# load pyenv virtualenv if the virtualenv plugin is installed
if ( pyenv virtualenv-init - &>/dev/null ); then
  eval "$(pyenv virtualenv-init -)"
fi

# Completion
if [ -e "${PYENV_PATH}/completions/pyenv.bash" ]; then
  source "${PYENV_PATH}/completions/pyenv.bash"
fi

