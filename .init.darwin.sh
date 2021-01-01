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
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash -c -
fi
