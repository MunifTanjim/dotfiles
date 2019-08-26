#!/usr/bin/env bash

( directory_exists "./node_modules/.bin" ) && pathmunge "./node_modules/.bin"

( ! command_exists nvm ) && load_module nvm &>/dev/null

( ! command_exists npm ) && return

pathmunge "$(npm config get prefix)/bin"

# Completion
source <(npm completion)
