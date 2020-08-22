# shellcheck shell=sh

export VOLTA_HOME="${HOME}/.local/share/volta"

pathmunge "${VOLTA_HOME}/bin"

pathmunge "./node_modules/.bin"
