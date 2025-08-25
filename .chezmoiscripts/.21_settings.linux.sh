#!/usr/bin/env bash

set -euo pipefail

CHEZMOI_SOURCE="${HOME}/.local/share/chezmoi"
source "${CHEZMOI_SOURCE}/.chezmoiscripts/.00_helpers.sh"

TASK "Writing Linux Settings"

ensure_linux
ask_sudo

if is_headless_machine; then
  echo_warn "skipping dconf settings on headless machine"
  exit 0
fi

dconf_array_value() {
  local value=""

  while [[ $# -gt 0 ]]; do
    value="${value},'${1}'"
    shift
  done

  value="${value:1}"

  if [[ "${value}" == "" ]]; then
    value="''"
  fi

  echo "[${value}]"
}

set_custom_keyboard_shortcuts() {
  local -A custom_keybindings_keys=()

  add_custom_keybinding() {
    local -r key="mt_${1}"
    local -r name="'${2}'"
    local -r cmd="'${3//\'/\\\'}'"
    local -r binding="'${4}'"

    custom_keybindings_keys[${key}]="true"

    echo "(custom) :: ${name} :: ${binding}"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${key}/name "${name}"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${key}/command "${cmd}"
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${key}/binding "${binding}"
  }

  add_custom_keybinding rofi "Rofi" "${HOME}/.local/bin/run_rofi.sh" "<Super>slash"
  add_custom_keybinding rofunicode "Rofunicode" "sh -c '${HOME}/.local/bin/rofunicode.sh | xsel -i --clipboard'" "<Super>e"
  add_custom_keybinding music_next "Music - Next" "mpc next" "<Alt><Super>period"
  add_custom_keybinding music_prev "Music - Prev" "mpc prev" "<Alt><Super>comma"
  add_custom_keybinding music_toggle "Music - Toggle" "${HOME}/.local/bin/music-terminal" "<Alt><Super>m"

  local new_items=()

  local old_items="$(dconf read /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings)"
  if [[ "${old_items}" == "@as []" ]]; then
    old_items=""
  else
    old_items="${old_items:1:-1}"
  fi
  IFS=", " read -r -a old_items <<<"$old_items"
  for item in "${old_items[@]}"; do
    item="${item:1:-1}"
    item="${item/\/org\/gnome\/settings-daemon\/plugins\/media-keys\/custom-keybindings\//}"
    if ! [[ "${item}" == "mt_"* ]]; then
      new_items+=("/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${item}")
    fi
  done

  local available_items=("$(dconf list /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/)")
  for item in ${available_items[@]}; do
    if [[ "${item}" == "mt_"* ]]; then
      set +u
      if [[ "${custom_keybindings_keys[${item::-1}]}" == "true" ]]; then
        new_items+=("/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${item}")
      else
        dconf reset -f "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${item}"
      fi
      set -u
    fi
  done

  local -r value="$(dconf_array_value ${new_items[@]})"
  dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "${value}"
}

set_media_keyboard_shortcuts() {
  add_media_keybinding() {
    local -r key="${1}"
    shift
    local -r value="$(dconf_array_value $@)"

    echo "(media) :: ${key} :: ${value}"
    dconf write "/org/gnome/settings-daemon/plugins/media-keys/${key}" "${value}"
  }

  add_media_keybinding area-screenshot "<Super>Print"
  add_media_keybinding area-screenshot-clip "Print"
  add_media_keybinding screencast "<Alt><Super>Print"
  add_media_keybinding screenshot "<Primary><Shift><Super>Print"
  add_media_keybinding screenshot-clip "<Primary><Shift>Print"
  add_media_keybinding terminal ""
  add_media_keybinding window-screenshot "<Shift><Super>Print"
  add_media_keybinding window-screenshot-clip "<Shift>Print"
}

set_window_keyboard_shortcuts() {
  add_window_keybinding() {
    local -r key="${1}"
    shift
    local -r value="$(dconf_array_value $@)"

    echo "(window) :: ${key} :: ${value}"
    dconf write "/org/gnome/desktop/wm/keybindings/${key}" "${value}"
  }

  add_window_keybinding close "<Super>q"
}

SUB_TASK "XKB Options"

echo "shift:both_capslock :: left-shift + right-shift => capslock"
dconf write /org/gnome/desktop/input-sources/xkb-options "['shift:both_capslock']"

SUB_TASK "Keyboard Shortcut"

set_custom_keyboard_shortcuts
set_media_keyboard_shortcuts
set_window_keyboard_shortcuts

echo
echo_info "Done. Note that some of these changes require a logout/restart to take effect."
