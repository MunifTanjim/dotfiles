# shellcheck shell=sh

declare filename="$(dirname $0)/_generated.zsh"

rm -f "${filename}"
pyenv init --path zsh >> "${filename}"
pyenv init - --no-rehash zsh >> "${filename}"
pyenv virtualenv-init - zsh >> "${filename}"
