#!/usr/bin/env bash

if [ -x /usr/bin/dircolors ]; then
  _dircolors_file="${DOTFILES_MODULES}/.dircolors-solarized/dircolors.256dark"
  test -r ${_dircolors_file} && eval "$(dircolors -b ${_dircolors_file})" || eval "$(dircolors -b)"
fi

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export GREP_COLOR='1;33'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export STARSHIP_CONFIG=~/.config/starship/config.toml
eval "$(starship init bash)"
export PROMPT_COMMAND="starship_precmd;${PROMPT_COMMAND/starship_precmd;/}"
