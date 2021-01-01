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

if command_exists apt; then
  section_header "APT Packages"

  declare APT_PACKAGES=(
    chafa curl filezilla
    git gpa gparted grc
    htop jq neofetch
    rar unrar shellcheck
    libsecret-tools moreutils
    tmux tree vim
    xclip xsel zsh
    ibus-avro translate-shell
    software-properties-common
  )

  echo "${APT_PACKAGES[@]}"
  echo ""

  task_header "Updating Cache..."
  sudo apt update
  task_header "Installing Packages..."
  sudo apt install --yes "${APT_PACKAGES[@]}"

  section_header "APT Packages (3rd Party)"

  declare THIRD_PARTY_APT_PACKAGES=(
    alacritty
  )

  echo "${THIRD_PARTY_APT_PACKAGES[@]}"
  echo ""

  declare APT_REPOSITORIES=(
    ppa:mmstick76/alacritty
  )
  for apt_repo in "${APT_REPOSITORIES[@]}"; do
    task_header "Adding APT Repository: ${apt_repo}"
    sudo add-apt-repository --yes --no-update "${apt_repo}"
  done

  task_header "Updating Cache..."
  sudo apt update
  task_header "Installing Packages..."
  sudo apt install --yes "${THIRD_PARTY_APT_PACKAGES[@]}"
fi

if command_exists snap; then
  section_header "Snap Packages (classic)"

  declare SNAP_CLASSIC_PACKAGES=(
    asciinema code go
  )

  echo "${SNAP_CLASSIC_PACKAGES[@]}"
  echo ""

  for package in "${SNAP_CLASSIC_PACKAGES[@]}"; do
    snap install "${package}" --classic
  done

  section_header "Installing Snap Packages (strict)"

  declare SNAP_PACKAGES=(
    "--beta authy" bucklespring
    hugo opera vlc
  )

  echo "${SNAP_PACKAGES[@]}"
  echo ""

  for package in "${SNAP_PACKAGES[@]}"; do
    snap install ${package}
  done
fi

if command_exists setup-from-github-release; then
  section_header "Installing Packages from GitHub Release"

  declare -A GITHUB_PACKAGE_REPOSITORY=(
    [bat]="sharkdp/bat"
    [delta]="dandavison/delta"
    [fd]="sharkdp/fd"
    [gh]="cli/cli"
    [rg]="BurntSushi/ripgrep"
  )

  declare -A GITHUB_PACKAGE_URL_PATTERN=(
    [bat]="musl.+amd64.deb"
    [delta]="musl.+amd64.deb"
    [fd]="musl.+amd64.deb"
    [gh]="_linux_amd64.deb"
    [rg]="amd64.deb"
  )

  echo "${!GITHUB_PACKAGE_REPOSITORY[@]}"
  echo ""

  for bin_name in "${!GITHUB_PACKAGE_REPOSITORY[@]}"; do
    if ! command_exists "${bin_name}"; then
      setup-from-github-release \
        "${GITHUB_PACKAGE_REPOSITORY[${bin_name}]}" \
        "${GITHUB_PACKAGE_URL_PATTERN[${bin_name}]}"
    fi
  done
fi

section_header "Running Setup Scripts"

declare SETUP_SCRIPTS=(
  setup-nvm
  setup-pyenv
  setup-rbenv
  setup-volta
  setup-zinit
  setup-apt-fast
  setup-docker
  setup-fzf
  setup-git-credential-libsecret
  setup-keybase
  setup-neovim
  setup-postman
  setup-rofi
  setup-starship
  setup-youtube-dl
)

for script in "${SETUP_SCRIPTS[@]}"; do
  echo ""
  if command_exists "${script}"; then
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

section_header "Creating Necessary Directories"

declare NECESSARY_DIRECTORIES=(
  ~/.cache/nano/backup
  ~/.local/share/mpd/playlists
  ~/.local/share/{nvim,vim}/{backup,swap,undo}
)

printf '> %s\n' "${NECESSARY_DIRECTORIES[@]}"
echo ""
mkdir -p "${NECESSARY_DIRECTORIES[@]}"
