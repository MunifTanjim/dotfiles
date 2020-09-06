# shellcheck shell=sh

# export VOLTA_HOME="${HOME}/.local/share/volta"
# pathmunge "${VOLTA_HOME}/bin"

export NVM_DIR="${HOME}/.local/share/nvm"

if [ -d "${NVM_DIR}" ]; then
  __node_global_bins=("nvm" "node" $(find ${NVM_DIR}/versions/node -maxdepth 3 -path '*/bin/*' -type l -print0 2>/dev/null | xargs -0 -n1 basename | sort | uniq))

  __init_nvm() {
    unset -f ${__node_global_bins[@]} >/dev/null 2>&1
    unset __node_global_bins
    unset -f __init_nvm

    if [ -s "${NVM_DIR}/nvm.sh" ]; then
      . "${NVM_DIR}/nvm.sh"
    fi
  }

  for bin in "${__node_global_bins[@]}"; do
    eval "${bin}(){ __init_nvm; ${bin} \$@; }"
  done
fi

pathmunge "./node_modules/.bin"
