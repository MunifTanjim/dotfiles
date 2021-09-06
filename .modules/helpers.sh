# shellcheck shell=sh

export current_shell="$(ps -p$$ -oucomm= | xargs)"

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

refresh_and_clear() {
  if test -n "${SSH_CLIENT}" -o -n "${SSH_TTY}"; then
    # inside ssh session
    if [[ -n "$TMUX" ]] || [[ "$TERM" =~ "^(screen|tmux).*" ]]; then
      # inside tmux
      if [[ -n "${SSH_AUTH_SOCK}" ]] && [[ ! -S ${SSH_AUTH_SOCK} ]]; then
        # has stale ${SSH_AUTH_SOCK}
        eval "$(tmux show-environment -s | grep '^SSH_AUTH_SOCK')"
      fi
    fi
  fi

  clear -x
}

exit_or_tmux_detach() {
  if [[ -n "$LF_LEVEL" ]]; then
    # inside lf
    exit
  fi

  if [[ -z "$TMUX" ]] || [[ ! "$TERM" =~ "^(screen|tmux).*" ]]; then
    # outside tmux
    exit
  fi

  if ! command_exists tmux; then
    # no tmux
    exit
  fi

  # inside tmux
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
