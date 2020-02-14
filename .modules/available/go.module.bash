#!/usr/bin/env bash

( ! command_exists go ) && return

export GOROOT=${GOROOT:-$(go env | grep GOROOT | cut -d'"' -f2)}
pathmunge "${GOROOT}/bin"
export GOPATH=${GOPATH:-"${HOME}/.go"}
pathmunge "${GOPATH}/bin"

