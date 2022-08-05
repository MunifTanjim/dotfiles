# shellcheck shell=sh

if command_exists go; then
  export GOROOT="${GOROOT:-"$(go env GOROOT)"}"
else
  GOLANG_DIR="${GOLANG_DIR:-"${XDG_DATA_HOME:-"${HOME}/.local/share"}/golang"}"
  export GOROOT="${GOROOT:-"${GOLANG_DIR}/current"}"
fi

export GOPATH="${GOPATH:-"${XDG_DATA_HOME:-"${HOME}/.local/share"}/go"}"

pathmunge "${GOROOT}/bin"
pathmunge "${GOPATH}/bin"
