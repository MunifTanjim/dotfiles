#!/usr/bin/env bash

set -euo pipefail

CHEZMOI_SOURCE="$(chezmoi source-path)"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

ensure_command_line_tools() {
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "installing command line tools"
    xcode-select --install
  fi

  if is_arm64; then
    echo "installing rosetta"
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  fi
}

ensure_homebrew() {
  if ! command_exists brew; then
    echo "installing homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if is_arm64; then
    local homebrew_bin="/opt/homebrew/bin"
    if ! cat /etc/paths | grep -q "${homebrew_bin}"; then
      echo "setting up homebrew binary path for gui apps"
      echo -e "${homebrew_bin}\n$(cat /etc/paths)" | sudo tee /etc/paths > /dev/null
    fi
  fi
}

ensure_darwin
ask_sudo

ensure_command_line_tools
ensure_homebrew
ensure_secret_manager
