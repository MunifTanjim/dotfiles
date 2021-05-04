#!/usr/bin/env bash

set -euo pipefail

DIR="$(chezmoi source-path)"
source "${DIR}/.00_helpers.sh"
export PATH="${DIR}/.scripts.sh:${PATH}"

install_apt_packages() {
  if ! command_exists apt; then
    exit 1
  fi

  TASK "Install APT Packages"

  apt_update() {
    SUB_TASK "sudo apt update"
    sudo apt update
  }

  apt_install() {
    SUB_TASK "sudo apt install --yes $*"
    if command_exists apt-fast; then
      sudo apt-fast install --yes $@
    else
      sudo apt install --yes $@
    fi
  }

  if ! command_exists add-apt-repository; then
    apt_install software-properties-common
  fi

  add_apt_repository() {
    SUB_TASK "sudo add-add-apt-repository --yes --no-update $@"
    sudo add-apt-repository --yes --no-update "$@"
  }

  declare APT_REPOSITORIES=(
    ppa:git-core/ppa
  )

  declare APT_PACKAGES=(
    chafa curl git grc
    htop jq neofetch
    rar unrar shellcheck
    libsecret-tools moreutils
    tmux tree vim
    xclip xsel zsh
    translate-shell
  )

  if ! is_headless_machine; then
    APT_PACKAGES+=(filezilla gpa gparted ibus-avro)
  fi

  for apt_repo in "${APT_REPOSITORIES[@]}"; do
    add_apt_repository ${apt_repo}
  done

  apt_update

  apt_install "${APT_PACKAGES[@]}"
}

install_snap_packages() {
  if ! command_exists snap; then
    exit 1
  fi

  TASK "Install Snap Packages"

  snap_install() {
    SUB_TASK "snap install $*"
    snap install $@
  }

  declare SNAP_PACKAGES=(
    "--classic asciinema"
    "--classic go"
  )

  if ! is_headless_machine; then
    SNAP_PACKAGES+=("--beta authy")
    SNAP_PACKAGES+=("--classic code")
    SNAP_PACKAGES+=("opera")
    SNAP_PACKAGES+=("vlc")
  fi

  for package in "${SNAP_PACKAGES[@]}"; do
    snap_install ${package}
  done
}

run_setup_scripts() {
  TASK "Run Setup Scripts"

  declare SETUP_SCRIPTS=(
    setup-apt-fast
    setup-nvm
    setup-pyenv
    setup-rbenv
    setup-tpm
    setup-zinit

    setup-docker
    setup-exa
    setup-fzf
    setup-gh
    setup-git-credential-libsecret
    setup-neovim
    setup-rust
    setup-starship
    setup-youtube-dl
    setup-zoxide
  )

  if ! command_exists keybase; then
    SETUP_SCRIPTS+=(setup-keybase)
  fi

  if ! is_headless_machine; then
    SETUP_SCRIPTS+=(setup-alacritty)
    if ! command_exists postman; then
      SETUP_SCRIPTS+=(setup-postman)
    fi
    SETUP_SCRIPTS+=(setup-rofi)
  fi

  for script in "${SETUP_SCRIPTS[@]}"; do
    echo ""
    if command_exists ${script}; then
      echo_info "[${script}] started"
      echo ""
      ${script}
      echo ""
      echo_info "[${script}] ended"
    else
      echo_warn "[${script}] not found!"
    fi
    echo ""
  done
}

install_github_release_packages() {
  if ! command_exists setup-from-github-release; then
    exit 1
  fi

  TASK "Install Packages from GitHub Release"

  setup_from_github_release() {
    local -r bin_name="${1}"
    local -r repo="${2}"
    local -r url_pattern="${3}"
    SUB_TASK "setup-from-github-release ${repo} ${url_pattern}"
    if ! command_exists "${bin_name}"; then
      setup-from-github-release "${repo}" "${url_pattern}"
    fi
  }

  declare -A GITHUB_PACKAGE_REPOSITORY=(
    [bat]="sharkdp/bat"
    [delta]="dandavison/delta"
    [fd]="sharkdp/fd"
    [rg]="BurntSushi/ripgrep"
  )

  declare -A GITHUB_PACKAGE_URL_PATTERN=(
    [bat]="musl.+amd64.deb"
    [delta]="musl.+amd64.deb"
    [fd]="musl.+amd64.deb"
    [rg]="amd64.deb"
  )

  for bin_name in "${!GITHUB_PACKAGE_REPOSITORY[@]}"; do
    setup_from_github_release "${bin_name}" \
      "${GITHUB_PACKAGE_REPOSITORY[${bin_name}]}" \
      "${GITHUB_PACKAGE_URL_PATTERN[${bin_name}]}"
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

ensure_linux
ask_sudo

install_apt_packages
install_snap_packages
run_setup_scripts
install_github_release_packages
create_necessary_directories
