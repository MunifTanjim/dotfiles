export PYENV_ROOT=${PYENV_ROOT:-"${HOME}/.pyenv"}
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

if [[ -d "${PYENV_ROOT}/bin" ]]; then
  PATH="${PYENV_ROOT}/bin:${PATH}"
fi

if (( ${+commands[pyenv]} )); then
  source "${0:A:h}/_generated.zsh"
fi
