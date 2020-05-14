export CARGO_HOME=${CARGO_HOME:-"${HOME}/.cargo"}
export RUSTUP_HOME=${RUSTUP_HOME:-"${HOME}/.rustup"}

( ! directory_exists "${CARGO_HOME}" ) && return

source "${CARGO_HOME}/env"
