#!/usr/bin/env bash

export PYENV_ROOT="$HOME/.pyenv"
pathmunge "${PYENV_ROOT}/bin"

( command_exists pyenv ) && eval "$(pyenv init -)"

# load pyenv virtualenv if the virtualenv plugin is installed
if ( pyenv virtualenv-init - &>/dev/null ); then
  eval "$(pyenv virtualenv-init -)"
fi

# pyenv bash completion
if [ -e "${PYENV_ROOT}/completions/pyenv.bash" ]; then
  source "${PYENV_ROOT}/completions/pyenv.bash"
fi

