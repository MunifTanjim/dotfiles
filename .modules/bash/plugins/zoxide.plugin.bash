#!/usr/bin/evn bash

( ! command_exists zoxide ) && return

eval "$(zoxide init --no-aliases bash)"
