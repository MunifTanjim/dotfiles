# shellcheck shell=sh

pathmunge "/usr/local/sbin"
pathmunge "${HOME}/.local/bin"

# gnu tools
pathmunge "/usr/local/opt/coreutils/libexec/gnubin"
pathmunge "/usr/local/opt/findutils/libexec/gnubin"
pathmunge "/usr/local/opt/gnu-getopt/bin"
pathmunge "/usr/local/opt/gnu-indent/libexec/gnubin"
pathmunge "/usr/local/opt/gnu-sed/libexec/gnubin"
pathmunge "/usr/local/opt/gnu-tar/libexec/gnubin"
pathmunge "/usr/local/opt/gnu-which/libexec/gnubin"
pathmunge "/usr/local/opt/grep/libexec/gnubin"
pathmunge "/usr/local/opt/util-linux/bin"
pathmunge "/usr/local/opt/util-linux/sbin"


# openssl
OSX_OPENSSL_VERSION="${OSX_OPENSSL_VERSION:-"1.1"}"
brew_openssl_prefix="$(brew --prefix openssl@${OSX_OPENSSL_VERSION})"
pathmunge "${brew_openssl_prefix}/bin"
export CFLAGS="-I${brew_openssl_prefix}/include"
export CPPFLAGS="-I${brew_openssl_prefix}/include"
export LDFLAGS="-L${brew_openssl_prefix}/lib"
export PKG_CONFIG_PATH="${brew_openssl_prefix}/lib/pkgconfig"
unset brew_openssl_prefix

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
