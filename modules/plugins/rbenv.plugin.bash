#!/usr/bin/env bash

pathmunge "${HOME}/.rbenv/bin"

[ -x `which rbenv` ] && eval "$(rbenv init -)"

[ -d "${HOME}/.rbenv/plugins/ruby-build" ] && pathmunge "${HOME}/.rbenv/plugins/ruby-build/bin"

