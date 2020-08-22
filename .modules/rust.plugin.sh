# shellcheck shell=sh

export CARGO_HOME=${CARGO_HOME:-"${HOME}/.local/share/cargo"}
export RUSTUP_HOME=${RUSTUP_HOME:-"${HOME}/.local/share/rustup"}

if directory_exists "${CARGO_HOME}"; then
  . "${CARGO_HOME}/env"
fi
