#!/usr/bin/env bash

export CARGO_HOME=${CARGO_HOME:-"${HOME}/.cargo"}
export RUSTUP_HOME=${RUSTUP_HOME:-"${HOME}/.rustup"}

( ! directory_exists "${CARGO_HOME}" ) && return

. "${CARGO_HOME}/env"
