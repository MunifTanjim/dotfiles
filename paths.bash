export PATH="$HOME/.dotfiles/scripts/scripts.bash:$PATH"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    export PATH="$HOME/.bin:$PATH"
fi

# Ubuntu make installation of Ubuntu Make binary symlink
export PATH="$HOME/.local/share/umake/bin:$PATH"
