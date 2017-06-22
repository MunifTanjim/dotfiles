#!/usr/bin/env bash

export NVM_PATH="${HOME}/.nvm"

[ -s "${NVM_PATH}/nvm.sh" ] && source "${NVM_PATH}/nvm.sh"

[ -r ${NVM_PATH}/bash_completion ] && source "${NVM_PATH}/bash_completion"

