# MunifTanjim's dotfiles

## Setup

```sh
# [READY] setup chezmoi
curl -fsSL https://raw.githubusercontent.com/MunifTanjim/scripts.sh/main/setup-chezmoi | bash
# [SET] initialize
chezmoi init MunifTanjim
# [GO] apply
chezmoi apply
```

## Notes

### macOS Notes

#### Build with `openssl@1.0`

Run shell in a clean environment with `DARWIN_OPENSSL_VERSION=1.0`. For example:

```sh
env DARWIN_OPENSSL_VERSION=1.0 zsh -i -c 'PYTHON_BUILD_HOMEBREW_OPENSSL_FORMULA=openssl@1.0 pyenv install <version>'
```

_**NOTE**: Not supported on ARM64 (Apple Silicon)._

## Resources

- [chezmoi](https://www.chezmoi.io)
- [scripts.sh](https://github.com/MunifTanjim/scripts.sh)
