#!/usr/bin/env bash

pathmunge "./node_modules/.bin"

( ! _module_enabled nvm ) && load_module nvm &>/dev/null

( ! command_exists npm ) && return

pathmunge "$(npm config get prefix)/bin"

# Completion
source <(npm completion)
