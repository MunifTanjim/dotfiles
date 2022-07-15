#!/usr/bin/env bash

set -euo pipefail

CHEZMOI_SOURCE="$(chezmoi source-path)"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

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
    ppa:zanchey/asciinema
  )

  declare APT_PACKAGES=(
    asciinema
    chafa
    curl
    git
    gnupg2
    grc
    htop
    jq
    libsecret-tools
    moreutils
    neofetch
    rar
    shellcheck
    translate-shell
    tree
    unrar
    vim
    xclip
    xsel
    zsh
  )

  if ! is_headless_machine; then
    APT_PACKAGES+=(dconf-cli dconf-editor)
    APT_PACKAGES+=(filezilla gpa gparted ibus-avro)
    APT_PACKAGES+=(vlc)
  fi

  for apt_repo in "${APT_REPOSITORIES[@]}"; do
    add_apt_repository ${apt_repo}
  done

  apt_update

  apt_install "${APT_PACKAGES[@]}"
}

install_snap_packages() {
  if ! command_exists snap; then
    echo_warn "skipping install_snap_packages"
    return 0
  fi

  TASK "Install Snap Packages"

  snap_install() {
    SUB_TASK "snap install $*"
    snap install $@
  }

  declare SNAP_PACKAGES=(
    "--classic go"
  )

  if ! is_headless_machine; then
    SNAP_PACKAGES+=("--beta authy")
  fi

  for package in "${SNAP_PACKAGES[@]}"; do
    snap_install ${package}
  done
}

run_setup_scripts() {
  TASK "Run Setup Scripts"

  declare SETUP_SCRIPTS=(
    setup-tpm
    setup-zed
  )

  if ! is_github_codespace; then
    SETUP_SCRIPTS+=(setup-apt-fast)
    SETUP_SCRIPTS+=(setup-fnm setup-pyenv setup-rbenv)
    SETUP_SCRIPTS+=(setup-docker setup-gh)
    SETUP_SCRIPTS+=(setup-git-credential-libsecret)
    SETUP_SCRIPTS+=(setup-rust)
  fi

  SETUP_SCRIPTS+=(
    setup-bat
    setup-delta
    setup-exa
    setup-fd
    setup-fzf
    setup-ripgrep
    setup-starship
    setup-zoxide
  )

  if ! command_exists nvim; then
    SETUP_SCRIPTS+=(setup-neovim)
  fi

  if ! command_exists tmux; then
    SETUP_SCRIPTS+=(setup-tmux)
  fi

  if ! is_headless_machine; then
    if ! command_exists alacritty; then
      SETUP_SCRIPTS+=(setup-alacritty)
    fi
    if ! command_exists code; then
      SETUP_SCRIPTS+=(setup-vscode)
    fi
    if ! command_exists postman; then
      SETUP_SCRIPTS+=(setup-postman)
    fi
    if ! command_exists rofi; then
      SETUP_SCRIPTS+=(setup-rofi)
    fi
  fi

  if should_include_secrets; then
    if ! command_exists keybase; then
      SETUP_SCRIPTS+=(setup-keybase)
    fi
  fi

  for script in "${SETUP_SCRIPTS[@]}"; do
    echo ""
    if command_exists ${script}; then
      echo_info "[${script}] started"
      echo ""
      ${script}
      echo ""

      if [[ "${script}" == "setup-rust" ]]; then
        source "${CARGO_HOME:-"${HOME}/.local/share/cargo"}/env"
      fi

      echo_info "[${script}] ended"
    else
      echo_warn "[${script}] not found!"
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

ensure_linux
ask_sudo

install_apt_packages
install_snap_packages
run_setup_scripts
create_necessary_directories
