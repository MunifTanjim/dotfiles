# shellcheck shell=sh

GOLANG_DIR="${GOLANG_DIR:-"${XDG_DATA_HOME:-"${HOME}/.local/share"}/golang"}"

export GOROOT=${GOROOT:-"${GOLANG_DIR}/current"}
pathmunge "${GOROOT}/bin"
export GOPATH="${GOPATH:-"${XDG_DATA_HOME:-"${HOME}/.local/share"}/go"}"
pathmunge "${GOPATH}/bin"
