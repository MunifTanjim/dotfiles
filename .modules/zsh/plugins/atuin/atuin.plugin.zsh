source "${0:A:h}/_generated.zsh"

_zsh_autosuggest_strategy_atuin() {
  suggestion="$(atuin search --cmd-only --limit 1 --search-mode prefix --filter-mode workspace -- "${1}" || \
                atuin search --cmd-only --limit 1 --search-mode prefix -- "${1}")"
}

bindkey -M emacs '^r' atuin-search
bindkey -M viins '^r' atuin-search-viins
bindkey -M vicmd '/' atuin-search

# bindkey -M emacs "${key[Up]}" atuin-up-search
# bindkey -M vicmd "${key[Up]}" atuin-up-search-vicmd
# bindkey -M viins "${key[Up]}" atuin-up-search-viins
# bindkey -M vicmd 'k' atuin-up-search-vicmd
