#!/usr/bin/env bash

set -euo pipefail

DIR="$(chezmoi source-path)"
source "${DIR}/.00_helpers.sh"

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

ensure_command_line_tools
ensure_homebrew
ensure_secret_manager
