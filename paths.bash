export PATH="$DOTFILES/scripts/scripts.bash:$PATH"

if [ -d "$HOME/.bin" ] ; then
    export PATH="$HOME/.bin:$PATH"
fi

export PATH="$HOME/.local/share/umake/bin:$PATH"
