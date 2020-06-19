#!/usr/bin/env bash

function load_plugin() {
  local plugin="${1}.plugin.bash"
  if [ -e "${DOTFILES_MODULES}/bash/plugins/available/${plugin}" ]; then
    source "${DOTFILES_MODULES}/bash/plugins/available/${plugin}"
    echo "Loaded Plugin: ${1}"
  else
    echo "No Plugin Named: ${1}"
  fi
}

function disable_plugin() {
  local plugin="${1}.plugin.bash"
  if [ -e "${DOTFILES_MODULES}/bash/plugins/enabled/${plugin}" ]; then
    rm "${DOTFILES_MODULES}/bash/plugins/enabled/${plugin}"
    echo "Disabled Plugin: ${1}"
  fi
}

function enable_plugin() {
  local plugin="${1}.plugin.bash"
  if [ -e "${DOTFILES_MODULES}/bash/plugins/enabled/${plugin}" ]; then
    echo "Already Enabled: ${1}"
  elif [ -e "${DOTFILES_MODULES}/bash/plugins/available/${plugin}" ]; then
    if ! [ -d "${DOTFILES_MODULES}/bash/plugins/enabled" ]; then
      mkdir -p "${DOTFILES_MODULES}/bash/plugins/enabled"
    fi
    ln -s "../available/${plugin}" "${DOTFILES_MODULES}/bash/plugins/enabled/${plugin}"
    echo "Enabled Plugin: ${1}"
  else
    echo "No Plugin Named: ${1}"
  fi
}

function _plugin_enabled() {
  [ -e "${DOTFILES_MODULES}/bash/plugins/enabled/${1}.plugin.bash" ]
}

function reload_shell() {
  [[ -e "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
}

# Sensible defaults for BASH
if [ -f "${DOTFILES_MODULES}/.bash-sensible/sensible.bash" ]; then
  source "${DOTFILES_MODULES}/.bash-sensible/sensible.bash"
fi

source "${DOTFILES_MODULES}/helpers.sh"

# Load temporary scripts
for script in "${DOTFILES_MODULES}"/temp/*.sh; do
  [[ -e "${script}" ]] && source "${script}"
done
for script in "${DOTFILES_MODULES}"/temp/*.bash; do
  [[ -e "${script}" ]] && source "${script}"
done

# Load enabled plugins
if [ -d "${DOTFILES_MODULES}/bash/plugins/enabled" ]; then
  _PLUGINS="${DOTFILES_MODULES}/bash/plugins/enabled/*.plugin.bash"
  for plugin in ${_PLUGINS}; do
    [[ -e "${plugin}" ]] && source "${plugin}"
  done
  unset _PLUGINS plugin
fi

source "${DOTFILES_MODULES}/aliases.sh"
source "${DOTFILES_MODULES}/go.plugin.sh"
source "${DOTFILES_MODULES}/gpg.plugin.sh"
source "${DOTFILES_MODULES}/python.plugin.sh"
source "${DOTFILES_MODULES}/ruby.plugin.sh"
source "${DOTFILES_MODULES}/rust.plugin.sh"

source "${DOTFILES_MODULES}/fzf.plugin.sh"
source "${DOTFILES_MODULES}/lf.plugin.sh"

source "${DOTFILES_MODULES}/bash/appearance.bash"
