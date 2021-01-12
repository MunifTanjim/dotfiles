# shellcheck shell=sh

if ! command_exists go; then
  return
fi

export GOROOT=${GOROOT:-$(go env GOROOT)}
pathmunge "${GOROOT}/bin"
export GOPATH=${GOPATH:-"${HOME}/.local/share/go"}
pathmunge "${GOPATH}/bin"
