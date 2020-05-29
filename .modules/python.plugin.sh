# shellcheck shell=sh

export PYENV_ROOT=${PYENV_ROOT:-"$HOME/.pyenv"}

pathmunge "${PYENV_ROOT}/bin"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

