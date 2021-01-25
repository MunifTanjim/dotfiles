# MunifTanjim's .dotfiles

## Prerequisites

### Linux Prerequisites

```sh
# install basic tools
sudo apt install curl git

# login to snap with ubuntu account (for sudo-less `snap install`)
snap login
```

### macOS Prerequisites

```sh
# install command line tools
xcode-select --install

# install homebrew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Setup

```sh
# [READY] setup chezmoi
curl -sfL https://raw.githubusercontent.com/MunifTanjim/scripts.sh/main/setup-chezmoi | sh
# [SET] initialize
chezmoi init https://github.com/MunifTanjim/.dotfiles.git
# [GO] apply
chezmoi apply
```

## Notes

### macOS Notes

**Install `python<3.7` with `openssl@1.0`**:

```sh
env DARWIN_OPENSSL_VERSION=1.0 zsh -i -c 'PYTHON_BUILD_HOMEBREW_OPENSSL_FORMULA=openssl@1.0 pyenv install <version>'
```

## Resources

- [chezmoi](https://www.chezmoi.io)
- [scripts.sh](https://github.com/MunifTanjim/scripts.sh)
