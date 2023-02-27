# shellcheck shell=sh

current_shell="${current_shell:-"$(ps -p$$ -oucomm= | xargs)"}"

if [[ -f ~/.config/fzf/fzf.${current_shell} ]]; then
  source ~/.config/fzf/fzf.${current_shell}
fi

export FZF_DEFAULT_OPTS='--color=dark
--color=bg:#1d2021,bg+:#3c3836,fg:#fbf1c7,fg+:#fbf1c7,hl:#d79921,hl+:#d65d0e
--color=gutter:#3c3836,info:#b16286,border:#b16286,prompt:#458588,pointer:#d3869b
--color=marker:#b16286,spinner:#689d6a,header:#458588
--bind ctrl-y:preview-up,ctrl-e:preview-down
--bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down
--bind ctrl-b:preview-page-up,ctrl-f:preview-page-down
'

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
