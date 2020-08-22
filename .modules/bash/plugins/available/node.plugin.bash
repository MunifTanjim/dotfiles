#!/usr/bin/env bash

if command_exists volta; then
  source <(npm completion)
else
  ( ! command_exists nvm ) && load_module nvm &>/dev/null

  if command_exists npm; then
    pathmunge "$(npm config get prefix)/bin"
    source <(npm completion)
  fi
fi
