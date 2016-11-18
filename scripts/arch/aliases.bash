alias s='sudo'

# pacman aliases
alias pacman-remove-orphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pacman-unlock='sudo rm /var/lib/pacman/db.lck'

alias x='exit'

# Misc
alias insults='wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;";'
