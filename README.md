# MunifTanjim's .dotfiles

## Resources

- [chezmoi](https://www.chezmoi.io)
- [scripts.bash](https://github.com/MunifTanjim/scripts.bash)

## Setup

```sh
# [READY] setup chezmoi
curl -sfL https://raw.githubusercontent.com/MunifTanjim/scripts.bash/master/setup-chezmoi | sh
# [SET] initialize
chezmoi init https://github.com/MunifTanjim/.dotfiles.git
# [GO] apply
chezmoi apply
```

## Submodules

- [bash-sensible](https://github.com/mrzool/bash-sensible) by Mattia Tezzele
- [dircolors-solarized](https://github.com/seebi/dircolors-solarized) by Sebastian Tramp
- [liquidprompt](https://github.com/nojhan/liquidprompt) by nojhan
