# shellcheck shell=sh

if [ -f ~/.config/fzf/fzf.zsh ]; then
  source ~/.config/fzf/fzf.zsh
fi

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
