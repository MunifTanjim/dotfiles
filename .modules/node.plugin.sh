# shellcheck shell=sh

# export VOLTA_HOME="${HOME}/.local/share/volta"
# pathmunge "${VOLTA_HOME}/bin"

export NVM_DIR="${HOME}/.local/share/nvm"

if directory_exists "${NVM_DIR}"; then
  __init_nvm() {
    if [ -s "${NVM_DIR}/nvm.sh" ]; then
      . "$NVM_DIR/nvm.sh"
    fi
  }

  __node_global_bins=("nvm" "node" $(find ${NVM_DIR}/versions/node -maxdepth 3 -path '*/bin/*' -type l 2>/dev/null | xargs -n1 basename | sort | uniq))

  for bin in "${NODE_GLOBALS[@]}"; do
    eval "${bin}(){ unset -f ${__node_global_bins} >/dev/null 2>&1; __init_nvm; ${bin} \$@; }"
  done
fi

pathmunge "./node_modules/.bin"
