#!/usr/bin/env bash

set -euo pipefail

DIR="$(chezmoi source-path)"
source "${DIR}/.00_helpers.sh"

TASK "Writing Linux Settings"

ensure_linux
ask_sudo

if is_headless_machine; then
  echo_warn "skipping dconf settings on headless machine"
  exit 0
fi

# press both shift together to toggle capslock
dconf write /org/gnome/desktop/input-sources/xkb-options "['shift:both_capslock']"

echo "Done. Note that some of these changes require a logout/restart to take effect."
