# shellcheck shell=sh

export RBENV_ROOT=${RBENV_ROOT:-"$HOME/.rbenv"}

pathmunge "${RBENV_ROOT}/bin"
pathmunge "${RBENV_ROOT}/plugins/ruby-build/bin"

eval "$(rbenv init -)"
