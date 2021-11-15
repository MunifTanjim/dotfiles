export RBENV_ROOT=${RBENV_ROOT:-"$HOME/.rbenv"}

if [[ -d "${RBENV_ROOT}/bin" ]]; then
  PATH="${RBENV_ROOT}/bin:${PATH}"
fi

PATH="${RBENV_ROOT}/plugins/ruby-build/bin:${PATH}"

if (( ${+commands[rbenv]} )); then
  source "${0:A:h}/_generated.zsh"
fi
