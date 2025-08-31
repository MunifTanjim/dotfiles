# shellcheck shell=sh

current_shell="${current_shell:-"$(ps -p$$ -oucomm= | xargs)"}"

is_arm64() {
  test "$(uname -m)" = "arm64"
}

manpathmunge() {
  export MANPATH="${1}:${MANPATH}"
}

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

if is_arm64; then
  if test -z "${DARWIN_NO_GNU}"; then
    OLD_PATH="${PATH}"
    OLD_MANPATH="${MANPATH}"
    OLD_INFOPATH="${INFOPATH}"
    ## {{{ start: homebrew on arm64
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ## end: homebrew on arm64 }}}
    export PATH="${OLD_PATH}:${PATH}"
    export MANPATH="${OLD_MANPATH}:${MANPATH}"
    export INFOPATH="${OLD_INFOPATH}:${INFOPATH}"
  else
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  export HOMEBREW_PREFIX="$(brew --prefix)"
  pathmunge "${HOMEBREW_PREFIX}/sbin"
  manpathmunge "${HOMEBREW_PREFIX}/share/man"
fi

if test -z "${DARWIN_NO_GNU}"; then
  # gnu programs/tools binaries
  pathmunge "${HOMEBREW_PREFIX}/opt/gnu-getopt/bin"
  pathmunge "${HOMEBREW_PREFIX}/opt/util-linux/bin"
  pathmunge "${HOMEBREW_PREFIX}/opt/util-linux/sbin"
  for gnubin_path in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
    pathmunge "${gnubin_path}"
  done

  # gnu programs/tools manpage
  manpathmunge "${HOMEBREW_PREFIX}/opt/gnu-getopt/share/man"
  manpathmunge "${HOMEBREW_PREFIX}/opt/util-linux/share/man"
  for gnuman_path in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do
    manpathmunge "${gnuman_path}"
  done
fi

# docker
pathmunge "${HOME}/.docker/bin"

# google-cloud-sdk
if [[ -d "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk" ]]; then
  pathmunge "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin"
  . "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.${current_shell}.inc"
fi

# openssl
if ! is_arm64; then
  DARWIN_OPENSSL_VERSION="${DARWIN_OPENSSL_VERSION:-"1.1"}"
  brew_openssl_prefix="$(brew --prefix openssl@${DARWIN_OPENSSL_VERSION})"
  pathmunge "${brew_openssl_prefix}/bin"
  export CFLAGS="-I${brew_openssl_prefix}/include"
  export CPPFLAGS="-I${brew_openssl_prefix}/include"
  export LDFLAGS="-L${brew_openssl_prefix}/lib"
  export PKG_CONFIG_PATH="${brew_openssl_prefix}/lib/pkgconfig"
  unset brew_openssl_prefix
fi

darwin-no-gnu-run() {
  env -u PATH -u MANPATH DARWIN_NO_GNU=1 zsh -lic "$@"
}
