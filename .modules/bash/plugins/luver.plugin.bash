#!/usr/bin/env bash

export LUVER_DIR="${LUVER_DIR:-"${XDG_DATA_HOME:-"${HOME}/.local/share"}/luver"}"

if [[ ! -d "${LUVER_DIR}/self" ]]; then
  git clone https://github.com/MunifTanjim/luver.git "${LUVER_DIR}/self"
fi

source "${LUVER_DIR}/self/luver.bash"
