#!/usr/bin/env bash

section_header() {
  local -r str="$1"
  local -r str_len=$(( 4 + ${#str} ))
  local -r char="${2:-"="}"

  echo ""
  echo "$(printf '%*s' "${str_len}" | tr ' ' "${char}")"
  echo "$char $str $char"
  echo "$(printf '%*s' "${str_len}" | tr ' ' "${char}")"
  echo ""
}

task_header() {
  local -r str="$1"
  local -r char="${2:-"*"}"

  echo ""
  echo "$char $str"
  echo ""
}

command_exists() {
  type "${1}" >/dev/null 2>&1
}

if ! command_exists brew; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install coreutils
brew install ncurses

/usr/local/opt/ncurses/bin/infocmp tmux-256color > /tmp/tmux-256color.info
tic -xe tmux-256color /tmp/tmux-256color.info

brew install bash zsh tmux git gpg grc jq p7zip svn tree rar
brew install bat exa fd gh git-delta lf ripgrep starship zoxide
brew install go

brew install autoconf pkg-config readline sqlite3 xz zlib
brew install rbenv/tap/openssl@1.0 openssl

brew install pyenv pyenv-virtualenv
brew install rbenv ruby-build

brew install alacritty bitwarden-cli google-chrome visual-studio-code
brew install asciinema keybase postman vlc

brew install --cask docker

brew tap homebrew/cask-fonts
brew install font-{fira-code,jetbrains-mono,ubuntu-mono}{,-nerd-font}

brew install luajit --HEAD
brew install neovim --HEAD

declare NECESSARY_DIRECTORIES=(
  ~/.cache/nano/backup
  ~/.local/share/mpd/playlists
  ~/.local/share/{nvim,vim}/{backup,swap,undo}
)

printf '> %s\n' "${NECESSARY_DIRECTORIES[@]}"
echo ""
mkdir -p "${NECESSARY_DIRECTORIES[@]}"
