#!/usr/bin/env bash

set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/MunifTanjim/scripts.sh/main/setup-chezmoi | bash

chezmoi init MunifTanjim

chezmoi apply
