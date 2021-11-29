#!/usr/bin/env bash

set -euo pipefail

CHEZMOI_SOURCE="$(chezmoi source-path)"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

ensure_command_line_tools() {
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "installing command line tools"
    xcode-select --install
  fi
}

ensure_homebrew() {
  if ! command_exists brew; then
    echo "installing homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

ensure_darwin
ask_sudo

ensure_command_line_tools
ensure_homebrew
ensure_secret_manager
