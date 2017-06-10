#!/usr/bin/evn bash

( ! command_exists umake ) && return

pathmunge "${HOME}/.local/share/umake/bin"

