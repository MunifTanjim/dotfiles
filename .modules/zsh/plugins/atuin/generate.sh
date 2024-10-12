# shellcheck shell=sh

__generated_file="$(dirname $(realpath $0))/_generated.zsh"

rm -f "${__generated_file}"
ATUIN_NOBIND=true atuin init zsh >>"${__generated_file}"

unset __generated_file
