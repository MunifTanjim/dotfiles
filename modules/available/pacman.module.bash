#!/usr/bin/env bash

( ! command_exists pacman ) && return

# Aliases
alias pacman-remove-orphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pacman-unlock='sudo rm /var/lib/pacman/db.lck'
