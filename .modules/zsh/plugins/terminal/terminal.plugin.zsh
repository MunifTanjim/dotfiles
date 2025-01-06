if test -n "${GHOSTTY_RESOURCES_DIR}"; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
elif test -n "${KITTY_INSTALLATION_DIR}"; then
  export KITTY_SHELL_INTEGRATION="enabled"
  autoload -Uz -- "${KITTY_INSTALLATION_DIR}/shell-integration/zsh/kitty-integration"
  kitty-integration
  unfunction kitty-integration
fi

