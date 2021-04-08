#!/usr/bin/env bash

set -eu

DIR="$(chezmoi source-path)"
source "${DIR}/.00_helpers.sh"

install_basic_tools() {
  echo "installing basic tools..."
  sudo apt install curl git
}

login_to_snap() {
  local -r email=$(snap whoami | cut -d ' ' -f 2)
  if ! [[ $email = *@* ]]; then
    echo "login to snap with ubuntu account (for sudo-less \`snap install\`)"
    snap login
  fi
}

ensure_linux
ask_sudo

install_basic_tools
login_to_snap
ensure_secret_manager
