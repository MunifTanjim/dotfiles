# shellcheck shell=sh

export POETRY_CACHE_DIR="${XDG_CACHE_HOME:-"${HOME}/.cache"}/pypoetry"
export POETRY_CONFIG_DIR="${XDG_CONFIG_HOME:-"${HOME}/.config"}/pypoetry"
export POETRY_DATA_DIR="${XDG_DATA_HOME:-"${HOME}/.local/share"}/pypoetry"

export PYENV_ROOT=${PYENV_ROOT:-"${HOME}/.pyenv"}
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export VIRTUAL_ENV_DISABLE_PROMPT=1

pathmunge "${PYENV_ROOT}/bin"
pathmunge "${PYENV_ROOT}/shims"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
