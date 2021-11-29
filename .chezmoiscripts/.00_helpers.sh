#!/usr/bin/env bash

CHEZMOI_SOURCE="$(chezmoi source-path)"
export PATH="${CHEZMOI_SOURCE}/.scripts.sh:${PATH}"

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

is_github_codespace() {
  local -r bool="$(chezmoi execute-template '{{ get .meta.is "github_codespace" }}')"
  test "${bool}" = "true"
}

is_headless_machine() {
  local -r bool="$(chezmoi execute-template '{{ get .meta.is "headless_machine" }}')"
  test "${bool}" = "true"
}

is_personal_machine() {
  local -r bool="$(chezmoi execute-template '{{ get .meta.is "personal_machine" }}')"
  test "${bool}" = "true"
}

should_include_secrets() {
  local -r bool="$(chezmoi execute-template '{{ get .meta.should "include_secrets" }}')"
  test "${bool}" = "true"
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
  if ! should_include_secrets; then
    echo_warn "skipping ensure_secret_manager"
    return 0
  fi

  if ! command_exists bw; then
    echo_info "installing secret manager"
    setup-bitwarden-cli
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
