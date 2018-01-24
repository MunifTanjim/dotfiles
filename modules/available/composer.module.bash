#!/usr/bin/env bash

( ! command_exists composer ) && return

export COMPOSER_HOME=${COMPOSER_HOME:-"${HOME}/.composer"}
pathmunge "${COMPOSER_HOME}/vendor/bin"

