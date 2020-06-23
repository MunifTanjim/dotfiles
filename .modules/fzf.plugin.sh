# shellcheck shell=sh

fzf_shell=$(basename $(readlink /proc/$$/exe))

if [[ -f ~/.config/fzf/fzf.${fzf_shell} ]]; then
  source ~/.config/fzf/fzf.${fzf_shell}
fi

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
