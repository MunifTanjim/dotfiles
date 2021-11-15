# shellcheck shell=sh

declare filename="$(dirname $0)/_generated.zsh"

rm -f "${filename}"
rbenv init - zsh >> "${filename}"
