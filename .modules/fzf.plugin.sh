# shellcheck shell=sh

fzf_shell="$(ps -p$$ -ocomm=)"
fzf_shell="${fzf_shell#-}"

if [[ -f ~/.config/fzf/fzf.${fzf_shell} ]]; then
  source ~/.config/fzf/fzf.${fzf_shell}
fi

export FZF_DEFAULT_OPTS='--color=dark
--color=bg:#1d2021,bg+:#3c3836,fg:#fbf1c7,fg+:#fbf1c7,hl:#d79921,hl+:#d65d0e
--color=gutter:#3c3836,info:#b16286,border:#b16286,prompt:#458588,pointer:#d3869b
--color=marker:#b16286,spinner:#689d6a,header:#458588'

if command_exists fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
