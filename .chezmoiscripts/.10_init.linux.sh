#!/usr/bin/env bash

set -eu

CHEZMOI_SOURCE="$(chezmoi source-path)"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

install_basic_tools() {
  echo "installing basic tools..."
  sudo apt install curl git
}

login_to_snap() {
  if ! command_exists snap; then
    return 0
  fi

  local -r email=$(snap whoami | cut -d ' ' -f 2)
  if ! [[ $email = *@* ]]; then
    echo "login to snap with ubuntu account (for sudo-less \`snap install\`)"
    sudo snap login
  fi
}

ensure_linux
ask_sudo

install_basic_tools
login_to_snap
ensure_secret_manager
