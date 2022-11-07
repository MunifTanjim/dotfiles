#!/usr/bin/env bash

set -eu

CHEZMOI_SOURCE="$(chezmoi source-path)"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

install_basic_tools() {
  echo "installing basic tools..."
  sudo apt install curl git
}

ensure_linux
ask_sudo

install_basic_tools
ensure_secret_manager
