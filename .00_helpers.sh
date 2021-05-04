#!/usr/bin/env bash

declare -r red='\033[0;31m'
declare -r green='\033[0;32m'
declare -r orange='\033[0;33m'
declare -r blue='\033[0;34m'
declare -r normal='\033[0m' # No Color

echo_error() {
  printf "${red}[error] ${normal}$@\n"
}

echo_info() {
  printf "${blue}[info] ${normal}$@\n"
}

echo_warn() {
  printf "${orange}[warn] ${normal}$@\n"
}

command_exists() {
  type "${1}" >/dev/null 2>&1
}

ask_sudo() {
  echo_info "running this script would need 'sudo' permission."
  echo ""

  sudo -v

  # keep sudo permission fresh
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
}

is_darwin() {
  [[ $OSTYPE = darwin* ]]
}

is_linux() {
  [[ $OSTYPE = linux* ]]
}

is_headless_machine() {
  local -r is_headless="$(chezmoi execute-template '{{ get .meta "is_headless_machine" }}')"
  test "${is_headless}" = "true"
}

is_personal_machine() {
  local -r is_personal="$(chezmoi execute-template '{{ get .meta "is_personal_machine" }}')"
  test "${is_personal}" = "true"
}

ensure_darwin() {
  if ! is_darwin; then
    echo_error "unexpected os (${OSTYPE}), expected darwin!"
    exit 1
  fi
}

ensure_linux() {
  if ! is_linux; then
    echo_error "unexpected os (${OSTYPE}), expected linux!"
    exit 1
  fi
}

ensure_secret_manager() {
  if ! command_exists bw; then
    echo_info "installing secret manager"
    if is_darwin; then
      brew install bitwarden-cli
    elif is_linux; then
      snap install bw

      echo "linking bitwarden snap package config directory"
      ln -sf "${HOME}/snap/bw/current/.config/Bitwarden CLI" "${HOME}/.config/Bitwarden CLI"
    fi
  fi

  local status="$(bw status)"
  status="${status##*\"status\":\"}"
  status="${status%%\"*}"

  if [[ $status = "unauthenticated" ]]; then
    echo "secret manager is not authenticated, run:"
    echo ""
    echo "  bw login"
    echo ""
    echo "and then to unlock, run:"
    echo ""
    echo "  export BW_SESSION=\$(bw unlock --raw)"
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
