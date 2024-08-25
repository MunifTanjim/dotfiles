# shellcheck shell=sh

alias c='refresh_and_clear'
alias x='eval "$(__exit_or_tmux_detach)"'
alias :q='eval "$(__exit_or_tmux_detach)"'
alias :w=''

alias md='mkdir -p'

# apt
alias apt='sudo apt'
alias apt.i='sudo apt install'
alias apt.ud='sudo apt update'
alias apt.ug='sudo apt upgrade'
alias apt.dug='sudo apt dist-upgrade'
alias apt.ar='sudo apt autoremove'

# apt-fast
alias aptf='sudo apt-fast'
alias aptf.i='sudo apt-fast install'
alias aptf.ud='sudo apt-fast update'
alias aptf.ug='sudo apt-fast upgrade'
alias aptf.dug='sudo apt-fast dist-upgrade'

# git
alias g='git'
