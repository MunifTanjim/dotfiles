# shellcheck shell=sh

export PYENV_ROOT=${PYENV_ROOT:-"${HOME}/.pyenv"}
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export VIRTUAL_ENV_DISABLE_PROMPT=1

pathmunge "${PYENV_ROOT}/bin"
pathmunge "${PYENV_ROOT}/shims"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
