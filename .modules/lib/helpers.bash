#!/usr/bin/env bash

function load_module() {
  local module=("${1}.module.sh" "${1}.module.bash")
  for mod in ${module[@]}; do
    if [ -e "${DOTFILES_MODULES}/available/${mod}" ]; then
      source "${DOTFILES_MODULES}/available/${mod}"
      echo "Loaded Module: ${1}"
      break
    else
      echo "No Module Named: ${1}"
    fi
  done
}

function disable_module() {
  local module=("${1}.module.sh" "${1}.module.bash")
  for mod in ${module[@]}; do
    if [ -e "${DOTFILES_MODULES}/enabled/${mod}" ]; then
      rm "${DOTFILES_MODULES}/enabled/${mod}"
      echo "Disabled Module: ${1}"
    fi
  done
}

function enable_module() {
  local module=("${1}.module.sh" "${1}.module.bash")
  for mod in ${module[@]}; do
    if [ -e "${DOTFILES_MODULES}/enabled/${mod}" ]; then
      echo "Already Enabled: ${1}"
      break
    elif [ -e "${DOTFILES_MODULES}/available/${mod}" ]; then
      if ! [ -d "${DOTFILES_MODULES}/enabled" ]; then
        mkdir -p "${DOTFILES_MODULES}/enabled"
      fi
      ln -s "../available/${mod}" "${DOTFILES_MODULES}/enabled/${mod}"
      echo "Enabled Module: ${1}"
      break
    fi
  done
}

function _module_enabled() {
  [ -e "${DOTFILES_MODULES}/enabled/${1}.module.sh" ] ||   [ -e "${DOTFILES_MODULES}/enabled/${1}.module.bash" ]
}

if ! type pathmunge >/dev/null 2>&1; then
  function pathmunge () {
    if ! [[ ${PATH} =~ (^|:)${1}($|:) ]]; then
      if [ "${2}" = "after" ]; then
        export PATH=${PATH}:${1}
      else
        export PATH=${1}:${PATH}
      fi
    fi
  }
fi

function command_exists() {
  type ${1} >/dev/null 2>&1
}

function directory_exists() {
  [ -d "${1}" ]
}

function reload_bashrc() {
  [[ -e "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
}
