# shellcheck shell=sh

export CARGO_HOME=${CARGO_HOME:-"${HOME}/.cargo"}
export RUSTUP_HOME=${RUSTUP_HOME:-"${HOME}/.rustup"}

if directory_exists "${CARGO_HOME}"; then
  . "${CARGO_HOME}/env"
fi
