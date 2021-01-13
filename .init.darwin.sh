#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export PATH="${DIR}/scripts.sh:${PATH}"

TASK() {
  local -r str="$1"
  local -r str_len=$(( 4 + ${#str} ))
  local -r char="${2:-"="}"

  echo ""
  echo "$(printf '%*s' "${str_len}" | tr ' ' "${char}")"
  echo "$char $str $char"
  echo "$(printf '%*s' "${str_len}" | tr ' ' "${char}")"
  echo ""
}

SUB_TASK() {
  local -r str="$1"
  local -r char="${2:-"="}"

  echo ""
  echo "$char"
  echo "$str"
  echo "$char"
  echo ""
}

command_exists() {
  type "${1}" >/dev/null 2>&1
}


ensure_darwin() {
  if [[ $OSTYPE != darwin* ]]; then
    exit 1
  fi
}

ensure_brew() {
  if ! command_exists brew; then
    echo "command not found: brew"
    echo ""
    echo "  bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
  fi
}

ensure_secret_manager() {
  if ! command_exists bw; then
    echo "command not found: bw"
    echo ""
    echo "  brew install bitwarden-cli"
    exit 1
  fi

  local status="$(bw status)"
  status="${status##*\"status\":\"}"
  status="${status%%\"*}"

  if [[ $status = "unauthenticated" ]]; then
    echo "secret manager is not authenticated, run:"
    echo ""
    echo "  bw login"
    echo ""
    exit 1
  fi

  if [[ $status = "locked" ]]; then
    echo "secret manager is locked, run:"
    echo ""
    echo "  export BW_SESSION=\$(bw unlock --raw)"
    echo ""
    exit 1
  fi

  if [[ $status != "unlocked" ]]; then
    echo "secret manager is not unlocked"
    echo ""
    exit 1
  fi
}

setup_brew_packages() {
  if ! command_exists brew; then
    exit 1
  fi

  TASK "Setup Brew Packages"

  local brewfile=''
  brew_bundle() {
    echo "$brewfile" | brew bundle --no-lock --file=-
  }

  brew tap "homebrew/bundle"
  brew tap "homebrew/cask"

  SUB_TASK "Fix terminfo"
  brewfile='
  brew "ncurses"
  '
  brew_bundle
  $(brew --prefix ncurses)/bin/infocmp tmux-256color > /tmp/tmux-256color.info
  tic -xe tmux-256color /tmp/tmux-256color.info

  SUB_TASK "Setup GNU Tools"
  brewfile='
  brew "coreutils"
  brew "findutils"
  brew "gawk"
  brew "gnu-getopt"
  brew "gnu-indent"
  brew "gnu-sed"
  brew "gnu-tar"
  brew "gnu-which"
  brew "gnutls"
  brew "grep"
  brew "util-linux"
  '
  brew_bundle

  SUB_TASK "Setup tools and utilities"
  brewfile='
  brew "asciinema"
  brew "bash"
  brew "bat"
  brew "binutils"
  brew "diffutils"
  brew "exa"
  brew "fd"
  brew "gh"
  brew "git"
  brew "git-delta"
  brew "gnupg"
  brew "go"
  brew "grc"
  brew "gzip"
  brew "jq"
  brew "lf"
  brew "luajit", args: ["HEAD"]
  brew "neovim", args: ["HEAD"]
  brew "openssh"
  brew "p7zip"
  brew "perl"
  brew "ripgrep"
  brew "rsync"
  brew "starship"
  brew "subversion"
  brew "tmux"
  brew "tree"
  brew "wget"
  brew "zoxide"
  brew "zsh"
  cask "rar"
  '
  brew_bundle

  SUB_TASK "Setup Programming Language Version Managers"
  brewfile='
  tap "rbenv/tap"

  brew "autoconf"
  brew "openssl@1.1"
  brew "pkg-config"
  brew "pyenv"
  brew "pyenv-virtualenv"
  brew "rbenv"
  brew "rbenv/tap/openssl@1.0"
  brew "readline"
  brew "ruby-build"
  brew "sqlite"
  brew "xz"
  brew "zlib"
  '
  brew_bundle

  SUB_TASK "Setup Desktop Apps"
  brewfile='
  cask "alacritty"
  cask "brave-browser"
  cask "docker"
  cask "google-chrome"
  cask "keybase"
  cask "megasync"
  cask "postman"
  cask "visual-studio-code"
  cask "vlc"
  '
  brew_bundle

  SUB_TASK "Setup Fonts"
  brewfile='
  tap "homebrew/cask-fonts"

  cask "font-fira-code"
  cask "font-fira-code-nerd-font"
  cask "font-jetbrains-mono"
  cask "font-jetbrains-mono-nerd-font"
  cask "font-ubuntu"
  cask "font-ubuntu-mono"
  cask "font-ubuntu-mono-nerd-font"
  cask "font-ubuntu-nerd-font"
  '
  brew_bundle
}

run_setup_scripts() {
  TASK "Run Setup Scripts"

  declare SETUP_SCRIPTS=(
    setup-fzf
    setup-nvm
    setup-rust
    setup-tpm
    setup-zinit
  )

  for script in "${SETUP_SCRIPTS[@]}"; do
    echo ""
    if command_exists ${script}; then
      echo "[${script}] started"
      echo ""
      ${script}
      echo ""
      echo "[${script}] ended"
    else
      echo "[${script}] not found!"
    fi
    echo ""
  done
}

create_necessary_directories() {
  TASK "Creating Necessary Directories"

  declare NECESSARY_DIRECTORIES=(
    ~/.cache/nano/backup
    ~/.local/share/mpd/playlists
    ~/.local/share/{nvim,vim}/{backup,swap,undo}
  )

  printf '> %s\n' "${NECESSARY_DIRECTORIES[@]}"
  echo ""
  mkdir -p "${NECESSARY_DIRECTORIES[@]}"
}

ensure_darwin
ensure_brew
ensure_secret_manager

setup_brew_packages
run_setup_scripts
create_necessary_directories
