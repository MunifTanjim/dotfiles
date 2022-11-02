# shellcheck shell=zsh

__generated_file="$(dirname $(realpath $0))/os.darwin.plugin.zsh"

rm -f "${__generated_file}"
touch "${__generated_file}"

if test "$(uname -m)" != "arm64"; then
  exit 0
fi

homebrew_setup_on_arm64() {
  local -r marker_start="  ## {{{ start: homebrew on arm64"
  local -r marker_end="  ## end: homebrew on arm64 }}}"

  sed -e "/${marker_start}/,/${marker_end}/{//!d;}" -i -- "${__generated_file}"

  local -r homebrew="/opt/homebrew/bin/brew"

  local marker_start_linenr=$(( $(sed -n "/${marker_start}/=" "${__generated_file}") ))
  
  local content="$({ head -n $(( marker_start_linenr )) "${__generated_file}"; echo "$(
    $homebrew shellenv | sed 's/^/  /'
    echo "\n  FPATH=\"\${HOMEBREW_PREFIX}/share/zsh/site-functions:\${FPATH}\""
  )"; tail -n +$(( marker_start_linenr + 1 )) ${__generated_file}; })"

  echo "${content}" > "${__generated_file}"
}

cat "${DOTFILES_MODULES}/os.darwin.plugin.sh" > "${__generated_file}"

homebrew_setup_on_arm64

unset __generated_file
