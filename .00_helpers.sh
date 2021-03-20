#!/usr/bin/env bash

command_exists() {
  type "${1}" >/dev/null 2>&1
}

ask_sudo() {
  echo "Running this script would need 'sudo' permission."
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

ensure_darwin() {
  if ! is_darwin; then
    exit 1
  fi
}

ensure_linux() {
  if ! is_linux; then
    exit 1
  fi
}

ensure_secret_manager() {
  if ! command_exists bw; then
    echo "installing secret manager"
    if is_darwin; then
      brew install bitwarden-cli
    elif is_linux; then
      snap install bw
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
