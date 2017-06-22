function disable_module() {
  local module="${1}.module.bash"
  if [ -e "${DOTFILES_MODULES}/enabled/${module}" ]; then
    rm "${DOTFILES_MODULES}/enabled/${module}"
    echo "Disabled Module: ${1}"
  fi
}

function enable_module() {
  local module="${1}.module.bash"
  if [ -e "${DOTFILES_MODULES}/enabled/${module}" ]; then
    echo "Already Enabled: ${1}"
  elif [ -e "${DOTFILES_MODULES}/available/${module}" ]; then
    if ! [ -d "${DOTFILES_MODULES}/enabled" ]; then
      mkdir -p "${DOTFILES_MODULES}/enabled"
    fi
    ln -s "../available/${module}" "${DOTFILES_MODULES}/enabled/${module}"
    echo "Enabled Module: ${1}"
  else
    echo "No Module Named: ${1}"
  fi
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

function command_exists () {
  type ${1} >/dev/null 2>&1
}

function reload_bashrc() {
  [[ -e "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
}
