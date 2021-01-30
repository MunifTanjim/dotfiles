# shellcheck shell=sh

manpathmunge() {
  export MANPATH="${1}:${MANPATH}"
}

pathmunge "/usr/local/sbin"
pathmunge "${HOME}/.local/bin"

brew_prefix="$(brew --prefix)"

# gnu programs/tools binaries
pathmunge "${brew_prefix}/opt/gnu-getopt/bin"
pathmunge "${brew_prefix}/opt/util-linux/bin"
pathmunge "${brew_prefix}/opt/util-linux/sbin"
for gnubin_path in ${brew_prefix}/opt/*/libexec/gnubin; do
  pathmunge "${gnubin_path}"
done

# gnu programs/tools manpage
manpathmunge "${brew_prefix}/opt/gnu-getopt/share/man"
manpathmunge "${brew_prefix}/opt/util-linux/share/man"
for gnuman_path in ${brew_prefix}/opt/*/libexec/gnuman; do
  manpathmunge "${gnuman_path}"
done

# openssl
DARWIN_OPENSSL_VERSION="${DARWIN_OPENSSL_VERSION:-"1.1"}"
brew_openssl_prefix="$(brew --prefix openssl@${DARWIN_OPENSSL_VERSION})"
pathmunge "${brew_openssl_prefix}/bin"
export CFLAGS="-I${brew_openssl_prefix}/include"
export CPPFLAGS="-I${brew_openssl_prefix}/include"
export LDFLAGS="-L${brew_openssl_prefix}/lib"
export PKG_CONFIG_PATH="${brew_openssl_prefix}/lib/pkgconfig"
unset brew_openssl_prefix

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
