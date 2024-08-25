# shellcheck shell=sh

__generated_file="$(dirname $(realpath $0))/_generated.zsh"

rm -f "${__generated_file}"
pyenv init --path zsh >> "${__generated_file}"
pyenv init - --no-rehash zsh >> "${__generated_file}"
pyenv virtualenv-init - zsh >> "${__generated_file}"

unset __generated_file
