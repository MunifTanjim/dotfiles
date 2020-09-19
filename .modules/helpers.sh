# shellcheck shell=sh

command_exists() {
  type "${1}" >/dev/null 2>&1
}

directory_exists() {
  [ -d "${1}" ]
}

pathmunge() {
  if ! echo "${PATH}" | grep -Eq "(^|:)${1}($|:)"; then
    if directory_exists "${1}"; then
      if [ "${2}" = "after" ]; then
        export PATH="${PATH}:${1}"
      else
        export PATH="${1}:${PATH}"
      fi
    fi
  fi
}

expunge_history() {
  if ! command_exists fzf; then
    echo "not found: fzf"
  fi

  local -r items="$(cat "${HISTFILE}" | nl -b a)"
  local -r header="Expunge History (use TAB to select multiple)"
  local -r expression="$(echo "${items}" | fzf --multi --header="${header}" | awk '{print $1}' ORS='d;')"
  sed -i -e "${expression}" "${HISTFILE}"
}

exit_or_tmux_detach() {
  if [[ -z "$TMUX" ]] || [[ ! "$TERM" =~ "^(screen|tmux).*" ]]; then
    exit
  fi

  if ! command_exists tmux; then
    exit
  fi

  local -r total_windows=$(tmux list-windows | wc -l)

  if [ $total_windows != 1 ]; then
    exit
  fi

  local -r total_panes=$(tmux list-panes | wc -l)

  if [ $total_panes != 1 ]; then
    exit
  fi

  tmux detach && clear
}
