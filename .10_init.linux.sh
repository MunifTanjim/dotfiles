#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}/.00_helpers.sh"

install_basic_tools() {
  echo "installing basic tools..."
  sudo apt install curl git
}

login_to_snap() {
  echo "login to snap with ubuntu account (for sudo-less `snap install`)"
  snap login
}

ensure_linux
ask_sudo

install_basic_tools
login_to_snap
ensure_secret_manager
