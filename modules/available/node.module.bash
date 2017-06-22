#!/usr/bin/env bash

pathmunge "./node_modules/.bin"

if ( command_exists npm ); then
  pathmunge "$(npm config get prefix)/bin"
fi

# Completion
( command_exists npm ) && source <(npm completion)

