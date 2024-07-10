#!/usr/bin/env bash

set -euo pipefail

CHEZMOI_SOURCE="$(chezmoi source-path)"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

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

  SUB_TASK "Update terminfo database"
  brewfile='
  brew "ncurses"
  '
  brew_bundle

  update_terminfo_database() {
    local -r term_name="${1}"
    $(brew --prefix ncurses)/bin/infocmp -x "${term_name}" > "/tmp/${term_name}.info"
    tic -x -o "${HOME}/.terminfo" -e "${term_name}" "/tmp/${term_name}.info"
  }
  update_terminfo_database tmux
  update_terminfo_database tmux-256color

  SUB_TASK "Setup GNU Programs/Tools"
  brewfile='
  brew "binutils"
  brew "coreutils"
  brew "diffutils"
  brew "ed"
  brew "findutils"
  brew "gawk"
  brew "gnu-getopt"
  brew "gnu-indent"
  brew "gnu-sed"
  brew "gnu-tar"
  brew "gnu-which"
  brew "gnutls"
  brew "grep"
  brew "gzip"
  brew "less"
  brew "parallel"
  brew "screen"
  brew "util-linux"
  '
  brew_bundle

  SUB_TASK "Setup tools and utilities"
  brewfile='
  tap "yqrashawn/goku"

  brew "asciinema"
  brew "bash"
  brew "bash-completion@2"
  brew "bat"
  brew "blueutil"
  brew "exa"
  brew "fd"
  brew "gh"
  brew "git"
  brew "git-delta"
  brew "gnupg"
  brew "go"
  brew "grc"
  brew "imagemagick"
  brew "jq"
  brew "lf"
  brew "openssh"
  brew "p7zip"
  brew "perl"
  brew "pinentry-mac"
  brew "ripgrep"
  brew "rsync"
  brew "starship"
  brew "subversion"
  brew "switchaudio-osx"
  brew "tmux"
  brew "trash"
  brew "tree"
  brew "wget"
  brew "yqrashawn/goku/goku"
  brew "zoxide"
  brew "zsh"
  cask "rar"
  '
  brew_bundle

  SUB_TASK "Setup Programming Language Version Managers"
  brewfile='
  brew "autoconf"
  brew "openssl@1.1"
  brew "pkg-config"
  brew "pyenv"
  brew "pyenv-virtualenv"
  brew "rbenv"
  brew "readline"
  brew "ruby-build"
  brew "sqlite"
  brew "xz"
  brew "zlib"
  '
  brew_bundle

  if ! is_arm64; then
    brewfile='
    tap "rbenv/tap"

    brew "rbenv/tap/openssl@1.0"
    '
    brew_bundle
  fi

  SUB_TASK "Setup Desktop Apps"
  brewfile='
  cask "alacritty"
  cask "maccy"
  cask "docker"
  cask "google-chrome"
  cask "hammerspoon"
  cask "karabiner-elements"
  cask "keybase"
  cask "postman"
  cask "stats"
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
    setup-fnm
    setup-tpm
    setup-zed

    setup-fzf
  )

  if ! command_exists rustup; then
    SETUP_SCRIPTS+=(setup-rust)
  fi

  if ! command_exists nvim; then
    SETUP_SCRIPTS+=(setup-neovim)
  fi

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
    ~/.local/share/mpdscribble
    ~/.local/share/{nvim,vim}/{backup,swap,undo}
    ~/.ssh/control
  )

  printf '> %s\n' "${NECESSARY_DIRECTORIES[@]}"
  echo ""
  mkdir -p "${NECESSARY_DIRECTORIES[@]}"
}

ensure_darwin

setup_brew_packages
run_setup_scripts
create_necessary_directories
