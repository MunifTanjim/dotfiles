source "${0:A:h}/_generated.zsh"

bindkey -M emacs '^r' atuin-search
bindkey -M viins '^r' atuin-search-viins
bindkey -M vicmd '/' atuin-search

# bindkey -M emacs "${key[Up]}" atuin-up-search
# bindkey -M vicmd "${key[Up]}" atuin-up-search-vicmd
# bindkey -M viins "${key[Up]}" atuin-up-search-viins
# bindkey -M vicmd 'k' atuin-up-search-vicmd
