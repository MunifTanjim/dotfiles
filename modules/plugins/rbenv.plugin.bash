#!/usr/bin/env bash

pathmunge "${HOME}/.rbenv/bin"

( command_exists rbenv ) && eval "$(rbenv init -)"

if [ -d "${HOME}/.rbenv/plugins/ruby-build" ]; then
  pathmunge "${HOME}/.rbenv/plugins/ruby-build/bin"
fi

