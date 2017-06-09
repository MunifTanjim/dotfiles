#!/usr/bin/env bash

[ ! command -v go &>/dev/null ] && return

export GOROOT=${GOROOT:-$(go env | grep GOROOT | cut -d'"' -f2)}
pathmunge "${GOROOT}/bin"
export GOPATH=${GOPATH:-"$HOME/.go"}
pathmunge "${GOPATH}/bin"

