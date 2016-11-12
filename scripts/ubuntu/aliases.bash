alias s='sudo'

# APT aliases
alias apt='sudo apt'
alias aptf='sudo apt-fast'
alias apt.i='sudo apt install'
alias aptf.i='sudo apt-fast install'
alias apt.d='sudo apt download'
alias aptf.d='sudo apt-fast download'
alias apt.r='sudo apt remove'
alias apt.p='sudo apt purge'
alias apt.ud='sudo apt update'
alias apt.ug='sudo apt upgrade'
alias aptf.ug='sudo apt-fast upgrade'
alias apt.dug='sudo apt dist-upgrade'
alias aptf.dug='sudo apt-fast dist-upgrade'
alias apt.ar='sudo apt autoremove'
alias apt-obsolete='apt-show-versions | grep "No available version"'
alias apt.o='apt-obsolete'

# Repository aliases
alias aar='sudo add-apt-repository'
alias pp='sudo ppa-purge'

alias x='exit'

alias system-monitor='mate-system-monitor'

# Misc
alias insults='wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;";'
