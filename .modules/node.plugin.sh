# shellcheck shell=sh

export FNM_DIR="${FNM_DIR:-"${XDG_DATA_HOME:-"${HOME}/.local/share"}/fnm"}"
eval "$(fnm env)"

export COREPACK_ENABLE_AUTO_PIN=0

PATH="./node_modules/.bin:${PATH}"
