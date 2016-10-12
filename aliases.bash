alias _='sudo'

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

# Repository aliases
alias aar='sudo add-apt-repository'
alias pp='sudo ppa-purge'


alias apt-obsolete='apt-show-versions | grep "No available version"'

alias x='exit'

alias ..='cd ..'

alias system-monitor='mate-system-monitor'

alias limbo='cd ~/data/games/limbo && ./launch-limbo.sh & '

alias insults='wget http://www.randominsults.net -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;";'

# gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default -d NOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages -dCompressFonts=true -r150 -sOutputFile=Circuits.pdf CircuitsCover.pdf CircuitsSimulation.pdf

# dd if=/ext_card/FOTAKernel.img of=/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel

# tar -cvvzf test.tar.gz  video.avi
# split -v 5M test.tar.gz vid
# split -v 5M -d test.tar.gz video.avi
# cat vid* > test.tar.gz
