( ! command_exists apt ) && return

# APT aliases
alias apt='sudo apt'
alias apt.i='sudo apt install'
alias apt.ud='sudo apt update'
alias apt.ug='sudo apt upgrade'
alias apt.dug='sudo apt dist-upgrade'
alias apt.ar='sudo apt autoremove'
alias apt.r='sudo apt remove'
alias apt.p='sudo apt purge'
alias apt.d='sudo apt download'

alias apt.s='apt-cache search'
alias apt.v='apt-cache show'

alias aar='sudo add-apt-repository'
alias pp='sudo ppa-purge'

alias apt-obsolete='apt-show-versions | grep "No available version"'
alias apt.o='apt-obsolete'

( ! command_exists apt-fast ) && return

# APT-Fast aliases
alias aptf='sudo apt-fast'
alias aptf.d='sudo apt-fast download'
alias aptf.i='sudo apt-fast install'
alias aptf.ug='sudo apt-fast upgrade'
alias aptf.dug='sudo apt-fast dist-upgrade'

