alias s='sudo'

# APT aliases
alias apti='sudo apt install'
alias aptfi='sudo apt-fast install'
alias aptd='sudo apt download'
alias aptfd='sudo apt-fast download'
alias aptr='sudo apt remove'
alias aptp='sudo apt purge'
alias aptud='sudo apt update'
alias aptug='sudo apt upgrade'
alias aptfug='sudo apt-fast upgrade'
alias aptdug='sudo apt dist-upgrade'
alias aptfdug='sudo apt-fast dist-upgrade'
alias aptar='sudo apt autoremove'
alias apt-obsolete='apt-show-versions | grep "No available version"'

# Repository aliases
alias aar='sudo add-apt-repository'
alias pp='sudo ppa-purge'

alias x='exit'

alias system-monitor='mate-system-monitor'

# Misc
alias insults='wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;";'
