#!/usr/bin/env bash

( ! command_exists git ) && return

# Aliases
alias g='git'

alias g.cl='git clone'
alias g.cld='git clone --depth'

alias g.b='git branch'
alias g.ba='git branch -a'
alias g.bd='git branch -d'
alias g.bD='git branch -D'

alias g.co='git checkout'
alias g.com='git checkout master'
alias g.cob='git checkout -b'

alias g.s='git status -s'
alias g.st='git status'

alias g.d='git diff'

alias g.a='git add'
alias g.aa='git add -A'
alias g.rm='git rm'

alias g.c='git commit -v'
alias g.ca='git commit -v -a'
alias g.cm='git commit -v -m'
alias g.cam='git commit -v -am'
alias g.camend='git commit --amend'

alias g.ll='git log --graph --pretty=oneline --abbrev-commit'

alias g.r='git remote'
alias g.rv='git remote -v'
alias g.ra='git remote add'
alias g.rr='git remote remove'

alias g.pl='git pull'
alias g.plr='git pull --rebase'
alias g.plps='git pull && git push'

alias g.ps='git push'
alias g.pso='git push origin'
alias g.psom='git push origin master'
alias g.psu='git push --set-upstream'
