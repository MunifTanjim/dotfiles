#!/usr/bin/env bash

( command_exists nvm ) && return

export NVM_PATH="${HOME}/.nvm"

[ -s "${NVM_PATH}/nvm.sh" ] && source "${NVM_PATH}/nvm.sh"

[ -r ${NVM_PATH}/bash_completion ] && source "${NVM_PATH}/bash_completion"

