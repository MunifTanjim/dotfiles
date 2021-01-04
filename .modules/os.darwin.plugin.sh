# shellcheck shell=sh

pathmunge "/usr/local/sbin"
pathmunge "${HOME}/.local/bin"

# coreutils
pathmunge "/usr/local/opt/coreutils/libexec/gnubin"

# openssl
OSX_OPENSSL_VERSION="${OSX_OPENSSL_VERSION:-"1.1"}"
brew_openssl_prefix="$(brew --prefix openssl@${OSX_OPENSSL_VERSION})"
pathmunge "${brew_openssl_prefix}/bin"
export CFLAGS="-I${brew_openssl_prefix}/include"
export CPPFLAGS="-I${brew_openssl_prefix}/include"
export LDFLAGS="-L${brew_openssl_prefix}/lib"
export PKG_CONFIG_PATH="${brew_openssl_prefix}/lib/pkgconfig"
unset brew_openssl_prefix
